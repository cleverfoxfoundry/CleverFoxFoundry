import SwiftUI

struct AlarmListView: View {
    @Bindable var manager: AlarmManager
    @State private var showingAddAlarm = false

    var body: some View {
        VStack(spacing: 0) {
            if manager.alarms.isEmpty {
                emptyState
            } else {
                alarmList
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "moon.zzz.fill")
                .font(.system(size: 40))
                .foregroundColor(VikingColors.iron)

            Text("No alarms set")
                .font(VikingFont.body(16))
                .foregroundColor(VikingColors.stone)

            Text("Even Vikings need to wake up!")
                .font(VikingFont.body(14))
                .foregroundColor(VikingColors.iron)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }

    private var alarmList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(manager.alarms.sorted(by: {
                    ($0.hour * 60 + $0.minute) < ($1.hour * 60 + $1.minute)
                })) { alarm in
                    AlarmRowView(alarm: alarm, manager: manager)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }
}

struct AlarmRowView: View {
    let alarm: Alarm
    @Bindable var manager: AlarmManager
    @State private var showingEdit = false

    var body: some View {
        Button {
            showingEdit = true
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(alarm.timeString)
                        .font(VikingFont.clock(32))
                        .foregroundColor(alarm.isEnabled ? VikingColors.gold : VikingColors.iron)

                    Text(alarm.label)
                        .font(VikingFont.body(13))
                        .foregroundColor(alarm.isEnabled ? VikingColors.stone : VikingColors.iron)

                    if !alarm.repeatDays.isEmpty {
                        HStack(spacing: 4) {
                            ForEach(Weekday.allCases, id: \.self) { day in
                                Text(day.initial)
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(
                                        alarm.repeatDays.contains(day)
                                        ? VikingColors.gold
                                        : VikingColors.iron
                                    )
                            }
                        }
                    }
                }

                Spacer()

                // Toggle
                Button {
                    manager.toggleAlarm(alarm)
                } label: {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(alarm.isEnabled ? VikingColors.gold : VikingColors.iron.opacity(0.3))
                        .frame(width: 51, height: 31)
                        .overlay(
                            Circle()
                                .fill(alarm.isEnabled ? VikingColors.darkNavy : VikingColors.stone)
                                .frame(width: 27, height: 27)
                                .offset(x: alarm.isEnabled ? 10 : -10)
                                .animation(.easeInOut(duration: 0.2), value: alarm.isEnabled)
                        )
                }
                .buttonStyle(.plain)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(VikingColors.deepCharcoal)
            )
            .runicBorder(color: alarm.isEnabled ? VikingColors.gold : VikingColors.iron.opacity(0.3))
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showingEdit) {
            AlarmEditView(manager: manager, alarm: alarm)
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                manager.deleteAlarm(alarm)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

#Preview {
    ZStack {
        VikingColors.darkNavy.ignoresSafeArea()
        AlarmListView(manager: AlarmManager())
    }
}
