//
//  NotificationsManager.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 28.10.2022.
//  Copyright © 2022 messeb.com. All rights reserved.
//

import Foundation
import NotificationPermission
import PermissionsKit
import UserNotifications

class NotificationManager: NSObject {
    static let shared = NotificationManager()

    func addNotification(
        id: String,
        title: String,
        subtitle: String,
        sound: UNNotificationSound = UNNotificationSound.default,
        trigger: UNNotificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false),
        userInfo: [AnyHashable: Any] = [:]
    ) {
        let authorized = Permission.notification.authorized
        if !authorized {
            Permission.notification.request {
                if Permission.notification.authorized {
                    let content = UNMutableNotificationContent()
                    content.title = title
                    content.subtitle = subtitle
                    content.userInfo = userInfo
                    content.sound = sound

                    let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                    let center = UNUserNotificationCenter.current()
                    center.add(request)
                }
            }
        } else {
            let content = UNMutableNotificationContent()
            content.title = title
            content.subtitle = subtitle
            content.userInfo = userInfo
            content.sound = sound

            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            center.add(request) { error in
                if let error = error {
                    print(error)
                }
            }
        }
    }

    func removeNotifications(_ ids: [String]) {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ids)
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _: UNUserNotificationCenter,
        willPresent _: UNNotification,
        withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler(.banner)
    }
}
