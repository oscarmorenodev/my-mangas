import Foundation

struct MangaRepository: MangaRepositoryProtocol {
    private let remoteDataSource: MangaDataSourceProtocol
    
    init(remoteDataSource: MangaDataSourceProtocol = RemoteMangaDataSource()) {
        self.remoteDataSource = remoteDataSource
    }
    
    func getListMangas(page: Int, limit: Int) async throws -> Mangas {
        try await remoteDataSource.getListMangas(page: page, limit: limit)
    }
    
    func getBestMangas(page: Int, limit: Int) async throws -> Mangas {
        try await remoteDataSource.getBestMangas(page: page, limit: limit)
    }
    
    func getListMangasByDemographic(demographic: String, page: Int, limit: Int) async throws -> Mangas {
        try await remoteDataSource.getListMangasByDemographic(demographic: demographic, page: page, limit: limit)
    }
    
    func getListMangasByGenre(genre: String, page: Int, limit: Int) async throws -> Mangas {
        try await remoteDataSource.getListMangasByGenre(genre: genre, page: page, limit: limit)
    }
    
    func getListMangasByTheme(theme: String, page: Int, limit: Int) async throws -> Mangas {
        try await remoteDataSource.getListMangasByTheme(theme: theme, page: page, limit: limit)
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
