import UIKit

class SubHeaderLable: UILabel {
    
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        text = "The source of freely-usable images.\nPowered by creators everywhere."
        textColor = .white
        numberOfLines = 0
        font = UIFont(name: "Inter-Regular_Bold", size: 18)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
