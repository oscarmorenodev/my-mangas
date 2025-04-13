import Foundation

class TokenRenewalManager {
    private let interactor: DataInteractor
    private let tokenExpirationDays: Double = 2
    private let tokenRenewalThresholdDays: Double = 1
    
    init(interactor: DataInteractor = DataService.shared) {
        self.interactor = interactor
    }
    
    func shouldRenewToken() async throws -> Bool {
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
            return false
        }
        
        let daysSinceLastModification = Date().timeIntervalSince(modificationDate) / (60 * 60 * 24)
        return daysSinceLastModification >= tokenRenewalThresholdDays
    }
    
    func renewTokenIfNeeded() async throws -> Bool {
        guard try await shouldRenewToken() else {
            return false
        }
        
        do {
            let _ = try await interactor.renewToken()
            return true
        } catch TokenError.renewalFailed {
            try? TokenManager.deleteToken()
            throw TokenError.tokenExpired
        } catch {
            throw error
        }
    }
} 
