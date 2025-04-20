import Foundation

struct GetMangaCollectionUseCase {
    private let repository: MangaRepositoryProtocol
    
    init(repository: MangaRepositoryProtocol = MangaRepository()) {
        self.repository = repository
    }
    
    func getCollection() async throws -> [UserMangaCollectionResponse] {
        return try await repository.getCollection()
    }
    
    func addOrUpdateMangaCollection(_ manga: UserMangaCollectionRequest) async throws {
        try await repository.addOrUpdateMangaCollection(manga)
    }
    
    func deleteMangaFromCollection(id: Int) async throws {
        try await repository.deleteMangaFromCollection(id: id)
    }
}
