import UIKit

// i mean this whole massive view controller thing is giving me ptsd

enum InfoViewTypes {
    case errorInfo
    case exifData
}

class InfoView: UIViewController {
    
    // MARK: - Data
    weak var currentVC: Presentable? = nil
    
    private var type: InfoViewTypes = .errorInfo
    private var dimensions: String? = nil
    var exifStrings: [NSMutableAttributedString] = []
    
    // MARK: - inits
    convenience init(
        exifMetadata: ExifMetadata,
        dimensions imageDimensions: String
    ) {
        self.init()
        type = .exifData
        makeExifStrings(exifMetadata)
        dimensions = imageDimensions
    }
    
    convenience init(
        source: ErrorSource,
        vc: UIViewController
    ) {
        self.init()
        currentVC = vc
        
        switch source {
        case .headerImage:
            helpTextLable.text = "failed to download header image, rly sry"
            repeatButton.addTarget(
                self,
                action: #selector(tryAgainHeaderImage),
                for: .touchDown
            )
        case .collections:
            helpTextLable.text = "failed to download collections, rly sry"
            repeatButton.addTarget(
                self,
                action: #selector(tryAgainCollections),
                for: .touchDown
            )
        case .newImages:
            helpTextLable.text = "failed to download new images, rly sry"
            repeatButton.addTarget(
                self,
                action: #selector(tryAgainNewImagess),
                for: .touchDown
            )
        case .codeExchange:
            helpTextLable.text = "failed to get auth code, rly sry"
            repeatButton.addTarget(
                self,
                action: #selector(tryAgainCodeExchange),
                for: .touchDown
            )
        case .getPhoto:
            helpTextLable.text = "failed to get the photo, rly sry"
            repeatButton.addTarget(
                self,
                action: #selector(tryAgainGetPhoto),
                for: .touchDown
            )
        }
    }
    
    convenience required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI elements
    // MARK: error elements
    private let headerLable: UILabel = {
        let lable = UILabel()
        lable.text = "Sorry, there’s a problem."
        lable.textColor = .black
        lable.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        lable.textAlignment = .center
        
        return lable
    }()
    
    private let helpTextLable: UILabel = {
        let lable = UILabel()
        lable.textAlignment = .center
        lable.textColor = .systemGray
        lable.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        lable.numberOfLines = 0
        
        return lable
    }()
    
    private let repeatButton: UIButton = {
        let button = UIButton()
        button.setTitle("Try again", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        
        return button
    }()
    
    //MARK: Exif data elements
    private let cameraHeader: UILabel = {
        let lable = UILabel()
        lable.text = "Camera"
        lable.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        return lable
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(
            ExifDataCell.self,
            forCellWithReuseIdentifier: ExifDataCell.cellIdentifier
        )
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    //MARK: - view setup
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .cyan
        disableAutoresizing()
        addSubviews()
        configureLayout()
    }
    
    private func disableAutoresizing() {
        [headerLable, repeatButtonContainer, repeatButton, helpTextLable,
         cameraHeader, collectionView
        ].forEach{$0.translatesAutoresizingMaskIntoConstraints = false}
    }
    
    private func addSubviews() {
        switch type {
        case .errorInfo:
            [headerLable, repeatButtonContainer, helpTextLable
            ].forEach{view.addSubview($0)}
            repeatButtonContainer.addSubview(repeatButton)
        case .exifData:
            [cameraHeader, collectionView].forEach{view.addSubview($0)}
        }
    }
    
    private func makeExifStrings(_ exifData: ExifMetadata) {
        if let make = exifData.make {
            let makeAttributedString = NSMutableAttributedString(
                string: "make:\n\(make)"
            )
            makeAttributedString.setAttributes([
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
                NSAttributedString.Key.foregroundColor: UIColor.gray],
                range: NSMakeRange(0, 5)
            )
            
            exifStrings.append(makeAttributedString)
        }
        
        if let focalLenght = exifData.focal_length {
            let focalLenghtAttributedString = NSMutableAttributedString(
                string: "Focal Length:\n\(focalLenght)"
            )
            focalLenghtAttributedString.setAttributes([
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
                NSAttributedString.Key.foregroundColor: UIColor.gray],
                range: NSMakeRange(0, 14)
            )
            
            exifStrings.append(focalLenghtAttributedString)
        }
        
        if let model = exifData.model {
            let modelAttributedString = NSMutableAttributedString(
                string: "Model:\n\(model)"
            )
            modelAttributedString.setAttributes([
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
                NSAttributedString.Key.foregroundColor: UIColor.gray],
                range: NSMakeRange(0, 6)
            )
            
            exifStrings.append(modelAttributedString)
        }
        
        if let shutterSpeed = exifData.exposure_time {
            let shutterSpeedString = NSMutableAttributedString(
                string: "Shutter Speed:\n\(shutterSpeed)"
            )
            shutterSpeedString.setAttributes([
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
                NSAttributedString.Key.foregroundColor: UIColor.gray],
                range: NSMakeRange(0, 14)
            )
            
            exifStrings.append(shutterSpeedString)
        }
        
        if let iso = exifData.iso {
            let ISOString = NSMutableAttributedString(
                string: "ISO:\n\(iso)"
            )
            ISOString.setAttributes([
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
                NSAttributedString.Key.foregroundColor: UIColor.gray],
                range: NSMakeRange(0, 4)
            )
            
            exifStrings.append(ISOString)
        }
        
        if let dimensions = dimensions {
            let dimensionsString = NSMutableAttributedString(
                string: "Dimensions:\n\(dimensions)"
            )
            dimensionsString.setAttributes([
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
                NSAttributedString.Key.foregroundColor: UIColor.gray],
                range: NSMakeRange(0, 11)
            )
            
            exifStrings.append(dimensionsString)
        }
        
        if let apperture = exifData.aperture {
            let apertureString = NSMutableAttributedString(
                string: "Aperture:\n\(apperture)"
            )
            apertureString.setAttributes([
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
                NSAttributedString.Key.foregroundColor: UIColor.gray],
                range: NSMakeRange(0, 9)
            )
            
            exifStrings.append(apertureString)
        }
    }
    
    //MARK: - Layout
    private let repeatButtonContainer = UIView()
    
    private func configureLayout() {
        let errorConstraints: [NSLayoutConstraint] = [
            headerLable.topAnchor.constraint(
                equalTo: view.topAnchor, constant: 20
            ),
            headerLable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerLable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerLable.heightAnchor.constraint(equalToConstant: 32),
            
            repeatButtonContainer.heightAnchor.constraint(equalToConstant: 100),
            repeatButtonContainer.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            repeatButtonContainer.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            repeatButtonContainer.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            ),
            
            repeatButton.centerXAnchor.constraint(
                equalTo: repeatButtonContainer.centerXAnchor
            ),
            repeatButton.centerYAnchor.constraint(
                equalTo: repeatButtonContainer.centerYAnchor
            ),
            repeatButton.heightAnchor.constraint(equalToConstant: 50),
            repeatButton.widthAnchor.constraint(equalToConstant: 350),
            
            helpTextLable.topAnchor.constraint(
                equalTo: headerLable.bottomAnchor
            ),
            helpTextLable.bottomAnchor.constraint(
                equalTo: repeatButtonContainer.topAnchor
            ),
            helpTextLable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            helpTextLable.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            )
        ]
        
        let infoConstraints = [
            cameraHeader.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: 20
            ),
            cameraHeader.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),
            cameraHeader.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            cameraHeader.heightAnchor.constraint(equalToConstant: 22),
            
            collectionView.topAnchor.constraint(
                equalTo: cameraHeader.bottomAnchor
            ),
            collectionView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),
            collectionView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            collectionView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            ),
        ]
        switch type {
        case .errorInfo:
            NSLayoutConstraint.activate(errorConstraints)
        case .exifData:
            NSLayoutConstraint.activate(infoConstraints)
        }
    }
    
    private func getExploreVC(_ vc: Presentable?) -> ExploreViewController? {
        guard
            let exploreVC = currentVC as? ExploreViewController
        else
            {
            return nil
        }
        
        return exploreVC
    }
    
    // MARK: - action methods / logic
    @objc func tryAgainHeaderImage(_ sender: UIButton) {
        guard let exploreVC = getExploreVC(currentVC ?? nil) else {
            dismiss(animated: true)
            return
        }
        exploreVC.presenter?.startHeaderImageTask()
        dismiss(animated: true)
    }
    
    @objc func tryAgainCollections(_ sender: UIButton) {
        guard let exploreVC = getExploreVC(currentVC ?? nil) else {
            dismiss(animated: true)
            return
        }
        exploreVC.presenter?.getCollections()
        
        dismiss(animated: true)
    }
    
    @objc func tryAgainNewImagess(_ sender: UIButton) {
        guard let exploreVC = getExploreVC(currentVC ?? nil) else {
            dismiss(animated: true)
            return
        }
        exploreVC.presenter?.getNewImages(page: exploreVC.pageCount)
        
        dismiss(animated: true)
    }
    
    @objc func tryAgainCodeExchange(_ sender: UIButton) {
        // My guess is that authSession window will just disappear 
        dismiss(animated: true)
    }
    
    @objc func tryAgainGetPhoto(_ sender: UIButton) {
        guard
            let exifVC = currentVC as? ExifViewController
        else
            {
            return
        }
        // NOTE: aiming at visible vc, so i need time before BS'll disappear
        Task {
            try await Task.sleep(nanoseconds: 1000000000)
            let photoId = exifVC.photoId
            exifVC.downloadImage(photoId: photoId)
        }
        dismiss(animated: true)
    }
    
    private func getShutterSpeed(from exposure_time: String?) -> Int {
        // by api doc, and logic api should reutrn exposure time, but in reallity
        // it returning shutter speed, dunno, i think i'll keep this method for
        // some time
        let exposureTime: Float!
        if let exposureTimeFloat = Float(exposure_time ?? "0.0166 ") {
            exposureTime = exposureTimeFloat
        } else {
            exposureTime = 0.0166
        }
        let shutterSpeed: Float = 1 / exposureTime
        return Int(shutterSpeed)
    }
}
