protocol ExploreViewProtocol: AnyObject {
    func setUpContainer()
}

protocol ExploreConfiguratorProtocol: AnyObject {
    func configure(with viewController: ExploreViewController)
}

protocol ExplorePresenterProtocol: AnyObject {
    func configureView()
}


