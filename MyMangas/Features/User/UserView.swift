import SwiftUI

struct UserView: View {
    @Environment(AppStateManager.self) var appStateManager
    
    var body: some View {
        VStack {
            Button {
                appStateManager.logOut()
            } label: {
                Text("Logout")
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    UserView()
}
