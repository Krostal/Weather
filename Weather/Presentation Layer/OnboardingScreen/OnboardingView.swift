

import UIKit

protocol OnboardingViewDelegate: AnyObject {
    func locationAllowed()
    func locationDenied()
}

final class OnboardingView: UIView {
    
    weak var delegate: OnboardingViewDelegate?
    
    private enum Constants {
        static let horizontalSpacing: CGFloat = 16
        static let verticalSpacing: CGFloat = 25
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "onboardingImage"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var permissonLabel: UILabel = {
        let permissonLabel = UILabel()
        permissonLabel.translatesAutoresizingMaskIntoConstraints = false
        permissonLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        permissonLabel.textColor = .black
        permissonLabel.textAlignment = .center
        permissonLabel.numberOfLines = 0
        permissonLabel.text = "Разрешить приложению Weather использовать данные о местоположении вашего устройства"
        return permissonLabel
    }()
    
    private lazy var forWhatLabel: UILabel = {
        let forWhatLabel = UILabel()
        forWhatLabel.translatesAutoresizingMaskIntoConstraints = false
        forWhatLabel.font = .systemFont(ofSize: 14, weight: .regular)
        forWhatLabel.textColor = .black
        forWhatLabel.textAlignment = .center
        forWhatLabel.numberOfLines = 0
        forWhatLabel.text = "Чтобы получить более точные прогнозы погоды во время движения или путешествия"
        return forWhatLabel
    }()
    
    private lazy var choiceLabel: UILabel = {
        let choiceLabel = UILabel()
        choiceLabel.translatesAutoresizingMaskIntoConstraints = false
        choiceLabel.font = .systemFont(ofSize: 14, weight: .regular)
        choiceLabel.textColor = .black
        choiceLabel.textAlignment = .center
        choiceLabel.numberOfLines = 0
        choiceLabel.text = "Вы можете изменить свой выбор в любое время из меню приложения"
        return choiceLabel
    }()
    
    lazy var agreeButton: UIButton = {
        let agreeButton = UIButton(type: .system)
        agreeButton.translatesAutoresizingMaskIntoConstraints = false
        agreeButton.setTitle("ИСПОЛЬЗОВАТЬ МЕСТОПОЛОЖЕНИЕ УСТРОЙСТВА", for: .normal)
        agreeButton.setTitleColor(.black, for: .normal)
        agreeButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        agreeButton.layer.cornerRadius = 10
        agreeButton.backgroundColor = .systemOrange
        agreeButton.addTarget(self, action: #selector(agreeButtonTapped), for: .touchUpInside)
        return agreeButton
    }()
    
    private lazy var denyButton: UIButton = {
        let denyButton = UIButton(type: .system)
        denyButton.translatesAutoresizingMaskIntoConstraints = false
        denyButton.setTitle("НЕТ, Я БУДУ ДОБАВЛЯТЬ ЛОКАЦИИ", for: .normal)
        denyButton.setTitleColor(.black, for: .normal)
        denyButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        denyButton.addTarget(self, action: #selector(denyButtonTapped), for: .touchUpInside)
        denyButton.contentHorizontalAlignment = .right
        return denyButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupView() {
        backgroundColor = .systemBlue
    }
    
    private func addSubviews() {
        addSubview(imageView)
        addSubview(permissonLabel)
        addSubview(forWhatLabel)
        addSubview(choiceLabel)
        addSubview(agreeButton)
        addSubview(denyButton)
    }
    
    private func setupLayout() {
        
        NSLayoutConstraint.activate([
            
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 80),
            
            permissonLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Constants.verticalSpacing),
            permissonLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Constants.horizontalSpacing),
            permissonLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Constants.horizontalSpacing),
            
            forWhatLabel.topAnchor.constraint(equalTo: permissonLabel.bottomAnchor, constant: Constants.verticalSpacing),
            forWhatLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Constants.horizontalSpacing),
            forWhatLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Constants.horizontalSpacing),
            
            choiceLabel.topAnchor.constraint(equalTo: forWhatLabel.bottomAnchor, constant: Constants.verticalSpacing),
            choiceLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Constants.horizontalSpacing),
            choiceLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Constants.horizontalSpacing),
            
            agreeButton.topAnchor.constraint(equalTo: choiceLabel.bottomAnchor, constant: Constants.verticalSpacing),
            agreeButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Constants.horizontalSpacing),
            agreeButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Constants.horizontalSpacing),
            agreeButton.heightAnchor.constraint(equalToConstant: 40),
            
            denyButton.topAnchor.constraint(equalTo: agreeButton.bottomAnchor, constant: Constants.verticalSpacing/2),
            denyButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Constants.horizontalSpacing),
            denyButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Constants.horizontalSpacing),
            denyButton.heightAnchor.constraint(equalToConstant: 25),
        ])
    }
    
    @objc func agreeButtonTapped() {
        delegate?.locationAllowed()
    }
    
    @objc func denyButtonTapped() {
        delegate?.locationDenied()
        denyButton.isEnabled = false
    }
    
}
