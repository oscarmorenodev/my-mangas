enum NetworkError: Error, CustomStringConvertible {
    case decode(Error)
    case encode(Error)
    case general(Error)
    case noHTTP
    case status(Int)
    
    public var description: String {
        switch self {
        case .decode(let error):
            "ERROR: Unable to decode JSON. More info: \(error)"
        case .encode(let error):
            "ERROR: Unable to encode JSON. More info: \(error)"
        case .general(let error):
            "ERROR: \(error.localizedDescription)"
        case .noHTTP:
            "ERROR: It's not HTTP response"
        case .status(let int):
            "ERROR: Status \(int)"
        }
    }
}
