class ExifRouter: ExifRouterProtocol {
    
    weak var view: Presentable?
    private let assembly: AppAssembly
    let customTransitioningDelegate = BSTransitioningDelegate()
    
    init(assembly: AppAssembly, view: Presentable) {
        self.assembly = assembly
        self.view = view
    }
    
    func dismissRequested() {
        view?.dismiss()
    }
}
