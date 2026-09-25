import SwiftUI

/// A view modifier that presents a toast over its content.
public struct RiceToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let text: String
    let duration: TimeInterval
    
    @Environment(\.riceTheme) private var theme
    
    public func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                if isPresented {
                    ToastView(text: text, theme: theme)
                        .padding(.horizontal)
                        .padding(.bottom, 24)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .task {
                            do {
                                try await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
                                if !Task.isCancelled {
                                    isPresented = false
                                }
                            } catch {
                                // Ignore cancellation
                            }
                        }
                }
            }
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPresented)
    }
}

private struct ToastView: View {
    let text: String
    let theme: RiceTheme
    
    var body: some View {
        Text(text)
            .font(.subheadline)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.background)
            .foregroundColor(theme.primaryColor)
            .cornerRadius(theme.cornerRadius)
            .shadow(color: Color.black.opacity(0.12), radius: 10, x: 0, y: 5)
    }
}

public extension View {
    /// Presents a toast when a given boolean binding is true.
    func riceToast(isPresented: Binding<Bool>, text: String, duration: TimeInterval = 3.0) -> some View {
        modifier(RiceToastModifier(isPresented: isPresented, text: text, duration: duration))
    }
}

#Preview {
    @Previewable @State var showToast = false
    
    VStack {
        Button("Show Toast") {
            showToast = true
        }
        .buttonStyle(.ricePrimary)
        .padding()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .riceToast(isPresented: $showToast, text: "This is a RiceKit Toast!")
}
