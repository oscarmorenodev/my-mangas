import Foundation

protocol UserRepositoryProtocol {
    func createUser(user: User) async throws
    func login(email: String, password: String) async throws -> String
    func renewToken() async throws -> String
} 