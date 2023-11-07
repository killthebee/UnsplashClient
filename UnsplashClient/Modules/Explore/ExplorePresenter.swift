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
    
    func setNewHeaderImage(imageData: Data, _ photographerName: String) {
        view?.setNewHeaderImage(imageData: imageData, photographerName)
    }
    
    func getCollections() {
        interactor?.getCollections()
    }
    
    //@MainActor // hmmmmm its not working
    func setColletions(with collectionsData: [UnsplashColletion]) {
        view?.setCollections(with: [collectionsData])
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
}
