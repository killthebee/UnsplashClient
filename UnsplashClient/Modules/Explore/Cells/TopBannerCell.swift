import UIKit

class TopBannderCell: UICollectionReusableView {
    
    static let cellIdentifier = "FoodTopBannerCollectionViewCell"
    
    var cellData : TopBannerModel? {
        didSet {
            guard let cellData = cellData else {return}
            UIView.transition(
                with: self.bannerImageView,
                duration: 0.3,
                options: .transitionCrossDissolve,
                animations: {
                    self.bannerImageView.setImage(
                        cellData.url,
                        imageId: cellData.id
                    )
                },
                completion: nil
            )
            
            credsHeaderLable.text = "photo by \(cellData.photographerName)"
        }
    }
    
    let headerLable: UILabel = {
        let lable = UILabel()
        lable.textColor = .white
        lable.textAlignment = .center
        lable.text = "Photos for everyone"
        lable.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        
        return lable
    }()
    
    let credsHeaderLable: UILabel = {
        let lable = UILabel()
        lable.text = "Photo by Marcelo Cidrack"
        lable.textColor = .systemGray
        lable.textAlignment = .center
        lable.font = UIFont.boldSystemFont(ofSize: 14)
        
        return lable
    }()
    
    let bannerImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "IntroBackgoundImage")
        
        return view
    }()
    
    private var imageViewHeight = NSLayoutConstraint()
    private var imageViewBottom = NSLayoutConstraint()
    private var containerView = UIView()
    private var containerViewHeight = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    func configure(){
        containerView.backgroundColor = .clear
        addSubview(containerView)
        [bannerImageView, credsHeaderLable, headerLable
        ].forEach{containerView.addSubview($0)}
        [containerView, bannerImageView, credsHeaderLable, headerLable
        ].forEach{$0.translatesAutoresizingMaskIntoConstraints = false}
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: containerView.widthAnchor),
            centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.widthAnchor.constraint(
            equalTo: bannerImageView.widthAnchor
        ).isActive = translatesAutoresizingMaskIntoConstraints
        containerViewHeight = containerView.heightAnchor.constraint(equalTo: self.heightAnchor)
        containerViewHeight.isActive = true
        
        imageViewBottom = bannerImageView.bottomAnchor.constraint(
            equalTo: containerView.bottomAnchor
        )
        imageViewBottom.isActive = true
        imageViewHeight = bannerImageView.heightAnchor.constraint(
            equalTo: containerView.heightAnchor
        )
        imageViewHeight.isActive = true
        
        
        let constraints: [NSLayoutConstraint] = [

            headerLable.centerXAnchor.constraint(
                equalTo: bannerImageView.centerXAnchor
            ),
            headerLable.centerYAnchor.constraint(
                equalTo: bannerImageView.centerYAnchor
            ),

            credsHeaderLable.bottomAnchor.constraint(
                equalTo: bannerImageView.bottomAnchor,
                constant: -14
            ),
            credsHeaderLable.centerXAnchor.constraint(
                equalTo: bannerImageView.centerXAnchor
            ),
            credsHeaderLable.heightAnchor.constraint(equalToConstant: 14),
        ]

        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func scrollviewDidScroll(scrollView: UIScrollView) {
        containerViewHeight.constant = scrollView.contentInset.top
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
        containerView.clipsToBounds = offsetY <= 0
        imageViewBottom.constant = offsetY >= 0 ? 0 : -offsetY / 2
        imageViewHeight.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
    }
}
