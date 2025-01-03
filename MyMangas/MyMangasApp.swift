import SwiftUI

@main
struct MyMangasApp: App {
    @State var mangasListViewModel = MangasListViewModel()
    @State var appStateManager = AppStateManager()
    @State var loginPresenter = LoginPresenter()
    
    var body: some Scene {
        WindowGroup {
            AppStateView()
                .environment(mangasListViewModel)
                .environment(appStateManager)
                .environment(loginPresenter)
        }
    }
}
