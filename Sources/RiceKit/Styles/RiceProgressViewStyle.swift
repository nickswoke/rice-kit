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
        if configuration.fractionCompleted == nil {
            IndeterminateSpinner(showsBackground: showsBackground, strokeFraction: strokeFraction, strokeWidth: strokeWidth)
        } else {
            ProgressView(configuration)
        }
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
