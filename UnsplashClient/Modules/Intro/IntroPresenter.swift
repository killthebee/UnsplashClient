import UIKit

class IntroPresenter: IntroPresenterProtocol {
    weak var view: IntroViewProtocol!
    var interactor: IntroInteractorProtocol!
    var router: IntroRouterProtocol!
    
    required init(view: IntroViewProtocol) {
        self.view = view
    }
    
    func configureView() {
        if let accessToken = interactor.isTokenAlive() {
            router.showExploreScreen(accessToken)
            return
        }
        
        view?.setBackground()
        view?.addSubviews()
        view?.disableAutoresizing()
        view?.addTargetsToButtons()
    }
    
    func loginIsTapped() {
        interactor.handleUserLogin()
    }
}
