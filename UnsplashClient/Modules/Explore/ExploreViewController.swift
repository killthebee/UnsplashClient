import UIKit

class ExploreViewController: UIViewController, ExploreViewProtocol {
    
    // MARK: - Dependencies
    var presenter: ExplorePresenterProtocol?
    let newImageTableDelegateAndDataSource = newTableDelegateAndDataSource()
    
    // MARK: - Data
    // this [[]] is for  carousel porpuses
    private var collections: [[UnsplashColletion]] = []
    
    private var newImages: [photoModel] = []
    
    // MARK: - UI Elements
    let headerImage: BackgroundImageView = {
        let image = BackgroundImageView(frame: .zero, "ExploreHeader")
        image.contentMode = .scaleAspectFill
        image.isUserInteractionEnabled = true

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
    
    private let newLable: UILabel = {
        let lable = UILabel()
        lable.text = "New"
        lable.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        
        return lable
    }()
    
    private lazy var newTable: UITableView = {
        let table = UITableView()
        table.register(
            NewTableCell.self,
            forCellReuseIdentifier: NewTableCell.identifier
        )
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(
         self,
         action: #selector(getNextImages(_:)),
         for: .valueChanged
        )
        refreshControl.attributedTitle = NSAttributedString(
            string: "Pull down to refresh..."
        )
        table.refreshControl = refreshControl
        table.addSubview(refreshControl)
        
        return table
    }()
    
    // MARK: - VC setup
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        view.backgroundColor = .white
        newImageTableDelegateAndDataSource.presenter = presenter
        newTable.dataSource = newImageTableDelegateAndDataSource
        newTable.delegate = newImageTableDelegateAndDataSource
        disableAutoresizing()
        addSubviews()
        configureLayout()
        configureSubviews()
        presenter?.getCollections()
        presenter?.startHeaderImageTask()
        getImages()
    }
    
    private func configureSubviews() {
        collectionsCarouselTableView.delegate = self
        collectionsCarouselTableView.dataSource = self
    }
    
    // MARK: - Layout
    private var headerContainer = UIView()
    private var exploreContainer = UIView()
    private var newContainer = UIView()
    
    private func addSubviews() {
        [headerContainer, exploreContainer, newContainer
        ].forEach{view.addSubview($0)}
        [headerImage, headerLable, credsHeaderLable
        ].forEach{headerContainer.addSubview($0)}
        [exploreLable, collectionsCarouselTableView
        ].forEach{exploreContainer.addSubview($0)}
        [newLable, newTable
        ].forEach{newContainer.addSubview($0)}
    }
    
    private func disableAutoresizing() {
        [headerContainer, headerImage, headerLable, credsHeaderLable,
         exploreContainer, exploreLable, collectionsCarouselTableView,
         newContainer, newLable, newTable
        ].forEach{$0.translatesAutoresizingMaskIntoConstraints = false}
    }
    
    private func configureLayout() {
        // constant justifyed cuz i would never want to shrink cells hight
        let roughlyCaroseulHeightPlusLableHightPlusGaps: CGFloat = 188
        let constraints: [NSLayoutConstraint] = [
            headerContainer.topAnchor.constraint(equalTo: view.topAnchor),
            headerContainer.heightAnchor.constraint(
                equalTo: view.heightAnchor,
                multiplier: 0.3
            ),
            headerContainer.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            headerContainer.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            
            headerImage.topAnchor.constraint(
                equalTo: headerContainer.topAnchor
            ),
            headerImage.bottomAnchor.constraint(
                equalTo: headerContainer.bottomAnchor
            ),
            headerImage.leadingAnchor.constraint(
                equalTo: headerContainer.leadingAnchor
            ),
            headerImage.trailingAnchor.constraint(
                equalTo: headerContainer.trailingAnchor
            ),
            
            headerLable.centerXAnchor.constraint(
                equalTo: headerContainer.centerXAnchor
            ),
            headerLable.centerYAnchor.constraint(
                equalTo: headerContainer.centerYAnchor
            ),
            
            credsHeaderLable.bottomAnchor.constraint(
                equalTo: headerContainer.bottomAnchor,
                constant: -14
            ),
            credsHeaderLable.centerXAnchor.constraint(
                equalTo: headerContainer.centerXAnchor
            ),
            credsHeaderLable.heightAnchor.constraint(equalToConstant: 14),
            
            exploreContainer.topAnchor.constraint(
                equalTo: headerContainer.bottomAnchor
            ),
            exploreContainer.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            exploreContainer.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            exploreContainer.heightAnchor.constraint(
                equalToConstant: roughlyCaroseulHeightPlusLableHightPlusGaps
            ),
            
            collectionsCarouselTableView.heightAnchor.constraint(
                equalToConstant: 130
            ),
            collectionsCarouselTableView.leadingAnchor.constraint(
                equalTo: exploreContainer.leadingAnchor, constant: 16
            ),
            collectionsCarouselTableView.trailingAnchor.constraint(
                equalTo: exploreContainer.trailingAnchor
            ),
            collectionsCarouselTableView.bottomAnchor.constraint(
                equalTo: exploreContainer.bottomAnchor
            ),
            
            exploreLable.bottomAnchor.constraint(
                equalTo: collectionsCarouselTableView.topAnchor, constant: -16
            ),
            exploreLable.leadingAnchor.constraint(
                equalTo: exploreContainer.leadingAnchor, constant: 16
            ),
            exploreLable.trailingAnchor.constraint(
                equalTo: exploreContainer.trailingAnchor
            ),
            
            newContainer.topAnchor.constraint(
                equalTo: exploreContainer.bottomAnchor
            ),
            newContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            newContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            newLable.topAnchor.constraint(
                equalTo: newContainer.topAnchor,
                constant: 16
            ),
            newLable.leadingAnchor.constraint(
                equalTo: newContainer.leadingAnchor,
                constant: 16
            ),
            newLable.trailingAnchor.constraint(
                equalTo: newContainer.trailingAnchor
            ),
            
            newTable.topAnchor.constraint(
                equalTo: newLable.bottomAnchor,
                constant: 16
            ),
            newTable.leadingAnchor.constraint(
                equalTo: newContainer.leadingAnchor
            ),
            newTable.trailingAnchor.constraint(
                equalTo: newContainer.trailingAnchor
            ),
            newTable.bottomAnchor.constraint(
                equalTo: newContainer.bottomAnchor
            ),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - logic
    func setNewHeaderImage(imageData: Data, _ photographerName: String) {
        let newImage = UIImage(data: imageData)
        headerImage.image = newImage
        credsHeaderLable.text = "photo by \(photographerName)"
    }
    
    func setCollections(with collectionsData: [[UnsplashColletion]]) {
        collections = collectionsData
        collectionsCarouselTableView.reloadData()
    }
    
    func getImages() {
        presenter?.getNewImages(page: 1)
    }
    
    @objc private func getNextImages(_ sender: Any) {
        presenter?.getNewImages(
            page: newImageTableDelegateAndDataSource.pageCount
        )
    }
    
    func addNewImages(photos newImages: [photoModel]) {
        newImageTableDelegateAndDataSource.images = newImages
        newImageTableDelegateAndDataSource.incrementPageCount()
        newTable.reloadData()
        newTable.refreshControl?.endRefreshing()
    }
    
    func setNewImages(photos newImages: [photoModel]) {
        newImageTableDelegateAndDataSource.images.append(contentsOf: newImages)
        newImageTableDelegateAndDataSource.incrementPageCount()
        newTable.reloadData()
        newTable.refreshControl?.endRefreshing()
    }
    
    private func forbidScrollNewTableIfNeeded() {
        newTable.isScrollEnabled = (
            newTable.contentSize.height > newTable.frame.size.height
        )
    }
    
    func invalidateHeaderTask() {
        presenter?.invalidateHeaderTask()
    }
}

extension ExploreViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return collections.count == 0 ? 5 : collections.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CarouselCell.identifier,
            for: indexPath
        ) as? CarouselCell else {
            fatalError()
        }
        if collections.count == 0 { return cell }
        cell.configure(with: collections[0])
        cell.explorePresenter = presenter
        
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return tableView.frame.size.height
    }
}

class newTableDelegateAndDataSource: NSObject {
    
    var images: [photoModel] = []
    var pageCount = 1
    var presenter: ExplorePresenterProtocol?
    
    func incrementPageCount() {
        pageCount += 1
    }
}

extension newTableDelegateAndDataSource: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return images.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let photo = images[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NewTableCell.identifier,
            for: indexPath
        ) as? NewTableCell else {
            fatalError()
        }
        cell.configure(with: photo)
        
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        let currentImage = images[indexPath.row]
        let imageCrop = UIImage(data: currentImage.image)!.getCropRation()
        return tableView.frame.width / imageCrop
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        presenter?.presentExifScreen(photoId: images[indexPath.row].id)
    }
}
