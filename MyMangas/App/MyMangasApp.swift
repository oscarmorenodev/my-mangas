import SwiftUI

@main
struct MyMangasApp: App {
    @State var mangasListViewModel = MangasListViewModel()
    @State var mangasCollectionViewModel = MangasCollectionViewModel()
    @State var appStateManager = AppStateManager()
    @State var loginPresenter = LoginViewModel()
    @State var signupPresenter = SignupViewModel()
    
    var body: some Scene {
        WindowGroup {
            AppStateView()
                .environment(mangasListViewModel)
                .environment(mangasCollectionViewModel)
                .environment(appStateManager)
                .environment(loginPresenter)
                .environment(signupPresenter)
        }
    }
}
