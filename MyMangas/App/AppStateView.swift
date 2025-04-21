import SwiftUI

struct AppStateView: View {
    @Environment(AppStateManager.self) var appStateManager
    
    var body: some View {
        VStack {
            switch appStateManager.state {
            case .logged:
                MainView()
            case .loading:
                SplashView()
            case .nonLogged:
                LoginView()
            case .signup:
                SignupView()
            }
        }
    }
}

#Preview {
    AppStateView()
        .environment(AppStateManager.preview)
        .environment(MangasListViewModel.preview)
        .environment(LoginViewModel.preview)
        .environment(SignupViewModel.preview)
}
