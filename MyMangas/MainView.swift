import SwiftUI

struct MainView: View {
    @Environment(MangasListViewModel.self) var vm
    
    var body: some View {
        MangasListView()
    }
}

#Preview {
    MainView.preview
}
