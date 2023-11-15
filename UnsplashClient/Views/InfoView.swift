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
    private var exifData: exifMetadata? = nil
    private var dimensions: String? = nil
    
    // MARK: - inits
    convenience init(exifMetadata: exifMetadata, dimensions imageDimensions: String) {
        self.init()
        type = .exifData
        exifData = exifMetadata
        dimensions = imageDimensions
    }
    
    convenience init(
        _ error: Error,
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
    
    // TODO: make new uilable
    private let makeLable: UILabel = {
        let lable = UILabel()
        lable.numberOfLines = 0
        lable.font = UIFont.systemFont(ofSize: 16, weight: .light)
        
        return lable
    }()
    
    private let focalLenghtLable: UILabel = {
        let lable = UILabel()
        lable.numberOfLines = 0
        lable.font = UIFont.systemFont(ofSize: 16, weight: .light)
        
        return lable
    }()
    
    private let modelLable: UILabel = {
        let lable = UILabel()
        lable.numberOfLines = 0
        lable.font = UIFont.systemFont(ofSize: 16, weight: .light)
        
        return lable
    }()
    
    private let shutterSpeedLable: UILabel = {
        let lable = UILabel()
        lable.numberOfLines = 0
        lable.font = UIFont.systemFont(ofSize: 16, weight: .light)
        
        return lable
    }()
    
    private let ISOLable: UILabel = {
        let lable = UILabel()
        lable.numberOfLines = 0
        lable.font = UIFont.systemFont(ofSize: 16, weight: .light)
        
        return lable
    }()
    
    private let DimensionsLable: UILabel = {
        let lable = UILabel()
        lable.numberOfLines = 0
        lable.font = UIFont.systemFont(ofSize: 16, weight: .light)
        
        return lable
    }()
    
    private let ApertureLable: UILabel = {
        let lable = UILabel()
        lable.numberOfLines = 0
        lable.font = UIFont.systemFont(ofSize: 16, weight: .light)
        
        return lable
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
        if type == .exifData {
            populateExifDataLables()
        }
    }
    
    private func disableAutoresizing() {
        [headerLable, repeatButtonContainer, repeatButton, helpTextLable,
         cameraHeader, makeLable, focalLenghtLable, modelLable, ISOLable,
         shutterSpeedLable, DimensionsLable, ApertureLable
        ].forEach{$0.translatesAutoresizingMaskIntoConstraints = false}
    }
    
    private func addSubviews() {
        switch type {
        case .errorInfo:
            [headerLable, repeatButtonContainer, helpTextLable
            ].forEach{view.addSubview($0)}
            repeatButtonContainer.addSubview(repeatButton)
        case .exifData:
            [cameraHeader, makeLable, focalLenghtLable, modelLable, ISOLable,
             shutterSpeedLable, DimensionsLable, ApertureLable
            ].forEach{view.addSubview($0)}
        }
    }
    
    private func populateExifDataLables() {
        guard let exifData = exifData else { return }
        
        let makeAttributedString = NSMutableAttributedString(
            string: "make:\n\(exifData.make ?? "Unknown")"
        )
        makeAttributedString.setAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
            NSAttributedString.Key.foregroundColor: UIColor.gray],
            range: NSMakeRange(0, 5)
        )
        makeLable.attributedText = makeAttributedString
        
        let focalLenghtAttributedString = NSMutableAttributedString(
            string: "Focal Length:\n\(exifData.focal_length ?? "Unknown")"
        )
        focalLenghtAttributedString.setAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
            NSAttributedString.Key.foregroundColor: UIColor.gray],
            range: NSMakeRange(0, 14)
        )
        focalLenghtLable.attributedText = focalLenghtAttributedString
        
        let modelAttributedString = NSMutableAttributedString(
            string: "Model:\n\(exifData.model ?? "Unknown")"
        )
        modelAttributedString.setAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
            NSAttributedString.Key.foregroundColor: UIColor.gray],
            range: NSMakeRange(0, 6)
        )
        modelLable.attributedText = modelAttributedString
        
        let shutterSpeedString = NSMutableAttributedString(
            string: "Shutter Speed:\n\(exifData.exposure_time ?? "unknown")"
        )
        shutterSpeedString.setAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
            NSAttributedString.Key.foregroundColor: UIColor.gray],
            range: NSMakeRange(0, 14)
        )
        shutterSpeedLable.attributedText = shutterSpeedString
        
        let ISOString: NSMutableAttributedString!
        if let iso = exifData.iso {
            ISOString = NSMutableAttributedString(
                string: "ISO:\n\(iso)"
            )
        } else {
            ISOString = NSMutableAttributedString(
                string: "ISO:\n Unknown"
            )
        }
        ISOString.setAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
            NSAttributedString.Key.foregroundColor: UIColor.gray],
            range: NSMakeRange(0, 4)
        )
        ISOLable.attributedText = focalLenghtAttributedString
        
        let dimensionsString = NSMutableAttributedString(
            string: "Dimensions:\n\(dimensions ?? "Unknown")"
        )
        dimensionsString.setAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
            NSAttributedString.Key.foregroundColor: UIColor.gray],
            range: NSMakeRange(0, 11)
        )
        DimensionsLable.attributedText = dimensionsString
        
        let apertureString = NSMutableAttributedString(
            string: "Aperture:\n\(exifData.aperture ?? "Unknown")"
        )
        apertureString.setAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
            NSAttributedString.Key.foregroundColor: UIColor.gray],
            range: NSMakeRange(0, 9)
        )
        ApertureLable.attributedText = apertureString
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
            
            makeLable.topAnchor.constraint(equalTo: cameraHeader.bottomAnchor),
            makeLable.leadingAnchor.constraint(
                equalTo: cameraHeader.leadingAnchor
            ),
            makeLable.widthAnchor.constraint(
                equalTo: view.widthAnchor,
                multiplier: 0.3
            ),
            makeLable.heightAnchor.constraint(equalToConstant: 40),
            
            focalLenghtLable.topAnchor.constraint(
                equalTo: cameraHeader.bottomAnchor
            ),
            focalLenghtLable.leadingAnchor.constraint(equalTo: makeLable.trailingAnchor, constant: 10),
            focalLenghtLable.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            focalLenghtLable.heightAnchor.constraint(equalToConstant: 40),
            
            modelLable.topAnchor.constraint(equalTo: makeLable.bottomAnchor),
            modelLable.leadingAnchor.constraint(
                equalTo: cameraHeader.leadingAnchor
            ),
            modelLable.widthAnchor.constraint(
                equalTo: view.widthAnchor,
                multiplier: 0.3
            ),
            modelLable.heightAnchor.constraint(equalToConstant: 40),
            
            ISOLable.topAnchor.constraint(
                equalTo: focalLenghtLable.bottomAnchor
            ),
            ISOLable.leadingAnchor.constraint(
                equalTo: modelLable.trailingAnchor,
                constant: 10
            ),
            ISOLable.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            ISOLable.heightAnchor.constraint(equalToConstant: 40),
            
            shutterSpeedLable.topAnchor.constraint(
                equalTo: modelLable.bottomAnchor
            ),
            shutterSpeedLable.leadingAnchor.constraint(
                equalTo: cameraHeader.leadingAnchor
            ),
            shutterSpeedLable.widthAnchor.constraint(
                equalTo: view.widthAnchor,
                multiplier: 0.3
            ),
            shutterSpeedLable.heightAnchor.constraint(equalToConstant: 40),
            
            DimensionsLable.topAnchor.constraint(
                equalTo: ISOLable.bottomAnchor
            ),
            DimensionsLable.leadingAnchor.constraint(
                equalTo: shutterSpeedLable.trailingAnchor,
                constant: 10
            ),
            DimensionsLable.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            DimensionsLable.heightAnchor.constraint(equalToConstant: 40),
            
            ApertureLable.topAnchor.constraint(
                equalTo: shutterSpeedLable.bottomAnchor
            ),
            ApertureLable.leadingAnchor.constraint(
                equalTo: cameraHeader.leadingAnchor
            ),
            ApertureLable.widthAnchor.constraint(
                equalTo: view.widthAnchor,
                multiplier: 0.3
            ),
            ApertureLable.heightAnchor.constraint(equalToConstant: 40),
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
        exploreVC.presenter?.wipeBadCollections()
        exploreVC.presenter?.getCollections()
        
        dismiss(animated: true)
    }
    
    @objc func tryAgainNewImagess(_ sender: UIButton) {
        guard let exploreVC = getExploreVC(currentVC ?? nil) else {
            dismiss(animated: true)
            return
        }
        let page = exploreVC.newImageTableDelegateAndDataSource.pageCount
        exploreVC.presenter?.getNewImages(page: page)
        
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
