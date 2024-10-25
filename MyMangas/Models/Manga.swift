import Foundation

struct Mangas: Decodable {
    let items: [Manga]
}

struct Manga: Decodable {
    let demographics: [Demographic]?
    let titleEnglish: String?
    let endDate: String?
    let genres: [Genre]?
    let authors: [Author]?
    let id: Int
    let url: String?
    let startDate: String?
    let themes: [Theme]?
    let background: String?
    let chapters: Int?
    let title: String?
    let score: Double?
    let mainPicture: String?
    let status: String?
    let titleJapanese: String?
    let sypnosis: String?
    let volumes: Int?
}
