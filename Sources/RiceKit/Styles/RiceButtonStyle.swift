import SwiftUI

public enum RiceButtonSize {
    case medium
    case large
}

public enum RiceButtonShape {
    case rounded
    case circle
}

/// A primary button style that uses the `RiceTheme` primary color and provides modern press interactions.
public struct PrimaryRiceButtonStyle: ButtonStyle {
    @Environment(\.riceTheme) private var theme
    
    public var size: RiceButtonSize
    public var shape: RiceButtonShape
    
    public init(size: RiceButtonSize = .medium, shape: RiceButtonShape = .rounded) {
        self.size = size
        self.shape = shape
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        let isCircle = shape == .circle
        let isLarge = size == .large
        
        let content = configuration.label
            .font(isLarge ? .title3.bold() : .headline)
            .padding(.horizontal, isCircle ? (isLarge ? theme.spacing * 1.5 : theme.spacing) : (isLarge ? theme.spacing * 3 : theme.spacing * 2))
            .padding(.vertical, isLarge ? theme.spacing * 1.5 : theme.spacing)
            .frame(maxWidth: isCircle ? nil : .infinity)
        let shape = isCircle ? AnyShape(Circle()) : AnyShape(Capsule())
        if #available(iOS 26.0, macOS 26.0, *) {
            content
                .glassEffect(.regular.interactive())
                .clipShape(shape)
        } else {
            content
                .background(.regularMaterial, in: shape)
                .clipShape(shape)
        }
    }
}

/// A secondary button style for alternate actions.
public struct SecondaryRiceButtonStyle: ButtonStyle {
    @Environment(\.riceTheme) private var theme
    
    public var size: RiceButtonSize
    public var shape: RiceButtonShape
    
    public init(size: RiceButtonSize = .medium, shape: RiceButtonShape = .rounded) {
        self.size = size
        self.shape = shape
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        let isCircle = shape == .circle
        let isLarge = size == .large
        
        let content = configuration.label
            .font(isLarge ? .title3.bold() : .headline)
            .padding(.horizontal, isCircle ? (isLarge ? theme.spacing * 1.5 : theme.spacing) : (isLarge ? theme.spacing * 3 : theme.spacing * 2))
            .padding(.vertical, isLarge ? theme.spacing * 1.5 : theme.spacing)
            .frame(maxWidth: isCircle ? nil : .infinity)
            .foregroundColor(theme.primaryColor)
        let shape = isCircle ? AnyShape(Circle()) : AnyShape(RoundedRectangle(cornerRadius: theme.cornerRadius))
        if #available(iOS 26.0, macOS 26.0, *) {
            content
                .glassEffect(.regular.tint(theme.primaryColor.opacity(0.15)).interactive())
                .clipShape(shape)
        } else {
            content
                .background(theme.primaryColor.opacity(0.15), in: shape)
                .clipShape(shape)
        }
    }
}

public extension ButtonStyle where Self == PrimaryRiceButtonStyle {
    static var ricePrimary: PrimaryRiceButtonStyle {
        PrimaryRiceButtonStyle()
    }
    
    static func ricePrimary(size: RiceButtonSize = .medium, shape: RiceButtonShape = .rounded) -> PrimaryRiceButtonStyle {
        PrimaryRiceButtonStyle(size: size, shape: shape)
    }
}

public extension ButtonStyle where Self == SecondaryRiceButtonStyle {
    static var riceSecondary: SecondaryRiceButtonStyle {
        SecondaryRiceButtonStyle()
    }
    
    static func riceSecondary(size: RiceButtonSize = .medium, shape: RiceButtonShape = .rounded) -> SecondaryRiceButtonStyle {
        SecondaryRiceButtonStyle(size: size, shape: shape)
    }
}

#Preview {
    VStack(spacing: 20) {
        Button("Primary Medium") {}
            .buttonStyle(.ricePrimary)
            
        Button("Primary Large") {}
            .buttonStyle(.ricePrimary(size: .large))
            
        Button {
        } label: {
            Image(systemName: "plus")
        }
        .buttonStyle(.ricePrimary(shape: .circle))
            
        Button("Secondary Large") {}
            .buttonStyle(.riceSecondary(size: .large))
            
        Button {
        } label: {
            Image(systemName: "trash")
        }
        .buttonStyle(.riceSecondary(size: .large, shape: .circle))
            
        Button("Custom Theme") {}
            .buttonStyle(.ricePrimary)
            .riceTheme(RiceTheme(primaryColor: .blue, cornerRadius: 8))
    }
    .padding()
}
