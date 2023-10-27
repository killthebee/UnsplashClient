import UIKit

enum InfoViewTypes {
    case errorInfo
    case exifData
}

class InfoView: UIViewController {
    
    private let headerLable: UILabel = {
        let lable = UILabel()
        lable.text = "Sorry, there’s a problem."
        lable.textColor = .black
        lable.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        lable.textAlignment = .center
        
        return lable
    }()
    
    private let helpTextLable: UILabel = {
        let lable = UILabel()
        lable.text = "Something went wrong and we’re not too sure what it is right now. While we figure it out, please try again."
        lable.textAlignment = .center
        lable.textColor = .systemGray
        lable.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        lable.numberOfLines = 0
        
        return lable
    }()
    
    private let repeatButton: UIButton = {
        let button = UIButton()
        button.setTitle("Try again", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .cyan
        disableAutoresizing()
        addSubviews()
        configureLayout()
    }
    
    private func disableAutoresizing() {
        [headerLable, repeatButtonContainer, repeatButton, helpTextLable
        ].forEach{$0.translatesAutoresizingMaskIntoConstraints = false}
    }
    
    private func addSubviews() {
        [headerLable, repeatButtonContainer, helpTextLable
        ].forEach{view.addSubview($0)}
        repeatButtonContainer.addSubview(repeatButton)
    }
    
    private let repeatButtonContainer = UIView()
    
    private func configureLayout() {
        let constraints: [NSLayoutConstraint] = [
            headerLable.topAnchor.constraint(
                equalTo: view.topAnchor, constant: 20
            ),
            headerLable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerLable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerLable.heightAnchor.constraint(equalToConstant: 32),
            
            repeatButtonContainer.heightAnchor.constraint(equalToConstant: 100),
            repeatButtonContainer.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            repeatButtonContainer.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            repeatButtonContainer.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            ),
            
            repeatButton.centerXAnchor.constraint(
                equalTo: repeatButtonContainer.centerXAnchor
            ),
            repeatButton.centerYAnchor.constraint(
                equalTo: repeatButtonContainer.centerYAnchor
            ),
            repeatButton.heightAnchor.constraint(equalToConstant: 50),
            repeatButton.widthAnchor.constraint(equalToConstant: 350),
            
            helpTextLable.topAnchor.constraint(
                equalTo: headerLable.bottomAnchor
            ),
            helpTextLable.bottomAnchor.constraint(
                equalTo: repeatButtonContainer.topAnchor
            ),
            helpTextLable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            helpTextLable.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
