import UIKit

class ExploreViewController: UIViewController, ExploreViewProtocol {
    
    // MARK: - Data
    var presenter: ExplorePresenterProtocol?
//    var 
    
    // MARK: - UI Elements
    let headerImage: BackgroundImageView = {
        let image = BackgroundImageView(frame: .zero, "ExploreHeader")
        image.contentMode = .scaleAspectFill

        return image
    }()
    
    let headerLable: UILabel = {
        let lable = UILabel()
        lable.textColor = .white
        lable.textAlignment = .center
        lable.text = "Photos for everyone"
        lable.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        
        return lable
    }()
    
    let credsHeaderLable: UILabel = {
        let lable = UILabel()
        lable.text = "Photo by Marcelo Cidrack"
        lable.textColor = .systemGray
        lable.textAlignment = .center
        lable.font = UIFont.boldSystemFont(ofSize: 14)
        
        return lable
    }()
    
    let exploreLable: UILabel = {
        let lable = UILabel()
        lable.text = "Explore"
        lable.textColor = .black
//        lable.textAlignment = .center
        lable.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        
        return lable
    }()
    
    // MARK: - VC setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        exploreContainer.backgroundColor = .yellow
        configureView()
    }
    
    // MARK: - Layout
    private func configureView() {
        disableAutoresizing()
        addSubviews()
        configureLayout()
        configureSubviews()
    }
    
    private func configureSubviews() {
        setUpFirstContainer()
    }
    
    private var headerContainer = UIView()
    private var exploreContainer = UIView()
    
    private func setUpFirstContainer() {
    }
    
    private func addSubviews() {
        [headerContainer, exploreContainer
        ].forEach{view.addSubview($0)}
        [headerImage, headerLable, credsHeaderLable
        ].forEach{headerContainer.addSubview($0)}
        [exploreLable,
        ].forEach{exploreContainer.addSubview($0)}
    }
    
    private func disableAutoresizing() {
        [headerContainer, headerImage, headerLable, credsHeaderLable,
         exploreContainer, exploreLable
        ].forEach{$0.translatesAutoresizingMaskIntoConstraints = false}
    }
    
    private func configureLayout() {
        let constraints: [NSLayoutConstraint] = [
            headerContainer.topAnchor.constraint(equalTo: view.topAnchor),
            headerContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            headerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            headerImage.topAnchor.constraint(equalTo: headerContainer.topAnchor),
            headerImage.bottomAnchor.constraint(equalTo: headerContainer.bottomAnchor),
            headerImage.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor),
            headerImage.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor),
            
            headerLable.centerXAnchor.constraint(equalTo: headerContainer.centerXAnchor),
            headerLable.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor),
            
            credsHeaderLable.bottomAnchor.constraint(
                equalTo: headerContainer.bottomAnchor, constant: -14
            ),
            credsHeaderLable.centerXAnchor.constraint(equalTo: headerContainer.centerXAnchor),
            credsHeaderLable.heightAnchor.constraint(equalToConstant: 14),
            
            exploreContainer.topAnchor.constraint(
                equalTo: headerContainer.bottomAnchor
            ),
            exploreContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            exploreContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            exploreContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            
            exploreLable.topAnchor.constraint(equalTo: exploreContainer.topAnchor, constant: 16),
            exploreLable.leadingAnchor.constraint(equalTo: exploreContainer.leadingAnchor, constant: 16),
            exploreLable.trailingAnchor.constraint(equalTo: exploreContainer.trailingAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//    }
}
