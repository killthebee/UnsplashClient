import UIKit

class NewImageCell: UICollectionViewCell {
    
    static let cellIdentifier = "NewImageCell"
    
    var cellData : PhotoModel? {
        didSet {
            guard let cellData = cellData else {return}
            coverPhoto.image = UIImage(data: cellData.image)
            ration = coverPhoto.image?.getCropRation2() ?? 1
            imageConstarins(ration)
        }
    }
    
    private let coverPhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private var imageViewHeight = NSLayoutConstraint()
    private var ration: CGFloat = 1
    
    private func imageConstarins(_ ration: CGFloat = 1) {
        coverPhoto.widthAnchor.constraint(
            equalToConstant: contentView.frame.size.width
        ).isActive = true
        let imageHeight = coverPhoto.heightAnchor.constraint(
            equalTo: coverPhoto.widthAnchor,
            multiplier: ration
        )
        imageHeight.priority = UILayoutPriority(900)
        imageHeight.isActive = true
    }
    
    private func setupView() {
        contentView.addSubview(coverPhoto)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: coverPhoto.widthAnchor),
            centerXAnchor.constraint(equalTo: coverPhoto.centerXAnchor),
            heightAnchor.constraint(equalTo: coverPhoto.heightAnchor)
        ])
    }
}
