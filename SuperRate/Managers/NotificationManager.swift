//
//  NotificationManager.swift
//  SuperRate
//
//  Created by AnaKardava on 05.07.24.
//

import UserNotifications

final class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
  // MARK: - Shared Instance
  static let shared = NotificationManager()

  // MARK: - Init
  private override init() {
    super.init()
    UNUserNotificationCenter.current().delegate = self
  }

  // MARK: - Methods
  func requestAuthorization(completion: @escaping (Bool) -> Void) {
    let options: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, _ in
      completion(granted)
    }
  }

  func scheduleNotification(for order: OrderInfo) {
    let content = UNMutableNotificationContent()
    content.title = "კონვერტაციის განაცხადი წარმატებულია"
    content.body = "დეტალები იხილეთ დასრულებულ განაცხადებში"
    content.sound = .default

    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)

    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

    UNUserNotificationCenter.current().add(request) { error in
      if let error = error {
        print("Error scheduling notification: \(error.localizedDescription)")
      } else {
        print("Notification scheduled for 2 minutes later.")
      }
    }
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.banner, .sound, .badge])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    completionHandler()
  }
}
