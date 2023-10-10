struct TokenExchangeSuccessData: Decodable {
    let access_token: String
    let refresh_token: String
    let token_type: String
    let scope: String
    let created_at: Int
}

struct UnsplashUser: Decodable {
    let name: String
}

struct PhotoLinks: Decodable {
    let download: String
}

struct PhotoUrls: Decodable {
    let raw: String
}

struct UnsplashPhoto: Decodable {
    let id: String
    let links: PhotoLinks
    let urls: PhotoUrls
    let user: UnsplashUser
}

struct UnsplashColletion: Decodable {
    let id: Int
    let title: String
    let cover_photo: UnsplashPhoto
}

struct exifMetadata: Decodable {
    let make: String
    let model: String
    let focal_length: String
    let aperture: String
    let exposure_time: String
}

struct photoData: Decodable {
    let exif: exifMetadata
}
