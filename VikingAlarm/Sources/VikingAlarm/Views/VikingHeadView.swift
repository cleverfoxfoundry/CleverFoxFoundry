import SwiftUI

struct VikingHeadView: View {
    var size: CGFloat = 200
    var isAngry: Bool = false

    var body: some View {
        ZStack {
            // Helmet
            helmetShape
            // Face
            faceShape
            // Eyes
            eyesShape
            // Nose
            noseShape
            // Mouth / angry expression
            mouthShape
            // Beard
            beardShape
            // Helmet horns
            hornsShape
            // Helmet rim detail
            helmetRimShape
        }
        .frame(width: size, height: size)
    }

    // MARK: - Helmet
    private var helmetShape: some View {
        ZStack {
            // Main helmet dome
            Ellipse()
                .fill(VikingColors.iron)
                .frame(width: size * 0.72, height: size * 0.50)
                .offset(y: -size * 0.12)

            // Helmet band
            Ellipse()
                .fill(VikingColors.gold)
                .frame(width: size * 0.74, height: size * 0.08)
                .offset(y: size * 0.05)

            // Nose guard
            Rectangle()
                .fill(VikingColors.iron)
                .frame(width: size * 0.05, height: size * 0.22)
                .offset(y: size * 0.08)
        }
    }

    // MARK: - Face
    private var faceShape: some View {
        Ellipse()
            .fill(Color(red: 0.85, green: 0.70, blue: 0.55))
            .frame(width: size * 0.55, height: size * 0.42)
            .offset(y: size * 0.12)
    }

    // MARK: - Eyes
    private var eyesShape: some View {
        HStack(spacing: size * 0.14) {
            // Left eye
            vikingEye
            // Right eye
            vikingEye
        }
        .offset(y: size * 0.06)
    }

    private var vikingEye: some View {
        ZStack {
            // Eye white
            Ellipse()
                .fill(.white)
                .frame(width: size * 0.12, height: isAngry ? size * 0.06 : size * 0.09)

            // Pupil
            Circle()
                .fill(VikingColors.darkNavy)
                .frame(width: size * 0.05, height: size * 0.05)

            // Angry eyebrow
            if isAngry {
                Rectangle()
                    .fill(Color(red: 0.35, green: 0.20, blue: 0.10))
                    .frame(width: size * 0.14, height: size * 0.025)
                    .rotationEffect(.degrees(-10))
                    .offset(y: -size * 0.06)
            }
        }
    }

    // MARK: - Nose
    private var noseShape: some View {
        Ellipse()
            .fill(Color(red: 0.78, green: 0.60, blue: 0.45))
            .frame(width: size * 0.07, height: size * 0.06)
            .offset(y: size * 0.14)
    }

    // MARK: - Mouth
    private var mouthShape: some View {
        Group {
            if isAngry {
                // Angry open mouth
                ZStack {
                    Ellipse()
                        .fill(Color(red: 0.3, green: 0.05, blue: 0.05))
                        .frame(width: size * 0.18, height: size * 0.08)

                    // Teeth
                    HStack(spacing: size * 0.01) {
                        ForEach(0..<4, id: \.self) { _ in
                            Rectangle()
                                .fill(.white)
                                .frame(width: size * 0.025, height: size * 0.03)
                        }
                    }
                    .offset(y: -size * 0.01)
                }
                .offset(y: size * 0.22)
            } else {
                // Neutral/frown line
                Capsule()
                    .fill(Color(red: 0.5, green: 0.30, blue: 0.20))
                    .frame(width: size * 0.12, height: size * 0.02)
                    .offset(y: size * 0.22)
            }
        }
    }

    // MARK: - Beard
    private var beardShape: some View {
        ZStack {
            // Main beard
            Ellipse()
                .fill(Color(red: 0.55, green: 0.30, blue: 0.12))
                .frame(width: size * 0.48, height: size * 0.35)
                .offset(y: size * 0.32)

            // Beard bottom point
            Triangle()
                .fill(Color(red: 0.55, green: 0.30, blue: 0.12))
                .frame(width: size * 0.20, height: size * 0.15)
                .offset(y: size * 0.45)

            // Braids (left)
            Capsule()
                .fill(Color(red: 0.50, green: 0.27, blue: 0.10))
                .frame(width: size * 0.06, height: size * 0.18)
                .rotationEffect(.degrees(15))
                .offset(x: -size * 0.18, y: size * 0.32)

            // Braids (right)
            Capsule()
                .fill(Color(red: 0.50, green: 0.27, blue: 0.10))
                .frame(width: size * 0.06, height: size * 0.18)
                .rotationEffect(.degrees(-15))
                .offset(x: size * 0.18, y: size * 0.32)

            // Braid ties
            Circle()
                .fill(VikingColors.gold)
                .frame(width: size * 0.04)
                .offset(x: -size * 0.20, y: size * 0.40)
            Circle()
                .fill(VikingColors.gold)
                .frame(width: size * 0.04)
                .offset(x: size * 0.20, y: size * 0.40)
        }
    }

    // MARK: - Horns
    private var hornsShape: some View {
        ZStack {
            // Left horn
            HornShape()
                .fill(VikingColors.bone)
                .frame(width: size * 0.12, height: size * 0.28)
                .rotationEffect(.degrees(30))
                .offset(x: -size * 0.38, y: -size * 0.15)

            // Left horn stripe
            HornShape()
                .stroke(VikingColors.stone, lineWidth: 1.5)
                .frame(width: size * 0.12, height: size * 0.28)
                .rotationEffect(.degrees(30))
                .offset(x: -size * 0.38, y: -size * 0.15)

            // Right horn
            HornShape()
                .fill(VikingColors.bone)
                .frame(width: size * 0.12, height: size * 0.28)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                .rotationEffect(.degrees(-30))
                .offset(x: size * 0.38, y: -size * 0.15)

            // Right horn stripe
            HornShape()
                .stroke(VikingColors.stone, lineWidth: 1.5)
                .frame(width: size * 0.12, height: size * 0.28)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                .rotationEffect(.degrees(-30))
                .offset(x: size * 0.38, y: -size * 0.15)
        }
    }

    // MARK: - Helmet Rim
    private var helmetRimShape: some View {
        ZStack {
            // Rivets along the band
            ForEach(0..<5, id: \.self) { i in
                Circle()
                    .fill(VikingColors.amber)
                    .frame(width: size * 0.025)
                    .offset(
                        x: CGFloat(i - 2) * size * 0.12,
                        y: size * 0.05
                    )
            }
        }
    }
}

// MARK: - Custom Shapes

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

struct HornShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX - rect.width * 0.3, y: rect.maxY))
        path.addQuadCurve(
            to: CGPoint(x: rect.midX - rect.width * 0.1, y: rect.minY),
            control: CGPoint(x: rect.minX - rect.width * 0.2, y: rect.midY)
        )
        path.addLine(to: CGPoint(x: rect.midX + rect.width * 0.1, y: rect.minY + rect.height * 0.1))
        path.addQuadCurve(
            to: CGPoint(x: rect.midX + rect.width * 0.3, y: rect.maxY),
            control: CGPoint(x: rect.midX + rect.width * 0.3, y: rect.midY)
        )
        path.closeSubpath()
        return path
    }
}

#Preview {
    ZStack {
        VikingColors.darkNavy.ignoresSafeArea()
        VStack(spacing: 40) {
            VikingHeadView(size: 200, isAngry: false)
            VikingHeadView(size: 200, isAngry: true)
        }
    }
}
