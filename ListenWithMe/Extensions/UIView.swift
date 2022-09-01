//
//  UIView.swift
//  ListenWithMe
//
//  Created by nader said on 20/08/2022.
//

import UIKit

extension UIView
{
    func addShadows()
    {
        self.layer.cornerRadius = 20
        self.layer.shadowRadius = 10
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 1
    }
}
