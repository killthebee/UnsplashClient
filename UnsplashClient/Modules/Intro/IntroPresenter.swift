import UIKit

class IntroPresenter: IntroPresenterProtocol {
    weak var view: IntroViewProtocol!
    var interactor: IntroInteractorProtocol!
    var router: IntroRouterProtocol!
    
    required init(view: IntroViewProtocol) {
        self.view = view
    }
    
    func configureView() {
        if interactor.isTokenAlive() {
            router.showExploreScreen()
            return
        }
        
        view?.setBackground()
        view?.addSubviews()
        view?.disableAutoresizing()
    }
}
