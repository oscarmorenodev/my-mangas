import Foundation

@Observable
final class SignupViewModel {
    private let createUserUseCase: CreateUserUseCase
    var displayError = false
    var errorMessage = ""
    var isLoading = false
    
    init(createUserUseCase: CreateUserUseCase = CreateUserUseCase()) {
        self.createUserUseCase = createUserUseCase
    }
    
    func validateCredentials (_ email: String, _ password: String) -> Bool {
        validateCredentialsFormat(email, password) && validateCredentialsAreNotEmpty(email, password)
    }
    
    func createUser (_ email: String, _ password: String) async {
        let user = User(email: email, password: password)
        do {
            try await createUserUseCase.execute(user: user)
        } catch {
            await handleError(error)
        }
    }
    
    private func validateCredentialsAreNotEmpty (_ email: String, _ password: String) -> Bool {
        if email.isEmpty || password.isEmpty {
            false
        } else {
            true
        }
    }
    
    private func validateCredentialsFormat (_ email: String, _ password: String) -> Bool {
        if password.count < 8 || !isValidEmail(email) {
            false
        } else {
            true
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func handleError(_ error: any Error) async {
        await MainActor.run {
            self.errorMessage = error.localizedDescription
            self.displayError.toggle()
        }
    }
}
