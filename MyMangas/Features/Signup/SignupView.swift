import SwiftUI

struct SignupView: View {
    @Environment(AppStateManager.self) var appStateManager
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    var body: some View {
        VStack {
            Text("Signup")
                .font(.largeTitle)
                .padding(.vertical, 100)
            VStack {
                TextField("Email", text: $email)
                    .autocorrectionDisabled()
                TextField("Password", text: $password)
                    .autocorrectionDisabled()
                TextField("Confirm Password", text: $confirmPassword)
                    .autocorrectionDisabled()
            }
            .textFieldStyle(.roundedBorder)
            .padding(.horizontal, 50)
            Button {
                
            } label: {
                Text("Create user")
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 50)
            Spacer()
            Button("Account created? Login") {
                appStateManager.state = .nonLogged
            }
        }
    }
}

#Preview {
    SignupView()
}
