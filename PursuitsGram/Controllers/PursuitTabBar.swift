//
//  PursuitTabBar.swift
//  PursuitsGram
//
//  Created by Krystal Campbell on 11/25/19.
//  Copyright © 2019 Krystal Campbell. All rights reserved.
//

import UIKit

class PursuitTabBar: UITabBarController {
    
    lazy var feedVC = UINavigationController(rootViewController: PostsFeedViewController())
    
    lazy var uploadVC = UINavigationController(rootViewController: UploadViewController())
    
    lazy var profileVC: UINavigationController  = {
        let userProfileVC = UserProfileViewController()
        userProfileVC.user = AppUser(from: FirebaseAuthService.manager.currentUser!)
        userProfileVC.isCurrentUser = true
        return UINavigationController(rootViewController: userProfileVC)
    }()

    override func viewDidLoad() {
        feedVC.isNavigationBarHidden = true
        uploadVC.isNavigationBarHidden = true
        profileVC.isNavigationBarHidden = true
        super.viewDidLoad()
        feedVC.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "list.bullet"), tag: 0)
        uploadVC.tabBarItem = UITabBarItem(title: "Upload", image: UIImage(systemName: "plus.square"), tag: 1)
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.circle"), tag: 2)
        self.viewControllers = [feedVC,uploadVC,profileVC]
        self.viewControllers?.forEach({ $0.tabBarController?.tabBar.barStyle = .black})

        // Do any additional setup after loading the view.
    }
    
}
