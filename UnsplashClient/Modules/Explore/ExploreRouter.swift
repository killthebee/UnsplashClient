class ExploreRouter: ExploreRouterProtocol {
    
    weak var view: Presentable?
    private let assembly: AppAssembly
    
    init(assembly: AppAssembly, view: Presentable) {
        self.assembly = assembly
        self.view = view
    }
    
    func showExifDataScreen() {
//        guard let view = view as? ExploreViewProtocol else { return }
//        view.interactor?.invalidateHeaderTask()
        
    }
}
