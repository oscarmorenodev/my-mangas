import SwiftUI

struct MangasListView: View {
    @Environment(MangasListViewModel.self) var vm
    @Namespace private var namespace
    let gridItem = GridItem(.adaptive(minimum: 150), alignment: .center)
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [gridItem]) {
                    ForEach(vm.mangas) { manga in
                        VStack {
                            MangasListCellView(manga: manga,
                                               namespace: namespace)
                        }
                    }
                }
            }
        }
        .task {
            _ = await vm.getMangas()
        }
    }
    
}

#Preview {
    MangasListView.preview
}
