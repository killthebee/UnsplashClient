class ExifPresenter: ExifPresenterProtocol {
    weak var view: ExifViewProtocol?
    var interactor: ExifInteractorProtocol?
    var router: ExifRouterProtocol?
    
    required init(view: ExifViewProtocol) {
        self.view = view
    }
}
