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
    
    @ObservationIgnored var page: Int = 0
    
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
        do {
            let mangas = try await interactor.getListMangas(page: page).items
            await MainActor.run {
                self.mangas += mangas.map {MangaItemViewModel(manga: $0, inCollection: false)}
                page += 1
            }
        } catch {
            await handleError(error)
        }
    }
    
    func getBestMangas() async {
        do {
            let mangas = try await interactor.getBestMangas(page: page).items
            await MainActor.run {
                self.mangas += mangas.map {MangaItemViewModel(manga: $0, inCollection: false)}
                page += 1
            }
        } catch {
            await handleError(error)
        }
    }
    
    func getMangasByDemographic(demographic: String) async {
        do {
            let mangas = try await interactor.getListMangasByDemographic(demographic: demographic, page: page).items
            await MainActor.run {
                self.mangas += mangas.map {MangaItemViewModel(manga: $0, inCollection: false)}
                page += 1
            }
        } catch {
            await handleError(error)
        }
    }
    
    func getMangasByGenre(genre: String) async {
        do {
            let mangas = try await interactor.getListMangasByGenre(genre: genre, page: page).items
            await MainActor.run {
                self.mangas += mangas.map {MangaItemViewModel(manga: $0, inCollection: false)}
                page += 1
            }
        } catch {
            await handleError(error)
        }
    }
    
    func getMangasByTheme(theme: String) async {
        do {
            let mangas = try await interactor.getListMangasByTheme(theme: theme, page: page).items
            await MainActor.run {
                self.mangas += mangas.map {MangaItemViewModel(manga: $0, inCollection: false)}
                page += 1
            }
        } catch {
            await handleError(error)
        }
    }
    
    func returnMangas(_ onlyInCollection: Bool = false) -> [MangaItemViewModel] {
        onlyInCollection ? mangas.filter {$0.inCollection} : mangas
    }
    
    func toggleAddedToCollection(_ manga: MangaItemViewModel) {
        if let index = mangas.firstIndex(where: { $0.title == manga.title}) {
            mangas[index].inCollection.toggle()
        }
    }
    
    func shouldLoadMore(manga: MangaItemViewModel) -> Bool {
        guard let index = mangas.firstIndex(where: { $0.id == manga.id }) else {
            return false
        }

        return index + 2 == mangas.count
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
