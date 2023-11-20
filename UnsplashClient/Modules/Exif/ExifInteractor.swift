class ExifInteractor: ExifInteractorProtocol {
    
    weak var presenter: ExifPresenterProtocol?
    
    required init(
        presenter: ExifPresenterProtocol
    ) {
        self.presenter = presenter
    }
    
    func getImage(photoId: String) {
        
        Task {
            await UnsplashApi.shared.getPhoto(
                photoId
            ) { [weak self] imageData, exif in
                await MainActor.run { [weak self] in
                    self?.presenter?.setImage(
                        imageData: imageData,
                        exif: exif
                    )
                }
            }
        }
    }
}
