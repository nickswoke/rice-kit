import SwiftUI

/// A view that renders a square-cell grid sized to its available width.
public struct RiceGrid: View {
    /// The number of cells across the grid.
    public var resolution: Int

    /// The width of each grid line.
    public var strokeThickness: CGFloat

    /// The color of the grid lines.
    public var color: Color

    /// Creates a grid view.
    /// - Parameters:
    ///   - resolution: The number of cells across the grid.
    ///   - strokeThickness: The width of each grid line.
    ///   - color: The grid line color. Defaults to a translucent white.
    public init(
        resolution: Int,
        strokeThickness: CGFloat,
        color: Color = .white.opacity(0.5)
    ) {
        self.resolution = resolution
        self.strokeThickness = strokeThickness
        self.color = color
    }

    public var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height

                guard resolution > 0, width > 0 else { return }

                let step = width / CGFloat(resolution)

                // Vertical lines.
                if resolution > 1 {
                    for index in 1..<resolution {
                        let x = CGFloat(index) * step
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: height))
                    }
                }

                // Horizontal lines continue across the available height.
                let horizontalLinesCount = Int(ceil(height / step)) - 1
                if horizontalLinesCount > 0 {
                    for index in 1...horizontalLinesCount {
                        let y = CGFloat(index) * step
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: width, y: y))
                    }
                }
            }
            .stroke(color, lineWidth: strokeThickness)
        }
    }
}

#Preview {
    RiceGrid(resolution: 3, strokeThickness: 1)
        .frame(width: 300, height: 300)
        .background(Color.black)
}
