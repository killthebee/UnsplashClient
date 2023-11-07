class ExploreRouter: ExploreRouterProtocol {
    
    weak var view: Presentable?
    private let assembly: AppAssembly
    
    init(assembly: AppAssembly, view: Presentable) {
        self.assembly = assembly
        self.view = view
    }
    
    func presentExifDataScreen(photoId: String) {
        guard
            let exifVC = assembly.makeExifScreen(photoId: photoId) as? ExifViewController
        else {
            return
        }
        
        exifVC.modalPresentationStyle = .fullScreen
        view?.present(exifVC)
    }
}
