import UIKit

class BackgroundImageView: UIImageView {
    
    public init(
        frame: CGRect = .zero,
        _ imageName: String = "IntroBackgoundImage"
    ) {
        super.init(frame: frame)
        
        contentMode = .scaleAspectFit
        clipsToBounds = true
        image = UIImage(named: imageName)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
