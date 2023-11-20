class ExploreRouter: ExploreRouterProtocol {
    
    weak var view: Presentable?
    private let assembly: AppAssembly
    let customTransitioningDelegate = BSTransitioningDelegate()
    
    init(assembly: AppAssembly, view: Presentable) {
        self.assembly = assembly
        self.view = view
    }
    
    func presentExifDataScreen(photoId: String) {
        guard
            let exifVC = assembly.makeExifScreen(photoId: photoId) as? ExifViewController,
            let exploreVCDelegate = view as? ExploreViewProtocol
        else {
            return
        }
        
        exifVC.exploreVCDelegate = exploreVCDelegate
        exifVC.modalPresentationStyle = .fullScreen
        view?.present(exifVC)
    }
}
