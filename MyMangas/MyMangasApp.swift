import SwiftUI

@main
struct MyMangasApp: App {
    @State var mangasListViewModel = MangasListViewModel()
    @State var appStateManager = AppStateManager()
    @State var loginPresenter = LoginPresenter()
    @State var signupPresenter = SignupPresenter()
    
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
