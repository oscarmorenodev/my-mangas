import SwiftUI

struct SignupView: View {
    @Environment(AppStateManager.self) var appStateManager
    @Environment(SignupViewModel.self) var vm
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showAlert = false
    @State private var activeAlert: ActiveAlert = .failure
    
    private let requirements = "\nEmail must have valid format. \nPassword must be 8 characters or longer"
    
    var body: some View {
        VStack {
            LogoView(width: 100, height: 70)
            Text("Signup")
                .font(.title)
                .padding(.top, 50)
            VStack {
                TextField("Email", text: $email)
                    .autocorrectionDisabled()
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                SecureField("Password", text: $password)
                SecureField("Confirm Password", text: $confirmPassword)
            }
            .textFieldStyle(.roundedBorder)
            .padding(.horizontal, 50)
            Button {
                if vm.validateCredentials(email, password) {
                    Task {
                        await vm.createUser(email, password)
                    }
                    activeAlert = .success
                    showAlert = true
                } else {
                    activeAlert = .failure
                    showAlert = true
                }
            } label: {
                Text("Create user")
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 50)
            .alert(isPresented: $showAlert) {
                switch activeAlert {
                case .success:
                    Alert(title: Text("Success"),
                          message: Text("User created successfully"),
                          dismissButton: .default(Text("OK")) {
                        appStateManager.state = .nonLogged
                    })
                case .failure:
                    Alert(title: Text("Error"),
                          message: Text("Invalid email or password.\n\(requirements)"),
                          dismissButton: .default(Text("OK")) {
                        email = ""
                        password = ""
                        confirmPassword = ""
                    })
                }
            }
            Spacer()
            Button("Account created? Login") {
                appStateManager.state = .nonLogged
            }
            .padding(.bottom, UIDevice.current.userInterfaceIdiom == .vision ? 20 : 0)
        }
    }
}

enum ActiveAlert {
    case failure
    case success
}

#Preview {
    SignupView()
        .environment(AppStateManager.preview)
        .environment(SignupViewModel.preview)
}
