import SwiftUI
import UserNotifications

class AlarmManager: ObservableObject {
    @Published var alarms: [Alarm] = []
    @Published var firingAlarm: Alarm?
    @Published var isAlarmFiring: Bool = false

    private let storageKey = "viking_alarms"

    init() {
        loadAlarms()
        requestNotificationPermission()
    }

    // MARK: - Notification Permission

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            }
        }
    }

    // MARK: - CRUD

    func addAlarm(_ alarm: Alarm) {
        alarms.append(alarm)
        if alarm.isEnabled {
            scheduleNotification(for: alarm)
        }
        saveAlarms()
    }

    func updateAlarm(_ alarm: Alarm) {
        guard let index = alarms.firstIndex(where: { $0.id == alarm.id }) else { return }
        cancelNotification(for: alarms[index])
        alarms[index] = alarm
        if alarm.isEnabled {
            scheduleNotification(for: alarm)
        }
        saveAlarms()
    }

    func deleteAlarm(_ alarm: Alarm) {
        cancelNotification(for: alarm)
        alarms.removeAll { $0.id == alarm.id }
        saveAlarms()
    }

    func toggleAlarm(_ alarm: Alarm) {
        guard let index = alarms.firstIndex(where: { $0.id == alarm.id }) else { return }
        alarms[index].isEnabled.toggle()
        if alarms[index].isEnabled {
            scheduleNotification(for: alarms[index])
        } else {
            cancelNotification(for: alarms[index])
        }
        saveAlarms()
    }

    // MARK: - Alarm Firing

    func triggerAlarm(_ alarm: Alarm) {
        firingAlarm = alarm
        isAlarmFiring = true
    }

    func dismissAlarm() {
        guard let alarm = firingAlarm else { return }
        isAlarmFiring = false
        firingAlarm = nil

        // If it's a one-time alarm, disable it
        if alarm.repeatDays.isEmpty {
            if let index = alarms.firstIndex(where: { $0.id == alarm.id }) {
                alarms[index].isEnabled = false
                saveAlarms()
            }
        } else {
            // Reschedule for the next occurrence
            scheduleNotification(for: alarm)
        }
    }

    func snoozeAlarm(minutes: Int = 5) {
        guard let alarm = firingAlarm else { return }
        isAlarmFiring = false
        firingAlarm = nil

        // Schedule a snooze notification
        let content = UNMutableNotificationContent()
        content.title = "VIKING ALARM!"
        content.body = alarm.label
        content.sound = .default
        content.categoryIdentifier = "VIKING_ALARM"

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: TimeInterval(minutes * 60),
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: "\(alarm.id.uuidString)-snooze",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }

    // MARK: - Local Notifications

    private func scheduleNotification(for alarm: Alarm) {
        let content = UNMutableNotificationContent()
        content.title = "VIKING ALARM!"
        content.body = alarm.label
        content.sound = .default
        content.categoryIdentifier = "VIKING_ALARM"
        content.userInfo = ["alarmId": alarm.id.uuidString]

        if alarm.repeatDays.isEmpty {
            // One-time alarm
            var dateComponents = DateComponents()
            dateComponents.hour = alarm.hour
            dateComponents.minute = alarm.minute

            let trigger = UNCalendarNotificationTrigger(
                dateMatching: dateComponents,
                repeats: false
            )

            let request = UNNotificationRequest(
                identifier: alarm.id.uuidString,
                content: content,
                trigger: trigger
            )

            UNUserNotificationCenter.current().add(request)
        } else {
            // Repeating alarm: one notification per weekday
            for day in alarm.repeatDays {
                var dateComponents = DateComponents()
                dateComponents.hour = alarm.hour
                dateComponents.minute = alarm.minute
                dateComponents.weekday = day.calendarWeekday

                let trigger = UNCalendarNotificationTrigger(
                    dateMatching: dateComponents,
                    repeats: true
                )

                let request = UNNotificationRequest(
                    identifier: "\(alarm.id.uuidString)-\(day.rawValue)",
                    content: content,
                    trigger: trigger
                )

                UNUserNotificationCenter.current().add(request)
            }
        }
    }

    private func cancelNotification(for alarm: Alarm) {
        var identifiers = [alarm.id.uuidString]
        for day in Weekday.allCases {
            identifiers.append("\(alarm.id.uuidString)-\(day.rawValue)")
        }
        identifiers.append("\(alarm.id.uuidString)-snooze")
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: identifiers
        )
    }

    // MARK: - Persistence

    private func saveAlarms() {
        if let data = try? JSONEncoder().encode(alarms) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    private func loadAlarms() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([Alarm].self, from: data)
        else { return }
        alarms = decoded
    }
}
