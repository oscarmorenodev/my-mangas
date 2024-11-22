import Foundation

protocol DataInteractor {
    func getListMangas(page: Int) async throws -> Mangas
    func getBestMangas(page: Int) async throws -> Mangas
    func searchMangas(_ query: String, page: Int) async throws -> Mangas
    func getDemographics() async throws -> [String]
    func getGenres() async throws -> [String]
    func getThemes() async throws -> [String]
}

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
    
    func getListMangas(page: Int) async throws -> Mangas {
        try await getData(request: .get(url: .getListMangasUrl(page: page)), type: Mangas.self)
    }
    
    func getBestMangas(page: Int) async throws -> Mangas {
        try await getData(request: .get(url: .getBestMangasUrl(page: page)), type: Mangas.self)
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
