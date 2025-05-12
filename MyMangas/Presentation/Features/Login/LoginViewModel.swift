import Foundation

@Observable
final class LoginViewModel {
    private let loginUseCase: LoginUseCase
    @ObservationIgnored private var appStateManager: AppStateManager?
    var displayError = false
    var errorMessage = ""
    
    init(loginUseCase: LoginUseCase = LoginUseCase()) {
        self.loginUseCase = loginUseCase
    }
    
    func setAppStateManager(_ manager: AppStateManager) {
        self.appStateManager = manager
    }
    
    func login(email: String, password: String) async -> Bool {
        do {
            let _ = try await loginUseCase.execute(email: email, password: password)
            
            await MainActor.run {
                appStateManager?.notifyUserLoggedIn()
            }
            
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
        
        Task {
            await appStateManager?.logOut()
        }
    }
}
