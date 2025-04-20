import Foundation

struct RenewTokenUseCase {
    private let repository: UserRepositoryProtocol
    static let shared = RenewTokenUseCase()
    
    init(repository: UserRepositoryProtocol = UserRepository()) {
        self.repository = repository
    }
    
    func execute() async throws -> String {
        try await repository.renewToken()
    }
} 
