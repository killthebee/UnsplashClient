import Foundation

struct photoModel {
    let id: String
    let title: String?
    let image: Data
}

struct photoAndExifModel {
    let photoModel: photoModel
    let exifData: exifMetadata
}

struct TopBannerModel {
    let url: String
    let id: String
    let photographerName: String
}
