import UIKit

class CellsHeaderLable: UICollectionViewCell {
    
    static let headerIdentifier = "FilterHeaderView"
    
    let exploreLable: UILabel = {
        let lable = UILabel()
        lable.text = "Explore"
        lable.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        
        return lable
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(exploreLable)
        setUpConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpConstrains() {
        exploreLable.frame = bounds
    }
}
