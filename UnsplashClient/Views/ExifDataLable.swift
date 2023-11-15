import UIKit

class ExifDataLable: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        numberOfLines = 0
        font = UIFont.systemFont(ofSize: 16, weight: .light)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
