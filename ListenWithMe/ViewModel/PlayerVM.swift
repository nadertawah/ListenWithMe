//
//  PlayerVM.swift
//  ListenWithMe
//
//  Created by nader said on 24/08/2022.
//

import Foundation
import Combine
import MediaPlayer

class PlayerVM
{
    init(friend : User)
    {
        self.friend = friend
        roomID = Helper.getChatRoomID(ID1: Helper.getCurrentUserID(), ID2: friend.userID)
        observeSyncState()
        observePreparingToPlayState()
        observeNowPlaying()
        observeNowPlayingRemoved()
        
    }
    
    //MARK: - Var(s)
    private(set) var friend : User
    @Published private(set) var songs  : [MPMediaItem] = []
    @Published private(set) var syncState : SyncState = .notSynced
    @Published private(set) var isPreparingToPlay = false
    @Published private(set) var recievedNowPlaying : (String,String,String,TimeInterval,TimeInterval) = ("","","",0,0)
    private(set) var sentNowPlaying : (String,String,String,TimeInterval,TimeInterval) = ("","","",0,0)

    private var mySyncState = false
    private var roomID : String
    var isStreamer = false
    
    //MARK: - intent(s)
    func getSongs()
    {
        songs = MPMediaQuery.songs().items ?? []
    }
    
    func trySync()
    {
        if mySyncState
        {
            FireBaseDB.sharedInstance.setSyncState(roomID: roomID, state: SyncState(rawValue: syncState.rawValue - 1) ?? .notSynced)
        }
        else
        {
            FireBaseDB.sharedInstance.setSyncState(roomID: roomID, state: SyncState(rawValue: syncState.rawValue + 1) ?? .oneSynced)
        }
        mySyncState = !mySyncState
    }
    
    func resetNowPlaying()
    {
        FireBaseDB.sharedInstance.resetNowPlaying(roomID: roomID)
    }
    
    func getFriendNowPlayingLocalUrl(songName:String,completion : @escaping (URL)->())
    {
        if let songLocalUrl = songFileUrl(songName: songName)
        {
            completion(songLocalUrl)
        }
        else
        {
            FireBaseStore.sharedInstance.storageRef.child(friend.userID).child("\(songName).m4a").write(toFile: FileManager.songUrlInDocuments(fileName: songName))
            {
                url, err in
                if let url = url
                {
                    completion(url)
                }
            }
        }
    }
    
    func setPreparingToPlayState(isPreparing: Bool)
    {
        FireBaseDB.sharedInstance.setPreparingToPlayState(roomID: roomID, isPreparing: isPreparing)
    }

    func setNowPlaying(userID:String,url:String,singer:String,songName:String,duration:TimeInterval,startTime:TimeInterval = 0)
    {
        self.sentNowPlaying = (songName, singer, url,startTime,duration)
        
        let dict = ["url":url,"singer": singer,"duration":duration,"startTime":startTime] as [String : Any]
        FireBaseDB.sharedInstance.setNowPlaying(roomID: roomID, userID: userID, dict: [songName:dict])
    }
    
    func exportAndUploadSong(index:Int)
    {
        let title = songs[index].title ?? "temp"
        FireBaseDB.sharedInstance.songExists(songName: title)
        { [weak self]
            exists,url  in
            guard let self = self else {return}
            
            let song = self.songs[index]
            if let librarySongUrl = song.assetURL, !exists
            {
                let assetUrl = AVURLAsset(url: librarySongUrl)
                guard let export = AVAssetExportSession(asset: assetUrl, presetName:AVAssetExportPresetAppleM4A) else {return}
                
                let outputURL = FileManager.songUrlInDocuments(fileName:title)
                export.outputURL = outputURL
                export.outputFileType = .m4a
                export.exportAsynchronously
                {
                    if export.error == nil
                    {
                        self.uploadSong(localFileUrl: outputURL,songIndex: index)
                        {
                            self.setNowPlaying(userID: Helper.getCurrentUserID(), url: $0, singer: song.artist ?? "unknown", songName: title, duration: song.playbackDuration)
                        }
                    }
                }
            }
            else
            {
                self.setNowPlaying(userID: Helper.getCurrentUserID(), url: url, singer: song.artist ?? "unknown", songName: title, duration: song.playbackDuration)
            }
        }
    }
    
    func resumeNowPlayingWithStartTime(time:TimeInterval)
    {
        if sentNowPlaying.2 == "" {return}
        setNowPlaying(userID: Helper.getCurrentUserID(), url: sentNowPlaying.2, singer: sentNowPlaying.1, songName: sentNowPlaying.0, duration: sentNowPlaying.4, startTime: time)
    }
    
    //MARK: - Helper Funcs
    private func uploadSong(localFileUrl : URL,songIndex: Int,completion : @escaping (String)->())
    {
        do
        {
            let songName = songs[songIndex].title ?? "temp"
            let data = try Data(contentsOf: localFileUrl)
            let songRef = FireBaseStore.sharedInstance.storageRef.child(Helper.getCurrentUserID()).child("\(songName).m4a")
            
            let task = songRef.putData(data)
            task.observe(.success)
            {
                StorageTaskSnapshot in
                songRef.downloadURL
                { url, err in
                    if let url = url?.absoluteString
                    {
                        FireBaseDB.sharedInstance.addSongToUserCollection(songName: songName, urlStr: url)
                        task.removeAllObservers()
                        completion(url)
                    }
                }
            }
            task.observe(.failure) { StorageTaskSnapshot in
                print(StorageTaskSnapshot.error ?? "Error uploading the song")
                task.removeAllObservers()
            }
        }
        catch
        {
            print(error)
        }
    }
    
    private func observeSyncState()
    {
        FireBaseDB.sharedInstance.observeSyncState(roomID: roomID)
        { [weak self]
            state in
            guard let self = self else {return}
            self.syncState = state
        }
    }
    
    private func observePreparingToPlayState()
    {
        FireBaseDB.sharedInstance.observePreparingToPlayState(roomID: roomID)
        {
            [weak self]
            state in
            guard let self = self else {return}
            self.isPreparingToPlay = state
        }
    }
    
    private func observeNowPlaying()
    {
        FireBaseDB.sharedInstance.observeNowPlaying(roomID: roomID, friendID: friend.userID)
        {
            [weak self]
            songName, singer, url,startTime,duration  in
            guard let self = self else {return}
            self.isStreamer = false
            self.recievedNowPlaying = (songName, singer, url,startTime,duration)
        }
    }
    
    
    
    private func songFileUrl(songName:String) -> URL?
    {
        let localFileURL = FileManager.songUrlInDocuments(fileName: songName)
        if FileManager.default.fileExists(atPath: localFileURL.path)
        {
            return localFileURL
        }
        else
        {
            return nil
        }
    }
    
    func observeNowPlayingRemoved()
    {
        FireBaseDB.sharedInstance.observeNowPlayingRemoved(roomID: roomID)
        {
            [weak self] in
            guard let self = self else {return}
            if !self.isStreamer
            {
                self.recievedNowPlaying.2 = ""

            }
        }
    }
    
    
}
