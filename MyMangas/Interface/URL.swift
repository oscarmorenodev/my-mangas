import Foundation

let api = URL(string: "https://mymanga-acacademy-5607149ebe3d.herokuapp.com")!

extension URL {
    static func getMangasUrl(page: Int?) -> URL {
        let endpoint = "/list/mangas"
        let mangasUrl = api.appending(path: endpoint)
        var urlComponent = URLComponents(string: mangasUrl.absoluteString)!
        if let page {
            let queryItem = URLQueryItem(name: "page", value: String(page))
            urlComponent.queryItems = [queryItem]
        }
        return urlComponent.url!
    }
    
    static func searchMangasUrl(_ query: String) -> URL {
        let endpoint = "/search/mangasContains/\(query)"
        let searchUrl = api.appending(path: endpoint)
        var urlComponent = URLComponents(string: searchUrl.absoluteString)!
        let queryItem = URLQueryItem(name: "query", value: query)
        urlComponent.queryItems = [queryItem]
        return urlComponent.url!
    }
    
    static func getPage(_ page: Int = 1) -> URLQueryItem {
        URLQueryItem(name: "page", value: String(page))
    }
}
