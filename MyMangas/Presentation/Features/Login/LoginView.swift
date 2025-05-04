import SwiftUI

struct LoginView: View {
    @Environment(AppStateManager.self) var appStateManager
    @Environment(LoginViewModel.self) var presenter
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert = false
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            if isLoading {
                LoadingView(loading: $isLoading)
            } else {
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
                    Task {
                        isLoading = true
                        if await presenter.login(email: email, password: password) {
                            appStateManager.state = .logged
                        } else {
                            showAlert = true
                        }
                        isLoading = false
                    }
                } label: {
                    if isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Login")
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(isLoading)
                .padding(.top, 50)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"),
                          message: Text("User or password incorrect"),
                          dismissButton: .default(Text("OK")) {
                        email = ""
                        password = ""
                    })
                }
                Spacer()
                Button("Not account yet? Sign up") {
                    appStateManager.state = .signup
                }
                .padding(.bottom, UIDevice.current.userInterfaceIdiom == .vision ? 20 : 0)
                .disabled(isLoading)
            }
        }
    }
}

#Preview {
    LoginView()
        .environment(AppStateManager.preview)
        .environment(LoginViewModel.preview)
}
