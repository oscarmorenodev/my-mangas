import SwiftUI

struct SplashView: View {
    @Environment(MangasListViewModel.self) var vm
    @State var loading = false
    
    var body: some View {
        ZStack {
            ProgressView()
                .controlSize(.extraLarge)
                .tint(.cyan)
                .opacity(loading ? 1.0 : 0.0)
        }
        .ignoresSafeArea()
        .task {
            loading = true
            await vm.getMangas()
            loading = false
            vm.appState = .loaded
        }
    }
}

#Preview {
    SplashView()
        .environment(MangasListViewModel())
}
