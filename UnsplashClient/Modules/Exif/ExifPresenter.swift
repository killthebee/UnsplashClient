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
    
    @MainActor
    func setImage(_ photoDataAndExif: photoData, photoId: String) async {
        view?.setImage(
            imageUrl: photoDataAndExif.urls.raw,
            exif: photoDataAndExif.exif,
            photoId: photoId
        )
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
