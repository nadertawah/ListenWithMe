//
//  PlayerVC.swift
//  ListenWithMe
//
//  Created by nader said on 23/08/2022.
//

import UIKit
import Combine
import MediaPlayer

class PlayerVC: UIViewController
{
    //MARK: - IBOutlet(s)
    @IBOutlet weak var slider: ArcSlider!
    
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var playPauseBtn: UIButton!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var listBtn: UIButton!
  
    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var syncImgView: UIImageView!
    @IBOutlet weak var songImgView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var songDetailsView: UIView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var singerNameLabel: UILabel!
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var songLengthLabel: UILabel!
    
    @IBOutlet weak var walkThroughLabel: UILabel!
    
    @IBOutlet weak var songImgViewTop: NSLayoutConstraint!
    @IBOutlet weak var songImgViewLeading: NSLayoutConstraint!
    @IBOutlet var songImgViewFullWidth: NSLayoutConstraint!

    @IBOutlet var songImgViewSmallWidth: NSLayoutConstraint!
    @IBOutlet var songImgViewSmallHeight: NSLayoutConstraint!
    
    @IBOutlet weak var songDetailsViewTop: NSLayoutConstraint!
    @IBOutlet weak var songDetailsViewWidth: NSLayoutConstraint!
    @IBOutlet weak var songDetailsViewLeading: NSLayoutConstraint!
    
    @IBOutlet var songDetailssViewBottom: NSLayoutConstraint!
    @IBOutlet weak var tableViewTrailing: NSLayoutConstraint!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setUI()
    }
    deinit
    {
        iPodPlayer.stop()
        iPodPlayer.setQueue(with: [])
        iPodPlayer.currentPlaybackTime = 0
    }
    init(friend:User)
    {
        VM = PlayerVM(friend: friend)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - IBAction(s)
    @IBAction func listBtnPressed(_ sender: UIButton)
    {
        if isAnimating {return}
        isAnimating = true
        
        if listIsHidden
        {
            //song image view constraint update
            songImgViewTop.constant = 40 + view.safeAreaInsets.top
            songImgViewLeading.constant = 10

            songImgViewFullWidth.isActive = false
            songImgViewSmallWidth.isActive = true
            songImgViewSmallHeight.isActive = true
            
            //song details view constraint update
            songDetailsViewTop.constant = -75 - (songDetailsView.frame.height / 2)

            songDetailsViewWidth.constant = -170
            songDetailsViewLeading.constant = 165
            songDetailssViewBottom.isActive = false
            animateConstraintsUpdate
            {
                [weak self] in
                    guard let self = self else { return }
                
                self.tableViewTrailing.constant = 10
                self.animateConstraintsUpdate
                {
                    self.isAnimating = false
                }
            }
        }
        else
        {
            //tabe view constraint update
            tableViewTrailing.constant = -tableView.frame.width - 10
            
            animateConstraintsUpdate
            {
                [weak self] in
                    guard let self = self else { return }
                
                //song image view constraint update
                self.songImgViewTop.constant = 0
                self.songImgViewLeading.constant = 0

                self.songImgViewFullWidth.isActive = true
                self.songImgViewSmallWidth.isActive = false
                self.songImgViewSmallHeight.isActive = false
                
                //song details view constraint update
                self.songDetailsViewTop.constant = 0
                self.songDetailsViewWidth.constant = 0
                self.songDetailsViewLeading.constant = 0
                self.songDetailssViewBottom.isActive = true
                self.animateConstraintsUpdate
                {
                    self.isAnimating = false
                }
            }
        }
        
        listIsHidden = !listIsHidden
    }
    
    @IBAction func backBtn(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func playPauseBtnPressed(_ sender: UIButton)
    {
        if iPodPlayer.playbackState == .playing
        {
            pauseSong()
            if VM.syncState == .synced
            {
                VM.isStreamer = true
                VM.resetNowPlaying()
            }
        }
        else
        {
            if VM.syncState == .synced
            {
                VM.setPreparingToPlayState(isPreparing: true)
                VM.resumeNowPlayingWithStartTime(time:iPodPlayer.currentPlaybackTime)
            }
            else
            {
                self.playIpodPlayer()
            }
        }
    }
    
    @IBAction func nextBtnPressed(_ sender: UIButton)
    {
        if iPodPlayer.nowPlayingItem != nil , let playingSongIndex = tableView.indexPathForSelectedRow, playingSongIndex.row < VM.songs.count - 1
        {
            let nextSongIndex = IndexPath(row: playingSongIndex.row + 1 , section: playingSongIndex.section)
            tableView.selectRow(at: nextSongIndex, animated: true, scrollPosition: .top)
            self.tableView(tableView, didSelectRowAt: nextSongIndex)
        }
    }
    
    @IBAction func previousBtnPressed(_ sender: Any)
    {
        if iPodPlayer.nowPlayingItem != nil , let playingSongIndex = tableView.indexPathForSelectedRow, playingSongIndex.row > 0
        {
            let previousSongIndex = IndexPath(row: playingSongIndex.row - 1 , section: playingSongIndex.section)
            tableView.selectRow(at: previousSongIndex, animated: true, scrollPosition: .top)
            self.tableView(tableView, didSelectRowAt: previousSongIndex)
        }
    }
    
    //MARK: - Var(s)
    private var VM : PlayerVM!
    private var disposeBag = [AnyCancellable]()
    private let iPodPlayer = MPMusicPlayerController.applicationQueuePlayer
    private var timer = Timer()
    private var avAudioPlayer = AVAudioPlayer()
    private var listIsHidden = true
    private var isAnimating = false
    lazy private var walkThrough = WalkThrough(frame: self.view.bounds)
    
    //MARK: - Helper Funcs
    func setUI()
    {
        //apply shadows
        listBtn.addShadows()
        currentTimeLabel.addShadows()
        songLengthLabel.addShadows()
        previousBtn.addShadows()
        playPauseBtn.addShadows()
        nextBtn.addShadows()
        
        //set control buttons images
        playPauseBtn.setImage(UIImage(named: "play_icon")?.resizeImageTo(size: CGSize(width: 50, height: 50))  , for: .normal)
        nextBtn.setImage(UIImage(named: "next_icon")?.resizeImageTo(size: CGSize(width: 30, height: 30))  , for: .normal)
        previousBtn.setImage(UIImage(named: "next_icon")?.resizeImageTo(size: CGSize(width: 30, height: 30))?.withHorizontallyFlippedOrientation()  , for: .normal)

        //register cells
        tableView.register(UINib(nibName: SongsListCell.reuseIdentfier, bundle: nil), forCellReuseIdentifier: SongsListCell.reuseIdentfier)
        
        //bind VM
        VM.$songs.receive(on: DispatchQueue.main).sink
        {
            [weak self] _ in
            guard let self = self else {return}
            self.tableView.reloadData()
        }.store(in: &disposeBag)
        
        getMusicPermission()
        
        //slider change action
        slider.addTarget(self, action: #selector(sliderDragged), for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderFinishedDragging), for: .editingDidEnd)
        
        //set avatar
        avatarImgView.image = UIImage.imageFromString(imgSTR: VM.friend.avatar)?.circleMasked
        avatarImgView.isUserInteractionEnabled = true
        let avatarTapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(self.trySync))
        avatarImgView.addGestureRecognizer(avatarTapGestureRecogniser)
        
        
        //bind sync state
        VM.$syncState.receive(on: DispatchQueue.main).scan((SyncState.notSynced,SyncState.notSynced))
        { return ($0.1 , $1)}
            .sink
        {
            [weak self] (previous,current) in
            guard let self = self else {return}
            switch current
            {
                case .oneSynced:
                    if previous == .synced
                    {
                        self.VM.resetNowPlaying()
                        self.pauseSong()
                        self.VM.isStreamer = false

                        //enable controls and slider
                        self.slider.isUserInteractionEnabled = true
                    }
                
                    self.syncImgView.tintColor = .orange
                    break
                    
                case .synced:
                    self.syncImgView.tintColor = .green
                    break
                    
                default:
                    self.syncImgView.tintColor = .red
                    break
            }
        }.store(in: &disposeBag)
        
        //bind preparing to play state
        VM.$isPreparingToPlay.receive(on: DispatchQueue.main).sink
        {
            [weak self]  in
            guard let self = self else {return}
            if $0
            {
                self.setPreparingToPlayAnimation()
            }
            else
            {
                if self.VM.isStreamer
                {
                    self.iPodPlayer.currentPlaybackTime = self.VM.sentNowPlaying.3 + 0.25
                    self.playIpodPlayer()
                   // self.VM.isStreamer = false
                }
                self.stopPreparingToPlayAnimation()
            }
            
        }.store(in: &disposeBag)
        
        //bind now playing
        VM.$recievedNowPlaying.receive(on: DispatchQueue.main).sink
        {
            [weak self] songName,singer,url,startTime,duration  in
            guard let self = self else {return}
            
            //set labels
            self.songNameLabel.text = songName
            self.singerNameLabel.text = singer
            
            self.songLengthLabel.text = self.getTimeStampFormatStr(interval: duration)
            self.currentTimeLabel.text = self.getTimeStampFormatStr(interval: startTime)
            
            if url == "" {self.avAudioPlayer.stop();return}
            
            self.VM.getFriendNowPlayingLocalUrl(songName: songName)
            {
                url in
                do
                {
                    self.avAudioPlayer = try AVAudioPlayer(data: Data(contentsOf: url))

                    self.avAudioPlayer.volume = 1
                    self.avAudioPlayer.prepareToPlay()
                    self.avAudioPlayer.currentTime = startTime
                    self.VM.setPreparingToPlayState(isPreparing: false)

                    self.avAudioPlayer.play()
                    
                    //set slider
                    self.setProgressTimer(isIpodPlaying: false)
                    
                    //disable controls and slider
                    self.slider.isUserInteractionEnabled = false
                }
                catch
                {
                    print(error)
                }
                
                
            }
        }.store(in: &disposeBag)
    }
    
    func pauseSong()
    {
        iPodPlayer.pause()
        playPauseBtn.setImage(UIImage(named: "play_icon")?.resizeImageTo(size: CGSize(width: 50, height: 50))  , for: .normal)
        timer.invalidate()
    }
    
    func setPreparingToPlayAnimation()
    {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.autoreverse,.repeat])
        {
            self.syncImgView.alpha = 0
        }
    }
    
    func stopPreparingToPlayAnimation()
    {
        self.syncImgView.alpha = 1
        self.syncImgView.layer.removeAllAnimations()
    }
    
    @objc func trySync()
    {
        VM.trySync()
    }
    
    @objc func sliderDragged()
    {
        if VM.syncState != .synced
        {
            iPodPlayer.currentPlaybackTime = (iPodPlayer.nowPlayingItem?.playbackDuration ?? 0) * slider.percentage
        }
    }
    
    @objc func sliderFinishedDragging()
    {
        let currentTime = (iPodPlayer.nowPlayingItem?.playbackDuration ?? 0) * slider.percentage

        if VM.syncState == .synced
        {
            VM.isStreamer = true

            VM.resetNowPlaying()
            VM.setPreparingToPlayState(isPreparing: true)
            VM.resumeNowPlayingWithStartTime(time:currentTime)

        }
    }
    
    func getMusicPermission()
    {
        let status = MPMediaLibrary.authorizationStatus()
        if status == .authorized
        {
            VM.getSongs()
        }
        else
        {
            MPMediaLibrary.requestAuthorization()
            { [weak self] status in
                if status == .authorized
                {
                    DispatchQueue.main.async
                    {
                        self?.VM.getSongs()
                        self?.beginWalkthrough()
                    }
                }
                else
                {
                    self?.showAlert(title: "", msg: "You need to give the app a permisson from the settings to access music.")
                }
            }
        }
    }
    
    
    func beginWalkthrough()
    {
        view.addSubview(walkThrough.blurEffectView)
        
        let nextGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(nextWalkThrough))
                                                           
        walkThrough.blurEffectView.addGestureRecognizer(nextGestureRecogniser)
        
        walkThroughLabel.isHidden = false
        walkThroughLabel.text = "The avatar pic is clickable and it's used to sync with your friend.\nThe red dot next to the avatar is a sync indicator. Red means you're not synced with each other yet.\nTap anywhere to go next. "
                
        view.bringSubviewToFront(walkThroughLabel)
        view.bringSubviewToFront(avatarImgView)
        view.bringSubviewToFront(syncImgView)
    }
    
    @objc private func nextWalkThrough()
    {
        walkThrough.next()
        switch walkThrough.step
        {
            case 1:
            walkThroughLabel.text = "If you click now the indicator will turn orange.\nIt means one of you is ready to sync.\nTap anywhere to go next."
                self.syncImgView.tintColor = .orange
                break
            
            case 2:
            walkThroughLabel.text = "If both of you click on the avatar the indicator will turn green.\nIt means you're synced and ready to listen to music together.\nTap anywhere to go next."
                self.syncImgView.tintColor = .green
                break
            
            case 3:
            walkThroughLabel.text = "If the indicator is flashing green, it means the music player is getting ready to play and once it stops flashing, the song will play.\nTap anywhere to go next."
            self.setPreparingToPlayAnimation()
                break
            
            case 4:
                self.syncImgView.tintColor = .red
                self.stopPreparingToPlayAnimation()
                walkThroughLabel.text = "The next step is to show your songs list and click on one to play.\nEnjoy...\nTap anywhere to finish."
                self.view.bringSubviewToFront(walkThrough.blurEffectView)
                self.view.bringSubviewToFront(listBtn)
                self.view.bringSubviewToFront(walkThroughLabel)

                break
            default:
                
                self.walkThrough.blurEffectView.removeFromSuperview()
                self.walkThroughLabel.isHidden = true
                break
        }
    }
}


extension PlayerVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        VM.songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SongsListCell.reuseIdentfier) as? SongsListCell else{return UITableViewCell()}
        let song = VM.songs[indexPath.row]
        
        cell.songNameLabel.text = song.title
        cell.singerNameLabel.text = song.artist
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let mediaCollection = MPMediaItemCollection(items: [VM.songs[indexPath.row]])
        iPodPlayer.setQueue(with: mediaCollection)
        
        //set song and singer names
        songNameLabel.text = VM.songs[indexPath.row].title
        singerNameLabel.text = VM.songs[indexPath.row].artist
        
        //set song pic
        songImgView.image = VM.songs[indexPath.row].artwork?.image(at: songImgView.frame.size) ?? UIImage(named: "songImgPlaceHolder")
        
        //set duration label
        self.iPodPlayer.prepareToPlay()
        self.iPodPlayer.currentPlaybackTime = 0
        self.songLengthLabel.text = getTimeStampFormatStr(interval: VM.songs[indexPath.row].playbackDuration)
        
        if VM.syncState == .synced
        {
            VM.isStreamer = true
            pauseSong()
            VM.setPreparingToPlayState(isPreparing: true)
            VM.exportAndUploadSong(index: indexPath.row)
        }
        else
        {
            playIpodPlayer()
        }
        
        //enable controls and slider
        self.slider.isUserInteractionEnabled = true
    }
    
    func playIpodPlayer()
    {
        //play the song
        iPodPlayer.play()

        //change play button image
        playPauseBtn.setImage(UIImage(named: "pause_icon")?.resizeImageTo(size: CGSize(width: 50, height: 50))  , for: .normal)
        
        //set timer for progress
        setProgressTimer(isIpodPlaying: true)
    }
    
    func getTimeStampFormatStr(interval:TimeInterval) -> String
    {
        let hour = Int(interval / 3600)
        let min = Int(interval.truncatingRemainder(dividingBy: 3600)) / 60
        let sec = Int(interval.truncatingRemainder(dividingBy: 60))
        let totalTimeString = String(format: "%02d:%02d:%02d",hour, min, sec)
        return totalTimeString
    }
    
    func setProgressTimer(isIpodPlaying:Bool)
    {
        if timer.isValid
        {
            timer.invalidate()
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true)
        {
            [weak self] _ in
            guard let self = self else {return}
            
            let currentTime = isIpodPlaying ? self.iPodPlayer.currentPlaybackTime : self.avAudioPlayer.currentTime
            
            
            let duration = isIpodPlaying ? (self.iPodPlayer.nowPlayingItem?.playbackDuration ?? 1) : self.avAudioPlayer.duration
            
            let playedPercentage = currentTime / duration
            self.slider.changeProgress(percentage: playedPercentage)
            
            //set current time label
            let hour = Int(currentTime / 3600)
            let min = Int(currentTime / 60)
            let sec = Int(currentTime.truncatingRemainder(dividingBy: 60))
            let totalTimeString = String(format: "%02d:%02d:%02d",hour, min, sec)
            self.currentTimeLabel.text = totalTimeString
            
            if currentTime == 0
            {
                self.timer.invalidate()
                self.playPauseBtn.setImage(UIImage(named: "play_icon")?.resizeImageTo(size: CGSize(width: 50, height: 50))  , for: .normal)
            }
        }
    }
    
}

