import UIKit

class ExifViewController: UIViewController, ExifViewProtocol {
    
    var presenter: ExifPresenterProtocol?
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#54545C")
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(hex: "#292929")
    }
}
