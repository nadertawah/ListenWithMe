//
//  Constants.swift
//  Chatter
//
//  Created by Nader Said on 12/07/2022.
//

import Foundation
import UIKit

struct Constants
{
    //Users
    static let kALLUSERS = "Users"
    static let kAVATAR = "avatar"
    static let kCREATEDAT = "createdAt"
    static let kEMAIL = "email"
    static let kFULLNAME = "fullname"
    static let kONLINE = "isOnline"
    static let kUPDATEDAT = "updatedAt"
    static let kUSERID = "userId"
    static let kFRIENDS = "friends"
    static let kFRIENDREQUESTS = "friendRequests"
    static let kSONGSCOLLECTION = "songsCollection"
    //-------------------//

    //rooms
    static let kROOMS = "Rooms"
    static let kSYNCSTATE = "syncState"
    static let kPREPARINGTOPLAYSTATE = "preparingToPlay"
    static let kNOWPLAYING = "nowPlaying"
    static let kCURRENTSONGTIME = "currentTimeInterval"
    static let kISPAUSED = "isPaused"
    
    //FireStore
    static let kIMAGESTORE = "images"
    //-------------------//
    
    //URLs
    static let fireBaseDBUrl = "https://listenwithme-3ee11-default-rtdb.europe-west1.firebasedatabase.app/"
    static let fireBaseStoreUrl = "gs://listenwithme-3ee11.appspot.com"
    //-------------------//

    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
            
}

