import UIKit

class ExifViewController: UIViewController, ExifViewProtocol {
    
    //56 px
    
    // MARK: - Data
    var presenter: ExifPresenterProtocol?
    
    var photoId: String? = nil
    
    //TODO: I really need to cache get photo request!
    //TODO: add spiner while it's loading!
    private var image: UIImage?
    
    private var exif: exifMetadata? = nil
    
    let customTransitioningDelegate = BSTransitioningDelegate()
    
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
        
        return imageView
    }()
    
    private let imagePlaceholderView = ImagePlaceholder()

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
        downloadImage(photoId: photoId)
        addTargetMethods()
    }
    
    private func disableAutoresizing() {
        [topSafeAreaContainer, headerView, shareButton, dismissButton,
         infoButton, imageView, imagePlaceholderView
        ].forEach{$0.translatesAutoresizingMaskIntoConstraints = false}
    }
    
    private func addSubviews() {
        [topSafeAreaContainer, headerView, infoButton, imageView,
         imagePlaceholderView
        ].forEach{view.addSubview($0)}
        [shareButton, dismissButton
        ].forEach{headerView.addSubview($0)}
    }
    
    func downloadImage(photoId: String?) {
        guard let photoId = photoId else { return }
        presenter?.getImage(photoId: photoId)
    }
    
    func setImage(imageData: photoModel, exif exifData: exifMetadata) {
        image = UIImage(data: imageData.image)
        imageView.image = image
        exif = exifData
        
        removeImagePlaceholder()
        layoutImage()
    }
    
    private func addTargetMethods() {
        dismissButton.addTarget(
            self,
            action: #selector(handleDismissButtonClicked),
            for: .touchDown
        )
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
        ]
        
        NSLayoutConstraint.activate(constraints)
        // NOTE: mb there is better place to activate this?
        layoutImagePlaceHolder()
    }
    
    private func layoutImage() {
        let constraints: [NSLayoutConstraint] = [
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            imageView.heightAnchor.constraint(
                equalToConstant: getImageViewHeight()
            )
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func layoutImagePlaceHolder() {
        let constraints: [NSLayoutConstraint] = [
            imagePlaceholderView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            imagePlaceholderView.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            ),
            imagePlaceholderView.widthAnchor.constraint(
                equalTo: view.widthAnchor
            ),
            imagePlaceholderView.heightAnchor.constraint(
                equalTo: view.widthAnchor, multiplier: 0.65
            )
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    
    
    private func removeImagePlaceholder() {
        imagePlaceholderView.removeFromSuperview()
    }
    
    private func setCoversBackgroundColor() {
        [topSafeAreaContainer, headerView, imagePlaceholderView
        ].forEach{$0.backgroundColor = UIColor(hexString: "#54545C")}
    }
    
    private let topSafeAreaContainer = UIView()
    private let headerView = UIView()
    
    // MARK: - logic
    
    @objc func handleDismissButtonClicked(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
