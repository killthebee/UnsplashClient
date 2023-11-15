class ExifPresenter: ExifPresenterProtocol {
    weak var view: ExifViewProtocol?
    var interactor: ExifInteractorProtocol?
    var router: ExifRouterProtocol?
    
    required init(view: ExifViewProtocol) {
        self.view = view
    }
    
    func getImage(photoId: String) {
        interactor?.getImage(photoId: photoId)
    }
    
    func setImage(imageData: photoModel, exif: exifMetadata) {
        view?.setImage(imageData: imageData, exif: exif)
    }
    
    func infoButtonTouched(exif: exifMetadata?) {
        guard let exif = exif else { return }
        view?.presentExifInfo(exif: exif)
    }
    
    func dismissRequested() {
        view?.reStartHeaderTask()
        router?.dismissRequested()
    }
    
    func presentShareVC() {
        view?.presentShareVC()
    }
}
