import Foundation

protocol DataInteractor {
    func getListMangas(page: Int) async throws -> Mangas
    func getBestMangas(page: Int) async throws -> Mangas
    func getListMangasByDemographic(demographic: String, page: Int) async throws -> Mangas
    func getListMangasByGenre(genre: String, page: Int) async throws -> Mangas
    func getListMangasByTheme(theme: String, page: Int) async throws -> Mangas
    func searchMangas(_ query: String, page: Int) async throws -> Mangas
    func getDemographics() async throws -> [String]
    func getGenres() async throws -> [String]
    func getThemes() async throws -> [String]
    func createUser(user: Users) async throws -> Users
    func login(email: String, password: String) async throws -> String
}

// MARK: Generic methods
struct DataService: DataInteractor {
    static let shared = DataService()
    
    func getData<T:Decodable>(request: URLRequest, type: T.Type) async throws -> T where T: Decodable {
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
    
    func postData<T:Encodable, U: Decodable>(request: URLRequest, payload: T, responseType: U.Type) async throws -> U {
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
        
        if let token = String(data: data, encoding: .utf8) {
            return token as! U
        }
        
        do {
            return try JSONDecoder().decode(responseType, from: data)
        } catch {
            throw NetworkError.decode(error)
        }
    }
}

// MARK: GET Methods
extension DataService {
    func getListMangas(page: Int) async throws -> Mangas {
        try await getData(request: .get(url: .getListMangasUrl(page: page)), type: Mangas.self)
    }
    
    func getBestMangas(page: Int) async throws -> Mangas {
        try await getData(request: .get(url: .getListBestMangasUrl(page: page)), type: Mangas.self)
    }
    
    func getListMangasByDemographic(demographic: String, page: Int) async throws -> Mangas {
        try await getData(request: .get(url: .getListMangasByDemographicUrl(demographic: demographic, page: page)), type: Mangas.self)
    }
    
    func getListMangasByGenre(genre: String, page: Int) async throws -> Mangas {
        try await getData(request: .get(url: .getListMangasByGenreUrl(genre: genre, page: page)), type: Mangas.self)
    }
    
    func getListMangasByTheme(theme: String, page: Int) async throws -> Mangas {
        try await getData(request: .get(url: .getListMangasByThemeUrl(theme: theme, page: page)), type: Mangas.self)
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
}

// MARK: POST Methods
extension DataService {
    func createUser(user: Users) async throws -> Users {
        try await postData(request: .post(url: .createUser()), payload: user, responseType: Users.self)
    }
    
    func login(email: String, password: String) async throws -> String {
        let credentials = "\(email):\(password)"
        guard let encodedCredentials = credentials.data(using: .utf8) else {
            throw NetworkError.encode(NSError(domain: "Login", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode credentials"]))
        }
        
        var request = URLRequest.post(url: .login())
        request.setValue("Basic \(encodedCredentials.base64EncodedString())", forHTTPHeaderField: "Authorization")

        let loginResponse = try await postData(request: request, payload: "", responseType: String.self)
        try TokenManager.saveToken(loginResponse)
        return loginResponse
    }
}
