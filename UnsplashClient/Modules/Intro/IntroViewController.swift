import UIKit

class IntroViewController: UIViewController, IntroViewProtocol {
    
    var presenter: IntroPresenterProtocol!
    var configurator: IntroConfiguratorProtocol = IntroConfigurator()
    
    var backgroundImage: BackgroundImageView!
    var headerLable = HeaderLable()
    
    let firstContainer = UIView()
    let secondContainer = UIView()
    let thirdContainer = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(with: self)
        presenter.configureView()
    }

    func setBackground() {
        backgroundImage = BackgroundImageView(frame: view.bounds)
        self.view.sendSubviewToBack(backgroundImage)
    }
    
    func addSubviews() {
        [backgroundImage, firstContainer, secondContainer, thirdContainer
        ].forEach{view.addSubview($0)}
        
        secondContainer.addSubview(headerLable)
    }
    
    func disableAutoresizing() {
        [firstContainer, secondContainer, thirdContainer, headerLable
        ].forEach{$0.translatesAutoresizingMaskIntoConstraints = false}
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundImage.center = view.center
//        [firstContainer, thirdContainer].forEach{$0.backgroundColor = .cyan}
//        secondContainer.backgroundColor = .yellow
        let constraints: [NSLayoutConstraint] = [
            firstContainer.topAnchor.constraint(equalTo: view.topAnchor),
            firstContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            firstContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            firstContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.33),
            
            thirdContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            thirdContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            thirdContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            thirdContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.33),
            
            secondContainer.topAnchor.constraint(equalTo: firstContainer.bottomAnchor),
            secondContainer.bottomAnchor.constraint(equalTo: thirdContainer.topAnchor),
            secondContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            secondContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            headerLable.centerYAnchor.constraint(equalTo: secondContainer.centerYAnchor),
            headerLable.widthAnchor.constraint(equalTo: secondContainer.widthAnchor, multiplier: 1),
            
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
