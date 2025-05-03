import Foundation

struct RemoteMangaDataSource: MangaDataSourceProtocol {
    
    private func getData<T:Decodable>(request: URLRequest, type: T.Type) async throws -> T where T: Decodable {
        let (data, response) = try await URLSession.shared.getData(for: request)
        if response.statusCode == 200 {
            do {
                return try JSONDecoder().decode(type, from: data)
            } catch {
                throw NetworkError.decode(error)
            }
        } else {
            throw NetworkError.status(response.statusCode)
        }
    }
    
    private func postData<T:Encodable, U: Decodable>(request: URLRequest, payload: T, responseType: U.Type) async throws -> U {
        var request = request
        
        do {
            request.httpBody = try JSONEncoder().encode(payload)
        } catch {
            throw NetworkError.encode(error)
        }
        
        let (data, response) = try await URLSession.shared.getData(for: request)
        
        guard response.statusCode == 201 || response.statusCode == 200 else {
            throw NetworkError.status(response.statusCode)
        }
        
        if let token = String(data: data, encoding: .utf8), !token.isEmpty {
            return token as! U
        }
        
        do {
            return try JSONDecoder().decode(responseType, from: data)
        } catch {
            throw NetworkError.decode(error)
        }
    }
    
    private func getAuthenticatedRequest(request: URLRequest) throws -> URLRequest {
        guard let token = try TokenManager.getToken() else {
            throw TokenError.tokenNotFound
        }
        
        var authenticatedRequest = request
        authenticatedRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return authenticatedRequest
    }
    
    func getListMangas(page: Int, limit: Int) async throws -> Mangas {
        try await getData(request: .get(url: .getListMangasUrl(page: page, limit: limit)), type: Mangas.self)
    }
    
    func getBestMangas(page: Int, limit: Int) async throws -> Mangas {
        try await getData(request: .get(url: .getListBestMangasUrl(page: page, limit: limit)), type: Mangas.self)
    }
    
    func getListMangasByDemographic(demographic: String, page: Int, limit: Int) async throws -> Mangas {
        try await getData(request: .get(url: .getListMangasByDemographicUrl(demographic: demographic, page: page, limit: limit)), type: Mangas.self)
    }
    
    func getListMangasByGenre(genre: String, page: Int, limit: Int) async throws -> Mangas {
        try await getData(request: .get(url: .getListMangasByGenreUrl(genre: genre, page: page, limit: limit)), type: Mangas.self)
    }
    
    func getListMangasByTheme(theme: String, page: Int, limit: Int) async throws -> Mangas {
        try await getData(request: .get(url: .getListMangasByThemeUrl(theme: theme, page: page, limit: limit)), type: Mangas.self)
    }
    
    func searchMangas(_ query: String, page: Int) async throws -> Mangas {
        try await getData(request: .get(url: .searchMangasUrl(query, page: page)), type: Mangas.self)
    }
    
    func getDemographics() async throws -> [String] {
        try await getData(request: .get(url: .getDemographicsUrl()), type: [String].self)
    }
    
    func getGenres() async throws -> [String] {
        try await getData(request: .get(url: .getGenresUrl()), type: [String].self)
    }
    
    func getThemes() async throws -> [String] {
        try await getData(request: .get(url: .getThemesUrl()), type: [String].self)
    }
    
    func getCollection() async throws -> [UserMangaCollectionResponse] {
        let request = try getAuthenticatedRequest(request: .get(url: .mangaCollectionUrl()))
        return try await getData(request: request, type: [UserMangaCollectionResponse].self)
    }
    
    func getMangaFromCollection(id: Int) async throws -> Manga {
        let request = try getAuthenticatedRequest(request: .get(url: .mangaCollectionByIdUrl(mangaId: id)))
        return try await getData(request: request, type: Manga.self)
    }
    
    func addOrUpdateMangaCollection(_ manga: UserMangaCollectionRequest) async throws {
        let request = try getAuthenticatedRequest(request: .post(url: .mangaCollectionUrl()))
        _ = try await postData(request: request, payload: manga, responseType: UserMangaCollectionRequest.self)
    }
    
    func deleteMangaFromCollection(id: Int) async throws {
        let request = try getAuthenticatedRequest(request: .delete(url: .mangaCollectionByIdUrl(mangaId: id)))
        let (_, _) = try await URLSession.shared.getData(for: request)
    }
} 
