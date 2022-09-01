//
//  BaseTabBar.swift
//  Chatter
//
//  Created by nader said on 12/07/2022.
//

import UIKit

class BaseTabBar:  UITabBarController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //initiate tabBar VC(s)
        
        //Home Screen
        let homeVC = HomeVC()
        homeVC.title = "Home"

        //profile screen
        let profileVC = ProfileView()
        profileVC.title = "Profile"
        
        //Set VC(s) in the tabBar
        self.setViewControllers([homeVC, profileVC], animated: true)
        
        //Set tabBar image
        guard let items = self.tabBar.items else { return }
        items[0].image = UIImage(systemName: "music.note.house.fill")
        items[1].image = UIImage(systemName: "person.fill")

        //set tabBar attributes
        self.tabBar.tintColor = UIColor.black
        self.tabBar.backgroundColor = UIColor.systemGray3
    }
    
}
