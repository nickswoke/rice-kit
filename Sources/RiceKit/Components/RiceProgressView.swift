import SwiftUI

/// A customizable RiceKit progress view.
///
/// Pass `value` to show an animated determinate ring. Leave it `nil` to show
/// the indeterminate spinner.
public struct RiceProgressView: View {
    public let value: Double?
    public let total: Double
    public let showsBackground: Bool
    public let strokeFraction: Double
    public let strokeWidth: CGFloat
    
    public init(
        value: Double? = nil,
        total: Double = 1,
        showsBackground: Bool = true,
        strokeFraction: Double = 0.25,
        strokeWidth: CGFloat = 4
    ) {
        self.value = value
        self.total = max(total, .leastNonzeroMagnitude)
        self.showsBackground = showsBackground
        self.strokeFraction = strokeFraction
        self.strokeWidth = strokeWidth
    }
    
    public var body: some View {
        ProgressView(value: value, total: total)
            .progressViewStyle(.rice(showsBackground: showsBackground, strokeFraction: strokeFraction, strokeWidth: strokeWidth))
    }
}

#Preview {
    VStack(spacing: 40) {
        RiceProgressView()
        
        RiceProgressView(showsBackground: false)
            
        RiceProgressView(strokeFraction: 0.25)
            
        RiceProgressView(strokeWidth: 2)
            .tint(.red)

        RiceProgressView(value: 0.38)

        RiceProgressView(value: 0.72, showsBackground: false, strokeWidth: 3)
            .tint(.green)
    }
    .padding()
}
