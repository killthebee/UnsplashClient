import UIKit

class ExifDataCell: UICollectionViewCell {
    
    static let cellIdentifier = "ExifDataCell"
    
    var cellData : NSMutableAttributedString? {
        didSet {
            guard let cellData = cellData else {return}
            cellLable.attributedText = cellData
        }
    }
    
    let cellLable: UILabel = {
        let lable = UILabel()
        lable.numberOfLines = 0
        lable.font = UIFont.systemFont(ofSize: 16, weight: .light)
//        lable.textAlignment = .center
        lable.translatesAutoresizingMaskIntoConstraints = false
        
        return lable
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        addSubview(cellLable)
        let cellConstraints: [NSLayoutConstraint] = [
            cellLable.topAnchor.constraint(equalTo: topAnchor),
            cellLable.bottomAnchor.constraint(equalTo: bottomAnchor),
            cellLable.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellLable.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(cellConstraints)
    }
}
