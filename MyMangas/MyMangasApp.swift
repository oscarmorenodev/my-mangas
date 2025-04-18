import SwiftUI

@main
struct MyMangasApp: App {
    @State var mangasListViewModel = MangasListViewModel()
    @State var appStateManager = AppStateManager()
    @State var loginPresenter = LoginViewModel()
    @State var signupPresenter = SignupViewModel()
    
    var body: some Scene {
        WindowGroup {
            AppStateView()
                .environment(mangasListViewModel)
                .environment(appStateManager)
                .environment(loginPresenter)
                .environment(signupPresenter)
        }
    }
}
