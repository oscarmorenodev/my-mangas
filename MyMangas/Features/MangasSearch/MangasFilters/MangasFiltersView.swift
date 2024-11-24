import SwiftUI

struct MangasFiltersView: View {
    @Environment(MangasListViewModel.self) var vm
    @Binding var showSheet: Bool
    var body: some View {
        HStack {
            VStack {
                FilterButtonView(title: "Best mangas") {
                    Task {
                        await vm.toggleBestMangas()
                    }
                }
                FilterButtonView(title: "Demographics") {
                    Task {
                        await vm.getFilterContent(filter: .demographic)
                    }
                    showSheet.toggle()
                }
            }
            VStack {
                FilterButtonView(title: "Genres") {
                    Task {
                        await vm.getFilterContent(filter: .genre)
                    }
                    showSheet.toggle()
                }
                FilterButtonView(title: "Themes") {
                    Task {
                        await vm.getFilterContent(filter: .theme)
                    }
                    showSheet.toggle()
                }
            }
        }
        .sheet(isPresented: $showSheet) {
            List(vm.filterValues, id: \.self) {
                Text($0)
            }
        }
    }
}

#Preview {
    MangasFiltersView(showSheet: .constant(false))
}
