class IntroInteractor: IntroInteractorProtocol {
    
    weak var presenter: IntroPresenterProtocol!
    
    let KeyChainService: KeyChainManagerProtocol = KeyChainManager()
    
    required init(presenter: IntroPresenterProtocol) {
            self.presenter = presenter
        }
    
    func isTokenAlive() -> Bool {
        guard let accessToken = KeyChainService.readToken(
            service: "access-token", account: "unsplash") else {
            return false
        }
        // TODO: 
        // pass the accessToken into the next screen and present it! Not shure how to
        // show the next screen yet tho
        return true
    }
}
