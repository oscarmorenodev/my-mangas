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
        cancelRenewalTask()
        renewalTask = Task {
            await TokenRenewalManager.startTokenRenewal()
        }
    }
    
    func checkTokenStatus() async {
        if TokenRenewalManager.isAuthenticated {
            if await TokenRenewalManager.isTokenExpired() {
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
        cancelRenewalTask()
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
    
    private func cancelRenewalTask() {
        renewalTask?.cancel()
        renewalTask = nil
        TokenRenewalManager.cancelRenewalTask()
    }
    
    deinit {
        cancelStateCheckTask()
        cancelRenewalTask()
    }
}
