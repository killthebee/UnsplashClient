class ExplorePresenter: ExplorePresenterProtocol {
    weak var view: ExploreViewProtocol!
    
    required init(view: ExploreViewProtocol) {
        self.view = view
    }
    
    func configureView() {
        view.setUpContainer()
    }
}
