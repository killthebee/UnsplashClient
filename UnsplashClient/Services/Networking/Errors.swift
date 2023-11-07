import Foundation

enum networkingErrors: Error {
    case imageDownloadError
    case customError(Data)
}

struct ResponseWithErrors: Decodable {
    let errors: [String]
}
