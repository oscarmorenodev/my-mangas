import Foundation

let api = URL(string: "https://mymanga-acacademy-5607149ebe3d.herokuapp.com")!

extension URL {
    static func getMangasUrl(page: Int?) -> URL {
        let endpoint = "/list/mangas"
        let mangasUrl = api.appending(path: endpoint)
        var urlComponents = URLComponents(string: mangasUrl.absoluteString)!
        if let page {
            let queryItem = URLQueryItem(name: "page", value: String(page))
            urlComponents.queryItems = [queryItem]
        }
        return urlComponents.url!
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
