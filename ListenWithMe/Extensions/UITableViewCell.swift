//
//  UITableViewCell.swift
//  ListenWithMe
//
//  Created by nader said on 21/08/2022.
//

import UIKit

extension UITableViewCell
{
    static var reuseIdentfier : String
    {
        return String(describing: self)
    }
}
