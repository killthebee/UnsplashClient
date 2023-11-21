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
    let thumb: String
}

struct UnsplashPhoto: Decodable {
    let id: String
    let links: PhotoLinks
    let urls: PhotoUrls
    let user: UnsplashUser
}

struct UnsplashColletion: Decodable {
    let id: String
    let title: String
    let cover_photo: UnsplashPhoto
}

struct exifMetadata: Codable {
    let make: String?
    let model: String?
    let name: String?
    let focal_length: String?
    let aperture: String?
    let exposure_time: String?
    var iso: Int? = nil
}
//"exif":{"make":"SONY","model":"ILCE-7M4","name":"SONY, ILCE-7M4","exposure_time":"1/500","aperture":"1.8","focal_length":"35.0","iso":640}
//"exif":{"make":null,"model":null,"name":null,"exposure_time":null,"aperture":null,"focal_length":null,"iso":null}

struct photoData: Decodable {
    let exif: exifMetadata
    let urls: PhotoUrls
}
