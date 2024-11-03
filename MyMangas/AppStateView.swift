import SwiftUI

struct AppStateView: View {
    @Environment(MangasListViewModel.self) var vm
    
    var body: some View {
        VStack {
            switch vm.appState {
            case .loaded:
                MainView()
            case .loading:
                SplashView()
            }
        }
    }
}

#Preview {
    AppStateView()
        .environment(MangasListViewModel())
}
