//
//  TabBar.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 07.10.2022.
//  Copyright © 2022 messeb.com. All rights reserved.
//

import SafeSFSymbols
import UIKit

class TabBar: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBar.appearance().tintColor = .systemBackground
        tabBar.tintColor = .Pallette.buttonBg
        view.backgroundColor = .systemBackground
        if #available(iOS 15.0, *) {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }

        setupTabs()
    }

    private func setupTabs() {
        viewControllers = [
            makeCoursesScreen(),
            makeScheduleScreen(),
            makeProfileScreen()
        ]
        selectedIndex = 1
    }

    private func makeCoursesScreen() -> UIViewController {
        let coursesNavigationController = UINavigationController()
        coursesNavigationController.setRootWireframe(CoursesScreenWireframe())
        coursesNavigationController.tabBarItem.image = UIImage(.list.bulletBelowRectangle)
        coursesNavigationController.tabBarItem.title = "Курсы"
        return coursesNavigationController
    }

    private func makeScheduleScreen() -> UIViewController {
        let scheduleNavigationController = UINavigationController()
        scheduleNavigationController.setRootWireframe(ScheduleScreenWireframe())
        scheduleNavigationController.tabBarItem.image = UIImage(.clock)
        scheduleNavigationController.tabBarItem.title = "Расписание"
        return scheduleNavigationController
    }

    private func makeProfileScreen() -> UIViewController {
        let profileNavigationController = UINavigationController()
        profileNavigationController.setRootWireframe(ProfileScreenWireframe())
        profileNavigationController.tabBarItem.image = UIImage(.person)
        profileNavigationController.tabBarItem.title = "Профиль"
        return profileNavigationController
    }
}
