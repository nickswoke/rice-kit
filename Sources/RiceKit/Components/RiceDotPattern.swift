import SwiftUI

/// A view that renders a repeatable dot pattern.
/// Ideal for background textures and overlays.
public struct RiceDotPattern: View {
    /// The diameter of each dot.
    public var dotSize: CGFloat
    
    /// The spacing between the centers of adjacent dots.
    public var spacing: CGFloat
    
    /// The color of the dots.
    public var color: Color
    
    /// Whether every other row should be offset to create a honeycomb-like pattern.
    public var isStaggered: Bool

    /// Creates a new dot pattern.
    /// - Parameters:
    ///   - dotSize: The diameter of each dot. Default is 2.
    ///   - spacing: The spacing between the centers of adjacent dots. Default is 12.
    ///   - color: The color of the dots. Default is a subtle gray.
    ///   - isStaggered: Whether every other row should be offset. Default is false.
    public init(
        dotSize: CGFloat = 2,
        spacing: CGFloat = 12,
        color: Color = Color.gray.opacity(0.3),
        isStaggered: Bool = false
    ) {
        self.dotSize = dotSize
        self.spacing = spacing
        self.color = color
        self.isStaggered = isStaggered
    }

    public var body: some View {
        Canvas { context, size in
            let columns = Int(ceil(size.width / spacing))
            let rows = Int(ceil(size.height / spacing))
            
            for row in -1...rows {
                // If staggered and this is an odd row, offset by half the spacing
                let rowOffset = (isStaggered && !row.isMultiple(of: 2)) ? (spacing / 2) : 0
                
                for col in -1...columns {
                    let x = CGFloat(col) * spacing + rowOffset
                    let y = CGFloat(row) * spacing
                    
                    let rect = CGRect(
                        x: x - dotSize / 2,
                        y: y - dotSize / 2,
                        width: dotSize,
                        height: dotSize
                    )
                    
                    context.fill(Path(ellipseIn: rect), with: .color(color))
                }
            }
        }
        .clipped()
    }
}

#Preview {
    VStack(spacing: 20) {
        RiceDotPattern(dotSize: 4, spacing: 20, color: .black)
            .frame(height: 120)
            .background(Color.white)
            .border(Color.gray)
            .overlay(
                Text("Grid Pattern")
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(8)
            )
            
        RiceDotPattern(dotSize: 4, spacing: 20, color: .black, isStaggered: true)
            .frame(height: 120)
            .background(Color.white)
            .border(Color.gray)
            .overlay(
                Text("Staggered Pattern")
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(8)
            )
        
        RiceDotPattern()
            .frame(height: 120)
            .overlay(
                Text("Default Settings")
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(8)
            )
    }
    .padding()
}
