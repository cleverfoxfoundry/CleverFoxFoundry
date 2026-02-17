import SwiftUI

struct HomeView: View {
    @Bindable var manager: AlarmManager
    @State private var showingAddAlarm = false

    var body: some View {
        ZStack {
            VikingColors.darkNavy.ignoresSafeArea()

            VStack(spacing: 0) {
                // Top: Clock display
                ClockView()
                    .padding(.top, 40)
                    .padding(.bottom, 24)

                // Divider
                vikingDivider

                // Header row with "Alarms" title and add button
                alarmHeader

                // Alarm list
                AlarmListView(manager: manager)
                    .frame(maxHeight: .infinity)
            }

            // Floating add button at bottom
            VStack {
                Spacer()
                addButton
                    .padding(.bottom, 20)
            }
        }
        .sheet(isPresented: $showingAddAlarm) {
            AlarmEditView(manager: manager)
        }
        .fullScreenCover(isPresented: $manager.isAlarmFiring) {
            AlarmFiringView(manager: manager)
        }
    }

    // MARK: - Viking Divider

    private var vikingDivider: some View {
        HStack(spacing: 12) {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.clear, VikingColors.gold.opacity(0.5)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)

            // Center ornament
            Image(systemName: "shield.fill")
                .font(.system(size: 12))
                .foregroundColor(VikingColors.gold.opacity(0.6))

            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [VikingColors.gold.opacity(0.5), Color.clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Alarm Header

    private var alarmHeader: some View {
        HStack {
            Text("ALARMS")
                .font(VikingFont.heading(18))
                .foregroundColor(VikingColors.gold)
                .tracking(3)

            Spacer()

            Text("\(manager.alarms.filter(\.isEnabled).count) active")
                .font(VikingFont.body(13))
                .foregroundColor(VikingColors.stone)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }

    // MARK: - Add Button

    private var addButton: some View {
        Button {
            showingAddAlarm = true
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .bold))
                Text("NEW ALARM")
                    .font(VikingFont.heading(16))
                    .tracking(1)
            }
            .foregroundColor(VikingColors.darkNavy)
            .padding(.horizontal, 28)
            .padding(.vertical, 14)
            .background(
                Capsule()
                    .fill(VikingColors.gold)
                    .shadow(color: VikingColors.gold.opacity(0.3), radius: 8, y: 4)
            )
        }
    }
}

#Preview {
    HomeView(manager: {
        let m = AlarmManager()
        m.alarms = [
            Alarm(hour: 7, minute: 0, label: "Raid at dawn!"),
            Alarm(hour: 12, minute: 30, isEnabled: false, label: "Midday feast"),
            Alarm(hour: 22, minute: 0, label: "Sharpen axes", repeatDays: [.monday, .wednesday, .friday])
        ]
        return m
    }())
}
