import UIKit

class HeaderLable: UILabel {

    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        text = "Explore\nUnsplash\nphotos"
        textColor = .white
        numberOfLines = 0
        for family in UIFont.familyNames {
                print("family:", family)
                for font in UIFont.fontNames(forFamilyName: family) {
                    print("font:", font)
                }
            }
        font = UIFont(name: "Inter-Regular_Bold", size: 48)
        // duno how to achive exactly mathcing line spacing with figma
        setLineHeight(lineHeight: 13)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
