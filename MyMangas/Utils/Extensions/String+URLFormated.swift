import Foundation

extension String {
    func formatedToUrl() -> URL {
        if self.isEmpty {
            return URL(string: "https://fakeurl.com")!
        } else {
            var urlString = self
            if urlString.hasPrefix("\"") && urlString.hasSuffix("\"") {
                urlString = String(urlString.dropFirst().dropLast())
            }
            return URL(string: urlString) ?? URL(string: "https://fakeurl.com")!
        }
    }
}
