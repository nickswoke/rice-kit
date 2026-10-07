import SwiftUI

/// A fixed-height scroll header that stretches into the top safe area when pulled down.
public struct StretchyHeader<Content: View>: View {
    private let height: CGFloat
    private let content: Content

    public init(
        height: CGFloat,
        @ViewBuilder content: () -> Content
    ) {
        self.height = height
        self.content = content()
    }

    public var body: some View {
        let safeHeight = height.isFinite ? max(1, height) : 1

        GeometryReader { geometry in
            let minY = geometry.frame(in: .scrollView(axis: .vertical)).minY
            let pullDown = minY.isFinite ? max(0, minY) : 0

            content
                .frame(
                    width: geometry.size.width,
                    height: safeHeight + pullDown
                )
                .clipped()
                .offset(y: -pullDown)
        }
        .frame(height: safeHeight)
    }
}
