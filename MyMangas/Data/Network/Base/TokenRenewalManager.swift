import Foundation

actor TokenRenewalManager {
    private let tokenExpirationDays: Double = 2
    private let tokenRenewalThresholdDays: Double = 1
    private var refreshTask: Task<Void, Never>?
    private var tokenExpiredContinuation: CheckedContinuation<Void, Never>?
    
    static let shared = TokenRenewalManager()
    
    private init() {}
    
    func getTokenAge() async -> Double? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "com.mymanga.auth",
            kSecAttrAccount as String: "authToken",
            kSecReturnAttributes as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let attributes = result as? [String: Any],
              let modificationDate = attributes[kSecAttrModificationDate as String] as? Date else {
            return nil
        }
        
        return Date().timeIntervalSince(modificationDate) / (60 * 60 * 24)
    }
    
    func shouldRenewToken() async -> Bool {
        guard let tokenAge = await getTokenAge() else {
            return false
        }
        return tokenAge >= tokenRenewalThresholdDays && tokenAge < tokenExpirationDays
    }
    
    func isTokenExpired() async -> Bool {
        guard let tokenAge = await getTokenAge() else {
            return true
        }
        return tokenAge >= tokenExpirationDays
    }
    
    func renewTokenIfNeeded() async throws -> Bool {
        let tokenAge = await getTokenAge()
        
        if tokenAge == nil {
            return false
        }
        
        if tokenAge! >= tokenExpirationDays {
            try? TokenManager.deleteToken()
            throw TokenError.tokenExpired
        }
        
        if tokenAge! < tokenRenewalThresholdDays {
            return false
        }
        
        do {
            let _ = try await RenewTokenUseCase.shared.execute()
            return true
        } catch TokenError.renewalFailed {
            try? TokenManager.deleteToken()
            throw TokenError.tokenExpired
        } catch {
            throw error
        }
    }
    
    var isAuthenticated: Bool {
        get {
            do {
                return try TokenManager.getToken() != nil
            } catch {
                return false
            }
        }
    }
    
    func startTokenRenewal() async {
        cancelRenewalTask()
        refreshTask = Task {
            while !Task.isCancelled {
                if await self.isTokenExpired() {
                    await self.notifyTokenExpired()
                    break
                }
                
                try? await Task.sleep(nanoseconds: 30 * 60 * 1_000_000_000)
            }
        }
    }
    
    func cancelRenewalTask() {
        refreshTask?.cancel()
        refreshTask = nil
    }
    
    func waitForTokenExpired() async {
        await withCheckedContinuation { continuation in
            tokenExpiredContinuation = continuation
        }
    }
    
    private func notifyTokenExpired() async {
        let continuation = tokenExpiredContinuation
        tokenExpiredContinuation = nil
        
        await MainActor.run {
            continuation?.resume()
        }
    }
}
