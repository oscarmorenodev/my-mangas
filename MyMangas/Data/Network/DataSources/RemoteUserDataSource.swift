import Foundation

struct RemoteUserDataSource: UserDataSourceProtocol {
    
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
    
    func renewToken() async throws -> String {
        let request = try getAuthenticatedRequest(request: .post(url: .renewToken()))
        let newToken = try await postData(request: request, payload: "", responseType: String.self)
        try TokenManager.saveToken(newToken)
        return newToken
    }
} 