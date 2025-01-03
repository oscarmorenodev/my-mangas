import SwiftUI

struct SplashView: View {
    @Environment(MangasListViewModel.self) var mangasListViewModel
    @Environment(AppStateManager.self) var appStateManager
    @State var loading = false
    @State var logged = false
    
    var body: some View {
        ZStack {
            LoadingView(loading: $loading)
        }
        .ignoresSafeArea()
        .task {
            loading = true
            await mangasListViewModel.fetchData()
            loading = false
            appStateManager.state = logged ? .logged : .nonLogged
        }
    }
}

#Preview {
    SplashView()
        .environment(MangasListViewModel())
}
