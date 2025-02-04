import SwiftUI

struct LoginView: View {
    @Environment(AppStateManager.self) var appStateManager
    @Environment(LoginPresenter.self) var presenter
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            Text("Login")
                .font(.largeTitle)
                .padding(.vertical, 100)
            VStack {
                TextField("Email", text: $email)
                    .autocorrectionDisabled()
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                SecureField("Password", text: $password)
            }
            .textFieldStyle(.roundedBorder)
            .padding(.horizontal, 50)
            Button {
                if presenter.validateLogin(email: email, password: password) {
                    appStateManager.state = .logged
                } else {
                    showAlert = true
                }
            } label: {
                Text("Login")
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 50)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"),
                      message: Text("Invalid email or password"),
                      dismissButton: .default(Text("OK")) {
                    email = ""
                    password = ""
                })
            }
            Spacer()
            Button("Not account yet? Sign up") {
                appStateManager.state = .signup
            }
        }
    }
}

#Preview {
    LoginView()
}
