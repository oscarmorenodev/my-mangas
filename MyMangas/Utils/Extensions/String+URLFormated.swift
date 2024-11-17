import Foundation

extension String {
    func formatedToUrl() -> URL {
        if self.isEmpty {
            return URL(string: "")!
        } else {
            return URL(string: String(self.dropFirst().dropLast()))!
        }
    }
}
