import Foundation

struct Alarm: Identifiable, Codable, Equatable {
    var id: UUID
    var hour: Int
    var minute: Int
    var isEnabled: Bool
    var label: String
    var repeatDays: Set<Weekday>
    var soundName: String

    init(
        id: UUID = UUID(),
        hour: Int = 7,
        minute: Int = 0,
        isEnabled: Bool = true,
        label: String = "Wake up, warrior!",
        repeatDays: Set<Weekday> = [],
        soundName: String = "viking_horn"
    ) {
        self.id = id
        self.hour = hour
        self.minute = minute
        self.isEnabled = isEnabled
        self.label = label
        self.repeatDays = repeatDays
        self.soundName = soundName
    }

    var timeString: String {
        let h = hour % 12 == 0 ? 12 : hour % 12
        let period = hour < 12 ? "AM" : "PM"
        return String(format: "%d:%02d %@", h, minute, period)
    }

    var nextFireDate: Date? {
        let calendar = Calendar.current
        let now = Date()
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        components.second = 0

        if repeatDays.isEmpty {
            // One-time alarm: find the next occurrence
            guard let candidate = calendar.nextDate(
                after: now,
                matching: components,
                matchingPolicy: .nextTime
            ) else { return nil }
            return candidate
        } else {
            // Repeating: find the nearest matching weekday
            var nearest: Date?
            for day in repeatDays {
                components.weekday = day.calendarWeekday
                if let candidate = calendar.nextDate(
                    after: now,
                    matching: components,
                    matchingPolicy: .nextTime
                ) {
                    if nearest == nil || candidate < nearest! {
                        nearest = candidate
                    }
                }
            }
            return nearest
        }
    }
}

enum Weekday: Int, Codable, CaseIterable, Comparable {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday

    var shortName: String {
        switch self {
        case .sunday:    return "Sun"
        case .monday:    return "Mon"
        case .tuesday:   return "Tue"
        case .wednesday: return "Wed"
        case .thursday:  return "Thu"
        case .friday:    return "Fri"
        case .saturday:  return "Sat"
        }
    }

    var initial: String {
        String(shortName.prefix(1))
    }

    var calendarWeekday: Int { rawValue }

    static func < (lhs: Weekday, rhs: Weekday) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
