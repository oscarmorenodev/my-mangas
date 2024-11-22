import SwiftUI

struct MangasFiltersView: View {
    @Bindable var vm: MangasSearchViewModel
    @Binding var showSheet: Bool
    var body: some View {
        HStack {
            FilterButtonView(title: "Demographics") {
                Task {
                    await vm.getFilterContent(filter: .demographic)
                }
                showSheet.toggle()
            }
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
        .sheet(isPresented: $showSheet) {
            List(vm.filterValues, id: \.self) {
                Text($0)
            }
        }
    }
}

#Preview {
    MangasFiltersView(vm: .preview, showSheet: .constant(false))
}
