import Foundation

@Observable
class LoginPresenter {
    func validateLogin(email: String, password: String) -> Bool {
        email == "admin" && password == "admin"
    }
}
