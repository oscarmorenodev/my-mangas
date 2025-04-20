import Foundation

@Observable
final class LoginViewModel {
    private let loginUseCase: LoginUseCase
    var displayError = false
    var errorMessage = ""
    
    
    init(loginUseCase: LoginUseCase = LoginUseCase()) {
        self.loginUseCase = loginUseCase
    }
    
    func login(email: String, password: String) async -> Bool {
        do {
            let _ = try await loginUseCase.execute(email: email, password: password)
            
            NotificationCenter.default.post(name: .userLoggedIn, object: nil)
            
            return true
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.displayError = true
            }
            return false
        }
    }
    
    func logout() {
        try? TokenManager.deleteToken()
        
        NotificationCenter.default.post(name: .userLoggedOut, object: nil)
    }
}
