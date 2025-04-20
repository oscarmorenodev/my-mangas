import Foundation

struct ApiKey {
    static func getCreateUserKey() -> String {
        if let environmentToken = ProcessInfo.processInfo.environment["USER_CREATION_TOKEN"] {
            return environmentToken
        }
        return "No key found"
    }
}
