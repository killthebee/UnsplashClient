import UIKit

struct photoModel {
    let id: String
    let title: String?
    let image: UIImage
}

class ExploreViewController: UIViewController, ExploreViewProtocol {
    
    // MARK: - Data
    var presenter: ExplorePresenterProtocol?
    private var collections: [[photoModel]] = [[
        photoModel(id: "1", title: "Travel", image: UIImage(named: "TravelImage")!),
        photoModel(id: "2", title: "Pizza", image: UIImage(named: "PizzaImage")!),
        photoModel(id: "3", title: "Sea", image: UIImage(named: "SeaImage")!)
    ]]
    
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
    
    let collectionsCarouselTableView: UITableView = {
        let table = UITableView()
        table.register(
            CarouselCell.self,
            forCellReuseIdentifier: CarouselCell.identifier
        )
        table.separatorStyle = .none
        table.alwaysBounceVertical = false
        
        return table
    }()
    
    // MARK: - VC setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = .red
        configureView()
    }
    
    // MARK: - Layout
    private func configureView() {
        view.backgroundColor = .white
        disableAutoresizing()
        addSubviews()
        configureLayout()
        configureSubviews()
    }
    
    private func configureSubviews() {
        setUpFirstContainer()
        collectionsCarouselTableView.delegate = self
        collectionsCarouselTableView.dataSource = self
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
        [exploreLable, collectionsCarouselTableView
        ].forEach{exploreContainer.addSubview($0)}
    }
    
    private func disableAutoresizing() {
        [headerContainer, headerImage, headerLable, credsHeaderLable,
         exploreContainer, exploreLable, collectionsCarouselTableView,
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
            exploreContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.23),
            
            exploreLable.topAnchor.constraint(equalTo: exploreContainer.topAnchor, constant: 16),
            exploreLable.leadingAnchor.constraint(equalTo: exploreContainer.leadingAnchor, constant: 16),
            exploreLable.trailingAnchor.constraint(equalTo: exploreContainer.trailingAnchor),
            
            collectionsCarouselTableView.topAnchor.constraint(equalTo: exploreLable.bottomAnchor),
            collectionsCarouselTableView.leadingAnchor.constraint(equalTo: exploreContainer.leadingAnchor, constant: 16),
            collectionsCarouselTableView.trailingAnchor.constraint(equalTo: exploreContainer.trailingAnchor),
            collectionsCarouselTableView.bottomAnchor.constraint(equalTo: exploreContainer.bottomAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//    }
}


extension ExploreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let collections = collections[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CarouselCell.identifier,
            for: indexPath
        ) as? CarouselCell else {
            fatalError()
        }
        cell.configure(with: collections)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height
    }
}
