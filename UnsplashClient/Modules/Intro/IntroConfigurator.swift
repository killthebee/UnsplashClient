class IntroConfigurator: IntroConfiguratorProtocol {
    
    private let assembly: AppAssembly
    
    init(assembly: AppAssembly) {
        self.assembly = assembly
    }
    
    func configure(with viewController: IntroViewController) {
        let presenter = IntroPresenter(view: viewController)
        let router = IntroRouter(assembly: assembly, view: viewController)
        let interactor = IntroInteractor(
            presenter: presenter,
            keychainService: assembly.keychainService
        )
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
