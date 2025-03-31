//
//  ViewController.swift
//  AITestApp
//
//  Created by L_0045_r.watanabe on 2025/03/25.
//

import UIKit
import Then

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Main"

        setupTabs()
    }

    func setupTabs() {
        let homeVC = HomeViewController()
        let homeTab = UINavigationController(rootViewController: homeVC)
        homeVC.tabBarItem = UITabBarItem(title: "ホーム", image: UIImage(systemName: "house"), tag: 0)

        let myPageVC = MyPageViewController()
        let myPageTab = UINavigationController(rootViewController: myPageVC)
        myPageVC.tabBarItem = UITabBarItem(title: "マイページ", image: UIImage(systemName: "person.crop.circle"), tag: 1)

        viewControllers = [homeTab, myPageTab]
    }
}
