class IntroConfigurator: IntroConfiguratorProtocol {
    
    func configure(with viewController: IntroViewController) {
        let presenter = IntroPresenter(view: viewController)
        let router = IntroRouter(viewController: viewController)
        let interactor = IntroInteractor(presenter: presenter)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
//        print(R.string.Intro.you())
    }
}
