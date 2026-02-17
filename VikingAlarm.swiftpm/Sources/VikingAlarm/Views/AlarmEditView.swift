import SwiftUI

struct AlarmEditView: View {
    @Bindable var manager: AlarmManager
    @Environment(\.dismiss) private var dismiss

    @State private var hour: Int
    @State private var minute: Int
    @State private var label: String
    @State private var repeatDays: Set<Weekday>
    @State private var isEnabled: Bool

    private let existingAlarm: Alarm?
    private let isNewAlarm: Bool

    // Init for editing an existing alarm
    init(manager: AlarmManager, alarm: Alarm) {
        self.manager = manager
        self.existingAlarm = alarm
        self.isNewAlarm = false
        _hour = State(initialValue: alarm.hour)
        _minute = State(initialValue: alarm.minute)
        _label = State(initialValue: alarm.label)
        _repeatDays = State(initialValue: alarm.repeatDays)
        _isEnabled = State(initialValue: alarm.isEnabled)
    }

    // Init for creating a new alarm
    init(manager: AlarmManager) {
        self.manager = manager
        self.existingAlarm = nil
        self.isNewAlarm = true
        let now = Calendar.current.dateComponents([.hour, .minute], from: Date())
        _hour = State(initialValue: now.hour ?? 7)
        _minute = State(initialValue: now.minute ?? 0)
        _label = State(initialValue: "Wake up, warrior!")
        _repeatDays = State(initialValue: [])
        _isEnabled = State(initialValue: true)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                VikingColors.darkNavy.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // Time picker
                        timePickerSection

                        // Label
                        labelSection

                        // Repeat days
                        repeatSection

                        // Delete button (only for existing alarms)
                        if !isNewAlarm {
                            deleteButton
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle(isNewAlarm ? "New Alarm" : "Edit Alarm")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(VikingColors.deepCharcoal, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(VikingColors.stone)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveAlarm() }
                        .foregroundColor(VikingColors.gold)
                        .fontWeight(.bold)
                }
            }
        }
    }

    // MARK: - Time Picker

    private var timePickerSection: some View {
        VStack(spacing: 16) {
            HStack(spacing: 4) {
                // Hour picker
                Picker("Hour", selection: $hour) {
                    ForEach(0..<24, id: \.self) { h in
                        let display = h % 12 == 0 ? 12 : h % 12
                        Text("\(display)")
                            .font(VikingFont.clock(36))
                            .foregroundColor(VikingColors.gold)
                            .tag(h)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 80, height: 150)
                .clipped()

                Text(":")
                    .font(VikingFont.clock(36))
                    .foregroundColor(VikingColors.gold)

                // Minute picker
                Picker("Minute", selection: $minute) {
                    ForEach(0..<60, id: \.self) { m in
                        Text(String(format: "%02d", m))
                            .font(VikingFont.clock(36))
                            .foregroundColor(VikingColors.gold)
                            .tag(m)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 80, height: 150)
                .clipped()

                // AM/PM indicator
                Text(hour < 12 ? "AM" : "PM")
                    .font(VikingFont.heading(20))
                    .foregroundColor(VikingColors.amber)
                    .padding(.leading, 8)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(VikingColors.deepCharcoal)
            )
            .runicBorder()
        }
    }

    // MARK: - Label

    private var labelSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Battle Cry")
                .font(VikingFont.heading(14))
                .foregroundColor(VikingColors.gold)

            TextField("Wake up, warrior!", text: $label)
                .font(VikingFont.body(16))
                .foregroundColor(VikingColors.bone)
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(VikingColors.deepCharcoal)
                )
                .runicBorder()
        }
    }

    // MARK: - Repeat Days

    private var repeatSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Repeat")
                .font(VikingFont.heading(14))
                .foregroundColor(VikingColors.gold)

            HStack(spacing: 8) {
                ForEach(Weekday.allCases, id: \.self) { day in
                    Button {
                        if repeatDays.contains(day) {
                            repeatDays.remove(day)
                        } else {
                            repeatDays.insert(day)
                        }
                    } label: {
                        Text(day.initial)
                            .font(.system(size: 14, weight: .bold, design: .serif))
                            .foregroundColor(
                                repeatDays.contains(day)
                                ? VikingColors.darkNavy
                                : VikingColors.stone
                            )
                            .frame(width: 38, height: 38)
                            .background(
                                Circle()
                                    .fill(
                                        repeatDays.contains(day)
                                        ? VikingColors.gold
                                        : VikingColors.deepCharcoal
                                    )
                            )
                            .overlay(
                                Circle()
                                    .stroke(
                                        repeatDays.contains(day)
                                        ? Color.clear
                                        : VikingColors.iron,
                                        lineWidth: 1
                                    )
                            )
                    }
                    .buttonStyle(.plain)
                }
            }

            if repeatDays.isEmpty {
                Text("One-time alarm")
                    .font(VikingFont.body(12))
                    .foregroundColor(VikingColors.iron)
            } else {
                Text(repeatSummary)
                    .font(VikingFont.body(12))
                    .foregroundColor(VikingColors.stone)
            }
        }
    }

    private var repeatSummary: String {
        let sorted = repeatDays.sorted()
        if sorted.count == 7 { return "Every day" }
        if sorted == [.monday, .tuesday, .wednesday, .thursday, .friday] { return "Weekdays" }
        if sorted == [.saturday, .sunday] { return "Weekends" }
        return sorted.map(\.shortName).joined(separator: ", ")
    }

    // MARK: - Delete

    private var deleteButton: some View {
        Button {
            if let alarm = existingAlarm {
                manager.deleteAlarm(alarm)
            }
            dismiss()
        } label: {
            Text("Delete Alarm")
                .font(VikingFont.heading(16))
                .foregroundColor(VikingColors.bloodRed)
                .frame(maxWidth: .infinity)
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(VikingColors.bloodRed.opacity(0.1))
                )
                .runicBorder(color: VikingColors.bloodRed)
        }
    }

    // MARK: - Save

    private func saveAlarm() {
        if isNewAlarm {
            let alarm = Alarm(
                hour: hour,
                minute: minute,
                isEnabled: true,
                label: label.isEmpty ? "Wake up, warrior!" : label,
                repeatDays: repeatDays
            )
            manager.addAlarm(alarm)
        } else if var alarm = existingAlarm {
            alarm.hour = hour
            alarm.minute = minute
            alarm.label = label.isEmpty ? "Wake up, warrior!" : label
            alarm.repeatDays = repeatDays
            alarm.isEnabled = isEnabled
            manager.updateAlarm(alarm)
        }
        dismiss()
    }
}

#Preview {
    AlarmEditView(manager: AlarmManager())
}
