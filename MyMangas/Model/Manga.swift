import Foundation

// MARK: - Manga
struct Manga {
    let demographics: [Demographic]
    let titleEnglish: String
    let endDate: Date
    let genres: [Genre]
    let authors: [Author]
    let id: Int
    let url: String
    let startDate: Date
    let themes: [Theme]
    let background: String
    let chapters: Int
    let title: String
    let score: Double
    let mainPicture: String
    let status: String
    let titleJapanese: String
    let sypnosis: String
    let volumes: Int
}

// MARK: - Author
struct Author {
    let role: String
    let lastName: String
    let firstName: String
    let id: String
}

// MARK: - Demographic
struct Demographic {
    let id: String
    let demographic: String
}

// MARK: - Genre
struct Genre {
    let genre: String
    let id: String
}

// MARK: - Theme
struct Theme {
    let theme: String
    let id: String
}
