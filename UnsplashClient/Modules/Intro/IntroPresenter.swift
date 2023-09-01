import UIKit

class IntroPresenter: IntroPresenterProtocol {
    weak var view: IntroViewProtocol!
    
    required init(view: IntroViewProtocol) {
        self.view = view
    }
    
    func configureView() {
        view?.setBackground()
        view?.addSubviews()
        view?.disableAutoresizing()
    }
}
