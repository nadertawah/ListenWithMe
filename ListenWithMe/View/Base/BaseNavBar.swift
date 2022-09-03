//
//  BaseNavBar.swift
//  Chatter
//
//  Created by nader said on 12/07/2022.
//

import UIKit

class BaseNavBar : UINavigationController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.isNavigationBarHidden = true
        
        //NavBar Attributes
        navigationBar.prefersLargeTitles = true
        
        navigationBar.tintColor = UIColor.black
        overrideUserInterfaceStyle = .light

        self.viewControllers = [BaseTabBar()]
    }
    
    
}

