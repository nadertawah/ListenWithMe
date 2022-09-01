//
//  FireBaseDB.swift
//  Chatter
//
//  Created by Nader Said on 12/07/2022.
//

import Foundation
import FirebaseDatabase

class FireBaseDB
{
    private init()
    {
        let db = Database.database(url: Constants.fireBaseDBUrl)
        db.isPersistenceEnabled = true
        DBref = db.reference()
    }
    
    static let sharedInstance = FireBaseDB()
    var DBref  : DatabaseReference
}

