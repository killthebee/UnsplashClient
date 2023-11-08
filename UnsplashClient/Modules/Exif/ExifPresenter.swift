class ExifPresenter: ExifPresenterProtocol {
    weak var view: ExifViewProtocol?
    var interactor: ExifInteractorProtocol?
    var router: ExifRouterProtocol?
    
    required init(view: ExifViewProtocol) {
        self.view = view
    }
    
    func getImage(photoId: String) {
        print("going dark ----")
        interactor?.getImage(photoId: photoId)
    }
    
    func setImage(imageData: photoModel, exif: exifMetadata) {
        view?.setImage(imageData: imageData, exif: exif)
    }
}
