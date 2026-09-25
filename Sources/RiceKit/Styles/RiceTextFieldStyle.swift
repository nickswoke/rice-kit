import SwiftUI

/// A modern text field style that uses the RiceTheme.
public struct RiceTextFieldStyle: TextFieldStyle {
    @Environment(\.riceTheme) private var theme
    @FocusState private var isFocused: Bool
    
    public init() {}
    
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(theme.spacing)
            .background(.secondary.opacity(0.15))
            .cornerRadius(theme.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: theme.cornerRadius)
                    .stroke(isFocused ? theme.primaryColor : Color.clear, lineWidth: 2)
            )
            .focused($isFocused)
            .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

public extension TextFieldStyle where Self == RiceTextFieldStyle {
    static var rice: RiceTextFieldStyle {
        RiceTextFieldStyle()
    }
}

#Preview {
    @Previewable @State var text = ""
    
    VStack(spacing: 20) {
        TextField("Placeholder", text: $text)
            .textFieldStyle(.rice)
        
        TextField("Custom Theme", text: $text)
            .textFieldStyle(.rice)
            .riceTheme(RiceTheme(primaryColor: .green, cornerRadius: 8))
    }
    .padding()
}
