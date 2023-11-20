class ExploreConfigurator: ExploreConfiguratorProtocol {
    
    private let assembly: AppAssembly
    
    init(assembly: AppAssembly) {
        self.assembly = assembly
    }
    
    func configure(with viewController: ExploreViewController) {
        let presenter = ExplorePresenter(view: viewController)
        let router = ExploreRouter(assembly: assembly, view: viewController)
        let interactor = ExploreInteractor(
            presenter: presenter
        )
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
