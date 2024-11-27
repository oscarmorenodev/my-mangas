import SwiftUI

struct MangasCategoriesView: View {
    @Environment(MangasListViewModel.self) var vm
    @Binding var selectedCategory: String
    @State var showBest = false
    @Binding var loading: Bool
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button {
                        Task {
                            loading = true
                            await vm.toggleBestMangas()
                            loading = false
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
                            loading = true
                            await vm.getMangasByDemographic(demographic: newValue)
                            loading = false
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
                            loading = true
                            await vm.getMangasByGenre(genre: newValue)
                            loading = false
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
                            loading = true
                            await vm.getMangasByTheme(theme: newValue)
                            loading = false
                        }
                    }
                }
                Button {
                    vm.clearList()
                    selectedCategory = ""
                    Task {
                        loading = true
                        await vm.getMangas()
                        loading = false
                    }
                } label: {
                    Text("Clear")
                }
                .padding(10)
            }
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
