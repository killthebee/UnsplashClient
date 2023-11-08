class ExifInteractor: ExifInteractorProtocol {
    
    weak var presenter: ExifPresenterProtocol?
    let keychainService: KeyChainManagerProtocol?
    
    required init(
        presenter: ExifPresenterProtocol,
        keychainService: KeyChainManagerProtocol
    ) {
        self.presenter = presenter
        self.keychainService = keychainService
    }
    
    func getImage(photoId: String) {
        guard let accessToken = self.keychainService?.readToken(
            service: "access-token",
            account: "unsplash"
        ) else { return }
        
        Task {
            await UnsplashApi.shared.getPhoto(
            accessToken,
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
