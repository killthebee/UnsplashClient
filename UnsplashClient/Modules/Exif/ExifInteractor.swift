class ExifInteractor: ExifInteractorProtocol {
    
    weak var presenter: ExifPresenterProtocol?
    let keychainService: KeyChainManagerProtocol
    
    required init(
        presenter: ExifPresenterProtocol,
        keychainService: KeyChainManagerProtocol
    ) {
        self.presenter = presenter
        self.keychainService = keychainService
    }
}
