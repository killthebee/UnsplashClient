protocol IntroViewProtocol: AnyObject {
    func setBackground()
    func addSubviews()
    func disableAutoresizing()
}

protocol IntroConfiguratorProtocol: AnyObject {
    func configure(with viewController: IntroViewController)
}

protocol IntroPresenterProtocol: AnyObject {
    func configureView()
}

protocol IntroRouterProtocol: AnyObject {
    func showExploreScreen()
}

protocol IntroInteractorProtocol: AnyObject {
    func isTokenAlive() -> Bool
}
