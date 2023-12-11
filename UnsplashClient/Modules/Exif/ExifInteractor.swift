class ExifInteractor: ExifInteractorProtocol {
    
    weak var presenter: ExifPresenterProtocol?
    let apiService: UnsplashApiProtocol?
    
    required init(
        presenter: ExifPresenterProtocol,
        apiService: UnsplashApiProtocol = AppAssembly.currentApiService
    ) {
        self.presenter = presenter
        self.apiService = apiService
    }
    
    func getImage(photoId: String) {
        
        Task {
            guard
                let photoDataAndExif = await self.apiService?.getPhoto(
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
