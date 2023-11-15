import UIKit

class ExifViewController: UIViewController, ExifViewProtocol {
    
    // MARK: - Dependencies
    var presenter: ExifPresenterProtocol?
    weak var exploreVCDelegate: ExploreViewProtocol?
    let customTransitioningDelegate = BSTransitioningDelegate()
    
    // MARK: - Data
    
    var photoId: String? = nil
    
    private var image: UIImage?
    
    private var exif: exifMetadata? = nil
    
    // MARK: - UI elements
    private let shareButton = UISystemImageButton(
        imageName: "square.and.arrow.up"
    )
    
    private let dismissButton = UISystemImageButton(
        imageName: "xmark"
    )
    
    private let infoButton: UIButton = UISystemImageButton(
        imageName: "info.circle"
    )

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
        
        infoButton.addTarget(
            self,
            action: #selector(infoButtonTouched),
            for: .touchDown
        )
        
        shareButton.addTarget(
            self,
            action: #selector(shareButtonTouched),
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
        let headViewHeightMultiplier: CGFloat = 54 / view.frame.height
        
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
    
    func reStartHeaderTask() {
        exploreVCDelegate?.presenter?.startHeaderImageTask()
    }
    
    @objc func handleDismissButtonClicked(_ sender: UIButton) {
        presenter?.dismissRequested()
    }
    
    @objc func infoButtonTouched(_ sender: UIButton) {
        presenter?.infoButtonTouched(exif: exif)
    }
    
    @objc func shareButtonTouched(_ sender: UIButton) {
        presenter?.presentShareVC()
        
    }
    
    func presentExifInfo(exif: exifMetadata) {
        let dimensions = "\(Int(image?.size.width ?? 0)) x \(Int(image?.size.height ?? 0))"
        
        let vc = InfoView(exifMetadata: exif, dimensions: dimensions)
        vc.transitioningDelegate = customTransitioningDelegate
        vc.modalPresentationStyle = .custom
            
        present(vc, animated: true)
    }
    
    func presentShareVC() {
        guard
            let photoId = photoId,
            let url = UnsplashApi.shared.makeUrl(photoId, target: .sharePhoto),
            let imageUrl = NSURL(string: url.absoluteString)
        else {
            return
        }
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [imageUrl], applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = shareButton
        
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
        activityViewController.popoverPresentationController?.sourceRect = CGRect(
            x: 150,
            y: 150,
            width: 0,
            height: 0
        )
        
        activityViewController.activityItemsConfiguration = [
            UIActivity.ActivityType.message
        ] as? UIActivityItemsConfigurationReading
        
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo,
            UIActivity.ActivityType.postToFacebook
        ]
        
        activityViewController.isModalInPresentation = true
        self.present(activityViewController, animated: true, completion: nil)
    }
}
