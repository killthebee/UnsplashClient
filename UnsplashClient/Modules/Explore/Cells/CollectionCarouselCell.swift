import UIKit

class CollectionsCarouselCell: UICollectionViewCell {
    
    static let cellIdentifier = "CollectionCell"
    
    var cellData : UnsplashColletion? {
        didSet {
            guard let cellData = cellData else {return}
            spinner.view.removeFromSuperview()
            contentView.backgroundColor = .clear
            contentView.alpha = 1
            collectionCoverPhoto.setImage(
                cellData.cover_photo.urls,
                imageId: cellData.id
            )
            collectionNameLable.text = cellData.title
        }
    }
    
    private let spinner = SpinnerViewController()
    
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
        collectionNameLable.frame = contentView.bounds
        
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        
        // yeah xD
        contentView.backgroundColor = .black
        contentView.alpha = 0.5
        contentView.isOpaque = false
    }
    
    
}
