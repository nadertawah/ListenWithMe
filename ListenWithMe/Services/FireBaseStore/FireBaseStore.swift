//
//  FireBaseStore.swift
//  ListenWithMe
//
//  Created by Nader Said on 25/08/2022.
//

import Foundation
import FirebaseStorage

class FireBaseStore
{
    private init()
    {
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage(url:  Constants.fireBaseStoreUrl)

        // Create a storage reference from our storage service
        storageRef = storage.reference()
    }
    
    static let sharedInstance = FireBaseStore()
    var storageRef  : StorageReference
    
}
