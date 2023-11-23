

import UIKit

final class HourlyForecastTableViewCell: UITableViewCell {
    
    static let id = "HourlyForecastTableViewCell"
        
    private enum Constants {
        static let viewSpacing: CGFloat = 16.0
        static let itemSpacing: CGFloat = 11.0
        static let iconSize: CGFloat = 20.0
    }
    
    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        dateLabel.textColor = .black
        return dateLabel
    }()
    
    private lazy var hourlyWeatherView: UIView = {
        let hourlyWeatherView = UIView()
        hourlyWeatherView.translatesAutoresizingMaskIntoConstraints = false
        return hourlyWeatherView
    }()
    
    private lazy var leftStackView: UIStackView = {
        let leftStackView = UIStackView()
        leftStackView.translatesAutoresizingMaskIntoConstraints = false
        leftStackView.axis = .vertical
        leftStackView.spacing = Constants.itemSpacing
        leftStackView.alignment = .leading
        leftStackView.distribution = .equalCentering
        leftStackView.addArrangedSubview(timeLabel)
        leftStackView.addArrangedSubview(temperatureLabel)
        return leftStackView
    }()
    
    private lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        timeLabel.textColor = .black
        return timeLabel
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let temperatureLabel = UILabel()
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        temperatureLabel.textColor = .black
        return temperatureLabel
    }()
    
    private lazy var rightStackView: UIStackView = {
        let rightStackView = UIStackView()
        rightStackView.translatesAutoresizingMaskIntoConstraints = false
        rightStackView.axis = .vertical
        rightStackView.spacing = Constants.itemSpacing
        rightStackView.alignment = .fill
        rightStackView.distribution = .fill
        rightStackView.addArrangedSubview(weatherStackView)
        rightStackView.addArrangedSubview(windStackView)
        rightStackView.addArrangedSubview(precipitationStackView)
        rightStackView.addArrangedSubview(humidityStackView)
        rightStackView.addArrangedSubview(cloudyStackView)
        return rightStackView
    }()
    
    private lazy var weatherStackView: UIStackView = {
        let weatherStackView = UIStackView()
        weatherStackView.translatesAutoresizingMaskIntoConstraints = false
        weatherStackView.axis = .horizontal
        weatherStackView.spacing = Constants.itemSpacing
        weatherStackView.alignment = .fill
        weatherStackView.distribution = .equalSpacing
        weatherStackView.addArrangedSubview(weatherDetailStackView)
        weatherStackView.addArrangedSubview(tempLabel)
        return weatherStackView
    }()
    
    private lazy var weatherDetailStackView: UIStackView = {
        let weatherDetailStackView = UIStackView()
        weatherDetailStackView.translatesAutoresizingMaskIntoConstraints = false
        weatherDetailStackView.axis = .horizontal
        weatherDetailStackView.spacing = Constants.itemSpacing
        weatherDetailStackView.alignment = .leading
        weatherDetailStackView.distribution = .fill
        weatherDetailStackView.addArrangedSubview(weatherIcon)
        weatherDetailStackView.addArrangedSubview(weatherLabel)
        return weatherDetailStackView
    }()
    
    private lazy var weatherIcon: UIImageView = {
        let weatherIcon = UIImageView(image: UIImage(systemName: "cloud.sun"))
        weatherIcon.translatesAutoresizingMaskIntoConstraints = false
        weatherIcon.contentMode = .scaleAspectFit
        return weatherIcon
    }()
    
    private lazy var weatherLabel: UILabel = {
        let weatherLabel = UILabel()
        weatherLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherLabel.font = .systemFont(ofSize: 14, weight: .regular)
        weatherLabel.textColor = .black
        return weatherLabel
    }()
    
    private lazy var tempLabel: UILabel = {
        let tempLabel = UILabel()
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        tempLabel.font = .systemFont(ofSize: 14, weight: .regular)
        tempLabel.textColor = .systemGray
        tempLabel.text = ""
        return tempLabel
    }()
    
    private lazy var windStackView: UIStackView = {
        let windStackView = UIStackView()
        windStackView.translatesAutoresizingMaskIntoConstraints = false
        windStackView.axis = .horizontal
        windStackView.alignment = .fill
        windStackView.distribution = .equalSpacing
        windStackView.addArrangedSubview(windDetailStackView)
        windStackView.addArrangedSubview(windSpeedLabel)
        return windStackView
    }()
    
    private lazy var windDetailStackView: UIStackView = {
        let windDetailStackView = UIStackView()
        windDetailStackView.translatesAutoresizingMaskIntoConstraints = false
        windDetailStackView.axis = .horizontal
        windDetailStackView.spacing = Constants.itemSpacing
        windDetailStackView.alignment = .leading
        windDetailStackView.distribution = .fill
        windDetailStackView.addArrangedSubview(windIcon)
        windDetailStackView.addArrangedSubview(windLabel)
        return windDetailStackView
    }()
    
    private lazy var windIcon: UIImageView = {
        let windIcon = UIImageView(image: UIImage(named: "wind"))
        windIcon.translatesAutoresizingMaskIntoConstraints = false
        windIcon.contentMode = .scaleAspectFit
        return windIcon
    }()
    
    private lazy var windLabel: UILabel = {
        let windLabel = UILabel()
        windLabel.translatesAutoresizingMaskIntoConstraints = false
        windLabel.font = .systemFont(ofSize: 14, weight: .regular)
        windLabel.textColor = .black
        windLabel.text = "Ветер"
        return windLabel
    }()
    
   
    private lazy var windSpeedLabel: UILabel = {
        let windSpeedLabel = UILabel()
        windSpeedLabel.translatesAutoresizingMaskIntoConstraints = false
        windSpeedLabel.font = .systemFont(ofSize: 14, weight: .regular)
        windSpeedLabel.textColor = .systemGray
        return windSpeedLabel
    }()
    
    private lazy var precipitationStackView: UIStackView = {
        let precipitationStackView = UIStackView()
        precipitationStackView.translatesAutoresizingMaskIntoConstraints = false
        precipitationStackView.axis = .horizontal
        precipitationStackView.spacing = Constants.itemSpacing
        precipitationStackView.alignment = .fill
        precipitationStackView.distribution = .equalSpacing
        precipitationStackView.addArrangedSubview(precipitationDetailStackView)
        precipitationStackView.addArrangedSubview(precipitationAmountLabel)
        return precipitationStackView
    }()
    
    private lazy var precipitationDetailStackView: UIStackView = {
        let precipitationDetailStackView = UIStackView()
        precipitationDetailStackView.translatesAutoresizingMaskIntoConstraints = false
        precipitationDetailStackView.axis = .horizontal
        precipitationDetailStackView.spacing = Constants.itemSpacing
        precipitationDetailStackView.alignment = .leading
        precipitationDetailStackView.distribution = .fill
        precipitationDetailStackView.addArrangedSubview(precipitationIcon)
        precipitationDetailStackView.addArrangedSubview(precipitationLabel)
        return precipitationDetailStackView
    }()
    
    private lazy var precipitationIcon: UIImageView = {
        let precipitationIcon = UIImageView(image: UIImage(named: "precipitation"))
        precipitationIcon.translatesAutoresizingMaskIntoConstraints = false
        precipitationIcon.contentMode = .scaleAspectFit
        return precipitationIcon
    }()
    
    private lazy var precipitationLabel: UILabel = {
        let precipitationLabel = UILabel()
        precipitationLabel.translatesAutoresizingMaskIntoConstraints = false
        precipitationLabel.font = .systemFont(ofSize: 14, weight: .regular)
        precipitationLabel.textColor = .black
        precipitationLabel.text = "Атмосферные осадки"
        return precipitationLabel
    }()
    
   
    private lazy var precipitationAmountLabel: UILabel = {
        let precipitationAmountLabel = UILabel()
        precipitationAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        precipitationAmountLabel.font = .systemFont(ofSize: 14, weight: .regular)
        precipitationAmountLabel.textColor = .systemGray
        precipitationAmountLabel.text = "27%"
        return precipitationAmountLabel
    }()
    
    private lazy var humidityStackView: UIStackView = {
        let humidityStackView = UIStackView()
        humidityStackView.translatesAutoresizingMaskIntoConstraints = false
        humidityStackView.axis = .horizontal
        humidityStackView.spacing = Constants.itemSpacing
        humidityStackView.alignment = .fill
        humidityStackView.distribution = .equalSpacing
        humidityStackView.addArrangedSubview(humidityDetailStackView)
        humidityStackView.addArrangedSubview(relativeHumidityLabel)
        return humidityStackView
    }()
    
    private lazy var humidityDetailStackView: UIStackView = {
        let humidityDetailStackView = UIStackView()
        humidityDetailStackView.translatesAutoresizingMaskIntoConstraints = false
        humidityDetailStackView.axis = .horizontal
        humidityDetailStackView.spacing = Constants.itemSpacing
        humidityDetailStackView.alignment = .leading
        humidityDetailStackView.distribution = .fill
        humidityDetailStackView.addArrangedSubview(humidityIcon)
        humidityDetailStackView.addArrangedSubview(humidityLabel)
        return humidityDetailStackView
    }()
    
    private lazy var humidityIcon: UIImageView = {
        let precipitationIcon = UIImageView(image: UIImage(named: "humidity"))
        precipitationIcon.translatesAutoresizingMaskIntoConstraints = false
        precipitationIcon.contentMode = .scaleAspectFit
        return precipitationIcon
    }()
    
    private lazy var humidityLabel: UILabel = {
        let precipitationLabel = UILabel()
        precipitationLabel.translatesAutoresizingMaskIntoConstraints = false
        precipitationLabel.font = .systemFont(ofSize: 14, weight: .regular)
        precipitationLabel.textColor = .black
        precipitationLabel.text = "Относительная влажность"
        return precipitationLabel
    }()
    
   
    private lazy var relativeHumidityLabel: UILabel = {
        let precipitationAmountLabel = UILabel()
        precipitationAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        precipitationAmountLabel.font = .systemFont(ofSize: 14, weight: .regular)
        precipitationAmountLabel.textColor = .systemGray
        return precipitationAmountLabel
    }()
    
    private lazy var cloudyStackView: UIStackView = {
        let cloudyStackView = UIStackView()
        cloudyStackView.translatesAutoresizingMaskIntoConstraints = false
        cloudyStackView.axis = .horizontal
        cloudyStackView.spacing = 1
        cloudyStackView.alignment = .fill
        cloudyStackView.distribution = .equalSpacing
        cloudyStackView.addArrangedSubview(cloudyDetailStackView)
        cloudyStackView.addArrangedSubview(cloudyAmountLabel)
        return cloudyStackView
    }()
    
    private lazy var cloudyDetailStackView: UIStackView = {
        let cloudyDetailStackView = UIStackView()
        cloudyDetailStackView.translatesAutoresizingMaskIntoConstraints = false
        cloudyDetailStackView.axis = .horizontal
        cloudyDetailStackView.spacing = Constants.itemSpacing
        cloudyDetailStackView.alignment = .leading
        cloudyDetailStackView.distribution = .fill
        cloudyDetailStackView.addArrangedSubview(cloudyIcon)
        cloudyDetailStackView.addArrangedSubview(cloudyLabel)
        return cloudyDetailStackView
    }()
    
    private lazy var cloudyIcon: UIImageView = {
        let cloudyIcon = UIImageView(image: UIImage(named: "clouds"))
        cloudyIcon.translatesAutoresizingMaskIntoConstraints = false
        cloudyIcon.contentMode = .scaleAspectFit
        return cloudyIcon
    }()
    
    private lazy var cloudyLabel: UILabel = {
        let cloudyLabel = UILabel()
        cloudyLabel.translatesAutoresizingMaskIntoConstraints = false
        cloudyLabel.font = .systemFont(ofSize: 14, weight: .regular)
        cloudyLabel.textColor = .black
        cloudyLabel.text = "Облачность"
        return cloudyLabel
    }()
    
    private lazy var cloudyAmountLabel: UILabel = {
        let cloudyAmountLabel = UILabel()
        cloudyAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        cloudyAmountLabel.font = .systemFont(ofSize: 14, weight: .regular)
        cloudyAmountLabel.textColor = .systemGray
        cloudyAmountLabel.text = "50%"
        return cloudyAmountLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupConstraints()
        backgroundColor = .systemBlue.withAlphaComponent(0.1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(hourlyWeatherView)
        hourlyWeatherView.addSubview(leftStackView)
        hourlyWeatherView.addSubview(rightStackView)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.viewSpacing),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.viewSpacing),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.viewSpacing),
            dateLabel.heightAnchor.constraint(equalToConstant: 22),
            
            hourlyWeatherView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: Constants.itemSpacing),
            hourlyWeatherView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.viewSpacing),
            hourlyWeatherView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.viewSpacing),
            hourlyWeatherView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.viewSpacing),
        
            leftStackView.leadingAnchor.constraint(equalTo: hourlyWeatherView.leadingAnchor),
            leftStackView.topAnchor.constraint(equalTo: hourlyWeatherView.topAnchor),
            leftStackView.heightAnchor.constraint(lessThanOrEqualTo: hourlyWeatherView.heightAnchor),
            leftStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 42),
            
            rightStackView.leadingAnchor.constraint(equalTo: leftStackView.trailingAnchor, constant: Constants.itemSpacing),
            rightStackView.trailingAnchor.constraint(equalTo: hourlyWeatherView.trailingAnchor),
            rightStackView.topAnchor.constraint(equalTo: hourlyWeatherView.topAnchor),
            rightStackView.bottomAnchor.constraint(equalTo: hourlyWeatherView.bottomAnchor),
            
            weatherIcon.widthAnchor.constraint(equalToConstant: Constants.iconSize),
            weatherIcon.heightAnchor.constraint(equalToConstant: Constants.iconSize),
            
            windIcon.widthAnchor.constraint(equalToConstant: Constants.iconSize),
            windIcon.heightAnchor.constraint(equalToConstant: Constants.iconSize),
            
            precipitationIcon.widthAnchor.constraint(equalToConstant: Constants.iconSize),
            precipitationIcon.heightAnchor.constraint(equalToConstant: Constants.iconSize),
            
            humidityIcon.widthAnchor.constraint(equalToConstant: Constants.iconSize),
            humidityIcon.heightAnchor.constraint(equalToConstant: Constants.iconSize),
            
            cloudyIcon.widthAnchor.constraint(equalToConstant: Constants.iconSize),
            cloudyIcon.heightAnchor.constraint(equalToConstant: Constants.iconSize)
        ])
    }
}

extension HourlyForecastTableViewCell: Configurable {
    func configure(with timePeriod: HourlyTimePeriod, units: Settings, at index: Int, at part: Int? = nil, at row: Int? = nil) {
        
        switch units.temperatureUnit {
        case .celsius:
            temperatureLabel.text = UnitsFormatter.celsius.format(timePeriod.instantData.airTemperature)
        case .fahrenheit:
            temperatureLabel.text = UnitsFormatter.fahrenheit.format(timePeriod.instantData.airTemperature)
        }
        
        switch units.windSpeedUnit {
        case .metersPerSecond:
            windSpeedLabel.text = "\(UnitsFormatter.metersPerSecond.format(timePeriod.instantData.windSpeed)), \(WindDirection(degrees: timePeriod.instantData.windFromDirection).rawValue)"
        case .milesPerHour:
            windSpeedLabel.text = "\(UnitsFormatter.milesPerHour.format(timePeriod.instantData.windSpeed)), \(WindDirection(degrees: timePeriod.instantData.windFromDirection).rawValue)"
        }
        
        switch units.timeFormat {
        case .twelveHour:
            timeLabel.text = timePeriod.time12Format
        case .twentyFourHour:
            timeLabel.text = timePeriod.time24Format
        }
        
        switch units.precipitationUnit {
        case .inches:
            precipitationAmountLabel.text = UnitsFormatter.inches.format(timePeriod.next1HoursForecast.precipitationAmount)
        case .millimeters:
            precipitationAmountLabel.text = UnitsFormatter.millimeters.format(timePeriod.next1HoursForecast.precipitationAmount)
        }
        
        dateLabel.text = CustomDateFormatter().formattedStringToString(date: timePeriod.timeStringFullInUTC, dateFormat: "EEEE, d MMMM yyyy", locale: Locale(identifier: "ru_RU"), timeZone: TimeZone(identifier: timePeriod.timeZone ?? ""))
        weatherIcon.image = UIImage(named: timePeriod.next1HoursForecast.symbolCode ?? "xmark.icloud")
        weatherLabel.text = CurrentWeatherDescription(symbolCode: timePeriod.next1HoursForecast.symbolCode ?? "cloud")?.description
        relativeHumidityLabel.text = "\(timePeriod.instantData.relativeHumidity)%"
        cloudyAmountLabel.text = "\(timePeriod.instantData.cloudAreaFraction)%"
    }
}



