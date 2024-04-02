import SwiftUI

@main
struct MyMangasApp: App {
    @State var vm = MangasListViewModel()
    
    var body: some Scene {
        WindowGroup {
            AppStateView()
                .environment(vm)
        }
    }
}
