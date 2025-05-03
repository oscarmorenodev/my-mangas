struct GetMangaListThemeUseCase {
    private let repository: MangaRepositoryProtocol
    
    init(repository: MangaRepositoryProtocol = MangaRepository()) {
        self.repository = repository
    }
    
    func getMangasByTheme(theme: String, page: Int, limit: Int) async throws -> Mangas {
        try await repository.getListMangasByTheme(theme: theme, page: page, limit: limit)
    }
    
    func getThemes() async throws -> [String] {
        try await repository.getThemes()
    }
}
