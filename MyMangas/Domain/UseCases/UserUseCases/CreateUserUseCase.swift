import Foundation

struct CreateUserUseCase {
    private let repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol = UserRepository()) {
        self.repository = repository
    }
    
    func execute(user: User) async throws {
        try await repository.createUser(user: user)
    }
} 