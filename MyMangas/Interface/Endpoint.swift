enum Endpoint: String {
    case bestMangas = "/list/bestMangas"
    case demographics = "/list/demographics"
    case genres = "/list/genres"
    case listByDemographic = "/list/mangaByDemographic"
    case listByGenre = "/list/mangaByGenre"
    case listByTheme = "/list/mangaByTheme"
    case themes = "/list/themes"
    case listMangas = "/list/mangas"
    case users = "/users"
    case login = "/users/login"
    case renewToken = "/users/renew"
}
