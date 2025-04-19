import Foundation

protocol MangaRepositoryProtocol {
    func getListMangas(page: Int) async throws -> Mangas
    func getBestMangas(page: Int) async throws -> Mangas
    func getListMangasByDemographic(demographic: String, page: Int) async throws -> Mangas
    func getListMangasByGenre(genre: String, page: Int) async throws -> Mangas
    func getListMangasByTheme(theme: String, page: Int) async throws -> Mangas
    func searchMangas(_ query: String, page: Int) async throws -> Mangas
    func getDemographics() async throws -> [String]
    func getGenres() async throws -> [String]
    func getThemes() async throws -> [String]
    func getMangaFromCollection(id: Int) async throws -> Manga
    func addOrUpdateMangaCollection(_ manga: UserMangaCollectionRequest) async throws
    func getCollection() async throws -> [UserMangaCollectionResponse]
    func deleteMangaFromCollection(id: Int) async throws
} 