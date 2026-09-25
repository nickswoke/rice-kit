import SwiftUI

/// A customizable progress view that uses the modern RiceKit styling natively.
public struct RiceProgressView: View {
    public let showsBackground: Bool
    public let strokeFraction: Double
    public let strokeWidth: CGFloat
    
    public init(showsBackground: Bool = true, strokeFraction: Double = 0.25, strokeWidth: CGFloat = 4) {
        self.showsBackground = showsBackground
        self.strokeFraction = strokeFraction
        self.strokeWidth = strokeWidth
    }
    
    public var body: some View {
        ProgressView()
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
    }
    .padding()
}
