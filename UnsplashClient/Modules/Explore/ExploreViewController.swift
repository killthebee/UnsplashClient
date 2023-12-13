import UIKit

class ExploreViewController: UIViewController, ExploreViewProtocol {
    func setNewHeaderImage(_ imageData: TopBannerModel) {
        headerImageData = imageData
        collectionView.reloadData()
    }
    
    func setCollections(with collectionsData: [UnsplashColletion]) {
        collections = collectionsData
        collectionView.reloadData()
    }
    
    func addNewImages(photos nextNewImages: [PhotoModel]) {
        newImages.append(contentsOf: nextNewImages) 
        pageCount += 1
        collectionView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func setNewImages(photos downloadedNewImages: [PhotoModel]) {
        newImages = downloadedNewImages
        pageCount += 1
        collectionView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func invalidateHeaderTask() {
        presenter?.invalidateHeaderTask()
    }
    
    @objc
    private func getNextImages(_ sender: Any) {
        presenter?.getNewImages(page: pageCount)
    }
    
    // MARK: Dependencies -
    var presenter: ExplorePresenterProtocol?
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Data
    var collections: [UnsplashColletion] = []
    var newImages: [PhotoModel] = []
    var headerImageData: TopBannerModel? = nil
    var pageCount = 1
    
    lazy var collectionView : UICollectionView = {
        let cv = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout.init()
        )
        cv.showsVerticalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        
        cv.register(
            TopBannderCell.self,
            forSupplementaryViewOfKind: "Stretchy",
            withReuseIdentifier: TopBannderCell.cellIdentifier
        )
        
        cv.register(
            CellsHeaderLable.self,
            forCellWithReuseIdentifier: CellsHeaderLable.headerIdentifier
        )
        
        cv.register(
            CollectionsCarouselCell.self,
            forCellWithReuseIdentifier: CollectionsCarouselCell.cellIdentifier
        )
        
        cv.register(
            NewImageCell.self,
            forCellWithReuseIdentifier: NewImageCell.cellIdentifier
        )
        
        refreshControl.addTarget(
            self,
            action: #selector(getNextImages(_:)),
            for: .valueChanged
        )
        cv.alwaysBounceVertical = true
        cv.refreshControl = refreshControl
        
        return cv
    }()
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let header = collectionView.supplementaryView(
            forElementKind: "Stretchy",
            at: IndexPath(item: 0, section: 0)
        ) as? TopBannderCell {
            header.scrollviewDidScroll(scrollView: collectionView)
         }
    }
    
    // MARK: VC setup -
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        presenter?.startHeaderImageTask()
        presenter?.getCollections()
        presenter?.getNewImages(page: 1)
    }
    
    private func configureView() {
        addSubviews()
        disableAutoresizing()
        setUpConstrains()
        configureCompositionalLayout()
    }
    
    private func addSubviews() {
        [collectionView,
        ].forEach{view.addSubview($0)}
    }
    
    // MARK: Layout -
    private func disableAutoresizing() {
        [collectionView,
        ].forEach{$0.translatesAutoresizingMaskIntoConstraints = false}
    }
    
    func setUpConstrains() {
        let constraints: [NSLayoutConstraint] = [
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}

extension ExploreViewController {
    
    func configureCompositionalLayout(){
        let layout = UICollectionViewCompositionalLayout {sectionIndex,enviroment in
            switch sectionIndex {
            case 0:
                return ExploreVCLayouts.shared.collectionsHeaderLayouts()
            case 1:
                return ExploreVCLayouts.shared.collectionsCarouselLayouts()
            case 2:
                return ExploreVCLayouts.shared.newImagesHeaderLayouts()
            case 3:
                return ExploreVCLayouts.shared.newImagesTableLayout()
            default:
                return ExploreVCLayouts.shared.topBannerSectionLayouts()
            }
        }
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
}


