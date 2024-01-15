protocol ExifViewProtocol: AnyObject {
    var presenter: ExifPresenterProtocol? { get }
    func setImage(
        imageUrls: PhotoUrls,
        exif exifData: ExifMetadata,
        photoId: String
    )
    func presentExifInfo(exif: ExifMetadata)
    func presentShareVC()
    func reStartHeaderTask()
}

protocol ExifConfiguratorProtocol: AnyObject {
    func configure(with viewController: ExifViewController)
}

protocol ExifPresenterProtocol: AnyObject {
    var router: ExifRouterProtocol? { get }
    func getImage(photoId: String)
    func setImage(_ photoDataAndExif: PhotoData, photoId: String) async
    func infoButtonTouched(exif: ExifMetadata?)
    func dismissRequested()
    func presentShareVC()
}

protocol ExifInteractorProtocol: AnyObject {
    func getImage(photoId: String)
}

protocol ExifRouterProtocol: AnyObject {
    func dismissRequested()
    var customTransitioningDelegate: BSTransitioningDelegate { get }
}
