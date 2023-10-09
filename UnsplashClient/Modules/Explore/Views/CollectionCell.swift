import UIKit

final class CollectionCell: UICollectionViewCell {
    static let identifier = "CollectionCell"
    
    private let collectionNameLable: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(
            ofSize: 22,
            weight: UIFont.Weight(rawValue: 500)
        )
        // thinking about satting line height to see if it'll affect height of
        // the view
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
    }

    required init?(coder: NSCoder) {
        fatalError()
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
    }
    
    func configure(with collectionData: photoModel) {
        collectionNameLable.text = collectionData.title
        collectionCoverPhoto.image = collectionData.image
    }
}
