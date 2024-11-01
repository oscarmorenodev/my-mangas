import Foundation

protocol DataInteractor {
    func getMangas(page: Int) async throws -> Mangas
    func searchMangas(_ query: String) async throws -> Mangas
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
    
    func getMangas(page: Int) async throws -> Mangas {
        try await getData(request: .get(url: .getMangasUrl(page: page)), type: Mangas.self)
    }
    
    func searchMangas(_ query: String) async throws -> Mangas {
        try await getData(request: .get(url: .searchMangasUrl(query)), type: Mangas.self)
    }
}
