import Foundation

@Observable
final class MangasListViewModel {
    let interactor: DataInteractor
    var mangas = [MangaItemViewModel]()
    var displayError = false
    var errorMessage = ""
    var appState: AppState = .loading
    @ObservationIgnored var page: Int = 0
    
    init(interactor: DataInteractor = DataService()) {
        self.interactor = interactor
    }
    
    func getMangas() async {
        page += 1
        do {
            let mangas = try await interactor.getListMangas(page: page).items
            await MainActor.run {
                self.mangas += mangas.map {MangaItemViewModel(manga: $0, isFavorite: false)}
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.displayError.toggle()
            }
        }
    }
    
    func returnMangas(_ onlyFavorites: Bool = false) -> [MangaItemViewModel] {
        onlyFavorites ? mangas.filter {$0.isFavorite} : mangas
    }
    
    func toogleFavorite(_ manga: MangaItemViewModel) {
        if let index = mangas.firstIndex(where: { $0.title == manga.title}) {
            mangas[index].isFavorite.toggle()
        }
    }
    
    func shouldLoadMore(manga: MangaItemViewModel) -> Bool {
        guard let index = mangas.firstIndex(where: { $0.id == manga.id }) else {
            return false
        }

        return index + 2 == mangas.count
    }
}
