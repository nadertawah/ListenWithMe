//
//  FileManager.swift
//  ListenWithMe
//
//  Created by Nader Said on 25/08/2022.
//

import Foundation

extension FileManager
{
    static func documentDir() -> URL
    {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    static func songUrlInDocuments(fileName:String) -> URL
    {
        documentDir().appendingPathComponent(fileName + ".m4a")
    }
}
