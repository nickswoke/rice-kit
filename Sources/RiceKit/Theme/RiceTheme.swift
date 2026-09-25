import SwiftUI

public struct RiceTheme: Sendable {
    public var primaryColor: Color
    public var cornerRadius: CGFloat
    public var spacing: CGFloat
    
    public init(
        primaryColor: Color = .red,
        cornerRadius: CGFloat = 16,
        spacing: CGFloat = 12
    ) {
        self.primaryColor = primaryColor
        self.cornerRadius = cornerRadius
        self.spacing = spacing
    }
}

public struct RiceThemeEnvironmentKey: EnvironmentKey {
    public static let defaultValue: RiceTheme = .init()
}

public extension EnvironmentValues {
    var riceTheme: RiceTheme {
        get { self[RiceThemeEnvironmentKey.self] }
        set { self[RiceThemeEnvironmentKey.self] = newValue }
    }
}

public extension View {
    /// Sets the RiceKit theme for this view and its descendants.
    func riceTheme(_ theme: RiceTheme) -> some View {
        environment(\.riceTheme, theme)
    }
}
