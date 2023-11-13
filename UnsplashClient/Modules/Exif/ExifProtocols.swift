protocol ExifViewProtocol: AnyObject {
    func setImage(imageData: photoModel, exif exifData: exifMetadata)
    func presentExifInfo(exif: exifMetadata)
}

protocol ExifConfiguratorProtocol: AnyObject {
    func configure(with viewController: ExifViewController)
}

protocol ExifPresenterProtocol: AnyObject {
    func getImage(photoId: String)
    func setImage(imageData: photoModel, exif: exifMetadata)
    func infoButtonTouched(exif: exifMetadata?)
    func dismissRequested()
}

protocol ExifInteractorProtocol: AnyObject {
    func getImage(photoId: String)
}

protocol ExifRouterProtocol: AnyObject {
    func dismissRequested()
}
