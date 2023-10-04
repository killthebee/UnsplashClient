class IntroRouter:  IntroRouterProtocol {
    
    weak var view: Presentable?
    private let assembly: AppAssembly
    
    init(assembly: AppAssembly, view: Presentable) {
        self.assembly = assembly
        self.view = view
    }
    
    func showExploreScreen() {
        guard let exploreVC = assembly.makeExploreScreen() as? ExploreViewController
        else { return }
        exploreVC.modalPresentationStyle = .fullScreen
//        ExplorePresenter.modalTransitionStyle = .
        view?.present(exploreVC)
    }
}
