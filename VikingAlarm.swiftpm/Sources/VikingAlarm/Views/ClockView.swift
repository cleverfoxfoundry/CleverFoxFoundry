import SwiftUI

struct ClockView: View {
    @State private var currentTime = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 8) {
            // Viking head as clock topper
            VikingHeadView(size: 80, isAngry: false)
                .padding(.bottom, 4)

            // Time display
            Text(timeString)
                .font(VikingFont.clock(64))
                .foregroundColor(VikingColors.gold)
                .shadow(color: VikingColors.gold.opacity(0.3), radius: 8)

            // Seconds
            Text(secondsString)
                .font(VikingFont.clock(20))
                .foregroundColor(VikingColors.amber.opacity(0.7))

            // Date
            Text(dateString)
                .font(VikingFont.body(16))
                .foregroundColor(VikingColors.stone)
                .padding(.top, 4)
        }
        .onReceive(timer) { _ in
            currentTime = Date()
        }
    }

    private var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm"
        return formatter.string(from: currentTime)
    }

    private var secondsString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ss a"
        return formatter.string(from: currentTime)
    }

    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: currentTime)
    }
}

struct ClockView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            VikingColors.darkNavy.ignoresSafeArea()
            ClockView()
        }
    }
}
