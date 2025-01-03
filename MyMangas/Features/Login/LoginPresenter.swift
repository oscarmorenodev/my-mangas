import Foundation

@Observable
class LoginPresenter {
    func validateLogin(username: String, password: String) -> Bool {
        username == "admin" && password == "admin"
    }
}
