class ExifConfigurator: ExifConfiguratorProtocol {
    private let assembly: AppAssembly
    
    init(assembly: AppAssembly) {
        self.assembly = assembly
    }
    
    func configure(with viewController: ExifViewController) {
        let presenter = ExifPresenter(view: viewController)
        let router = ExifRouter(assembly: assembly, view: viewController)
        let interactor = ExifInteractor(
            presenter: presenter,
            keychainService: assembly.keychainService
        )
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
