import SwiftUI

/// A container view that displays its content in a card.
/// Appearance is driven by the `riceCardStyle` environment value.
public struct RiceCard<Content: View>: View {
    @Environment(\.riceCardStyle) private var style
    
    let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        style.makeBody(
            configuration: RiceCardStyleConfiguration(
                content: RiceCardStyleConfiguration.Content(content)
            )
        )
    }
}

#Preview {
    VStack(spacing: 20) {
        RiceCard {
            Text("Default Card Style")
                .font(.headline)
        }
        
        RiceCard {
            VStack(alignment: .leading, spacing: 8) {
                Text("Custom Card")
                    .font(.title3.bold())
                Text("This card uses a custom style applied via modifier.")
                    .foregroundStyle(.secondary)
            }
        }
        .riceCardStyle(OutlinedRiceCardStyle())
    }
    .padding()
}

// Example of a custom style that developers can create
public struct OutlinedRiceCardStyle: RiceCardStyle {
    @Environment(\.riceTheme) private var theme
    
    public init() {}
    
    public func makeBody(configuration: RiceCardStyleConfiguration) -> some View {
        configuration.content
            .padding(theme.spacing * 1.5)
            .background(theme.primaryColor.opacity(0.15))
            .cornerRadius(theme.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: theme.cornerRadius)
                    .stroke(theme.primaryColor.opacity(0.8), lineWidth: 2)
            )
    }
}
