import UIKit

enum InfoViewTypes {
    case errorInfo
    case exifData
}

class InfoView: UIViewController {
    
    weak var currentVC: Presentable? = nil
    
    convenience init(exifMetadata: exifMetadata) {
        self.init()
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
//        lable.text = "Something went wrong and we’re not too sure what it is right now. While we figure it out, please try again."
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
        [headerLable, repeatButtonContainer, repeatButton, helpTextLable
        ].forEach{$0.translatesAutoresizingMaskIntoConstraints = false}
    }
    
    private func addSubviews() {
        [headerLable, repeatButtonContainer, helpTextLable
        ].forEach{view.addSubview($0)}
        repeatButtonContainer.addSubview(repeatButton)
    }
    
    private let repeatButtonContainer = UIView()
    
    private func configureLayout() {
        let constraints: [NSLayoutConstraint] = [
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
            helpTextLable.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
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
}
