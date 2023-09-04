import UIKit

enum ButtonCollorScheme {
    case blackWhite
    case translusent
    case whiteBlack
}

class GenericActionButton: UIButton {

    required init(
        frame: CGRect = .zero,
        text: String,
        _ colorScheme: ButtonCollorScheme = .blackWhite
    ) {
        super.init(frame: frame)
        setupView(text, colorScheme)
    }
    
//    required override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(_ text: String, _ colorScheme: ButtonCollorScheme) {
        layer.cornerRadius = 5
        titleLabel?.font = UIFont(name: "Inter-Regular", size: 16)
        
        setTitle(text, for: .normal)
        switch colorScheme {
        case .blackWhite:
            backgroundColor = .black
        case .whiteBlack:
            setTitleColor(.black, for: .normal)
            backgroundColor = .white
        default:
            return
        }
    }
}
