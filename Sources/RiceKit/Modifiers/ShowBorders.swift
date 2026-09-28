import SwiftUI

/// A debugging modifier that outlines the view it is applied to.
public struct ShowBordersModifier: ViewModifier {
    public let color: Color
    public let lineWidth: CGFloat

    public init(color: Color, lineWidth: CGFloat) {
        self.color = color
        self.lineWidth = lineWidth
    }

    public func body(content: Content) -> some View {
        content.overlay {
            Rectangle()
                .stroke(color, lineWidth: lineWidth)
        }
    }
}

public extension View {
    /// Outlines this view for layout debugging.
    ///
    /// Apply this modifier to individual child views to see their bounds.
    /// Applying it to a container outlines the container's bounds.
    func showBorders(_ color: Color = .red, lineWidth: CGFloat = 1) -> some View {
        modifier(ShowBordersModifier(color: color, lineWidth: lineWidth))
    }
}

/// A vertical stack whose content is outlined for layout debugging.
public struct DebugVStack<Content: View>: View {
    public let alignment: HorizontalAlignment
    public let spacing: CGFloat?
    public let color: Color
    public let lineWidth: CGFloat

    private let content: Content

    public init(
        alignment: HorizontalAlignment = .center,
        spacing: CGFloat? = nil,
        color: Color = .red,
        lineWidth: CGFloat = 1,
        @ViewBuilder content: () -> Content
    ) {
        self.alignment = alignment
        self.spacing = spacing
        self.color = color
        self.lineWidth = lineWidth
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: alignment, spacing: spacing) {
            content.showBorders(color, lineWidth: lineWidth)
        }
    }
}

/// A horizontal stack whose content is outlined for layout debugging.
public struct DebugHStack<Content: View>: View {
    public let alignment: VerticalAlignment
    public let spacing: CGFloat?
    public let color: Color
    public let lineWidth: CGFloat

    private let content: Content

    public init(
        alignment: VerticalAlignment = .center,
        spacing: CGFloat? = nil,
        color: Color = .red,
        lineWidth: CGFloat = 1,
        @ViewBuilder content: () -> Content
    ) {
        self.alignment = alignment
        self.spacing = spacing
        self.color = color
        self.lineWidth = lineWidth
        self.content = content()
    }

    public var body: some View {
        HStack(alignment: alignment, spacing: spacing) {
            content.showBorders(color, lineWidth: lineWidth)
        }
    }
}
