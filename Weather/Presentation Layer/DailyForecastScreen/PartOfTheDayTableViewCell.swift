

import UIKit

final class PartOfTheDayTableViewCell: UITableViewCell {
    
    static let id = "PartOfTheDayTableViewCell"
    
    private enum Constants {
        static let viewSpacing: CGFloat = 16.0
        static let itemSpacing: CGFloat = 11.0
        static let iconSize: CGFloat = 30.0
    }
    
    private lazy var partOfTheDayLabel: UILabel = {
        let partOfTheDayLabel = UILabel()
        partOfTheDayLabel.translatesAutoresizingMaskIntoConstraints = false
        partOfTheDayLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        partOfTheDayLabel.textColor = .black
        return partOfTheDayLabel
    }()
    
    private lazy var stackView: UIStackView = {
        let leftStackView = UIStackView()
        leftStackView.translatesAutoresizingMaskIntoConstraints = false
        leftStackView.axis = .vertical
        leftStackView.alignment = .center
        leftStackView.distribution = .fillEqually
        leftStackView.addArrangedSubview(weatherStackView)
        leftStackView.addArrangedSubview(weatherLabel)
        return leftStackView
    }()
    
    private lazy var weatherStackView: UIStackView = {
        let weatherStackView = UIStackView()
        weatherStackView.translatesAutoresizingMaskIntoConstraints = false
        weatherStackView.axis = .horizontal
        weatherStackView.spacing = Constants.itemSpacing
        weatherStackView.alignment = .center
        weatherStackView.distribution = .fill
        weatherStackView.addArrangedSubview(weatherIcon)
        weatherStackView.addArrangedSubview(tempLabel)
        return weatherStackView
    }()
    
    private lazy var weatherIcon: UIImageView = {
        let weatherIcon = UIImageView(image: UIImage(systemName: "cloud.sun"))
        weatherIcon.translatesAutoresizingMaskIntoConstraints = false
        weatherIcon.contentMode = .scaleAspectFit
        return weatherIcon
    }()
    
    private lazy var tempLabel: UILabel = {
        let tempLabel = UILabel()
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        tempLabel.font = .systemFont(ofSize: 30, weight: .semibold)
        tempLabel.textColor = .black
        return tempLabel
    }()
    
    private lazy var weatherLabel: UILabel = {
        let weatherLabel = UILabel()
        weatherLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherLabel.font = .systemFont(ofSize: 18, weight: .medium)
        weatherLabel.textColor = .black
        weatherLabel.numberOfLines = 0
        return weatherLabel
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
        contentView.addSubview(partOfTheDayLabel)
        contentView.addSubview(stackView)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            partOfTheDayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.viewSpacing),
            partOfTheDayLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            partOfTheDayLabel.centerYAnchor.constraint(equalTo: tempLabel.centerYAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.viewSpacing),
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: partOfTheDayLabel.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            weatherIcon.widthAnchor.constraint(equalToConstant: Constants.iconSize),
            weatherIcon.heightAnchor.constraint(equalToConstant: Constants.iconSize)
        ])
    }
}
    

extension PartOfTheDayTableViewCell: Configurable {
    
    func configure(with timePeriod: DailyTimePeriod, at index: Int, at part: Int?, at row: Int? = nil) {
        
        let sortedDailyForecast = timePeriod.dailyForecast.sorted { $0.key < $1.key }
        
        let dateKeys = sortedDailyForecast.map { $0.key }
        
        if index >= dateKeys.count {
            return
        }
        
        let dailyForecast = sortedDailyForecast[index].value
        
        guard let part = part,
              part >= 1 && part <= 4,
              let forecast = dailyForecast[part-1].timePeriodData
        else {
            return
        }
        
        let instantData = forecast.instantData
        let next6Hours = forecast.next6HoursForecast
        
        switch part {
        case 1:
            partOfTheDayLabel.text = "Утро"
        case 2:
            partOfTheDayLabel.text = "День"
        case 3:
            partOfTheDayLabel.text = "Вечер"
        case 4:
            partOfTheDayLabel.text = "Ночь"
        default:
            break
        }
        
        if let instantData = instantData,
           let next6Hours = next6Hours {
            weatherIcon.image = UIImage(named: next6Hours.symbolCode ?? "xmark.icloud")
            tempLabel.text = "\(instantData.airTemperature)°"
            weatherLabel.text = CurrentWeatherDescription(symbolCode: next6Hours.symbolCode ?? "cloud")?.description
        }
    }
}

