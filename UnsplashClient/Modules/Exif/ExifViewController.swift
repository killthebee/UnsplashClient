import UIKit

class ExifViewController: UIViewController, ExifViewProtocol {
    
    //56 px
    
    // MARK: - Data
    var presenter: ExifPresenterProtocol?
    
    var photoId: String? { didSet {
            // update image
            print(photoId)
        }
    }
    
    private let image = UIImage(named: "New1")
    
    // MARK: - UI elements
    
    private let shareButton: UIButton = {
        let button = UIButton()
        let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
        let boldSearch = UIImage(
            systemName: "square.and.arrow.up",
            withConfiguration: boldConfig
        )

        button.setImage(boldSearch, for: .normal)
        button.tintColor = .white
        
        return button
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
        let boldSearch = UIImage(
            systemName: "xmark",
            withConfiguration: boldConfig
        )

        button.setImage(boldSearch, for: .normal)
        button.tintColor = .white
        
        return button
    }()
    
    private let infoButton: UIButton = {
        let button = UIButton()
        let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
        let boldSearch = UIImage(
            systemName: "info.circle",
            withConfiguration: boldConfig
        )

        button.setImage(boldSearch, for: .normal)
        button.tintColor = .white
        
        return button
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = image
        
        return imageView
    }()

    // MARK: - VC setup
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    private func configureView() {
        view.backgroundColor = UIColor(hexString: "#292929")
        disableAutoresizing()
        addSubviews()
        configureLayout()
    }
    
    private func disableAutoresizing() {
        [topSafeAreaContainer, headerView, shareButton, dismissButton,
         infoButton, imageView
        ].forEach{$0.translatesAutoresizingMaskIntoConstraints = false}
    }
    
    private func addSubviews() {
        [topSafeAreaContainer, headerView, infoButton, imageView
        ].forEach{view.addSubview($0)}
        [shareButton, dismissButton
        ].forEach{headerView.addSubview($0)}
    }
    
    // MARK: - Layout
    private func getImageViewHeight() -> CGFloat {
        guard
            let imageWidth = image?.size.width,
            let imageHeight = image?.size.height
        else {
            return 1
        }
        let height = (view.frame.size.width /
                      imageWidth * imageHeight)
        return height
    }
    private func configureLayout() {
        setCoversBackgroundColor()
        let headViewHeightMultiplier: CGFloat = 54 / 812
        
        let constraints: [NSLayoutConstraint] = [
            topSafeAreaContainer.topAnchor.constraint(equalTo: view.topAnchor),
            topSafeAreaContainer.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            topSafeAreaContainer.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            topSafeAreaContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            headerView.topAnchor.constraint(
                equalTo: topSafeAreaContainer.bottomAnchor
            ),
            headerView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            headerView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            headerView.heightAnchor.constraint(
                equalTo: view.heightAnchor,
                multiplier: headViewHeightMultiplier
            ),
            
            shareButton.centerYAnchor.constraint(
                equalTo: headerView.centerYAnchor
            ),
            shareButton.leadingAnchor.constraint(
                equalTo: headerView.leadingAnchor,
                constant: 16
            ),
            shareButton.widthAnchor.constraint(equalToConstant: 24),
            
            dismissButton.centerYAnchor.constraint(
                equalTo: headerView.centerYAnchor
            ),
            dismissButton.trailingAnchor.constraint(
                equalTo: headerView.trailingAnchor,
                constant: -16
            ),
            dismissButton.widthAnchor.constraint(equalToConstant: 24),
            
            infoButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -24
            ),
            infoButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),
            infoButton.widthAnchor.constraint(equalToConstant: 24),
            
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            imageView.heightAnchor.constraint(
                equalToConstant: getImageViewHeight()
            )
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setCoversBackgroundColor() {
        [topSafeAreaContainer, headerView
        ].forEach{$0.backgroundColor = UIColor(hexString: "#54545C")}
    }
    
    private let topSafeAreaContainer = UIView()
    private let headerView = UIView()
}
