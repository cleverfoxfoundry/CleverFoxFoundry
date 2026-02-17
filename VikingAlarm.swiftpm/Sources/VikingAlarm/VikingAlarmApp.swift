import SwiftUI
import UserNotifications

@main
struct VikingAlarmApp: App {
    @StateObject private var alarmManager = AlarmManager()

    var body: some Scene {
        WindowGroup {
            HomeView(manager: alarmManager)
                .preferredColorScheme(.dark)
                .onAppear {
                    configureNotificationDelegate()
                }
        }
    }

    private func configureNotificationDelegate() {
        let center = UNUserNotificationCenter.current()

        // Define notification actions
        let dismissAction = UNNotificationAction(
            identifier: "DISMISS",
            title: "Silence the Viking",
            options: [.foreground]
        )
        let snoozeAction = UNNotificationAction(
            identifier: "SNOOZE",
            title: "Snooze (5 min)",
            options: []
        )

        let category = UNNotificationCategory(
            identifier: "VIKING_ALARM",
            actions: [dismissAction, snoozeAction],
            intentIdentifiers: [],
            options: [.customDismissAction]
        )

        center.setNotificationCategories([category])

        // Set delegate for foreground notifications
        let delegate = NotificationDelegate(alarmManager: alarmManager)
        center.delegate = delegate
        // Store reference to prevent deallocation
        NotificationDelegate.shared = delegate
    }
}

// MARK: - Notification Delegate

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    static var shared: NotificationDelegate?

    let alarmManager: AlarmManager

    init(alarmManager: AlarmManager) {
        self.alarmManager = alarmManager
    }

    // Show notification even when app is in foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Trigger the firing screen
        if let alarmIdString = notification.request.content.userInfo["alarmId"] as? String,
           let alarmId = UUID(uuidString: alarmIdString),
           let alarm = alarmManager.alarms.first(where: { $0.id == alarmId }) {
            DispatchQueue.main.async {
                self.alarmManager.triggerAlarm(alarm)
            }
        }
        completionHandler([.sound, .banner])
    }

    // Handle notification tap or action
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let alarmIdString = response.notification.request.content.userInfo["alarmId"] as? String
        let alarmId = alarmIdString.flatMap { UUID(uuidString: $0) }
        let alarm = alarmId.flatMap { id in alarmManager.alarms.first { $0.id == id } }

        switch response.actionIdentifier {
        case "SNOOZE":
            if let alarm = alarm {
                DispatchQueue.main.async {
                    self.alarmManager.firingAlarm = alarm
                    self.alarmManager.snoozeAlarm(minutes: 5)
                }
            }
        case "DISMISS", UNNotificationDefaultActionIdentifier:
            if let alarm = alarm {
                DispatchQueue.main.async {
                    self.alarmManager.triggerAlarm(alarm)
                }
            }
        default:
            break
        }
        completionHandler()
    }
}
