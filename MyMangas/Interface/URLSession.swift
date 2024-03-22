import Foundation

extension URLSession {
    func getData(for url: URLRequest, delegate: (URLSessionTaskDelegate)? = nil) async throws -> (Data, HTTPURLResponse) {
        do {
            let (data, response) = try await URLSession.shared.data(for: url, delegate: delegate)
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.noHTTP
            }
            return (data, response)
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.general(error)
        }
    }
}
