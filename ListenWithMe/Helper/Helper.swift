//
//  Helper.swift
//  ListenWithMe
//
//  Created by nader said on 20/08/2022.
//

import FirebaseAuth

struct Helper
{
    static func getChatRoomID(ID1: String, ID2: String) -> String
    {
        let compariosnResult = ID1.compare(ID2).rawValue
        if(compariosnResult == 1){return ID2 + ID1}
        else {return ID1 + ID2}
    }
    
    //Auth
    static func getCurrentUserID() -> String
    {
        Auth.auth().currentUser?.uid ?? ""
    }

}
