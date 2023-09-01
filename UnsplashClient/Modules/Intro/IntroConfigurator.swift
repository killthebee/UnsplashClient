class IntroConfigurator: IntroConfiguratorProtocol {
    
    func configure(with viewController: IntroViewController) {
        let presenter = IntroPresenter(view: viewController)
        
        viewController.presenter = presenter
//        print(R.string.Intro.you())
    }
}
