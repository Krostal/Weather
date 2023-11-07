

import UIKit

final class WeatherInfoTableViewCell: UITableViewCell {
    
    static let id = "WeatherInfoTableViewCell"
    
    private enum Constants {
        static let viewSpacing: CGFloat = 16.0
        static let itemSpacing: CGFloat = 11.0
    }
    
    private lazy var stackView: UIStackView = {
        let weatherStackView = UIStackView()
        weatherStackView.translatesAutoresizingMaskIntoConstraints = false
        weatherStackView.axis = .horizontal
        weatherStackView.spacing = Constants.itemSpacing
        weatherStackView.alignment = .fill
        weatherStackView.distribution = .fill
        weatherStackView.addArrangedSubview(iconImage)
        weatherStackView.addArrangedSubview(categorylabel)
        weatherStackView.addArrangedSubview(valueLabel)
        return weatherStackView
    }()
    
    private lazy var iconImage: UIImageView = {
        let iconImage = UIImageView(image: UIImage(systemName: "cloud.sun"))
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        iconImage.contentMode = .scaleAspectFit
        return iconImage
    }()
    
    private lazy var categorylabel: UILabel = {
        let categorylabel = UILabel()
        categorylabel.translatesAutoresizingMaskIntoConstraints = false
        categorylabel.font = .systemFont(ofSize: 14, weight: .regular)
        categorylabel.textColor = .black
        categorylabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return categorylabel
    }()
    
    private lazy var valueLabel: UILabel = {
        let valueLabel = UILabel()
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.font = .systemFont(ofSize: 14, weight: .regular)
        valueLabel.textColor = .systemGray
        valueLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return valueLabel
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
        contentView.addSubview(stackView)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.viewSpacing),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.viewSpacing),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.viewSpacing),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.viewSpacing),
            stackView.heightAnchor.constraint(equalToConstant: 25),
            
            iconImage.widthAnchor.constraint(equalToConstant: 24),
            categorylabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 10),
            valueLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 10)
        ])
    }
}
    
extension WeatherInfoTableViewCell: Configurable {
    
    func configure(with timePeriod: DailyTimePeriod, units: Settings, at index: Int, at section: Int?, at row: Int?) {
        
        let sortedDailyForecast = timePeriod.dailyForecast.sorted { $0.key < $1.key }
        
        let dateKeys = sortedDailyForecast.map { $0.key }
        
        if index >= dateKeys.count {
            return
        }
        
        let dailyForecast = sortedDailyForecast[index].value
        
        guard let section = section,
              let forecast = dailyForecast[section-1].timePeriodData?.instantData,
              let forecastNext6Hour = dailyForecast[section-1].timePeriodData?.next6HoursForecast
        else {
            return
        }
        
        switch row {
        case 1:
            iconImage.image = UIImage(named: "humidity")
            categorylabel.text = "Относительная влажность"
            valueLabel.text = "\(forecast.relativeHumidity)%"
        case 2:
            iconImage.image = UIImage(named: "wind")
            categorylabel.text = "Ветер"
            switch units.windSpeedUnit {
            case .metersPerSecond:
                valueLabel.text = "\(UnitsFormatter.metersPerSecond.format(forecast.windSpeed)), \(WindDirection(degrees: forecast.windFromDirection).rawValue)"
            case .milesPerHour:
                valueLabel.text = "\(UnitsFormatter.milesPerHour.format(forecast.windSpeed)), \(WindDirection(degrees: forecast.windFromDirection).rawValue)"
            }
        case 3:
            iconImage.image = UIImage(systemName: "sun.min")
            categorylabel.text = "УФ  индекс"
            valueLabel.text = "\(forecast.ultravioletIndexClearSky) \(UVIndex(ultraVioletIndex: forecast.ultravioletIndexClearSky).rawValue)"
        case 4:
            iconImage.image = UIImage(named: "precipitation")
            categorylabel.text = "Атмосферные осадки"
            
            switch units.precipitationUnit {
            case .inches:
                valueLabel.text = UnitsFormatter.inches.format(forecastNext6Hour.precipitationAmount)
            case .millimeters:
                valueLabel.text = UnitsFormatter.millimeters.format(forecastNext6Hour.precipitationAmount)
            }
        case 5:
            iconImage.image = UIImage(named: "clouds")
            categorylabel.text = "Облачность"
            valueLabel.text = "\(forecast.cloudAreaFraction)%"
        default:
            break
        }
    }
}

