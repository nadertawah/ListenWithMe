//
//  Date.swift
//  ListenWithMe
//
//  Created by nader said on 20/08/2022.
//

import Foundation

extension Date
{
    static func fullDate(str : String) -> Date
    {
        DateFormatter.dateTimeDateFormatter().date(from: str) ?? Date()
    }
    
    func stringFromDate() -> String
    {
        DateFormatter.dateTimeDateFormatter().string(from: self)
    }
    
    func localString(dateStyle: DateFormatter.Style = .medium, timeStyle: DateFormatter.Style = .medium) -> String
    {
        DateFormatter.localizedString( from: self, dateStyle: dateStyle, timeStyle: timeStyle)
    }
}
