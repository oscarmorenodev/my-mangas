import SwiftUI

struct LoginView: View {
    @Environment(AppStateManager.self) var appStateManager
    @State private var vm = LoginViewModel()
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert = false
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            if isLoading {
                LoadingView(loading: $isLoading)
            } else {
                LogoView(width: 100, height: 70)
                Text("Login")
                    .font(.title)
                    .padding(.top, 50)
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
                        if await vm.login(email: email, password: password) {
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
        .onAppear {
            vm.setAppStateManager(appStateManager)
        }
    }
}

#Preview {
    LoginView()
        .environment(AppStateManager.preview)
}
