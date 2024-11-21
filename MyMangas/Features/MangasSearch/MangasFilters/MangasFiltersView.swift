import SwiftUI

struct MangasFiltersView: View {
    @Bindable var vm: MangasSearchViewModel
    @Binding var showSheet: Bool
    var body: some View {
        HStack {
            FilterButtonView(title: "Demographics") {
                showSheet.toggle()
            }
            FilterButtonView(title: "Genres") {
                showSheet.toggle()
            }
            FilterButtonView(title: "Themes") {
                showSheet.toggle()
            }
            
        }
        .sheet(isPresented: $showSheet) {
            
        }
    }
}

#Preview {
    MangasFiltersView(vm: .preview, showSheet: .constant(false))
}
