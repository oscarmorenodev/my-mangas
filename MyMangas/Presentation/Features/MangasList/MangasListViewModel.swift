import Foundation
import SwiftUI

@Observable
final class MangasListViewModel {
    private let getMangaListPageUseCase: GetMangaListPageUseCase
    private let getMangaListBestUseCase: GetMangaListBestUseCase
    private let getMangaListDemographicUseCase: GetMangaListDemographicUseCase
    private let getMangaListGenreUseCase: GetMangaListGenreUseCase
    private let getMangaListThemeUseCase: GetMangaListThemeUseCase
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
    @ObservationIgnored private var itemsPerPage: Int
    
    init(getMangaListPageUseCase: GetMangaListPageUseCase = GetMangaListPageUseCase(),
         getMangaListBestUseCase: GetMangaListBestUseCase = GetMangaListBestUseCase(),
         getMangaListDemographicUseCase: GetMangaListDemographicUseCase = GetMangaListDemographicUseCase(),
         getMangaListGenreUseCase: GetMangaListGenreUseCase = GetMangaListGenreUseCase(),
         getMangaListThemeUseCase: GetMangaListThemeUseCase = GetMangaListThemeUseCase()) {
        self.getMangaListPageUseCase = getMangaListPageUseCase
        self.getMangaListBestUseCase = getMangaListBestUseCase
        self.getMangaListDemographicUseCase = getMangaListDemographicUseCase
        self.getMangaListGenreUseCase = getMangaListGenreUseCase
        self.getMangaListThemeUseCase = getMangaListThemeUseCase
        
        self.itemsPerPage = UIDevice.current.userInterfaceIdiom != .phone ? 20 : 10
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
            let mangas = try await getMangaListPageUseCase.execute(page: page, limit: itemsPerPage).items
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
            let mangas = try await getMangaListBestUseCase.execute(page: page, limit: itemsPerPage).items
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
        isLoading = true
        do {
            let mangas = try await getMangaListDemographicUseCase.getMangasByDemograhpic(demographic: demographic, page: page, limit: itemsPerPage).items
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
        isLoading = true
        
        do {
            let mangas = try await getMangaListGenreUseCase.getMangaByGenre(genre: genre, page: page, limit: itemsPerPage).items
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
        isLoading = true
        
        do {
            let mangas = try await getMangaListThemeUseCase.getMangasByTheme(theme: theme, page: page, limit: itemsPerPage).items
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
            let demographics = try await getMangaListDemographicUseCase.getDemographics().sorted()
            await MainActor.run {
                self.demographics = demographics
            }
        } catch {
            await handleError(error)
        }
    }
    
    func getGenres() async {
        do {
            let genres = try await getMangaListGenreUseCase.getGenres().sorted()
            await MainActor.run {
                self.genres = genres
            }
        } catch {
            await handleError(error)
        }
    }
        
    func getThemes() async {
        do {
            let themes = try await getMangaListThemeUseCase.getThemes().sorted()
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
