import SwiftUI

struct PreviewData: DataInteractor {
    let urlMangasPreview = Bundle.main.url(forResource: "mangasPreview", withExtension: "json")!
    
    func getMangas() async throws -> Mangas {
        try loadPreviewData(url: urlMangasPreview)
    }
    
    func loadPreviewData<T>(url: URL) throws -> T where T: Decodable {
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
}

extension MangasListViewModel {
    static let preview = MangasListViewModel(interactor: PreviewData())
}

extension MangasListView {
    static var preview: some View {
        let vm = MangasListViewModel.preview
        
        return MangasListView()
            .task {
                _ = await vm.getMangas()
            }
            .environment(vm)
    }
}
