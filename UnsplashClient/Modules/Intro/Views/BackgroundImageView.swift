import UIKit

class BackgroundImageView: UIImageView {
    
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        contentMode = .scaleAspectFit
        clipsToBounds = true
        image = UIImage(named: "IntroBackgoundImage")
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
