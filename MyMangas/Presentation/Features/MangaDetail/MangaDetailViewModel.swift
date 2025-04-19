import Foundation

@Observable
class MangaDetailViewModel {
    private let getMangaUseCase: GetMangaDetailUseCase
    
    var manga: Manga?
    var isLoading = false
    var error: Error?
    
    init(getMangaUseCase: GetMangaDetailUseCase = GetMangaDetailUseCase()) {
        self.getMangaUseCase = getMangaUseCase
    }
    
    func loadMangaDetail(mangaId: Int) {
        isLoading = true
        error = nil
        
        Task {
            do {
                manga = try await getMangaUseCase.execute(mangaId: mangaId)
                isLoading = false
            } catch {
                self.error = error
                isLoading = false
            }
        }
    }
} 
