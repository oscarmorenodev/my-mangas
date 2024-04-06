import SwiftUI

struct AppStateView: View {
    @Environment(MangasListViewModel.self) var vm
    
    var body: some View {
        VStack {
            switch vm.appState {
            case .home:
                MainView()
            case .splash:
                SplashView()
            }
        }
    }
}

#Preview {
    AppStateView()
        .environment(MangasListViewModel())
}
