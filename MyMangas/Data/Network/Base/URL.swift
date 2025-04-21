import Foundation

let api = URL(string: "https://mymanga-acacademy-5607149ebe3d.herokuapp.com")!

// MARK: Mangas
extension URL {
    static func getListMangasUrl(page: Int) -> URL {
        getMangasUrl(endpoint: .listMangas, page: page)
    }
    
    static func getListBestMangasUrl(page: Int) -> URL {
        getMangasUrl(endpoint: .bestMangas, page: page)
    }
    
    static func getListMangasByDemographicUrl(demographic: String, page: Int) -> URL {
        getMangasUrl(endpoint: .listByDemographic, category: demographic, page: page)
    }
    
    static func getListMangasByGenreUrl(genre: String, page: Int) -> URL {
        getMangasUrl(endpoint: .listByGenre, category: genre, page: page)
    }
    
    static func getListMangasByThemeUrl(theme: String, page: Int) -> URL {
        getMangasUrl(endpoint: .listByTheme, category: theme, page: page)
    }
    
    static func getDemographicsUrl() -> URL {
        getCategoryUrl(endpoint: .demographics)
    }
    
    static func getGenresUrl() -> URL {
        getCategoryUrl(endpoint: .genres)
    }
    
    static func getThemesUrl() -> URL {
        getCategoryUrl(endpoint: .themes)
    }

    static func mangaCollectionUrl() -> URL {
        getMangaCollectionUrl(endpoint: .mangaCollection)
    }
    
    static func mangaCollectionByIdUrl(mangaId: Int) -> URL {
        getMangaCollectionUrl(endpoint: .mangaCollection, id: mangaId)
    }
    
    static func searchMangasUrl(_ query: String, page: Int) -> URL {
        let endpoint = "/search/mangasContains/\(query)"
        let searchUrl = api.appending(path: endpoint)
        var urlComponents = URLComponents(string: searchUrl.absoluteString)!
        let queryItem = URLQueryItem(name: "query", value: query)
        let pageQueryItem = URLQueryItem(name: "page", value: String(page))
        let perPageQueryItem = URLQueryItem(name: "per", value: "20")
        urlComponents.queryItems = [queryItem, pageQueryItem, perPageQueryItem]
        return urlComponents.url!
    }
    
    static func getPage(_ page: Int = 1) -> URLQueryItem {
        URLQueryItem(name: "page", value: String(page))
    }
}

// MARK: Users
extension URL {
    static func createUser() -> URL {
        api.appending(path: Endpoint.users.rawValue)
    }
    
    static func login() -> URL {
        api.appending(path: Endpoint.login.rawValue)
    }
    
    static func renewToken() -> URL {
        api.appending(path: Endpoint.renewToken.rawValue)
    }
}


// MARK: Private
private extension URL {
    static func getMangasUrl(endpoint: Endpoint, category: String? = nil, page: Int?) -> URL {
        let endpoint = endpoint.rawValue
        var mangasUrl = api.appending(path: endpoint)
        if let category {
            mangasUrl.append(component: category)
        }
        var urlComponents = URLComponents(string: mangasUrl.absoluteString)!
        if let page {
            let queryItem = URLQueryItem(name: "page", value: String(page))
            urlComponents.queryItems = [queryItem]
        }
        return urlComponents.url!
    }
    
    static func getCategoryUrl(endpoint: Endpoint) -> URL {
        api.appending(path: endpoint.rawValue)
    }
    
    static func getMangaCollectionUrl(endpoint: Endpoint, id: Int? = nil) -> URL {
        if let id {
            return api.appending(path: endpoint.rawValue + "/" + String(id))
        } else {
            return api.appending(path: endpoint.rawValue)
        }
    }
}
