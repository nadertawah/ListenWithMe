//
//  FriendsVM.swift
//  ListenWithMe
//
//  Created by nader said on 21/08/2022.
//

import Foundation
import Combine

class FriendsVM
{
    init()
    {
        //bind users
        $users.receive(on: DispatchQueue.main).sink
        {
            [weak self]  in
            self?.filteredUsers = $0
        }.store(in: &disposeBag)
        
        getFriends()
    }
    
    //MARK: - Var(s)
    @Published private(set) var users = [User]()
    @Published private(set) var filteredUsers = [User]()
    private var disposeBag = [AnyCancellable]()
    
    //MARK: - intent(s)
    func searchByEmail(email:String,segmentIndex:Int)
    {
        if segmentIndex != 1
        {
            filteredUsers = email == "" ? users : users.filter({ $0.email.lowercased().contains(email) || $0.fullName.lowercased().contains(email) })
        }
        else
        {
            if email == ""
            {
                filteredUsers = []
            }
            else
            {
                FireBaseDB.sharedInstance.searchUsersByEmail(email: email)
                {
                    [weak self] in
                    self?.filteredUsers = $0 != nil ? [$0!] : []
                }
            }
        }
    }
    
    func getFriends()
    {
        users = []
        FireBaseDB.sharedInstance.observeFriends{ [weak self] in self?.users = $0 }
    }
    
    func getRequests()
    {
        users = []
        FireBaseDB.sharedInstance.observeFriendRequests { [weak self] in self?.users = $0 }
    }
    
    func sendFriendRequest(index:Int)
    {
        let friendID = filteredUsers[index].userID
        FireBaseDB.sharedInstance.setFriendRequest(friendID: friendID)
    }
    
    func acceptFriendRequest(index:Int)
    {
        let friendID = filteredUsers[index].userID
        FireBaseDB.sharedInstance.setFriend(friendID: friendID)
        filteredUsers.remove(at: index)
    }
    
    func removeFriend(index:Int)
    {
        let friendID = filteredUsers[index].userID
        FireBaseDB.sharedInstance.removeFriend(friendID: friendID)
        filteredUsers.remove(at: index)
    }
    
    func removeFriendRequest(index:Int)
    {
        let friendID = filteredUsers[index].userID
        FireBaseDB.sharedInstance.removeFriendRequest(friendID: friendID)
    }
}
