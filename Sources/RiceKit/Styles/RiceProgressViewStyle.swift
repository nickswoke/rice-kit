import SwiftUI

public struct RiceProgressViewStyle: ProgressViewStyle {
    public let showsBackground: Bool
    public let strokeFraction: Double
    public let strokeWidth: CGFloat
    
    public init(showsBackground: Bool = true, strokeFraction: Double = 0.8, strokeWidth: CGFloat = 4) {
        self.showsBackground = showsBackground
        self.strokeFraction = max(0.01, min(1.0, strokeFraction))
        self.strokeWidth = strokeWidth
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        if let fractionCompleted = configuration.fractionCompleted {
            DeterminateProgressRing(
                progress: fractionCompleted,
                showsBackground: showsBackground,
                strokeWidth: strokeWidth
            )
        } else {
            IndeterminateSpinner(
                showsBackground: showsBackground,
                strokeFraction: strokeFraction,
                strokeWidth: strokeWidth
            )
        }
    }
}

private struct DeterminateProgressRing: View {
    let progress: Double
    let showsBackground: Bool
    let strokeWidth: CGFloat

    private var clampedProgress: Double {
        min(max(progress, 0), 1)
    }

    var body: some View {
        ZStack {
            if showsBackground {
                Circle()
                    .stroke(
                        Color.accentColor.opacity(0.2),
                        style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round)
                    )
            }

            Circle()
                .trim(from: 0, to: clampedProgress)
                .stroke(
                    Color.accentColor,
                    style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
        }
        .frame(width: 32, height: 32)
        .animation(.snappy(duration: 0.2), value: clampedProgress)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Progress")
        .accessibilityValue("\(Int(clampedProgress * 100)) percent")
    }
}

private struct IndeterminateSpinner: View {
    let showsBackground: Bool
    let strokeFraction: Double
    let strokeWidth: CGFloat
    @State private var isSpinning = false
    
    var body: some View {
        ZStack {
            if showsBackground {
                Circle()
                    .stroke(Color.accentColor.opacity(0.2), style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
                    .frame(width: 32, height: 32)
            }
            
            Circle()
                .trim(from: 0.0, to: strokeFraction)
                .stroke(Color.accentColor, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
                .frame(width: 32, height: 32)
                .rotationEffect(.degrees(isSpinning ? 360 : 0))
                .animation(.linear(duration: 1.0).repeatForever(autoreverses: false), value: isSpinning)
                .onAppear {
                    isSpinning = true
                }
        }
    }
}

public extension ProgressViewStyle where Self == RiceProgressViewStyle {
    static var rice: RiceProgressViewStyle {
        RiceProgressViewStyle()
    }
    
    static func rice(showsBackground: Bool = true, strokeFraction: Double = 0.8, strokeWidth: CGFloat = 4) -> RiceProgressViewStyle {
        RiceProgressViewStyle(showsBackground: showsBackground, strokeFraction: strokeFraction, strokeWidth: strokeWidth)
    }
}

#Preview {
    VStack(spacing: 40) {
        ProgressView()
            .progressViewStyle(.rice)
        
        ProgressView()
            .progressViewStyle(.rice(showsBackground: false))
            
        ProgressView()
            .progressViewStyle(.rice(strokeFraction: 0.25))
            
        ProgressView()
            .progressViewStyle(.rice)
            .tint(.purple)
    }
}
