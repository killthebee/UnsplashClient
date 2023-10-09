import UIKit

class NewTableCell: UITableViewCell {
    static let identifier = "NewCell"
    
    private let NewCoverPhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [NewCoverPhoto,
        ].forEach{contentView.addSubview($0)}
        setupViewLayout()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupViewLayout() {
        NewCoverPhoto.frame = contentView.bounds
    }
    
    func configure(with collectionData: photoModel) {
        NewCoverPhoto.image = collectionData.image
        NewCoverPhoto.frame = contentView.bounds
    }
}
