class IntroInteractor: IntroInteractorProtocol {
    
    weak var presenter: IntroPresenterProtocol?
    let keychainService: KeyChainManagerProtocol
        
        required init(
            presenter: IntroPresenterProtocol,
            keychainService: KeyChainManagerProtocol
        ) {
            self.presenter = presenter
            self.keychainService = keychainService
        }
    
    func handleUserLogin() {
        LoginSession.standard.performLogin(interactor: self)
    }
    
    func showExploreScreen() {
        presenter?.presentExploreScreen()
    }
}
