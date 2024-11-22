import Foundation

@Observable
final class MangasSearchViewModel {
    let interactor: DataInteractor
    var searchText = ""
    var searchResults = [MangaItemViewModel]()
    var displayError = false
    var errorMessage = ""
    var filter: Filter = .demographic
    var filterValues = [String]()
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
    
    func getFilterContent(filter: Filter) async {
        if filter == .demographic {
            self.filter = .demographic
            await getDemographics()
        } else if filter == .genre {
            self.filter = .genre
            await getGenres()
        } else if filter == .theme {
            self.filter = .theme
            await getThemes()
        }
    }
    
    func getDemographics() async {
        do {
            let demographics = try await interactor.getDemographics().sorted()
            await MainActor.run {
                self.filterValues = demographics
            }
        } catch {
            await handleError(error)
        }
    }
    
    func getGenres() async {
        do {
            let genres = try await interactor.getGenres().sorted()
            await MainActor.run {
                self.filterValues = genres
            }
        } catch {
            await handleError(error)
        }
    }
        
    func getThemes() async {
        do {
            let themes = try await interactor.getThemes().sorted()
            await MainActor.run {
                self.filterValues = themes
            }
        } catch {
            await handleError(error)
        }
    }
    
    private func handleError(_ error: any Error) async {
        await MainActor.run {
            self.errorMessage = error.localizedDescription
            self.displayError.toggle()
        }
    }
}
