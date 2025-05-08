import SwiftUI

struct UserView: View {
    @Environment(AppStateManager.self) var appStateManager
    
    var body: some View {
        VStack {
            LogoView()
            Spacer()
            Button {
                appStateManager.logOut()
            } label: {
                Text("Logout")
            }
            .buttonStyle(.borderedProminent)
            .padding(.bottom, 50)
        }
    }
}

#Preview {
    UserView()
        .environment(AppStateManager.preview)
}
