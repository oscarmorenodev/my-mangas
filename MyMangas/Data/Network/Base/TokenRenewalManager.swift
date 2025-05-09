import Foundation

class TokenRenewalManager {
    private static let tokenExpirationDays: Double = 2
    private static let tokenRenewalThresholdDays: Double = 1
    private static var refreshTask: Task<Void, Never>?
    private static var tokenExpiredContinuation: CheckedContinuation<Void, Never>?
    
    static func getTokenAge() async -> Double? {
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
    
    static func shouldRenewToken() async -> Bool {
        guard let tokenAge = await getTokenAge() else {
            return false
        }
        return tokenAge >= tokenRenewalThresholdDays && tokenAge < tokenExpirationDays
    }
    
    static func isTokenExpired() async -> Bool {
        guard let tokenAge = await getTokenAge() else {
            return true
        }
        return tokenAge >= tokenExpirationDays
    }
    
    static func renewTokenIfNeeded() async throws -> Bool {
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
    
    static var isAuthenticated: Bool {
        get {
            do {
                return try TokenManager.getToken() != nil
            } catch {
                return false
            }
        }
    }
    
    static func startTokenRenewal() async {
        cancelRenewalTask()
        refreshTask = Task {
            while !Task.isCancelled {
                if await isTokenExpired() {
                    await notifyTokenExpired()
                    break
                }
                
                try? await Task.sleep(nanoseconds: 30 * 60 * 1_000_000_000)
            }
        }
    }
    
    static func cancelRenewalTask() {
        refreshTask?.cancel()
        refreshTask = nil
    }
    
    static func waitForTokenExpired() async {
        await withCheckedContinuation { continuation in
            tokenExpiredContinuation = continuation
        }
    }
    
    private static func notifyTokenExpired() async {
        await MainActor.run {
            tokenExpiredContinuation?.resume()
            tokenExpiredContinuation = nil
        }
    }
}

extension Notification.Name {
    static let tokenExpired = Notification.Name("tokenExpired")
    static let userLoggedIn = Notification.Name("userLoggedIn")
    static let userLoggedOut = Notification.Name("userLoggedOut")
}
