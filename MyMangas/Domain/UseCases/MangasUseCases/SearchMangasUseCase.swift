import Foundation

struct SearchMangasUseCase {
    private let repository: MangaRepositoryProtocol
    
    init(repository: MangaRepositoryProtocol = MangaRepository()) {
        self.repository = repository
    }
    
    func execute(query: String, page: Int) async throws -> Mangas {
        try await repository.searchMangas(query, page: page)
    }
} 
