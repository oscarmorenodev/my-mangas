import Foundation

struct GetMangaDetailUseCase {
    private let repository: MangaRepositoryProtocol
    
    init(repository: MangaRepositoryProtocol = MangaRepository()) {
        self.repository = repository
    }
    
    func execute(mangaId: Int) async throws -> Manga {
        try await repository.getMangaFromCollection(id: mangaId)
    }
} 