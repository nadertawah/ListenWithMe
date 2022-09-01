//
//  DateFormatter.swift
//  ListenWithMe
//
//  Created by nader said on 20/08/2022.
//

import Foundation

extension DateFormatter
{
    static func dateTimeDateFormatter() -> DateFormatter
    {
        let dateFormat = "yyyyMMddHHmmss"
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: "en")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: TimeZone.current.secondsFromGMT())
        dateFormatter.dateFormat = dateFormat
        return dateFormatter
    }
}
