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
}
