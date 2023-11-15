import UIKit

class UISystemImageButton: UIButton {
    
    convenience init(imageName: String) {
        self.init()
        let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
        let boldSearch = UIImage(
            systemName: imageName,
            withConfiguration: boldConfig
        )

        setImage(boldSearch, for: .normal)
        tintColor = .white
    }
}
