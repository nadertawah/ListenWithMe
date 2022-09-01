//
//  User.swift
//  Chatter
//
//  Created by Nader Said on 12/07/2022.
//

import Foundation

struct User
{
    var userID : String
    let createdAt : Date
    var updatedAt : Date
    var email : String
    var fullName : String
    var avatar : String
    var friends : [String] = []
    var friendRequests : [String] = []
    
    init(userID : String, createdAt : Date, updatedAt : Date, email : String, fullName : String, avatar : String, friends : [String] = [] , friendRequests : [String] = [])
    {
        self.userID = userID
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.email = email
        self.fullName = fullName
        self.avatar = avatar
        self.friends = friends
        self.friendRequests = friendRequests
    }
    
    init(_ dictionary: NSDictionary)
    {
        userID = dictionary.allKeys.first as? String ?? ""
        let dictValue = dictionary[userID] as? NSDictionary
        
        createdAt = Date.fullDate(str: dictValue?[Constants.kCREATEDAT] as? String ?? "")
        updatedAt = Date.fullDate(str: dictValue?[Constants.kUPDATEDAT] as? String ?? "")
        email = dictValue?[Constants.kEMAIL] as? String ?? ""
        fullName = dictValue?[Constants.kFULLNAME] as? String ?? ""
        avatar = dictValue?[Constants.kAVATAR] as? String ?? ""
        
        let friendsDict = dictValue?[Constants.kFRIENDS] as? NSDictionary
        self.friends = friendsDict?.allValues as? [String] ?? []
        
        let friendRequestsDict = dictValue?[Constants.kFRIENDREQUESTS] as? NSDictionary
        self.friendRequests = friendRequestsDict?.allValues as? [String] ?? []
    }
    
    //MARK: - Helper Funcs
    func userDictionary() -> NSDictionary
    {
        
        let createdAt = createdAt.stringFromDate()
        let updatedAt = updatedAt.stringFromDate()
        
        return NSDictionary(objects: [createdAt,    updatedAt,  email,    fullName,   avatar ],
                            forKeys: [Constants.kCREATEDAT as NSCopying, Constants.kUPDATEDAT as NSCopying, Constants.kEMAIL as NSCopying, Constants.kFULLNAME as NSCopying, Constants.kAVATAR as NSCopying])
    }
}
