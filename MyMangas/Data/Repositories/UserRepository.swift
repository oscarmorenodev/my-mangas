import Foundation

struct UserRepository: UserRepositoryProtocol {
    private let remoteDataSource: UserDataSourceProtocol
    
    init(remoteDataSource: UserDataSourceProtocol = RemoteUserDataSource()) {
        self.remoteDataSource = remoteDataSource
    }
    
    func createUser(user: Users) async throws -> Users {
        try await remoteDataSource.createUser(user: user)
    }
    
    func login(email: String, password: String) async throws -> String {
        try await remoteDataSource.login(email: email, password: password)
    }
    
    func renewToken() async throws -> String {
        try await remoteDataSource.renewToken()
    }
} 