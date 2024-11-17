import Foundation

extension String {
    func formatedToUrl() -> URL {
        if self.isEmpty {
            return URL(string: "https://fakeurl.com")!
        } else {
            return URL(string: String(self.dropFirst().dropLast()))!
        }
    }
}
