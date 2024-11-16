import SwiftUI

struct MangasSearchView: View {
    @Bindable var vm: MangasSearchViewModel
    @State var selected: MangaItemViewModel?
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(vm.searchResults) { manga in
                    MangaItemView(manga: manga)
                        .onTapGesture {
                            selected = manga
                        }
                }
            }
            .opacity(selected == nil ? 1.0 : 0.0)
            .overlay(
                Group {
                    if selected != nil {
                        MangaDetailView(selected: $selected)
                    }
                }
            )
        }
        .addCustomSearchBar(searchText: $vm.searchText, placeholder: "Search for a manga")
        .onChange(of: vm.searchText) {
            if vm.searchText.isEmpty {
                vm.searchResults.removeAll()
            } else {
                Task {
                    await vm.searchMangas()
                }
            }
        }
    }
}

#Preview {
    MangasSearchView(vm: .preview)
}
