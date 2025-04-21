import Foundation

@Observable
final class MangasSearchViewModel {
    private let searchMangasUseCase: SearchMangasUseCase
    var searchText = ""
    var searchResults = [MangaItemViewModel]()
    var displayError = false
    var errorMessage = ""
    @ObservationIgnored var page = 1
    @ObservationIgnored var isLoadingMore = false
    @ObservationIgnored private var loadedIds = Set<String>()
    
    init(searchMangaUseCase: SearchMangasUseCase = SearchMangasUseCase()) {
        self.searchMangasUseCase = searchMangaUseCase
    }
    
    func searchMangas() async {
        do {
            let mangas = try await searchMangasUseCase.execute(query: searchText, page: 1).items
            await MainActor.run {
                self.loadedIds.removeAll()
                self.searchResults.removeAll()
                self.page = 1
                appendUniqueMangas(mangas)
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
            let mangas = try await searchMangasUseCase.execute(query: searchText, page: page + 1).items
            await MainActor.run {
                appendUniqueMangas(mangas)
                self.page += 1
            }
        } catch {
            await handleError(error)
        }
    }
    
    private func appendUniqueMangas(_ newMangas: [Manga]) {
        let uniqueMangas = newMangas.filter { manga in
            !loadedIds.contains(String(manga.id))
        }
        
        uniqueMangas.forEach { manga in
            loadedIds.insert(String(manga.id))
            searchResults.append(MangaItemViewModel(manga: manga))
        }
    }
    
    func shouldLoadMore(manga: MangaItemViewModel) -> Bool {
        guard !isLoadingMore, !searchText.isEmpty else { return false }
        guard let index = searchResults.firstIndex(where: { $0.id == manga.id }) else { return false }
        return index >= searchResults.count - 6
    }
    
    func cleanSearchResults() {
        searchResults.removeAll()
        loadedIds.removeAll()
        page = 1
    }
    
    private func handleError(_ error: any Error) async {
        await MainActor.run {
            self.errorMessage = error.localizedDescription
            self.displayError.toggle()
        }
    }
}
