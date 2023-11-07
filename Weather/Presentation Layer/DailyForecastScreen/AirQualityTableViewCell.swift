

import UIKit

final class AirQualityTableViewCell: UITableViewCell {
    
    static let id = "AirQualityTableViewCell"
    
    private enum Constants {
        static let viewSpacing: CGFloat = 16.0
        static let itemSpacing: CGFloat = 11.0
    }
    
    private lazy var airQualityView: UIView = {
        let airQualityView = UIView()
        airQualityView.translatesAutoresizingMaskIntoConstraints = false
        return airQualityView
    }()
    
    private lazy var airLabel: UILabel = {
        let airLabel = UILabel()
        airLabel.translatesAutoresizingMaskIntoConstraints = false
        airLabel.font = .systemFont(ofSize: 18, weight: .medium)
        airLabel.textColor = .black
        airLabel.text = "Качество воздуха"
        airLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return airLabel
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(levelLabel)
        stackView.addArrangedSubview(qualityLabel)
        return stackView
    }()
    
    private lazy var levelLabel: UILabel = {
        let levelLabel = UILabel()
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        levelLabel.font = .systemFont(ofSize: 30, weight: .semibold)
        levelLabel.textColor = .black
        return levelLabel
    }()
    
    private lazy var qualityLabel: UILabel = {
        let qualityLabel = UILabel()
        qualityLabel.translatesAutoresizingMaskIntoConstraints = false
        qualityLabel.font = .systemFont(ofSize: 16, weight: .regular)
        qualityLabel.textColor = .black
        qualityLabel.textAlignment = .center
        qualityLabel.layer.cornerRadius = 5
        qualityLabel.clipsToBounds = true
        return qualityLabel
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = .systemFont(ofSize: 16, weight: .regular)
        descriptionLabel.textColor = .systemGray
        descriptionLabel.textAlignment = .natural
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemBlue.withAlphaComponent(0.1)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(airQualityView)
        airQualityView.addSubview(airLabel)
        airQualityView.addSubview(stackView)
        airQualityView.addSubview(descriptionLabel)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            airQualityView.topAnchor.constraint(equalTo: contentView.topAnchor),
            airQualityView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            airQualityView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            airQualityView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            airLabel.leadingAnchor.constraint(equalTo: airQualityView.leadingAnchor, constant: Constants.viewSpacing),
            airLabel.trailingAnchor.constraint(equalTo: airQualityView.trailingAnchor, constant: -Constants.viewSpacing),
            airLabel.topAnchor.constraint(equalTo: airQualityView.topAnchor, constant: Constants.viewSpacing),
            
            stackView.topAnchor.constraint(equalTo: airLabel.bottomAnchor, constant: Constants.itemSpacing),
            stackView.leadingAnchor.constraint(equalTo: airQualityView.leadingAnchor, constant: Constants.viewSpacing),
            stackView.trailingAnchor.constraint(equalTo: airQualityView.trailingAnchor, constant: -Constants.viewSpacing),
            
            qualityLabel.heightAnchor.constraint(equalTo: levelLabel.heightAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: Constants.itemSpacing),
            descriptionLabel.leadingAnchor.constraint(equalTo: airQualityView.leadingAnchor, constant: Constants.viewSpacing),
            descriptionLabel.trailingAnchor.constraint(equalTo: airQualityView.trailingAnchor, constant: -Constants.viewSpacing),
            descriptionLabel.bottomAnchor.constraint(equalTo: airQualityView.bottomAnchor, constant: -Constants.itemSpacing),
        ])
    }
}

extension AirQualityTableViewCell: Configurable {
    func configure(with model: AirQuality, units: Settings, at index: Int, at section: Int? = nil, at row: Int? = nil) {
        guard let forecastSet = model.airQualityForecast,
              let forecast = Array(forecastSet) as? [AirQualityForecast] else {
            return
        }
        
        let currentDate = Date()
        
        let forecastForNextDays = forecast.filter {
            if let day = $0.day,
               let formattedDay = CustomDateFormatter().formattedStringToDate(date: day, dateFormat: "yyyy-MM-dd") {
                return formattedDay > currentDate
            }
            return true
        }
        
        if index < forecastForNextDays.count {
            levelLabel.text = String(forecastForNextDays[index].index)
            qualityLabel.text = AirQualityDescription(pm25Index: forecastForNextDays[index].index).rawValue
            qualityLabel.backgroundColor = AirQualityDescription(pm25Index: forecastForNextDays[index].index).color
            descriptionLabel.text = AirQualityDescription(pm25Index: forecastForNextDays[index].index).description
        } else {
            levelLabel.text = "?"
            qualityLabel.backgroundColor = .systemGray
            qualityLabel.text = "не определено"
        }
    }
}
