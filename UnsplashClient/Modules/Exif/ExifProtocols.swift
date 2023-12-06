protocol ExifViewProtocol: AnyObject {
    var presenter: ExifPresenterProtocol? { get }
    func setImage(
        imageUrl: String,
        exif exifData: exifMetadata,
        photoId: String
    )
    func presentExifInfo(exif: exifMetadata)
    func presentShareVC()
    func reStartHeaderTask()
}

protocol ExifConfiguratorProtocol: AnyObject {
    func configure(with viewController: ExifViewController)
}

protocol ExifPresenterProtocol: AnyObject {
    var router: ExifRouterProtocol? { get }
    func getImage(photoId: String)
    func setImage(_ photoDataAndExif: photoData, photoId: String) async
    func infoButtonTouched(exif: exifMetadata?)
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
