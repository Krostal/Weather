

import UIKit

protocol SettingsViewDelegate: AnyObject {
    func setUnits(temperatureUnit: String, windSpeedUnit: String, timeFormat: String, precipitationUnit: String)
    func deleteButtonTapped()
}

final class SettingsView: UIView {
    
    private enum Constants {
        static let horizontalSpacing: CGFloat = 16
        static let verticalSpacing: CGFloat = 25
        static let stackViewWidth: CGFloat = 80
        static let padding: CGFloat = 25
        static let buttonHeight: CGFloat = 40
    }
    
    weak var delegate: SettingsViewDelegate?
    
    var settings = SettingsManager.shared.settings
    
    var selectedTemperatureUnit: String = "°"
    var selectedWindSpeedUnit: String = "м/с"
    var selectedTimeFormat: String = "24"
    var selectedPrecipitationUnit: String = "мм"
    
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
        celsiusLabel.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(celsiusLabelTapped))
        celsiusLabel.addGestureRecognizer(tapGestureRecognizer)
        return celsiusLabel
    }()
    
    private lazy var fahrenheitLabel: UILabel = {
        let fahrenheitLabel = UILabel()
        fahrenheitLabel.translatesAutoresizingMaskIntoConstraints = false
        fahrenheitLabel.font = .systemFont(ofSize: 16, weight: .regular)
        fahrenheitLabel.textColor = .black
        fahrenheitLabel.backgroundColor = .white
        fahrenheitLabel.textAlignment = .center
        fahrenheitLabel.text = "F"
        fahrenheitLabel.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(fahrenheitLabelTapped))
        fahrenheitLabel.addGestureRecognizer(tapGestureRecognizer)
        return fahrenheitLabel
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
        windSpeedStackView.addArrangedSubview(metersLabel)
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
        milesLabel.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(milesLabelTapped))
        milesLabel.addGestureRecognizer(tapGestureRecognizer)
        return milesLabel
    }()
    
    private lazy var metersLabel: UILabel = {
        let metresLabel = UILabel()
        metresLabel.translatesAutoresizingMaskIntoConstraints = false
        metresLabel.font = .systemFont(ofSize: 16, weight: .regular)
        metresLabel.textColor = .black
        metresLabel.backgroundColor = .white
        metresLabel.textAlignment = .center
        metresLabel.text = "m"
        metresLabel.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(metersLabelTapped))
        metresLabel.addGestureRecognizer(tapGestureRecognizer)
        return metresLabel
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
        twelveLabel.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(twelveLabelTapped))
        twelveLabel.addGestureRecognizer(tapGestureRecognizer)
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
        twentyFourLabel.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(twentyFourLabelTapped))
        twentyFourLabel.addGestureRecognizer(tapGestureRecognizer)
        return twentyFourLabel
    }()
    
    private lazy var notificationLabel: UILabel = {
        let notificationLabel = UILabel()
        notificationLabel.translatesAutoresizingMaskIntoConstraints = false
        notificationLabel.font = .systemFont(ofSize: 16, weight: .regular)
        notificationLabel.textColor = .systemGray
        notificationLabel.text = "Количество осадков"
        return notificationLabel
    }()
    
    private lazy var precipitationStackView: UIStackView = {
        let precipitationStackView = UIStackView()
        precipitationStackView.translatesAutoresizingMaskIntoConstraints = false
        precipitationStackView.axis = .horizontal
        precipitationStackView.spacing = 0
        precipitationStackView.layer.cornerRadius = 5
        precipitationStackView.clipsToBounds = true
        precipitationStackView.addArrangedSubview(inchLabel)
        precipitationStackView.addArrangedSubview(mmLabel)
        return precipitationStackView
    }()
    
    private lazy var inchLabel: UILabel = {
        let inchLabel = UILabel()
        inchLabel.translatesAutoresizingMaskIntoConstraints = false
        inchLabel.font = .systemFont(ofSize: 16, weight: .regular)
        inchLabel.textColor = .white
        inchLabel.backgroundColor = .systemBlue
        inchLabel.textAlignment = .center
        inchLabel.text = "in"
        inchLabel.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(inchLabelTapped))
        inchLabel.addGestureRecognizer(tapGestureRecognizer)
        return inchLabel
    }()
    
    private lazy var mmLabel: UILabel = {
        let mmLabel = UILabel()
        mmLabel.translatesAutoresizingMaskIntoConstraints = false
        mmLabel.font = .systemFont(ofSize: 16, weight: .regular)
        mmLabel.textColor = .black
        mmLabel.backgroundColor = .white
        mmLabel.textAlignment = .center
        mmLabel.text = "mm"
        mmLabel.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(mmLabelTapped))
        mmLabel.addGestureRecognizer(tapGestureRecognizer)
        return mmLabel
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
    
    lazy var deleteButton: UIButton = {
        let setButton = UIButton(type: .system)
        setButton.translatesAutoresizingMaskIntoConstraints = false
        setButton.setTitle("Удалить текущую страницу", for: .normal)
        setButton.setTitleColor(.systemRed, for: .normal)
        setButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        setButton.layer.cornerRadius = 10
        setButton.backgroundColor = .white
        setButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
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
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            celsiusLabel.textColor = settings.temperatureUnit == .celsius ? .white : .black
            celsiusLabel.backgroundColor = settings.temperatureUnit == .celsius ? .systemBlue : .white
            fahrenheitLabel.textColor = settings.temperatureUnit == .fahrenheit ? .white : .black
            fahrenheitLabel.backgroundColor = settings.temperatureUnit == .fahrenheit ? .systemBlue : .white
            
            metersLabel.textColor = settings.windSpeedUnit == .metersPerSecond ? .white : .black
            metersLabel.backgroundColor = settings.windSpeedUnit == .metersPerSecond ? .systemBlue : .white
            milesLabel.textColor = settings.windSpeedUnit == .milesPerHour ? .white : .black
            milesLabel.backgroundColor = settings.windSpeedUnit == .milesPerHour ? .systemBlue : .white
            
            twelveLabel.textColor = settings.timeFormat == .twelveHour ? .white : .black
            twelveLabel.backgroundColor = settings.timeFormat == .twelveHour ? .systemBlue : .white
            twentyFourLabel.textColor = settings.timeFormat == .twentyFourHour ? .white : .black
            twentyFourLabel.backgroundColor = settings.timeFormat == .twentyFourHour ? .systemBlue : .white
            
            inchLabel.textColor = settings.precipitationUnit == .inches ? .white : .black
            inchLabel.backgroundColor = settings.precipitationUnit == .inches ? .systemBlue : .white
            mmLabel.textColor = settings.precipitationUnit == .millimeters ? .white : .black
            mmLabel.backgroundColor = settings.precipitationUnit == .millimeters ? .systemBlue : .white
        }
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
        settingsView.addSubview(precipitationStackView)
        settingsView.addSubview(setButton)
        addSubview(deleteButton)
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
            metersLabel.widthAnchor.constraint(equalToConstant: Constants.stackViewWidth / 2),
            
            timeFormatLabel.topAnchor.constraint(equalTo: windSpeedLabel.bottomAnchor, constant: Constants.verticalSpacing),
            timeFormatLabel.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor, constant: Constants.horizontalSpacing),
            
            timeFormatStackView.centerYAnchor.constraint(equalTo: timeFormatLabel.centerYAnchor),
            timeFormatStackView.trailingAnchor.constraint(equalTo: settingsView.trailingAnchor, constant: -Constants.horizontalSpacing),
            timeFormatStackView.widthAnchor.constraint(equalToConstant: Constants.stackViewWidth),
            twelveLabel.widthAnchor.constraint(equalToConstant: Constants.stackViewWidth / 2),
            twentyFourLabel.widthAnchor.constraint(equalToConstant: Constants.stackViewWidth / 2),

            notificationLabel.topAnchor.constraint(equalTo: timeFormatLabel.bottomAnchor, constant: Constants.verticalSpacing),
            notificationLabel.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor, constant: Constants.horizontalSpacing),
            
            precipitationStackView.centerYAnchor.constraint(equalTo: notificationLabel.centerYAnchor),
            precipitationStackView.trailingAnchor.constraint(equalTo: settingsView.trailingAnchor, constant: -Constants.horizontalSpacing),
            precipitationStackView.widthAnchor.constraint(equalToConstant: Constants.stackViewWidth),
            inchLabel.widthAnchor.constraint(equalToConstant: Constants.stackViewWidth / 2),
            mmLabel.widthAnchor.constraint(equalToConstant: Constants.stackViewWidth / 2),

            setButton.bottomAnchor.constraint(equalTo: settingsView.bottomAnchor, constant: -Constants.verticalSpacing),
            setButton.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor, constant: Constants.padding),
            setButton.trailingAnchor.constraint(equalTo: settingsView.trailingAnchor, constant: -Constants.padding),
            setButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            
            deleteButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Constants.verticalSpacing),
            deleteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.padding),
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.padding),
            deleteButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
        ])
    }
    
    @objc func agreeButtonTapped() {
        selectedTemperatureUnit = celsiusLabel.backgroundColor == .systemBlue ? "°" : "F"
        selectedWindSpeedUnit = milesLabel.backgroundColor == .systemBlue ? "mph" : "м/с"
        selectedTimeFormat = twelveLabel.backgroundColor == .systemBlue ? "12" : "24"
        selectedPrecipitationUnit = inchLabel.backgroundColor == .systemBlue ? "'" : "мм"
        
        delegate?.setUnits(temperatureUnit: selectedTemperatureUnit, windSpeedUnit: selectedWindSpeedUnit, timeFormat: selectedTimeFormat, precipitationUnit: selectedPrecipitationUnit)
    }
    
    @objc func deleteButtonTapped() {
        delegate?.deleteButtonTapped()
    }
    
    @objc func celsiusLabelTapped() {
        celsiusLabel.textColor = .white
        celsiusLabel.backgroundColor = .systemBlue
        fahrenheitLabel.textColor = .black
        fahrenheitLabel.backgroundColor = .white
    }
    
    @objc func fahrenheitLabelTapped() {
        fahrenheitLabel.textColor = .white
        fahrenheitLabel.backgroundColor = .systemBlue
        celsiusLabel.textColor = .black
        celsiusLabel.backgroundColor = .white
    }

    @objc func metersLabelTapped() {
        metersLabel.textColor = .white
        metersLabel.backgroundColor = .systemBlue
        milesLabel.textColor = .black
        milesLabel.backgroundColor = .white
    }
    
    @objc func milesLabelTapped() {
        milesLabel.textColor = .white
        milesLabel.backgroundColor = .systemBlue
        metersLabel.textColor = .black
        metersLabel.backgroundColor = .white
    }
    
    @objc func twelveLabelTapped() {
        twelveLabel.textColor = .white
        twelveLabel.backgroundColor = .systemBlue
        twentyFourLabel.textColor = .black
        twentyFourLabel.backgroundColor = .white
    }
    
    @objc func twentyFourLabelTapped() {
        twentyFourLabel.textColor = .white
        twentyFourLabel.backgroundColor = .systemBlue
        twelveLabel.textColor = .black
        twelveLabel.backgroundColor = .white
    }
    
    @objc func inchLabelTapped() {
        inchLabel.textColor = .white
        inchLabel.backgroundColor = .systemBlue
        mmLabel.textColor = .black
        mmLabel.backgroundColor = .white
    }
    
    @objc func mmLabelTapped() {
        mmLabel.textColor = .white
        mmLabel.backgroundColor = .systemBlue
        inchLabel.textColor = .black
        inchLabel.backgroundColor = .white
    }
    
    
    
}
