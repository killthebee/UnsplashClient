import UIKit

class HeaderLable: UILabel {

    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        text = "Explore\nUnsplash\nphotos"
        textColor = .white
        numberOfLines = 0
        font = UIFont(name: "Inter-Regular_Bold", size: 48)
        setLineHeight(lineHeight: 12)
        accessibilityLabel = "Explore\nUnsplash\nphotos"
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
