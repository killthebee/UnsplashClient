protocol IntroViewProtocol: AnyObject {
    var presenter: IntroPresenterProtocol? { get }
}

protocol IntroConfiguratorProtocol: AnyObject {
    func configure(with viewController: IntroViewController)
}

protocol IntroPresenterProtocol: AnyObject {
    var router: IntroRouterProtocol? { get }
    func loginIsTapped()
    func presentExploreScreen()
}

protocol IntroRouterProtocol: AnyObject {
    func showExploreScreen()
    var customTransitioningDelegate: BSTransitioningDelegate { get }
}

protocol IntroInteractorProtocol: AnyObject {
    func handleUserLogin()
    var keychainService: KeyChainManagerProtocol { get }
    func showExploreScreen()
}
