import SwiftUI

struct PreviewData {
    let urlMangasPreview = Bundle.main.url(forResource: "mangasPreview", withExtension: "json")!
    
    func getListMangas(page: Int = 1) async throws -> Mangas {
        try loadPreviewData(url: urlMangasPreview)
    }
    
    func getBestMangas(page: Int = 1) async throws -> Mangas {
        try loadPreviewData(url: urlMangasPreview)
    }
    
    func getListMangasByDemographic(demographic: String, page: Int) async throws -> Mangas {
        try loadPreviewData(url: urlMangasPreview)
    }
    
    func getListMangasByGenre(genre: String, page: Int) async throws -> Mangas {
        try loadPreviewData(url: urlMangasPreview)
    }
    
    func getListMangasByTheme(theme: String, page: Int) async throws -> Mangas {
        try loadPreviewData(url: urlMangasPreview)
    }
    
    func searchMangas(_ query: String, page: Int = 1) async throws -> Mangas {
        let mangas: Mangas = try loadPreviewData(url: urlMangasPreview)
        let filteredMangas = mangas.items.filter { $0.title?.localizedCaseInsensitiveContains(query) ?? false }
        return Mangas(items: filteredMangas)
    }
    
    func getDemographics() async throws -> [String] {
        MangasSearchViewModel.filterValuesPreview
    }
    
    func getGenres() async throws -> [String] {
        MangasSearchViewModel.filterValuesPreview
    }
    
    func getThemes() async throws -> [String] {
        MangasSearchViewModel.filterValuesPreview
    }
    
    func loadPreviewData<T>(url: URL) throws -> T where T: Decodable {
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func createUser(user: User) async throws -> Bool {
        true
    }
    
    func login(email: String, password: String) async throws -> String {
        "FQ8tHe+2mZ7tZ/ZFs5LgJ58X5M15Vjav"
    }
    
    func renewToken() async throws -> String {
        "4Z+UtklF34pzrK9bdq5LOKRS1pcBhXwv"
    }
    
    func addOrUpdateMangaCollection(_ manga: UserMangaCollectionRequest) async throws {
      // No preview, only for testing
    }
    
    func getCollection() async throws -> [UserMangaCollectionResponse] {
        [UserMangaCollectionResponse.preview]
    }
    
    func getMangaFromCollection(id: Int) async throws -> Manga {
        Manga.preview
    }
    
    func deleteMangaFromCollection(id: Int) async throws {
        // No preview, only for testing
    }
}

extension Manga {
    static let preview: Manga = .init(demographics: [Demographic(id: "5E05BBF1-A72E-4231-9487-71CFE508F9F9",
                                                                 demographic: "Shounen")],
                                      titleEnglish: "Dragon Ball",
                                      endDate: "1995-05-23T00:00:00Z",
                                      genres: [Genre(id: "72C8E862-334F-4F00-B8EC-E1E4125BB7CD", genre: "Action"),
                                               Genre(id: "BE70E289-D414-46A9-8F15-928EAFBC5A32", genre: "Adventure"),
                                               Genre(id: "F974BCB6-B002-44A6-A224-90D1E50595A2", genre: "Comedy"),
                                               Genre(id: "2DEDC015-82DA-4EF4-B983-F0F58C8F689E", genre: "Sci-Fi")],
                                      authors: [Author(role: "Story & Art", lastName: "Toriyama", firstName: "Akira", id: "998C1B16-E3DB-47D1-8157-8389B5345D03")],
                                      id: 42,
                                      url: "https://myanimelist.net/manga/42/Dragon_Ball",
                                      startDate: "1984-11-20T00:00:00Z",
                                      themes: [Theme(id: "ADC7CBC8-36B9-4E52-924A-4272B7B2CB2C", theme: "Martial Arts"),
                                               Theme(id: "472FB2AE-13C0-4EEE-9A45-A7B75AC5DC29", theme: "Super Power")],
                                      background: "Dragon Ball has become one of the most successful manga series of all time, with over 230 million copies sold worldwide with 157 million in Japan alone, making it the third all-time best selling manga as of 2015, and the #1 manga series not currently publishing. The series is often credited for the \"Golden Age of Jump\" where the magazine's circulation was at its highest. VIZ Media serialized the manga in English from March 1998 to March 2005 in monthly comic book anthology format; and was later collected into traditional tankobon format volumes from March 12, 2003 to June 6, 2006. To closer follow the English anime localization, the series is split; in which volumes 17-42 are titled Dragon Ball Z and renumbered as volumes 1-26. Other releases by VIZ include the large format VIZ Big Edition, kanzenban cover based 3-in-1 Edition, and a Full Color Edition of chapters 195-245. Other English publishers include Madman Entertainment in Australia/New Zealand, and the now defunct Gollancz Manga (distribution rights transferred to VIZ) in the United Kingdom. The series is also published in Spanish by Planet DeAgostini Cómics and in French by Glénat Editions.",
                                      chapters: 520,
                                      title: "Dragon Ball",
                                      score: 8.41,
                                      mainPicture: "https://cdn.myanimelist.net/images/manga/1/267793l.jpg",
                                      status: "finished",
                                      titleJapanese: "ドラゴンボール",
                                      sypnosis: "Bulma, a headstrong 16-year-old girl, is on a quest to find the mythical Dragon Balls—seven scattered magic orbs that grant the finder a single wish. She has but one desire in mind: a perfect boyfriend. On her journey, Bulma stumbles upon Gokuu Son, a powerful orphan who has only ever known one human besides her. Gokuu possesses one of the Dragon Balls, it being a memento from his late grandfather. In exchange for it, Bulma invites Gokuu to be a companion in her travels.\n\nBy Bulma's side, Gokuu discovers a world completely alien to him. Powerful enemies embark on their own pursuits of the Dragon Balls, pushing Gokuu beyond his limits in order to protect Bulma and their growing circle of allies. However, Gokuu has secrets unbeknownst to even himself; the incredible strength within him stems from a mysterious source, one that threatens the many people he grows to hold dear.\n\nAs his prowess in martial arts flourishes, Gokuu attracts stronger opponents whose villainous plans could collapse beneath his might. He undertakes the endless venture of combat training to defend his loved ones and the fate of the planet itself.\n\n[Written by MAL Rewrite]",
                                      volumes: 42)
}

extension MangaItemViewModel {
    static let preview: MangaItemViewModel = .init(
        manga: Manga.preview
    )
}

extension MainView {
    static var preview: some View {
        let vm = MangasListViewModel.preview
        return MainView()
            .task {
                await vm.getMangas()
            }
            .environment(vm)
    }
}

extension MangasListViewModel {
    static let preview = MangasListViewModel()
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

extension MangasCategoriesView {
    static var preview: some View {
        let vm = MangasListViewModel.preview
        
        return MangasListView()
            .task {
                _ = await vm.getMangas()
            }
            .environment(vm)
    }
}

extension MangasSearchViewModel {
    static let preview = MangasSearchViewModel()
}

extension MangasSearchView {
    static var preview: some View {
        return MangasSearchView(vm: .preview)
    }
}

extension MangasSearchViewModel {
    static let filterValuesPreview = ["Filter value 1", "Filter value 2", "Filter value 3"]
}

extension AppStateManager {
    static let preview = AppStateManager()
}

extension LoginViewModel {
    static var preview = LoginViewModel()
}

extension SignupViewModel {
    static var preview: SignupViewModel {
        let mockUseCase = CreateUserUseCase(repository: MockUserRepository())
        return SignupViewModel(createUserUseCase: mockUseCase)
    }
}

extension UserMangaCollectionRequest {
    static let preview: UserMangaCollectionRequest = .init(
        manga: MangaItemViewModel.preview.id,
        completeCollection: true,
        volumesOwned: [40, 41, 42],
        readingVolume: 42
    )
}

extension UserMangaCollectionResponse {
    static let preview = UserMangaCollectionResponse(manga: Manga.preview,
                                                     completeCollection: true, volumesOwned: [1,2,3])
        
}

extension MangasCollectionViewModel {
    static let preview = MangasCollectionViewModel()
}

extension MangasCollectionView {
    static var preview: some View {
        let vm = MangasCollectionViewModel.preview
        
        return MangasCollectionView()
            .task {
                _ = await vm.loadCollection()
            }
            .environment(vm)
    }
}

extension MangaDetailViewModel {
    static let preview = MangaDetailViewModel()
}

extension MangaDetailView {
    static var preview: some View {
        let vm = MangasListViewModel.preview
        
        return MangaDetailView(selected: .constant(MangaItemViewModel.preview as? T))
            .environment(vm)
    }
}

extension MangaItemView {
    static let preview = MangaItemView(manga: MangaItemViewModel.preview)
}

private class MockUserRepository: UserRepositoryProtocol {
    func createUser(user: User) async throws {}
    
    func login(email: String, password: String) async throws -> String {
        "token_simulado_123456"
    }
    
    func renewToken() async throws -> String {
        "token_renovado_123456"
    }
}
