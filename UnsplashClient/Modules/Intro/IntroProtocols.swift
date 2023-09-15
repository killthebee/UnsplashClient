protocol IntroViewProtocol: AnyObject {
}

protocol IntroConfiguratorProtocol: AnyObject {
    func configure(with viewController: IntroViewController)
}

protocol IntroPresenterProtocol: AnyObject {
    func loginIsTapped()
    func presentExploreScreen()
}

protocol IntroRouterProtocol: AnyObject {
    func showExploreScreen()
}

protocol IntroInteractorProtocol: AnyObject {
    func handleUserLogin()
    var keychainService: KeyChainManagerProtocol { get }
    func showExploreScreen()
}
