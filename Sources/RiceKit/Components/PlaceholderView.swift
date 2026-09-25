import SwiftUI

/// A theme-aware placeholder for unfinished or unavailable content.
public struct PlaceholderView: View {
    @Environment(\.riceTheme) private var theme

    /// The primary label shown in the placeholder.
    public var title: String

    /// Supporting text that explains what will appear here.
    public var message: String?

    /// The SF Symbol displayed above the title.
    public var systemImage: String

    /// The number of grid cells drawn across the background.
    public var gridResolution: Int

    /// The minimum height of the placeholder.
    public var minimumHeight: CGFloat

    /// Creates a development placeholder.
    /// - Parameters:
    ///   - title: The primary label. Defaults to "Placeholder".
    ///   - message: Supporting text. Pass `nil` to hide it.
    ///   - systemImage: The SF Symbol displayed above the title.
    ///   - gridResolution: The number of grid cells across the background.
    ///   - minimumHeight: The minimum height of the placeholder.
    public init(
        title: String = "Placeholder",
        message: String? = "Replace this view with your content.",
        systemImage: String = "square.dashed",
        gridResolution: Int = 12,
        minimumHeight: CGFloat = 220
    ) {
        self.title = title
        self.message = message
        self.systemImage = systemImage
        self.gridResolution = gridResolution
        self.minimumHeight = minimumHeight
    }

    public var body: some View {
        let shape = RoundedRectangle(
            cornerRadius: theme.cornerRadius,
            style: .continuous
        )

        ZStack {
            shape
                .fill(theme.primaryColor.opacity(0.06))

            RiceGrid(
                resolution: max(gridResolution, 1),
                strokeThickness: 0.5,
                color: theme.primaryColor.opacity(0.12)
            )
            .mask(shape)

            VStack(spacing: theme.spacing) {
                Image(systemName: systemImage)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(theme.primaryColor)
                    .frame(width: 48, height: 48)
                    .background(
                        theme.primaryColor.opacity(0.12),
                        in: RoundedRectangle(
                            cornerRadius: theme.cornerRadius * 0.75,
                            style: .continuous
                        )
                    )

                VStack(spacing: theme.spacing * 0.5) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    if let message, !message.isEmpty {
                        Text(message)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .lineLimit(3)
                    }
                }
            }
            .padding(theme.spacing * 2)
            .background(.regularMaterial, in: shape)
            .padding(theme.spacing * 2)
        }
        .frame(maxWidth: .infinity, minHeight: max(minimumHeight, 0))
        .overlay {
            shape.stroke(
                theme.primaryColor.opacity(0.24),
                style: StrokeStyle(lineWidth: 1, dash: [6, 6])
            )
        }
        .clipShape(shape)
        .accessibilityElement(children: .combine)
    }
}

#Preview("Default") {
    PlaceholderView()
        .padding()
}

#Preview("Customized") {
    PlaceholderView(
        title: "Analytics chart",
        message: "Revenue data will appear here once the chart is connected.",
        systemImage: "chart.xyaxis.line",
        gridResolution: 16,
        minimumHeight: 280
    )
    .riceTheme(
        RiceTheme(primaryColor: .indigo)
    )
    .padding()
}
