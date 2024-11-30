import SwiftUI

struct SplashView: View {
    @Environment(MangasListViewModel.self) var listVM
    @State var loading = false
    
    var body: some View {
        ZStack {
            LoadingView(loading: $loading)
        }
        .ignoresSafeArea()
        .task {
            loading = true
            await listVM.fetchData()
            loading = false
            listVM.appState = .loaded
        }
    }
}

#Preview {
    SplashView()
        .environment(MangasListViewModel())
}
