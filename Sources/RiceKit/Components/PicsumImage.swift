import SwiftUI

/// Builds image URLs for the Lorem Picsum service.
public enum Picsum {
    private static let baseURL = URL(string: "https://picsum.photos")!

    /// Returns a random image URL for the requested dimensions.
    public static func url(width: Int, height: Int) -> URL {
        baseURL.appending(path: "\(max(width, 1))/\(max(height, 1))")
    }

    /// Returns a repeatable image URL for the requested seed and dimensions.
    public static func url(seed: String, width: Int, height: Int) -> URL {
        baseURL
            .appending(path: "seed")
            .appending(path: seed)
            .appending(path: "\(max(width, 1))/\(max(height, 1))")
    }

    /// Returns a specific Picsum image by its image ID.
    public static func url(id: Int, width: Int, height: Int) -> URL {
        baseURL
            .appending(path: "id")
            .appending(path: "\(id)")
            .appending(path: "\(max(width, 1))/\(max(height, 1))")
    }
}

/// Loads a Lorem Picsum image using SwiftUI's native asynchronous image loader.
///
/// ```swift
/// PicsumImage(seed: "coffee", width: 600, height: 400)
///     .frame(height: 220)
///     .clipShape(RoundedRectangle(cornerRadius: 16))
/// ```
public struct PicsumImage: View {
    private let url: URL
    private let contentMode: ContentMode

    /// Loads a random image. The returned image may change between requests.
    public init(width: Int, height: Int, contentMode: ContentMode = .fill) {
        url = Picsum.url(width: width, height: height)
        self.contentMode = contentMode
    }

    /// Loads a stable image selected by seed.
    public init(seed: String, width: Int, height: Int, contentMode: ContentMode = .fill) {
        url = Picsum.url(seed: seed, width: width, height: height)
        self.contentMode = contentMode
    }

    /// Loads a specific image by its Picsum ID.
    public init(id: Int, width: Int, height: Int, contentMode: ContentMode = .fill) {
        url = Picsum.url(id: id, width: width, height: height)
        self.contentMode = contentMode
    }

    public var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            case .empty:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .failure:
                Image(systemName: "photo")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            @unknown default:
                EmptyView()
            }
        }
        .accessibilityLabel("Sample photo")
    }
}

#Preview {
    PicsumImage(seed: "ricekit-preview", width: 600, height: 400)
        .frame(height: 220)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding()
}
