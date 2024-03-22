import Foundation

protocol DataInteractor {
    func getMangas() async throws -> Mangas
}

struct Network: DataInteractor {
    static let shared = Network()
    
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
    
    func getMangas() async throws -> Mangas {
        try await getData(request: .get(url: .getMangas), type: Mangas.self)
    }
}
