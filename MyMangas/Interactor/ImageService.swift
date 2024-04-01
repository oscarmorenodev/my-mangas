import SwiftUI

protocol ImageInteractor {
    func getImage(url: URL) async throws -> UIImage?
}

struct ImageService: ImageInteractor {
    func getImage(url: URL) async throws -> UIImage? {
        let imageURL = URL.cachesDirectory.appending(path: url.lastPathComponent)
        let (data, _) = try await URLSession.shared.getData(for: URLRequest(url: url))
        if let image = UIImage(data: data),
           let jpgData = image.jpegData(compressionQuality: 0.7) {
            try jpgData.write(to: imageURL, options: .atomic)
            return image
        } else {
            return nil
        }
    }
}
