import UIKit

enum InfoViewTypes {
    case errorInfo
    case exifData
}

class InfoView: UIViewController {
    
    let textLable: UILabel = {
        let lable = UILabel()
        lable.text = " camon!! "
        lable.textColor = .red
        lable.backgroundColor = .yellow
        
        return lable
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .cyan
        view.addSubview(textLable)
        
    }
}
