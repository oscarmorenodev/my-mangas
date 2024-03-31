import SwiftUI

struct MangasListView: View {
    @Environment(MangasListViewModel.self) var vm
    let gridItem = GridItem(.adaptive(minimum: 150), alignment: .center)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [gridItem]) {
                    ForEach(vm.mangas) { manga in
                        VStack {
                            Text(manga.title ?? "")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    MangasListView.preview
}
