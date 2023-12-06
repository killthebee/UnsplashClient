class ExifInteractor: ExifInteractorProtocol {
    
    weak var presenter: ExifPresenterProtocol?
    
    required init(
        presenter: ExifPresenterProtocol
    ) {
        self.presenter = presenter
    }
    
    func getImage(photoId: String) {
        
        Task {
            guard
                let photoDataAndExif = await UnsplashApi.shared.getPhoto(
                    photoId
                )
            else
            {
                return
            }
            
            await presenter?.setImage(photoDataAndExif, photoId: photoId)
        }
    }
}
