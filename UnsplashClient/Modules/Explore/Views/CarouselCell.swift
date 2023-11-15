import UIKit

final class CarouselCell: UITableViewCell, CarouselCellDelegateProtocol {
    
    static let identifier = "CarouselCell"
    
    var collections: [UnsplashColletion] = []
    
    var dataMap: [Int: Data] = [:]
    
    weak var explorePresenter: ExplorePresenterProtocol?
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(
            CollectionCell.self,
            forCellWithReuseIdentifier: CollectionCell.identifier
        )
        // maybe maybe
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
        
    }
}

extension CarouselCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return collections.count == 0 ? 5 : collections.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CollectionCell.identifier,
            for: indexPath
        ) as? CollectionCell else {
            fatalError()
        }
        cell.carouselDelegate = self
        if collections.count == 0 { return cell }
        cell.configure(
            with: collections[indexPath.row],
            index: indexPath.row,
            imageData: dataMap[indexPath.row]
        )
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
//        explorePresenter?.collectionSelected(id: collections[indexPath.row].id)
    }
}

extension CarouselCell {
    func configure(with collectionsData: [UnsplashColletion]) {
        collections = collectionsData
        collectionView.reloadData()
    }
}

extension CarouselCell: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 319, height: 130)
    }
}
