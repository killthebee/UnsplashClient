protocol IntroViewProtocol: AnyObject {
    func setBackground()
    func addSubviews()
    func disableAutoresizing()
    func addTargetsToButtons()
}

protocol IntroConfiguratorProtocol: AnyObject {
    func configure(with viewController: IntroViewController)
}

protocol IntroPresenterProtocol: AnyObject {
    func configureView()
    func loginIsTapped()
}

protocol IntroRouterProtocol: AnyObject {
    func showExploreScreen(_ accessToken: String?)
}

protocol IntroInteractorProtocol: AnyObject {
    func isTokenAlive() -> String?
    func handleUserLogin()
}
