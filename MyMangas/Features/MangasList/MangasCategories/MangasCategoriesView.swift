import SwiftUI

struct MangasCategoriesView: View {
    @Environment(MangasListViewModel.self) var vm
    @Binding var selectedCategory: String
    @State var showBest: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    Task {
                       await vm.toggleBestMangas()
                    }
                    showBest.toggle()
                } label: {
                    Text(showBest ? "No order" : "Sort by best")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .buttonStyle(.borderedProminent)
                Picker("Demographic", selection: $selectedCategory) {
                    ForEach(vm.demographics, id: \.self) {
                        Text($0)
                    }
                }
                .buttonStyle(.borderedProminent)
                .pickerStyle(.navigationLink)
                .onChange(of: selectedCategory) { oldValue, newValue in
                    vm.clearList()
                    Task {
                        await vm.getMangasByDemographic(demographic: newValue)
                    }
                }
            }
            HStack {
                Picker("Genres", selection: $selectedCategory) {
                    ForEach(vm.genres, id: \.self) {
                        Text($0)
                    }
                }
                .buttonStyle(.borderedProminent)
                .pickerStyle(.navigationLink)
                .onChange(of: selectedCategory) { oldValue, newValue in
                    vm.clearList()
                    Task {
                        await vm.getMangasByGenre(genre: newValue)
                    }
                }
                Picker("Themes", selection: $selectedCategory) {
                    ForEach(vm.themes, id: \.self) {
                        Text($0)
                    }
                }
                .buttonStyle(.borderedProminent)
                .pickerStyle(.navigationLink)
                .onChange(of: selectedCategory) { oldValue, newValue in
                    vm.clearList()
                    Task {
                        await vm.getMangasByTheme(theme: newValue)
                    }
                }
            }
            Button {
                vm.clearList()
                selectedCategory = ""
                Task {
                    await vm.getMangas()
                }
            } label: {
                Text("Clear")
            }
            .padding(10)
        }
        .padding(5)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.blue, lineWidth: 2)
        )
        .padding(5)
        
    }
}

#Preview {
    MangasCategoriesView.preview
}
