struct Author: Decodable, Hashable, Identifiable  {
    let role: String
    let lastName: String
    let firstName: String
    let id: String
}
