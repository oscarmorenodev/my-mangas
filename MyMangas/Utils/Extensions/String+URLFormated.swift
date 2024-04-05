import Foundation

extension String {
    func formatedToUrl() -> URL {
        URL(string: String(self.dropFirst().dropLast()))!
    }
}
