struct GetMangaListDemographicUseCase {
    private let repository: MangaRepositoryProtocol
    
    init(repository: MangaRepositoryProtocol = MangaRepository()) {
        self.repository = repository
    }
    
    func getMangasByDemograhpic(demographic: String, page: Int, limit: Int) async throws -> Mangas {
        try await repository.getListMangasByDemographic(demographic: demographic, page: page, limit: limit)
    }
    
    func getDemographics() async throws -> [String] {
        try await repository.getDemographics()
    }
}
