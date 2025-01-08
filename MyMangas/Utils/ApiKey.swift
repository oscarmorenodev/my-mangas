import Foundation

struct ApiKey {
    static func getCreateUserKey() -> String {
        guard let infoDictionary: [String: Any] = Bundle.main.infoDictionary else { return "No Bundle found" }
        guard let userCreationToken = infoDictionary["CFUserCreationToken"] as? String else { return "No key found" }
        return userCreationToken
    }
}
