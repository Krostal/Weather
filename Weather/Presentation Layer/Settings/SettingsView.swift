

import UIKit

final class SettingsView: UIView {
    
    private enum Constants {
        static let horizontalSpacing: CGFloat = 16
        static let verticalSpacing: CGFloat = 25
        static let stackViewWidth: CGFloat = 80
    }
    
    private lazy var cloud1View: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "cloud1"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var cloud2View: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "cloud2"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var settingsView: UIView = {
        let settingsView = UIView()
        settingsView.translatesAutoresizingMaskIntoConstraints = false
        settingsView.layer.cornerRadius = 10
        settingsView.backgroundColor = .systemGray6
        return settingsView
    }()
    
    private lazy var cloud3View: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "cloud3"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var settingsLabel: UILabel = {
        let settingsLabel = UILabel()
        settingsLabel.translatesAutoresizingMaskIntoConstraints = false
        settingsLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        settingsLabel.textColor = .black
        settingsLabel.text = "Настройки"
        return settingsLabel
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let temperatureLabel = UILabel()
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.font = .systemFont(ofSize: 16, weight: .regular)
        temperatureLabel.textColor = .systemGray
        temperatureLabel.text = "Температура"
        return temperatureLabel
    }()
    
    private lazy var temperatureStackView: UIStackView = {
        let temperatureStackView = UIStackView()
        temperatureStackView.translatesAutoresizingMaskIntoConstraints = false
        temperatureStackView.axis = .horizontal
        temperatureStackView.alignment = .center
        temperatureStackView.distribution = .equalSpacing
        temperatureStackView.spacing = 0
        temperatureStackView.layer.cornerRadius = 5
        temperatureStackView.clipsToBounds = true
        temperatureStackView.addArrangedSubview(celsiusLabel)
        temperatureStackView.addArrangedSubview(fahrenheitLabel)
        return temperatureStackView
    }()
    
    private lazy var celsiusLabel: UILabel = {
        let celsiusLabel = UILabel()
        celsiusLabel.translatesAutoresizingMaskIntoConstraints = false
        celsiusLabel.font = .systemFont(ofSize: 16, weight: .regular)
        celsiusLabel.textColor = .white
        celsiusLabel.backgroundColor = .systemBlue
        celsiusLabel.textAlignment = .center
        celsiusLabel.text = "C°"
        return celsiusLabel
    }()
    
    private lazy var fahrenheitLabel: UILabel = {
        let celsiusLabel = UILabel()
        celsiusLabel.translatesAutoresizingMaskIntoConstraints = false
        celsiusLabel.font = .systemFont(ofSize: 16, weight: .regular)
        celsiusLabel.textColor = .black
        celsiusLabel.backgroundColor = .white
        celsiusLabel.textAlignment = .center
        celsiusLabel.text = "F"
        return celsiusLabel
    }()
    
    private lazy var windSpeedLabel: UILabel = {
        let windSpeedLabel = UILabel()
        windSpeedLabel.translatesAutoresizingMaskIntoConstraints = false
        windSpeedLabel.font = .systemFont(ofSize: 16, weight: .regular)
        windSpeedLabel.textColor = .systemGray
        windSpeedLabel.text = "Cкорость ветра"
        return windSpeedLabel
    }()
    
    private lazy var windSpeedStackView: UIStackView = {
        let windSpeedStackView = UIStackView()
        windSpeedStackView.translatesAutoresizingMaskIntoConstraints = false
        windSpeedStackView.axis = .horizontal
        windSpeedStackView.spacing = 0
        windSpeedStackView.layer.cornerRadius = 5
        windSpeedStackView.clipsToBounds = true
        windSpeedStackView.addArrangedSubview(milesLabel)
        windSpeedStackView.addArrangedSubview(kmLabel)
        return windSpeedStackView
    }()
    
    private lazy var milesLabel: UILabel = {
        let milesLabel = UILabel()
        milesLabel.translatesAutoresizingMaskIntoConstraints = false
        milesLabel.font = .systemFont(ofSize: 16, weight: .regular)
        milesLabel.textColor = .white
        milesLabel.backgroundColor = .systemBlue
        milesLabel.textAlignment = .center
        milesLabel.text = "Mi"
        return milesLabel
    }()
    
    private lazy var kmLabel: UILabel = {
        let kmLabel = UILabel()
        kmLabel.translatesAutoresizingMaskIntoConstraints = false
        kmLabel.font = .systemFont(ofSize: 16, weight: .regular)
        kmLabel.textColor = .black
        kmLabel.backgroundColor = .white
        kmLabel.textAlignment = .center
        kmLabel.text = "Km"
        return kmLabel
    }()
    
    private lazy var timeFormatLabel: UILabel = {
        let timeFormatLabel = UILabel()
        timeFormatLabel.translatesAutoresizingMaskIntoConstraints = false
        timeFormatLabel.font = .systemFont(ofSize: 16, weight: .regular)
        timeFormatLabel.textColor = .systemGray
        timeFormatLabel.text = "Формат времени"
        return timeFormatLabel
    }()
    
    private lazy var timeFormatStackView: UIStackView = {
        let timeFormatStackView = UIStackView()
        timeFormatStackView.translatesAutoresizingMaskIntoConstraints = false
        timeFormatStackView.axis = .horizontal
        timeFormatStackView.spacing = 0
        timeFormatStackView.layer.cornerRadius = 5
        timeFormatStackView.clipsToBounds = true
        timeFormatStackView.addArrangedSubview(twelveLabel)
        timeFormatStackView.addArrangedSubview(twentyFourLabel)
        return timeFormatStackView
    }()
    
    private lazy var twelveLabel: UILabel = {
        let twelveLabel = UILabel()
        twelveLabel.translatesAutoresizingMaskIntoConstraints = false
        twelveLabel.font = .systemFont(ofSize: 16, weight: .regular)
        twelveLabel.textColor = .white
        twelveLabel.backgroundColor = .systemBlue
        twelveLabel.textAlignment = .center
        twelveLabel.text = "12"
        return twelveLabel
    }()
    
    private lazy var twentyFourLabel: UILabel = {
        let twentyFourLabel = UILabel()
        twentyFourLabel.translatesAutoresizingMaskIntoConstraints = false
        twentyFourLabel.font = .systemFont(ofSize: 16, weight: .regular)
        twentyFourLabel.textColor = .black
        twentyFourLabel.backgroundColor = .white
        twentyFourLabel.textAlignment = .center
        twentyFourLabel.text = "24"
        return twentyFourLabel
    }()
    
    private lazy var notificationLabel: UILabel = {
        let notificationLabel = UILabel()
        notificationLabel.translatesAutoresizingMaskIntoConstraints = false
        notificationLabel.font = .systemFont(ofSize: 16, weight: .regular)
        notificationLabel.textColor = .systemGray
        notificationLabel.text = "Уведомления"
        return notificationLabel
    }()
    
    private lazy var notificationStackView: UIStackView = {
        let notificationStackView = UIStackView()
        notificationStackView.translatesAutoresizingMaskIntoConstraints = false
        notificationStackView.axis = .horizontal
        notificationStackView.spacing = 0
        notificationStackView.layer.cornerRadius = 5
        notificationStackView.clipsToBounds = true
        notificationStackView.addArrangedSubview(onLabel)
        notificationStackView.addArrangedSubview(offLabel)
        return notificationStackView
    }()
    
    private lazy var onLabel: UILabel = {
        let onLabel = UILabel()
        onLabel.translatesAutoresizingMaskIntoConstraints = false
        onLabel.font = .systemFont(ofSize: 16, weight: .regular)
        onLabel.textColor = .white
        onLabel.backgroundColor = .systemBlue
        onLabel.textAlignment = .center
        onLabel.text = "On"
        return onLabel
    }()
    
    private lazy var offLabel: UILabel = {
        let offLabel = UILabel()
        offLabel.translatesAutoresizingMaskIntoConstraints = false
        offLabel.font = .systemFont(ofSize: 16, weight: .regular)
        offLabel.textColor = .black
        offLabel.backgroundColor = .white
        offLabel.textAlignment = .center
        offLabel.text = "Off"
        return offLabel
    }()
    
    private lazy var setButton: UIButton = {
        let setButton = UIButton(type: .system)
        setButton.translatesAutoresizingMaskIntoConstraints = false
        setButton.setTitle("Установить", for: .normal)
        setButton.setTitleColor(.black, for: .normal)
        setButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        setButton.layer.cornerRadius = 10
        setButton.backgroundColor = .systemOrange
        setButton.addTarget(self, action: #selector(agreeButtonTapped), for: .touchUpInside)
        return setButton
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
        addSubview(cloud1View)
        addSubview(cloud2View)
        addSubview(settingsView)
        addSubview(cloud3View)
        settingsView.addSubview(settingsLabel)
        settingsView.addSubview(temperatureLabel)
        settingsView.addSubview(temperatureStackView)
        settingsView.addSubview(windSpeedLabel)
        settingsView.addSubview(windSpeedStackView)
        settingsView.addSubview(timeFormatLabel)
        settingsView.addSubview(timeFormatStackView)
        settingsView.addSubview(notificationLabel)
        settingsView.addSubview(notificationStackView)
        settingsView.addSubview(setButton)
    }
    
    private func setupLayout() {
        
        NSLayoutConstraint.activate([
            
            cloud1View.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.verticalSpacing),
            cloud1View.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            
            cloud2View.topAnchor.constraint(equalTo: cloud1View.bottomAnchor, constant: Constants.verticalSpacing),
            cloud2View.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            
            settingsView.centerYAnchor.constraint(equalTo: centerYAnchor),
            settingsView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Constants.horizontalSpacing),
            settingsView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Constants.horizontalSpacing),
            settingsView.heightAnchor.constraint(equalToConstant: 330),
            
            cloud3View.topAnchor.constraint(equalTo: settingsView.bottomAnchor, constant: Constants.verticalSpacing),
            cloud3View.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            
            settingsLabel.topAnchor.constraint(equalTo: settingsView.topAnchor, constant: Constants.verticalSpacing),
            settingsLabel.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor, constant: Constants.horizontalSpacing),
            settingsLabel.trailingAnchor.constraint(equalTo: settingsView.trailingAnchor, constant: -Constants.horizontalSpacing),
            
            temperatureLabel.topAnchor.constraint(equalTo: settingsLabel.bottomAnchor, constant: Constants.verticalSpacing),
            temperatureLabel.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor, constant: Constants.horizontalSpacing),
            
            temperatureStackView.centerYAnchor.constraint(equalTo: temperatureLabel.centerYAnchor),
            temperatureStackView.trailingAnchor.constraint(equalTo: settingsView.trailingAnchor, constant: -Constants.horizontalSpacing),
            temperatureStackView.widthAnchor.constraint(equalToConstant: Constants.stackViewWidth),
            celsiusLabel.widthAnchor.constraint(equalToConstant: Constants.stackViewWidth / 2),
            fahrenheitLabel.widthAnchor.constraint(equalToConstant: Constants.stackViewWidth / 2),
            
            windSpeedLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: Constants.verticalSpacing),
            windSpeedLabel.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor, constant: Constants.horizontalSpacing),
            
            windSpeedStackView.centerYAnchor.constraint(equalTo: windSpeedLabel.centerYAnchor),
            windSpeedStackView.trailingAnchor.constraint(equalTo: settingsView.trailingAnchor, constant: -Constants.horizontalSpacing),
            windSpeedStackView.widthAnchor.constraint(equalToConstant: Constants.stackViewWidth),
            milesLabel.widthAnchor.constraint(equalToConstant: Constants.stackViewWidth / 2),
            kmLabel.widthAnchor.constraint(equalToConstant: Constants.stackViewWidth / 2),
            
            timeFormatLabel.topAnchor.constraint(equalTo: windSpeedLabel.bottomAnchor, constant: Constants.verticalSpacing),
            timeFormatLabel.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor, constant: Constants.horizontalSpacing),
            
            timeFormatStackView.centerYAnchor.constraint(equalTo: timeFormatLabel.centerYAnchor),
            timeFormatStackView.trailingAnchor.constraint(equalTo: settingsView.trailingAnchor, constant: -Constants.horizontalSpacing),
            timeFormatStackView.widthAnchor.constraint(equalToConstant: Constants.stackViewWidth),
            twelveLabel.widthAnchor.constraint(equalToConstant: Constants.stackViewWidth / 2),
            twentyFourLabel.widthAnchor.constraint(equalToConstant: Constants.stackViewWidth / 2),

            notificationLabel.topAnchor.constraint(equalTo: timeFormatLabel.bottomAnchor, constant: Constants.verticalSpacing),
            notificationLabel.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor, constant: Constants.horizontalSpacing),
            
            notificationStackView.centerYAnchor.constraint(equalTo: notificationLabel.centerYAnchor),
            notificationStackView.trailingAnchor.constraint(equalTo: settingsView.trailingAnchor, constant: -Constants.horizontalSpacing),
            notificationStackView.widthAnchor.constraint(equalToConstant: Constants.stackViewWidth),
            onLabel.widthAnchor.constraint(equalToConstant: Constants.stackViewWidth / 2),
            offLabel.widthAnchor.constraint(equalToConstant: Constants.stackViewWidth / 2),

            setButton.bottomAnchor.constraint(equalTo: settingsView.bottomAnchor, constant: -Constants.verticalSpacing),
            setButton.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor, constant: 25),
            setButton.trailingAnchor.constraint(equalTo: settingsView.trailingAnchor, constant: -25),
            setButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    @objc func agreeButtonTapped() {
        
    }
    
    @objc func denyButtonTapped() {
        
    }
    
}
