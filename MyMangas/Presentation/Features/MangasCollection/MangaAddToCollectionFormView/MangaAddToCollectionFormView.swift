import SwiftUI

struct MangaAddToCollectionFormView: View {
    @StateObject private var vm: MangaAddToCollectionFormViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(mangaId: Int, numberOfVolumes: Int) {
        _vm = StateObject(wrappedValue: MangaAddToCollectionFormViewModel(mangaId: mangaId, numberOfVolumes: numberOfVolumes))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Toggle("Complete Collection", isOn: $vm.completeCollection)
                }
                
                Section("Volumes") {
                    ForEach(1...vm.numberOfVolumes, id: \.self) { volume in
                        Toggle("Volume \(volume)", isOn: Binding(
                            get: { vm.volumesOwned.contains(volume) },
                            set: { isOn in
                                if isOn {
                                    vm.volumesOwned.append(volume)
                                } else {
                                    vm.volumesOwned.removeAll { $0 == volume }
                                    vm.completeCollection = false
                                }
                                
                                if vm.volumesOwned.count == vm.numberOfVolumes {
                                    vm.completeCollection = true
                                }
                            }
                        ))
                    }
                }
                
                Section("Current Volume") {
                    Picker("Volume", selection: $vm.readingVolume) {
                        Text("Not specified").tag(Optional<Int>.none)
                        ForEach(1...vm.numberOfVolumes, id: \.self) { volume in
                            Text("Volume \(volume)").tag(Optional(volume))
                        }
                    }
                }
                
                Section("Remove of collection") {
                    Button("Remove of collection", role: .destructive) {
                        Task {
                            await vm.removeOfCollection(id: vm.mangaId)
                            dismiss()
                        }
                    }
                }
                
                if let error = vm.error {
                    Section {
                        Text(error)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Add to Collection")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task {
                            await vm.addToCollection()
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    MangaAddToCollectionFormView(mangaId: 1, numberOfVolumes: 5)
}
