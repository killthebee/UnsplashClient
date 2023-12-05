import Foundation

class ExplorePresenter: ExplorePresenterProtocol {
    weak var view: ExploreViewProtocol?
    var interactor: ExploreInteractorProtocol?
    var router: ExploreRouterProtocol?
    
    required init(view: ExploreViewProtocol) {
        self.view = view
    }
    
    func startHeaderImageTask() {
        interactor?.startHeaderImageTask()
    }
    
    @MainActor
    func setNewHeaderImage(imageData: Data, _ photographerName: String) async {
        view?.setNewHeaderImage(imageData: imageData, photographerName)
    }
    
    func getCollections() {
        interactor?.getCollections()
    }
    
    @MainActor
    func setColletions(with collectionsData: [UnsplashColletion]) async {
        view?.setCollections(with: collectionsData)
    }
    
    func getNewImages(page pageNum: Int) {
        interactor?.getNewImages(page: pageNum)
    }
    
    func addNewImages(photos newImages: [photoModel]) {
        view?.addNewImages(photos: newImages)
    }
    
    func setNewImages(photos newImages: [photoModel]) {
        view?.setNewImages(photos: newImages)
    }
    
    func presentExifScreen(photoId: String) {
        interactor?.invalidateHeaderTask()
        router?.presentExifDataScreen(photoId: photoId)
    }
    
    func invalidateHeaderTask() {
        interactor?.invalidateHeaderTask()
    }
}
