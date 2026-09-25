import SwiftUI

public struct PressActions: ViewModifier {
    let onPress: () -> Void
    let onRelease: () -> Void
    @State private var isPressing = false

    public init(
        onPress: @escaping () -> Void,
        onRelease: @escaping () -> Void
    ) {
        self.onPress = onPress
        self.onRelease = onRelease
    }

    public func body(content: Content) -> some View {
        content.simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    guard !isPressing else { return }
                    isPressing = true
                    onPress()
                }
                .onEnded { _ in
                    isPressing = false
                    onRelease()
                }
        )
    }
}

public extension View {
    func pressAction(
        onPress: @escaping () -> Void,
        onRelease: @escaping () -> Void
    ) -> some View {
        modifier(PressActions(onPress: onPress, onRelease: onRelease))
    }
}
