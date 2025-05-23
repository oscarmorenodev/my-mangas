import Foundation

@Observable
final class LoginViewModel {
    let interactor: DataInteractor
    var displayError = false
    var errorMessage = ""
    
    init(interactor: DataInteractor = DataService.shared) {
        self.interactor = interactor
    }
    
    func login(email: String, password: String) async -> Bool {
        do {
            let _ = try await interactor.login(email: email, password: password)
            
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
