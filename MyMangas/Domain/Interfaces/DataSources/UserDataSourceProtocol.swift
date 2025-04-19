import Foundation

protocol UserDataSourceProtocol {
    func createUser(user: Users) async throws -> Users
    func login(email: String, password: String) async throws -> String
    func renewToken() async throws -> String
} 