import SwiftUI

// MARK: - Viking Color Palette
enum VikingColors {
    // Primary backgrounds
    static let darkNavy = Color(red: 0.08, green: 0.08, blue: 0.16)
    static let deepCharcoal = Color(red: 0.12, green: 0.11, blue: 0.18)

    // Accent golds
    static let gold = Color(red: 0.79, green: 0.64, blue: 0.15)
    static let amber = Color(red: 0.83, green: 0.66, blue: 0.27)
    static let paleGold = Color(red: 0.91, green: 0.80, blue: 0.46)

    // Angry reds
    static let bloodRed = Color(red: 0.72, green: 0.11, blue: 0.11)
    static let fireOrange = Color(red: 0.89, green: 0.35, blue: 0.13)
    static let ember = Color(red: 0.95, green: 0.55, blue: 0.20)

    // Neutrals
    static let bone = Color(red: 0.90, green: 0.86, blue: 0.78)
    static let stone = Color(red: 0.55, green: 0.52, blue: 0.48)
    static let iron = Color(red: 0.35, green: 0.33, blue: 0.38)

    // Shield/leather browns
    static let leather = Color(red: 0.45, green: 0.28, blue: 0.15)
    static let darkWood = Color(red: 0.30, green: 0.18, blue: 0.10)
}

// MARK: - Viking Typography
enum VikingFont {
    // Use system serif fonts for a runic/medieval feel
    static func display(_ size: CGFloat) -> Font {
        .system(size: size, weight: .black, design: .serif)
    }

    static func heading(_ size: CGFloat) -> Font {
        .system(size: size, weight: .bold, design: .serif)
    }

    static func body(_ size: CGFloat) -> Font {
        .system(size: size, weight: .medium, design: .serif)
    }

    static func clock(_ size: CGFloat) -> Font {
        .system(size: size, weight: .heavy, design: .monospaced)
    }
}

// MARK: - Viking Button Style
struct VikingButtonStyle: ButtonStyle {
    var isPrimary: Bool = true

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(VikingFont.heading(18))
            .foregroundColor(isPrimary ? VikingColors.darkNavy : VikingColors.gold)
            .padding(.horizontal, 28)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isPrimary ? VikingColors.gold : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(VikingColors.gold, lineWidth: isPrimary ? 0 : 2)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Viking Toggle Style
struct VikingToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            RoundedRectangle(cornerRadius: 16)
                .fill(configuration.isOn ? VikingColors.gold : VikingColors.iron)
                .frame(width: 51, height: 31)
                .overlay(
                    Circle()
                        .fill(configuration.isOn ? VikingColors.darkNavy : VikingColors.stone)
                        .padding(3)
                        .offset(x: configuration.isOn ? 10 : -10)
                        .animation(.easeInOut(duration: 0.2), value: configuration.isOn)
                )
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}

// MARK: - Decorative Border
struct RunicBorder: ViewModifier {
    var color: Color = VikingColors.gold

    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(color.opacity(0.4), lineWidth: 1.5)
            )
    }
}

extension View {
    func runicBorder(color: Color = VikingColors.gold) -> some View {
        modifier(RunicBorder(color: color))
    }
}
