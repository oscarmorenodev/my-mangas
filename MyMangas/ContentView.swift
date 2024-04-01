import SwiftUI

struct ContentView: View {
    @Environment(MangasListViewModel.self) var vm
    
    var body: some View {
        MangasListView()
    }
}

#Preview {
    ContentView.preview
}
