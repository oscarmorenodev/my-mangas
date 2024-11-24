import Foundation

@Observable
final class MangasSearchViewModel {
    let interactor: DataInteractor
    var searchText = ""
    var searchResults = [MangaItemViewModel]()
    var displayError = false
    var errorMessage = ""
    @ObservationIgnored var page = 1
    @ObservationIgnored var isLoadingMore = false
    
    init(interactor: DataInteractor = DataService()) {
        self.interactor = interactor
    }
    
    func searchMangas() async {
        do {
            let mangas = try await interactor.searchMangas(searchText, page: 1).items
            await MainActor.run {
                self.searchResults = mangas.map { MangaItemViewModel(manga: $0) }
            }
        } catch {
            await handleError(error)
        }
    }
    
    func loadMoreMangas() async {
        guard !isLoadingMore else { return }
        isLoadingMore = true
        defer { isLoadingMore = false }
        
        do {
            let mangas = try await interactor.searchMangas(searchText, page: page + 1).items
            await MainActor.run {
                self.searchResults.append(contentsOf: mangas.map { MangaItemViewModel(manga: $0) })
                self.page += 1
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.displayError.toggle()
            }
        }
    }
    
    func shouldLoadMore(manga: MangaItemViewModel) -> Bool {
        guard !isLoadingMore, !searchText.isEmpty else { return false }
        guard let index = searchResults.firstIndex(where: { $0.id == manga.id }) else { return false }
        return index >= searchResults.count - 6
    }
    
    func cleanSearchResults() {
        searchResults.removeAll()
        page = 1
    }
    
    private func handleError(_ error: any Error) async {
        await MainActor.run {
            self.errorMessage = error.localizedDescription
            self.displayError.toggle()
        }
    }
}
