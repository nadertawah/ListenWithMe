//
//  ProfileVM.swift
//  Chatter
//
//  Created by nader said on 14/07/2022.
//

import Foundation
import FirebaseAuth
import Combine

class ProfileVM
{
    init()
    {
        DispatchQueue.global(qos: .userInteractive).async
        { [weak self] in
            self?.getUserData()
        }
    }
    
    //MARK: - Var(s)
    @Published private(set) var user =  User(userID: "", createdAt: Date(), updatedAt: Date(), email: "", fullName: "", avatar: "")
    
    //MARK: - intent(s)
    func logout(completion : @escaping ()->())
    {
        DispatchQueue.global(qos: .userInteractive).async
        {
            do
            {
                try Auth.auth().signOut()
                DispatchQueue.main.async
                {
                    completion()
                }
            }
            catch { print("already logged out") }
        }
    }
    
    //MARK: - Helper Funcs
    func getUserData()
    {
        FireBaseDB.sharedInstance.observeProfile {[weak self] in self?.user =  $0}
    }
    
    func changeAvatar(avatarStr : String)
    {
        //save to firebase db
        FireBaseDB.sharedInstance.setAvatar(avatarStr: avatarStr)
    }
}
