import UIKit

class IntroViewController: UIViewController, IntroViewProtocol {
    
    // MARK: Dependencies
    var presenter: IntroPresenterProtocol!
    var configurator: IntroConfiguratorProtocol = IntroConfigurator()
    
    // MARK: UI Elements
    var backgroundImage: BackgroundImageView!
    var headerLable = HeaderLable()
    var subHeaderLable = SubHeaderLable()
    var loginButton = GenericActionButton(text: "Log in", .whiteBlack)
    var exploreButton = GenericActionButton(text: "Explore photos")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(with: self)
        presenter.configureView()
    }
    
    // MARK: Layout
    let firstContainer = UIView()
    let secondContainer = UIView()
    let thirdContainer = UIView()
    let buttonsContainer = UIView()

    func setBackground() {
        backgroundImage = BackgroundImageView(frame: view.bounds)
        self.view.sendSubviewToBack(backgroundImage)
    }
    
    func addSubviews() {
        [backgroundImage, firstContainer, secondContainer, thirdContainer,
         loginButton,
        ].forEach{view.addSubview($0)}
        
        [headerLable, subHeaderLable
        ].forEach{secondContainer.addSubview($0)}
        
        thirdContainer.addSubview(buttonsContainer)
        [loginButton, exploreButton
        ].forEach{buttonsContainer.addSubview($0)}
    }
    
    func disableAutoresizing() {
        [firstContainer, secondContainer, thirdContainer, headerLable,
         subHeaderLable, loginButton, exploreButton, buttonsContainer,
        ].forEach{$0.translatesAutoresizingMaskIntoConstraints = false}
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundImage.center = view.center
        let twoButtonsPlusSpacingHeight = Float(120)
//        [firstContainer, thirdContainer].forEach{$0.backgroundColor = .cyan}
//        secondContainer.backgroundColor = .yellow
        
        let constraints: [NSLayoutConstraint] = [
            firstContainer.topAnchor.constraint(equalTo: view.topAnchor),
            firstContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            firstContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            firstContainer.heightAnchor.constraint(
                equalTo: view.heightAnchor, multiplier: 0.25
            ),
            
            thirdContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            thirdContainer.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 16
            ),
            thirdContainer.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -16
            ),
            thirdContainer.heightAnchor.constraint(
                equalTo: view.heightAnchor, multiplier: 0.25
            ),
            
            secondContainer.topAnchor.constraint(equalTo: firstContainer.bottomAnchor),
            secondContainer.bottomAnchor.constraint(equalTo: thirdContainer.topAnchor),
            secondContainer.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 16
            ),
            secondContainer.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -16
            ),
            
            headerLable.centerYAnchor.constraint(
                equalTo: secondContainer.centerYAnchor
            ),
            headerLable.widthAnchor.constraint(
                equalTo: secondContainer.widthAnchor, multiplier: 1
            ),
            
            subHeaderLable.topAnchor.constraint(equalTo: headerLable.bottomAnchor),
            subHeaderLable.widthAnchor.constraint(
                equalTo: secondContainer.widthAnchor, multiplier: 1
            ),
            subHeaderLable.bottomAnchor.constraint(
                equalTo: secondContainer.bottomAnchor
            ),
            
            buttonsContainer.centerXAnchor.constraint(
                equalTo: thirdContainer.centerXAnchor
            ),
            buttonsContainer.centerYAnchor.constraint(
                equalTo: thirdContainer.centerYAnchor
            ),
            buttonsContainer.widthAnchor.constraint(
                equalTo: thirdContainer.widthAnchor, multiplier: 1
            ),
            buttonsContainer.heightAnchor.constraint(
                equalToConstant: CGFloat(twoButtonsPlusSpacingHeight)
            ),
            
            loginButton.leadingAnchor.constraint(
                equalTo: buttonsContainer.leadingAnchor
            ),
            loginButton.trailingAnchor.constraint(
                equalTo: buttonsContainer.trailingAnchor
            ),
            loginButton.topAnchor.constraint(
                equalTo: buttonsContainer.topAnchor
            ),
            loginButton.heightAnchor.constraint(equalToConstant: 56),
            
            exploreButton.leadingAnchor.constraint(
                equalTo: buttonsContainer.leadingAnchor
            ),
            exploreButton.trailingAnchor.constraint(
                equalTo: buttonsContainer.trailingAnchor
            ),
            exploreButton.bottomAnchor.constraint(
                equalTo: buttonsContainer.bottomAnchor
            ),
            exploreButton.heightAnchor.constraint(equalToConstant: 56),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
