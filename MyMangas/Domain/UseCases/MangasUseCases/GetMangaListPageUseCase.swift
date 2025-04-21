import Foundation

struct GetMangaListPageUseCase {
    private let repository: MangaRepositoryProtocol
    
    init(repository: MangaRepositoryProtocol = MangaRepository()) {
        self.repository = repository
    }
    
    func execute(page: Int) async throws -> Mangas {
        try await repository.getListMangas(page: page)
    }
} 
