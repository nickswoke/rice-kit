import SwiftUI

/// A preview host that automatically presents its content in a sheet.
///
/// Use this inside a SwiftUI preview to see a view in the same presentation
/// context it will have in the app:
///
///     #Preview {
///         SheetPreview {
///             CreatePostView()
///         }
///     }
public struct SheetPreview<Content: View>: View {
    @Environment(\.riceTheme) private var theme
    @State private var isPresented: Bool

    private let detents: Set<PresentationDetent>
    private let dragIndicator: Visibility
    private let allowsInteractiveDismiss: Bool
    private let content: Content

    /// Creates a preview host that presents content in a sheet.
    /// - Parameters:
    ///   - startsPresented: Whether the sheet should appear immediately.
    ///   - detents: The heights where the sheet can rest.
    ///   - dragIndicator: The preferred visibility of the sheet drag indicator.
    ///   - allowsInteractiveDismiss: Whether the sheet can be dismissed by dragging.
    ///   - content: The view to present in the sheet.
    public init(
        startsPresented: Bool = true,
        detents: Set<PresentationDetent> = [.large],
        dragIndicator: Visibility = .visible,
        allowsInteractiveDismiss: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        _isPresented = State(initialValue: startsPresented)
        self.detents = detents
        self.dragIndicator = dragIndicator
        self.allowsInteractiveDismiss = allowsInteractiveDismiss
        self.content = content()
    }

    public var body: some View {
        VStack(spacing: theme.spacing) {
            Image(systemName: "rectangle.bottomhalf.inset.filled")
                .font(.title)
                .foregroundStyle(theme.primaryColor)

            Text("Sheet Preview")
                .font(.headline)

            Button("Present Sheet") {
                isPresented = true
            }
            .buttonStyle(.borderedProminent)
            .tint(theme.primaryColor)
            .disabled(isPresented)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background{ background }
        .sheet(isPresented: $isPresented) {
            content
                .presentationDetents(detents)
                .presentationDragIndicator(dragIndicator)
                .interactiveDismissDisabled(!allowsInteractiveDismiss)
        }
    }
    
    private var background: some View {
        ZStack {
            theme.primaryColor
            RiceGrid(resolution: 10, strokeThickness: 1, color: .black.opacity(0.2))
               
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SheetPreview(detents: [.medium, .large]) {
        NavigationStack {
            Form {
                Section("Example") {
                    Text("This view is presented inside a sheet.")
                }
            }
            .navigationTitle("Create Post")
        }
    }
}
