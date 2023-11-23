

import UIKit

final class CurrentTableViewCell: UITableViewCell {
    
    private enum Constants {
        static let horizontalPadding: CGFloat = 16.0
        static let verticalSpacing: CGFloat = 12.0
        static let halfCircleHorizontalPadding: CGFloat = 33.0
        static let iconSize: CGFloat = 20.0
    }
    
    static let id = "CurrentTableViewCell"
    
    private let dateFormatter = CustomDateFormatter()
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .systemBlue
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
        return containerView
    }()
    
    private lazy var tempRangeLabel: UILabel = {
        let tempRangeLabel = UILabel()
        tempRangeLabel.translatesAutoresizingMaskIntoConstraints = false
        tempRangeLabel.font = .systemFont(ofSize: 16, weight: .regular)
        tempRangeLabel.textColor = .white

        return tempRangeLabel
    }()
    
    private lazy var currentTemp: UILabel = {
        let currentTemp = UILabel()
        currentTemp.translatesAutoresizingMaskIntoConstraints = false
        currentTemp.font = .systemFont(ofSize: 36, weight: .semibold)
        currentTemp.textColor = .white
        return currentTemp
    }()
    
    private lazy var infoStackView: UIStackView = {
        let infoStackView = UIStackView()
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.axis = .horizontal
        infoStackView.spacing = 5
        infoStackView.alignment = .center
        infoStackView.distribution = .equalSpacing
        infoStackView.addArrangedSubview(infoIcon)
        infoStackView.addArrangedSubview(infoLabel)
        return infoStackView
    }()
    
    private lazy var infoIcon: UIImageView = {
        let infoIcon = UIImageView()
        infoIcon.image = UIImage()
        infoIcon.translatesAutoresizingMaskIntoConstraints = false
        return infoIcon
    }()
    
    private lazy var infoLabel: UILabel = {
        let infoLabel = UILabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.font = .systemFont(ofSize: 16, weight: .regular)
        infoLabel.textColor = .white
        return infoLabel
    }()
    
    private lazy var currentWeatherStackView: UIStackView = {
        let currentWeatherStackView = UIStackView()
        currentWeatherStackView.translatesAutoresizingMaskIntoConstraints = false
        currentWeatherStackView.axis = .horizontal
        currentWeatherStackView.spacing = 10
        currentWeatherStackView.alignment = .center
        currentWeatherStackView.distribution = .equalSpacing
        currentWeatherStackView.addArrangedSubview(precipitationStackView)
        currentWeatherStackView.addArrangedSubview(windStackView)
        currentWeatherStackView.addArrangedSubview(humidityStackView)
        return currentWeatherStackView
    }()
    
    private lazy var precipitationStackView: UIStackView = {
        let precipitationStackView = UIStackView()
        precipitationStackView.translatesAutoresizingMaskIntoConstraints = false
        precipitationStackView.axis = .horizontal
        precipitationStackView.spacing = 1
        precipitationStackView.addArrangedSubview(precipitationIcon)
        precipitationStackView.addArrangedSubview(precipitationAmountLabel)
        return precipitationStackView
    }()
    
    private lazy var precipitationIcon: UIImageView = {
        let precipitationIcon = UIImageView()
        precipitationIcon.image = UIImage(named: "precipitationAmount")
        precipitationIcon.translatesAutoresizingMaskIntoConstraints = false
        precipitationIcon.tintColor = .black
        return precipitationIcon
    }()
    
    private lazy var precipitationAmountLabel: UILabel = {
        let rainPossibilityLabel = UILabel()
        rainPossibilityLabel.translatesAutoresizingMaskIntoConstraints = false
        rainPossibilityLabel.font = .systemFont(ofSize: 14, weight: .regular)
        rainPossibilityLabel.textColor = .white
        return rainPossibilityLabel
    }()
    
    private lazy var windStackView: UIStackView = {
        let windStackView = UIStackView()
        windStackView.translatesAutoresizingMaskIntoConstraints = false
        windStackView.axis = .horizontal
        windStackView.spacing = 1
        windStackView.addArrangedSubview(windIcon)
        windStackView.addArrangedSubview(windSpeedLabel)
        return windStackView
    }()
    
    private lazy var windIcon: UIImageView = {
        let windIcon = UIImageView()
        windIcon.image = UIImage(named: "windSpeed")
        windIcon.translatesAutoresizingMaskIntoConstraints = false
        windIcon.tintColor = .white
        return windIcon
    }()
    
    private lazy var windSpeedLabel: UILabel = {
        let windSpeedLabel = UILabel()
        windSpeedLabel.translatesAutoresizingMaskIntoConstraints = false
        windSpeedLabel.font = .systemFont(ofSize: 14, weight: .regular)
        windSpeedLabel.textColor = .white
        return windSpeedLabel
    }()
    
    private lazy var humidityStackView: UIStackView = {
        let humidityStackView = UIStackView()
        humidityStackView.translatesAutoresizingMaskIntoConstraints = false
        humidityStackView.axis = .horizontal
        humidityStackView.spacing = 1
        humidityStackView.addArrangedSubview(humidityIcon)
        humidityStackView.addArrangedSubview(humidityLabel)
        return humidityStackView
    }()
    
    private lazy var humidityIcon: UIImageView = {
        let humidityIcon = UIImageView()
        humidityIcon.image = UIImage(named: "humidityPercent")
        humidityIcon.translatesAutoresizingMaskIntoConstraints = false
        return humidityIcon
    }()
    
    private lazy var humidityLabel: UILabel = {
        let windSpeedLabel = UILabel()
        windSpeedLabel.translatesAutoresizingMaskIntoConstraints = false
        windSpeedLabel.font = .systemFont(ofSize: 14, weight: .regular)
        windSpeedLabel.textColor = .white
        return windSpeedLabel
    }()
    
    private lazy var currentTimeLabel: UILabel = {
        let currentTimeLabel = UILabel()
        currentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        currentTimeLabel.font = .systemFont(ofSize: 16, weight: .regular)
        currentTimeLabel.textColor = .systemYellow
        return currentTimeLabel
    }()
    
    private lazy var sunriseIcon: UIImageView = {
        let sunriseIcon = UIImageView(image: UIImage(systemName: "sunrise"))
        sunriseIcon.translatesAutoresizingMaskIntoConstraints = false
        sunriseIcon.tintColor = .systemYellow
        return sunriseIcon
    }()
    
    private lazy var sunriseTimeLabel: UILabel = {
        let sunriseTimeLabel = UILabel()
        sunriseTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        sunriseTimeLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        sunriseTimeLabel.textColor = .white
        return sunriseTimeLabel
    }()
    
    private lazy var sunsetIcon: UIImageView = {
        let sunsetIcon = UIImageView(image: UIImage(systemName: "sunset"))
        sunsetIcon.translatesAutoresizingMaskIntoConstraints = false
        sunsetIcon.tintColor = .systemYellow
        return sunsetIcon
    }()
    
    private lazy var sunsetTimeLabel: UILabel = {
        let sunsetTimeLabel = UILabel()
        sunsetTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        sunsetTimeLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        sunsetTimeLabel.textColor = .white
        return sunsetTimeLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(containerView)
        addSemicircle()
        containerView.addSubview(tempRangeLabel)
        containerView.addSubview(currentTemp)
        containerView.addSubview(infoStackView)
        containerView.addSubview(currentWeatherStackView)
        containerView.addSubview(currentTimeLabel)
        containerView.addSubview(sunriseIcon)
        containerView.addSubview(sunriseTimeLabel)
        containerView.addSubview(sunsetIcon)
        containerView.addSubview(sunsetTimeLabel)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            tempRangeLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 33),
            tempRangeLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            currentTemp.topAnchor.constraint(equalTo: tempRangeLabel.bottomAnchor, constant: 5),
            currentTemp.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            infoStackView.topAnchor.constraint(equalTo: currentTemp.bottomAnchor, constant: 5),
            infoStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            currentWeatherStackView.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: 8),
            currentWeatherStackView.heightAnchor.constraint(equalToConstant: 30),
            currentWeatherStackView.leadingAnchor.constraint(lessThanOrEqualTo: sunriseIcon.trailingAnchor, constant: 5),
            currentWeatherStackView.trailingAnchor.constraint(greaterThanOrEqualTo: sunsetIcon.leadingAnchor, constant: -5),
            currentWeatherStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            currentTimeLabel.topAnchor.constraint(equalTo: currentWeatherStackView.bottomAnchor, constant: 10),
            currentTimeLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            sunriseIcon.topAnchor.constraint(equalTo: containerView.topAnchor, constant: (contentView.frame.width - Constants.horizontalPadding) / 2),
            sunriseIcon.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: -contentView.frame.width / 2 + Constants.halfCircleHorizontalPadding),
            
            sunriseTimeLabel.topAnchor.constraint(equalTo: sunriseIcon.bottomAnchor, constant: 1),
            sunriseTimeLabel.centerXAnchor.constraint(equalTo: sunriseIcon.centerXAnchor),
            
            sunsetIcon.topAnchor.constraint(equalTo: containerView.topAnchor, constant: (contentView.frame.width - Constants.horizontalPadding) / 2),
            sunsetIcon.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: contentView.frame.width / 2 - Constants.halfCircleHorizontalPadding),
            
            sunsetTimeLabel.topAnchor.constraint(equalTo: sunsetIcon.bottomAnchor, constant: 1),
            sunsetTimeLabel.centerXAnchor.constraint(equalTo: sunsetIcon.centerXAnchor),
            
            infoIcon.widthAnchor.constraint(equalToConstant: Constants.iconSize),
            infoIcon.heightAnchor.constraint(equalToConstant: Constants.iconSize),
            
            precipitationIcon.widthAnchor.constraint(equalToConstant: Constants.iconSize),
            precipitationIcon.heightAnchor.constraint(equalToConstant: Constants.iconSize),
            
            windIcon.widthAnchor.constraint(equalToConstant: Constants.iconSize),
            windIcon.heightAnchor.constraint(equalToConstant: Constants.iconSize),
            
            humidityIcon.widthAnchor.constraint(equalToConstant: Constants.iconSize),
            humidityIcon.heightAnchor.constraint(equalToConstant: Constants.iconSize)
            
        ])
    }
    
    private func addSemicircle() {
        let semicircleLine = CAShapeLayer()
    
        let radius = contentView.frame.width / 2 - Constants.halfCircleHorizontalPadding
        let centerX = UIScreen.main.bounds.width / 2 - Constants.horizontalPadding
        let centerY = contentView.frame.height / 2 + radius
                
        let path = UIBezierPath(arcCenter: CGPoint(x: centerX, y: centerY),
                                radius: radius,
                                startAngle: 0,
                                endAngle: CGFloat.pi,
                                clockwise: false)
       
        semicircleLine.path = path.cgPath
        semicircleLine.lineWidth = 3.0
        semicircleLine.strokeColor = UIColor.systemYellow.cgColor
        semicircleLine.fillColor = UIColor.clear.cgColor
        containerView.layer.addSublayer(semicircleLine)
    }
    
    func sunData(with model: Astronomy, units: Settings) {
        guard let forecastSet = model.astronomyForecast,
              let forecast = Array(forecastSet) as? [AstronomyForecast] else {
            return
        }
        if let sunrise = forecast.first?.sunrise,
           let sunset = forecast.first?.sunset {
            switch units.timeFormat {
            case .twelveHour:
                sunriseTimeLabel.text = dateFormatter.formattedStringToString(date: sunrise, dateFormat: "hh:mm", locale: nil, timeZone: TimeZone(identifier: model.weather?.timeZone ?? ""))
                sunsetTimeLabel.text = dateFormatter.formattedStringToString(date: sunset, dateFormat: "hh:mm", locale: nil, timeZone: TimeZone(identifier: model.weather?.timeZone ?? ""))
            case .twentyFourHour:
                sunriseTimeLabel.text = dateFormatter.formattedStringToString(date: sunrise, dateFormat: "HH:mm", locale: nil, timeZone: TimeZone(identifier: model.weather?.timeZone ?? ""))
                sunsetTimeLabel.text = dateFormatter.formattedStringToString(date: sunset, dateFormat: "HH:mm", locale: nil, timeZone: TimeZone(identifier: model.weather?.timeZone ?? ""))
            }
        }
    }
}

extension CurrentTableViewCell: Configurable {
    func configure(with timePeriod: CurrentTimePeriod, units: Settings, at index: Int, at part: Int? = nil, at row: Int? = nil) {
        
        switch units.temperatureUnit {
        case .celsius:
            tempRangeLabel.text = "\(UnitsFormatter.celsius.format(timePeriod.next6HoursForecast.airTemperatureMin)) / \(UnitsFormatter.celsius.format(timePeriod.next6HoursForecast.airTemperatureMax))"
            currentTemp.text = UnitsFormatter.celsius.format(timePeriod.instantData.airTemperature)
        case .fahrenheit:
            tempRangeLabel.text = "\(UnitsFormatter.fahrenheit.format(timePeriod.next6HoursForecast.airTemperatureMin)) / \(UnitsFormatter.fahrenheit.format(timePeriod.next6HoursForecast.airTemperatureMax))"
            currentTemp.text = UnitsFormatter.fahrenheit.format(timePeriod.instantData.airTemperature)
        }
        
        switch units.windSpeedUnit {
        case .metersPerSecond:
            windSpeedLabel.text = UnitsFormatter.metersPerSecond.format(timePeriod.instantData.windSpeed)
        case .milesPerHour:
            windSpeedLabel.text = UnitsFormatter.milesPerHour.format(timePeriod.instantData.windSpeed)
        }
        
        switch units.timeFormat {
        case .twelveHour:
            currentTimeLabel.text = dateFormatter.formattedCurrentDate(dateFormat: "hh:mm, E d MMMM", locale: Locale(identifier: "ru_RU"), timeZone: TimeZone(identifier: timePeriod.timeZone ?? ""))
        case .twentyFourHour:
            currentTimeLabel.text = dateFormatter.formattedCurrentDate(dateFormat: "HH:mm, E d MMMM", locale: Locale(identifier: "ru_RU"), timeZone: TimeZone(identifier: timePeriod.timeZone ?? ""))
        }
        
        switch units.precipitationUnit {
        case .inches:
            precipitationAmountLabel.text = UnitsFormatter.inches.format(timePeriod.next1HoursForecast.precipitationAmount)
        case .millimeters:
            precipitationAmountLabel.text = UnitsFormatter.millimeters.format(timePeriod.next1HoursForecast.precipitationAmount)
        }
        
        if let symbolCode = timePeriod.next1HoursForecast.symbolCode {
            infoIcon.image = UIImage(named: symbolCode)
            let currentWeatherDescription = CurrentWeatherDescription(symbolCode: symbolCode)
            infoLabel.text = currentWeatherDescription?.description
        }
        
        humidityLabel.text = "\(timePeriod.instantData.relativeHumidity)%"
    }
}

