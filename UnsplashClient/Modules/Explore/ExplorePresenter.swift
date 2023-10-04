class ExplorePresenter: ExplorePresenterProtocol {
    weak var view: ExploreViewProtocol?
    var interactor: ExploreInteractorProtocol?
    var router: ExploreRouterProtocol?
    
    required init(view: ExploreViewProtocol) {
        self.view = view
    }
    
}
