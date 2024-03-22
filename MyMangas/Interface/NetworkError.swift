enum NetworkError: Error, CustomStringConvertible {
    case general(Error)
    case status(Int)
    case decode(Error)
    case noHTTP
    
    public var description: String {
        switch self {
        case .general(let error):
            "ERROR: \(error.localizedDescription)"
        case .status(let int):
            "ERROR: Status \(int)"
        case .noHTTP:
            "ERROR: It's not HTTP response"
        case .decode(let error):
            "ERROR: Unable to decode JSON. More info: \(error)"
        }
    }
}
