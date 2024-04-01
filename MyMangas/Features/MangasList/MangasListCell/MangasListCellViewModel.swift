import SwiftUI

@Observable
final class MangasListCellViewModel {
    var image: UIImage?
    
    let interactor: ImageInteractor
    
    init(interactor: ImageInteractor = ImageService()) {
        self.interactor = interactor
    }
    
    func getImage(url: String) throws {
        let urlFormatted = String(url.dropFirst().dropLast())
        guard let url = URL(string: urlFormatted) else { return }
        Task {
            let image = try await interactor.getImage(url: url)
            await MainActor.run {
                self.image = image
            }
        }
    }
}
