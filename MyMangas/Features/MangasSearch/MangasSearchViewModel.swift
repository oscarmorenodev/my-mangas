import Foundation

@Observable
final class MangasSearchViewModel {
    let interactor: DataInteractor
    var searchText = ""
    var searchResults = [MangaItemViewModel]()
    var displayError = false
    var errorMessage = ""
    @ObservationIgnored var page: Int = 0
    
    init(interactor: DataInteractor = DataService()) {
        self.interactor = interactor
    }
    
    func searchMangas() async {
        do {
            let mangas = try await interactor.searchMangas(searchText).items
            await MainActor.run {
                self.searchResults += mangas.map { MangaItemViewModel(manga: $0) }
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.displayError.toggle()
            }
        }
    }
    
}
