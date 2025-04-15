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

enum TokenError: Error, CustomStringConvertible {
    case tokenNotFound
    case tokenExpired
    case renewalFailed
    case invalidToken
    case saveFailed
    case retrievalFailed
    case deletionFailed
    
    public var description: String {
        switch self {
        case .tokenNotFound:
            "ERROR: Token not found in keychain"
        case .tokenExpired:
            "ERROR: Token has expired"
        case .renewalFailed:
            "ERROR: Failed to renew token"
        case .invalidToken:
            "ERROR: Invalid token format"
        case .saveFailed:
            "ERROR: Failed to save token in keychain"
        case .retrievalFailed:
            "ERROR: Failed to retrieve token from keychain"
        case .deletionFailed:
            "ERROR: Failed to delete token from keychain"
        }
    }
}

enum CollectionError: Error, CustomStringConvertible {
    case mangaNotFound
    
    public var description: String {
        "ERROR: Manga not found"
    }
}
