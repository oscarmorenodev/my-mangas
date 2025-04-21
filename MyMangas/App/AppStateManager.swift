import Foundation

@Observable
class AppStateManager {
    var state: AppState = .loading
    
    init() {
        setupNotificationObservers()
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleTokenExpired),
            name: .tokenExpired,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleUserLoggedIn),
            name: .userLoggedIn,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleUserLoggedOut),
            name: .userLoggedOut,
            object: nil
        )
    }
    
    func startTokenRenewal() {
        TokenRenewalManager.startTokenRenewal()
    }
    
    func checkTokenStatus() async {
        if TokenRenewalManager.isAuthenticated {
            if await TokenRenewalManager.isTokenExpired() {
                logOut()
            } else {
                state = .logged
                TokenRenewalManager.startTokenRenewal()
            }
        } else {
            state = .nonLogged
        }
    }
    
    func checkAuthentication() {
        Task {
            await checkTokenStatus()
        }
    }
    
    func logOut() {
        try? TokenManager.deleteToken()
        TokenRenewalManager.cancelRenewalTask()
        state = .nonLogged
    }
    
    @objc private func handleTokenExpired() {
        logOut()
    }
    
    @objc private func handleUserLoggedIn() {
        state = .logged
        TokenRenewalManager.startTokenRenewal()
    }
    
    @objc private func handleUserLoggedOut() {
        logOut()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
