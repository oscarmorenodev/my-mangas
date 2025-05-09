import Foundation

@Observable
class AppStateManager {
    var state: AppState = .loading
    
    private var stateCheckTask: Task<Void, Never>?
    private var renewalTask: Task<Void, Never>?
    
    private var tokenExpiredContinuation: CheckedContinuation<Void, Never>?
    private var userLoggedInContinuation: CheckedContinuation<Void, Never>?
    private var userLoggedOutContinuation: CheckedContinuation<Void, Never>?
    
    init() {
        checkAuthentication()
    }
    
    func startTokenRenewal() {
        Task {
            await TokenRenewalManager.shared.cancelRenewalTask()
        }
        renewalTask = Task {
            await TokenRenewalManager.shared.startTokenRenewal()
        }
    }
    
    func checkTokenStatus() async {
        if await TokenRenewalManager.shared.isAuthenticated {
            if await TokenRenewalManager.shared.isTokenExpired() {
                await logOut()
            } else {
                await MainActor.run {
                    state = .logged
                }
                startTokenRenewal()
            }
        } else {
            await MainActor.run {
                state = .nonLogged
            }
        }
    }
    
    func checkAuthentication() {
        cancelStateCheckTask()
        stateCheckTask = Task {
            await checkTokenStatus()
        }
    }
    
    func logOut() async {
        try? TokenManager.deleteToken()
        await TokenRenewalManager.shared.cancelRenewalTask()
        state = .nonLogged
        
        notifyUserLoggedOut()
    }
    
    func waitForTokenExpired() async {
        await withCheckedContinuation { continuation in
            tokenExpiredContinuation = continuation
        }
    }
    
    func waitForUserLoggedIn() async {
        await withCheckedContinuation { continuation in
            userLoggedInContinuation = continuation
        }
    }
    
    func waitForUserLoggedOut() async {
        await withCheckedContinuation { continuation in
            userLoggedOutContinuation = continuation
        }
    }
    
    func notifyTokenExpired() {
        Task {
            await logOut()
            tokenExpiredContinuation?.resume()
            tokenExpiredContinuation = nil
        }
    }
    
    func notifyUserLoggedIn() {
        Task {
            state = .logged
            startTokenRenewal()
            userLoggedInContinuation?.resume()
            userLoggedInContinuation = nil
        }
    }
    
    func notifyUserLoggedOut() {
        userLoggedOutContinuation?.resume()
        userLoggedOutContinuation = nil
    }
    
    private func cancelStateCheckTask() {
        stateCheckTask?.cancel()
        stateCheckTask = nil
    }
    
    deinit {
        cancelStateCheckTask()
        renewalTask?.cancel()
        renewalTask = nil
        Task {
            await TokenRenewalManager.shared.cancelRenewalTask()
        }
    }
}
