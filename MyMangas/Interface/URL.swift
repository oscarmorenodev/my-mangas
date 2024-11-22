import Foundation

let api = URL(string: "https://mymanga-acacademy-5607149ebe3d.herokuapp.com")!

extension URL {
    static func getListMangasUrl(page: Int) -> URL {
        getMangasUrl(endpoint: .listMangas, page: page)
    }
    
    static func getBestMangasUrl(page: Int) -> URL {
        getMangasUrl(endpoint: .bestMangas, page: page)
    }
    
    static func getDemographicsUrl() -> URL {
        getFilterUrl(endpoint: .demographics)
    }
    
    static func getGenresUrl() -> URL {
        getFilterUrl(endpoint: .genres)
    }
    
    static func getThemesUrl() -> URL {
        getFilterUrl(endpoint: .themes)
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

private extension URL {
    static func getMangasUrl(endpoint: Endpoint, page: Int?) -> URL {
        let endpoint = endpoint.rawValue
        let mangasUrl = api.appending(path: endpoint)
        var urlComponents = URLComponents(string: mangasUrl.absoluteString)!
        if let page {
            let queryItem = URLQueryItem(name: "page", value: String(page))
            urlComponents.queryItems = [queryItem]
        }
        return urlComponents.url!
    }
    
    static func getFilterUrl(endpoint: Endpoint) -> URL {
        api.appending(path: endpoint.rawValue)
    }
}
