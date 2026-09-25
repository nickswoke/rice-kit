import SwiftUI

public struct RiceCardStyleConfiguration {
    public struct Content: View {
        private let _body: AnyView
        
        init<V: View>(_ view: V) {
            self._body = AnyView(view)
        }
        
        public var body: some View {
            _body
        }
    }
    
    public let content: Content
}

public protocol RiceCardStyle {
    associatedtype Body: View
    @ViewBuilder func makeBody(configuration: RiceCardStyleConfiguration) -> Body
}

public struct DefaultRiceCardStyle: RiceCardStyle {
    @Environment(\.riceTheme) private var theme
    
    public init() {}
    
    public func makeBody(configuration: RiceCardStyleConfiguration) -> some View {
        configuration.content
            .padding(theme.spacing * 1.5)
            .background(theme.primaryColor.opacity(0.06))
            .cornerRadius(theme.cornerRadius)
            .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
    }
}

public struct AnyRiceCardStyle: RiceCardStyle, @unchecked Sendable {
    private let _makeBody: (RiceCardStyleConfiguration) -> AnyView
    
    public init<S: RiceCardStyle>(style: S) {
        self._makeBody = { configuration in
            AnyView(style.makeBody(configuration: configuration))
        }
    }
    
    public func makeBody(configuration: RiceCardStyleConfiguration) -> some View {
        _makeBody(configuration)
    }
}

public struct RiceCardStyleEnvironmentKey: EnvironmentKey {
    public static let defaultValue: AnyRiceCardStyle = AnyRiceCardStyle(style: DefaultRiceCardStyle())
}

public extension EnvironmentValues {
    var riceCardStyle: AnyRiceCardStyle {
        get { self[RiceCardStyleEnvironmentKey.self] }
        set { self[RiceCardStyleEnvironmentKey.self] = newValue }
    }
}

public extension View {
    func riceCardStyle<S: RiceCardStyle>(_ style: S) -> some View {
        environment(\.riceCardStyle, AnyRiceCardStyle(style: style))
    }
}
