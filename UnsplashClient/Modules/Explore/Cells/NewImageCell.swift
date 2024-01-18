import UIKit

class NewImageCell: UICollectionViewCell {
    
    static let cellIdentifier = "NewImageCell"
    
    var cellData : UnsplashPhoto? {
        didSet {
            guard let cellData = cellData else {return}
            coverPhoto.setImage(cellData.urls, imageId: cellData.id)
            imageConstarins(coverPhoto.image?.getCropRation2() ?? 1)
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
    
    private var imageViewHeight: NSLayoutConstraint? = nil
    
    private func imageConstarins(_ ration: CGFloat) {
        let imageHeight = contentView.frame.width * ration
        
        if let imageViewHeight = imageViewHeight {
            imageViewHeight.constant = imageHeight
        } else {
            imageViewHeight = coverPhoto.heightAnchor.constraint(
                equalToConstant: imageHeight
            )
            imageViewHeight?.isActive = true
        }
    }
    
    private func setupView() {
        contentView.addSubview(coverPhoto)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: coverPhoto.topAnchor),
            contentView.bottomAnchor.constraint(
                equalTo: coverPhoto.bottomAnchor
            ),
            contentView.leadingAnchor.constraint(
                equalTo: coverPhoto.leadingAnchor
            ),
            contentView.trailingAnchor.constraint(
                equalTo: coverPhoto.trailingAnchor
            )
        ])
    }
}
