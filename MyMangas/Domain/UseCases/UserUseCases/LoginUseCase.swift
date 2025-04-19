import Foundation

struct LoginUseCase {
    private let repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol = UserRepository()) {
        self.repository = repository
    }
    
    func execute(email: String, password: String) async throws -> String {
        try await repository.login(email: email, password: password)
    }
} 