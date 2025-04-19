struct GetMangaListGenreUseCase {
    private let repository: MangaRepositoryProtocol
    
    init(repository: MangaRepositoryProtocol = MangaRepository()) {
        self.repository = repository
    }
    
    func getMangaByGenre(genre: String, page: Int) async throws -> Mangas {
        try await repository.getListMangasByGenre(genre: genre, page: page)
    }
    
    func getGenres() async throws -> [String] {
        try await repository.getGenres()
    }
}
