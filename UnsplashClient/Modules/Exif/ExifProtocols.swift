protocol ExifViewProtocol: AnyObject {
    var presenter: ExifPresenterProtocol? { get }
    func setImage(imageData: photoModel, exif exifData: exifMetadata)
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
    func setImage(imageData: photoModel, exif: exifMetadata)
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
