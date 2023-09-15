class ExploreConfigurator: ExploreConfiguratorProtocol {
    
    private let assembly: AppAssembly
    
    init(assembly: AppAssembly) {
        self.assembly = assembly
    }
    
    func configure(with viewController: ExploreViewController) {
        let presenter = ExplorePresenter(view: viewController)
        
        viewController.presenter = presenter
        print("tuc")
        print(assembly.keychainService.readToken(service: "access-token", account: "unsplash"))
    }
}
