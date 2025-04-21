import Foundation

struct MangaRepository: MangaRepositoryProtocol {
    private let remoteDataSource: MangaDataSourceProtocol
    
    init(remoteDataSource: MangaDataSourceProtocol = RemoteMangaDataSource()) {
        self.remoteDataSource = remoteDataSource
    }
    
    func getListMangas(page: Int) async throws -> Mangas {
        try await remoteDataSource.getListMangas(page: page)
    }
    
    func getBestMangas(page: Int) async throws -> Mangas {
        try await remoteDataSource.getBestMangas(page: page)
    }
    
    func getListMangasByDemographic(demographic: String, page: Int) async throws -> Mangas {
        try await remoteDataSource.getListMangasByDemographic(demographic: demographic, page: page)
    }
    
    func getListMangasByGenre(genre: String, page: Int) async throws -> Mangas {
        try await remoteDataSource.getListMangasByGenre(genre: genre, page: page)
    }
    
    func getListMangasByTheme(theme: String, page: Int) async throws -> Mangas {
        try await remoteDataSource.getListMangasByTheme(theme: theme, page: page)
    }
    
    func searchMangas(_ query: String, page: Int) async throws -> Mangas {
        try await remoteDataSource.searchMangas(query, page: page)
    }
    
    func getDemographics() async throws -> [String] {
        try await remoteDataSource.getDemographics()
    }
    
    func getGenres() async throws -> [String] {
        try await remoteDataSource.getGenres()
    }
    
    func getThemes() async throws -> [String] {
        try await remoteDataSource.getThemes()
    }
    
    func getMangaFromCollection(id: Int) async throws -> Manga {
        try await remoteDataSource.getMangaFromCollection(id: id)
    }
    
    func addOrUpdateMangaCollection(_ manga: UserMangaCollectionRequest) async throws {
        try await remoteDataSource.addOrUpdateMangaCollection(manga)
    }
    
    func getCollection() async throws -> [UserMangaCollectionResponse] {
        try await remoteDataSource.getCollection()
    }
    
    func deleteMangaFromCollection(id: Int) async throws {
        try await remoteDataSource.deleteMangaFromCollection(id: id)
    }
} 