import SwiftUI

struct SplashView: View {
    @Environment(MangasListViewModel.self) var mangasListViewModel
    @Environment(AppStateManager.self) var appStateManager
    @State var loading = false
    
    var body: some View {
        ZStack {
            LoadingView(loading: $loading)
        }
        .ignoresSafeArea()
        .task {
            loading = true
            
            await mangasListViewModel.fetchData()
            
            await appStateManager.checkTokenStatus()
            
            loading = false
        }
    }
}

#Preview {
    SplashView()
        .environment(MangasListViewModel())
}
