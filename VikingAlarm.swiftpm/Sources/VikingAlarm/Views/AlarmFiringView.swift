import SwiftUI

struct AlarmFiringView: View {
    @ObservedObject var manager: AlarmManager
    @State private var rotationAngle: Double = 0
    @State private var isShaking = false
    @State private var glowIntensity: Double = 0.5
    @State private var showSnoozeConfirm = false

    var body: some View {
        ZStack {
            // Animated background
            angryBackground

            VStack(spacing: 20) {
                Spacer()

                // "WAKE UP" header
                wakeUpHeader

                // Animated angry Viking head
                animatedViking

                // Time display
                if let alarm = manager.firingAlarm {
                    Text(alarm.timeString)
                        .font(VikingFont.clock(48))
                        .foregroundColor(VikingColors.gold)
                        .shadow(color: VikingColors.fireOrange.opacity(0.6), radius: 10)

                    Text(alarm.label)
                        .font(VikingFont.body(18))
                        .foregroundColor(VikingColors.bone)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }

                Spacer()

                // Action buttons
                actionButtons

                Spacer()
                    .frame(height: 40)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            startAnimations()
        }
    }

    // MARK: - Angry Background

    private var angryBackground: some View {
        ZStack {
            // Base dark
            VikingColors.darkNavy

            // Pulsing red glow
            RadialGradient(
                colors: [
                    VikingColors.bloodRed.opacity(glowIntensity * 0.4),
                    VikingColors.darkNavy
                ],
                center: .center,
                startRadius: 50,
                endRadius: 400
            )

            // Fire-like gradient at top
            LinearGradient(
                colors: [
                    VikingColors.fireOrange.opacity(glowIntensity * 0.2),
                    Color.clear
                ],
                startPoint: .top,
                endPoint: .center
            )
        }
    }

    // MARK: - Wake Up Header

    private var wakeUpHeader: some View {
        VStack(spacing: 4) {
            Text("WAKE UP")
                .font(VikingFont.display(42))
                .foregroundColor(VikingColors.bloodRed)
                .shadow(color: VikingColors.fireOrange.opacity(0.8), radius: 8)
                .offset(x: isShaking ? -3 : 3)
                .animation(
                    .easeInOut(duration: 0.08).repeatForever(autoreverses: true),
                    value: isShaking
                )

            Text("WARRIOR!")
                .font(VikingFont.display(28))
                .foregroundColor(VikingColors.gold)
                .shadow(color: VikingColors.gold.opacity(0.5), radius: 6)
        }
    }

    // MARK: - Animated Viking

    private var animatedViking: some View {
        VikingHeadView(size: 220, isAngry: true)
            .rotationEffect(.degrees(rotationAngle))
            .shadow(color: VikingColors.bloodRed.opacity(0.4), radius: 20)
            .padding(.vertical, 20)
    }

    // MARK: - Action Buttons

    private var actionButtons: some View {
        VStack(spacing: 16) {
            // Dismiss button
            Button {
                manager.dismissAlarm()
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 22))
                    Text("SILENCE THE VIKING")
                        .font(VikingFont.heading(18))
                }
                .foregroundColor(VikingColors.darkNavy)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(VikingColors.gold)
                )
                .shadow(color: VikingColors.gold.opacity(0.4), radius: 8)
            }
            .padding(.horizontal, 40)

            // Snooze button
            Button {
                manager.snoozeAlarm(minutes: 5)
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "moon.zzz.fill")
                        .font(.system(size: 18))
                    Text("Snooze (5 min)")
                        .font(VikingFont.body(16))
                }
                .foregroundColor(VikingColors.stone)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(VikingColors.iron, lineWidth: 1.5)
                )
            }
            .padding(.horizontal, 40)
        }
    }

    // MARK: - Animations

    private func startAnimations() {
        // Viking head turning side to side like a dial
        withAnimation(
            .easeInOut(duration: 0.6)
            .repeatForever(autoreverses: true)
        ) {
            rotationAngle = 15
        }

        // After a short delay, also animate the reverse
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(
                .easeInOut(duration: 0.6)
                .repeatForever(autoreverses: true)
            ) {
                rotationAngle = -15
            }
        }

        // Screen shake
        isShaking = true

        // Pulsing glow
        withAnimation(
            .easeInOut(duration: 1.0)
            .repeatForever(autoreverses: true)
        ) {
            glowIntensity = 1.0
        }
    }
}

#Preview {
    AlarmFiringView(manager: {
        let m = AlarmManager()
        m.firingAlarm = Alarm(hour: 7, minute: 0, label: "Time to raid!")
        m.isAlarmFiring = true
        return m
    }())
}
