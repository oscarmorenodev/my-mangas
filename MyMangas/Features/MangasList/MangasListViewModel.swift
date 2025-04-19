import Foundation

@Observable
final class MangasListViewModel {
    let interactor: DataInteractor
    var mangas = [MangaItemViewModel]()
    var demographics = [String]()
    var genres = [String]()
    var themes = [String]()
    var displayError = false
    var errorMessage = ""
    var showBest = false
    var category: Category = .demographic
    var categoryValues = [String]()
    var selectedCategory = ""
    var isLoading = false
    
    @ObservationIgnored var page: Int = 0
    @ObservationIgnored private var loadedIds = Set<String>()
    
    init(interactor: DataInteractor = DataService.shared) {
        self.interactor = interactor
    }
    
    func fetchData() async {
        await getMangas()
        await getDemographics()
        await getGenres()
        await getThemes()
    }
    
    func getMangas() async {
        guard !isLoading else { return }
        isLoading = true
        
        do {
            let mangas = try await interactor.getListMangas(page: page).items
            await MainActor.run {
                appendUniqueMangas(mangas)
                page += 1
                isLoading = false
            }
        } catch {
            await handleError(error)
            isLoading = false
        }
    }
    
    func getBestMangas() async {
        guard !isLoading else { return }
        isLoading = true
        
        do {
            let mangas = try await interactor.getBestMangas(page: page).items
            await MainActor.run {
                appendUniqueMangas(mangas)
                page += 1
                isLoading = false
            }
        } catch {
            await handleError(error)
            isLoading = false
        }
    }
    
    func getMangasByDemographic(demographic: String) async {
        guard !isLoading else { return }
        isLoading = true
        
        do {
            let mangas = try await interactor.getListMangasByDemographic(demographic: demographic, page: page).items
            await MainActor.run {
                appendUniqueMangas(mangas)
                page += 1
                isLoading = false
            }
        } catch {
            await handleError(error)
            isLoading = false
        }
    }
    
    func getMangasByGenre(genre: String) async {
        guard !isLoading else { return }
        isLoading = true
        
        do {
            let mangas = try await interactor.getListMangasByGenre(genre: genre, page: page).items
            await MainActor.run {
                appendUniqueMangas(mangas)
                page += 1
                isLoading = false
            }
        } catch {
            await handleError(error)
            isLoading = false
        }
    }
    
    func getMangasByTheme(theme: String) async {
        guard !isLoading else { return }
        isLoading = true
        
        do {
            let mangas = try await interactor.getListMangasByTheme(theme: theme, page: page).items
            await MainActor.run {
                appendUniqueMangas(mangas)
                page += 1
                isLoading = false
            }
        } catch {
            await handleError(error)
            isLoading = false
        }
    }
    
    private func appendUniqueMangas(_ newMangas: [Manga]) {
        let uniqueMangas = newMangas.filter { manga in
            !loadedIds.contains(String(manga.id))
        }
        
        uniqueMangas.forEach { manga in
            loadedIds.insert(String(manga.id))
            mangas.append(MangaItemViewModel(manga: manga, inCollection: false))
        }
    }
    
    func returnMangas(_ onlyInCollection: Bool = false) -> [MangaItemViewModel] {
        onlyInCollection ? mangas.filter {$0.inCollection} : mangas
    }
    
    func shouldLoadMore(manga: MangaItemViewModel) -> Bool {
        guard let index = mangas.firstIndex(where: { $0.id == manga.id }) else {
            return false
        }

        return index + 5 >= mangas.count && !isLoading
    }
    
    func toggleBestMangas() async {
        showBest.toggle()
        clearList()
        if showBest {
            await getBestMangas()
        } else {
            await getMangas()
        }
    }
    
    func clearList() {
        mangas.removeAll()
        loadedIds.removeAll()
        page = 0
    }
    
    func getFilterContent(filter: Category) async {
        if filter == .demographic {
            self.category = .demographic
            await getDemographics()
        } else if filter == .genre {
            self.category = .genre
            await getGenres()
        } else if filter == .theme {
            self.category = .theme
            await getThemes()
        }
    }
    
    func getDemographics() async {
        do {
            let demographics = try await interactor.getDemographics().sorted()
            await MainActor.run {
                self.demographics = demographics
            }
        } catch {
            await handleError(error)
        }
    }
    
    func getGenres() async {
        do {
            let genres = try await interactor.getGenres().sorted()
            await MainActor.run {
                self.genres = genres
            }
        } catch {
            await handleError(error)
        }
    }
        
    func getThemes() async {
        do {
            let themes = try await interactor.getThemes().sorted()
            await MainActor.run {
                self.themes = themes
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
