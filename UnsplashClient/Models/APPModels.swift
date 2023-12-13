import Foundation

struct PhotoModel {
    let id: String
    let title: String?
    let image: Data
}

struct PhotoAndExifModel {
    let photoModel: PhotoModel
    let exifData: ExifMetadata
}

struct TopBannerModel {
    let url: String
    let id: String
    let photographerName: String
}
