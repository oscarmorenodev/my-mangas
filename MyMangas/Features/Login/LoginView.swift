import SwiftUI

struct LoginView: View {
    @Environment(AppStateManager.self) var appStateManager
    @Environment(LoginPresenter.self) var presenter
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            Text("Login")
                .font(.largeTitle)
                .padding(.vertical, 100)
            VStack {
                TextField("Username", text: $username)
                    .autocorrectionDisabled()
                    .textContentType(.username)
                    .textInputAutocapitalization(.never)
                SecureField("Password", text: $password)
                    .autocorrectionDisabled()
                    .textContentType(.password)
            }
            .textFieldStyle(.roundedBorder)
            .padding(.horizontal, 50)
            Button {
                if presenter.validateLogin(username: username, password: password) {
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
                      message: Text("Invalid username or password"),
                      dismissButton: .default(Text("OK")) {
                    username = ""
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
