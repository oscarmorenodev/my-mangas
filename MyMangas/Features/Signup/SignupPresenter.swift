import Foundation

@Observable
class SignupPresenter {
    func validateCredentials (_ email: String, _ password: String) -> Bool {
        validateCredentialsFormat(email, password) && validateCredentialsAreNotEmpty(email, password)
    }
    
    func createUser (_ email: String, _ password: String) {
        let user = Users(email: email, password: password)
    }
    private func validateCredentialsAreNotEmpty (_ email: String, _ password: String) -> Bool {
        if email.isEmpty || password.isEmpty {
            false
        } else {
            true
        }
    }
    
    private func validateCredentialsFormat (_ email: String, _ password: String) -> Bool {
        if password.count < 8 || !isValidEmail(email) {
            false
        } else {
            true
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
