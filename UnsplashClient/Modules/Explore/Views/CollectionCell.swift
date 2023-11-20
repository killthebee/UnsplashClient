import UIKit

final class CollectionCell: UICollectionViewCell {
    static let identifier = "CollectionCell"
    
    private let spinner = SpinnerViewController()
    
    var carouselDelegate: CarouselCellDelegateProtocol? = nil
    
    private let collectionNameLable: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(
            ofSize: 22,
            weight: UIFont.Weight(rawValue: 500)
        )
        lable.textColor = .white
        lable.textAlignment = .center
        
        return lable
    }()
    
    private let collectionCoverPhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [collectionCoverPhoto, collectionNameLable,
        ].forEach{contentView.addSubview($0)}
        setupViewLayout()
        addSpinner()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func addSpinner() {
        spinner.view.frame = contentView.frame
        contentView.addSubview(spinner.view)
    }
    
    private func setupViewLayout() {
        collectionCoverPhoto.frame = contentView.bounds
        collectionNameLable.frame = CGRect(
            x: 0,
            y: 0,
            width: contentView.bounds.size.width,
            height: contentView.bounds.size.height
        )
        
        
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        
        // yeah xD
        contentView.backgroundColor = .black
        contentView.alpha = 0.5
        contentView.isOpaque = false
    }
    
    private func setupCellWithData(
        collectionData: UnsplashColletion,
        photoData: Data
    ) {
        spinner.view.removeFromSuperview()
        contentView.alpha = 1
        contentView.isOpaque = true
        collectionNameLable.text = collectionData.title
        contentView.backgroundColor = .clear
        collectionCoverPhoto.image = UIImage(data: photoData)
    }
    
    @MainActor
    private func setupCellWithNewData(
        index: Int,
        collectionData: UnsplashColletion,
        photoData: Data
    ) async {
        setupCellWithData(
            collectionData: collectionData,
            photoData: photoData
        )
        carouselDelegate?.dataMap[index] = photoData
    }
    
    func configure(
        with collectionData: UnsplashColletion,
        index: Int,
        imageData: Data? = nil
    ) {
        if let imageData = imageData {
            setupCellWithData(
                collectionData: collectionData,
                photoData: imageData
            )
            return
        }
        
        let compition = { [weak self] photoData async -> Void in
            await self?.setupCellWithNewData(
                index: index,
                collectionData: collectionData,
                photoData: photoData
            )
        }
        
        collectionCoverPhoto.setImage(
            with: collectionData,
            completion: compition
        )
    }
}
