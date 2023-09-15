import UIKit

class IntroPresenter: IntroPresenterProtocol {
    weak var view: IntroViewProtocol?
    var interactor: IntroInteractorProtocol?
    var router: IntroRouterProtocol?
    
    required init(view: IntroViewProtocol) {
        self.view = view
    }
    
    func loginIsTapped() {
        interactor?.handleUserLogin()
    }
    
    func presentExploreScreen() {
        router?.showExploreScreen()
    }
}
