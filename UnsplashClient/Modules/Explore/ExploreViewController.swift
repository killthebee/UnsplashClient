import UIKit

class ExploreViewController: UIViewController, ExploreViewProtocol {
    
    var presenter: ExplorePresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.configureView()
        view.backgroundColor = .red
    }
    
    // MARK: Layout
    private var headerContainer = UIView()
    
    func setUpContainer() {
        headerContainer.backgroundColor = .white
    }
    
    func addSubviews() {
        [headerContainer
        ].forEach{view.addSubview($0)}
    }
    
    func disableAutoresizing() {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}
