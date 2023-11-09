import Foundation

enum networkingErrors: Error {
    case imageDownloadError
    case customError(Data)
}

struct ResponseWithErrors: Decodable {
    let errors: [String]
}

enum ErrorSource {
    case codeExchange
    case headerImage
    case collections
    case newImages
    case getPhoto
}
