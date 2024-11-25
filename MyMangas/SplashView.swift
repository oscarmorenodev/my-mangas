import SwiftUI

struct SplashView: View {
    @Environment(MangasListViewModel.self) var listVM
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
