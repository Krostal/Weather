

import UIKit

final class HourlyCollectionViewCell: UICollectionViewCell {
    
    static let id = "HourlyCollectionViewCell"
    
    private lazy var hourlyForecastView: UIStackView = {
        let hourlyForecastView = UIStackView()
        hourlyForecastView.translatesAutoresizingMaskIntoConstraints = false
        hourlyForecastView.axis = .vertical
        hourlyForecastView.spacing = 1
        hourlyForecastView.alignment = .center
        hourlyForecastView.distribution = .equalSpacing
        hourlyForecastView.addArrangedSubview(hourLabel)
        hourlyForecastView.addArrangedSubview(weatherIcon)
        hourlyForecastView.addArrangedSubview(tempLabel)
        return hourlyForecastView
    }()
    
    private lazy var hourLabel: UILabel = {
        let hourLabel = UILabel()
        hourLabel.translatesAutoresizingMaskIntoConstraints = false
        hourLabel.font = .systemFont(ofSize: 14, weight: .regular)
        hourLabel.textColor = .blue
        hourLabel.text = "12:00"
        return hourLabel
    }()
    
    private lazy var weatherIcon: UIImageView = {
        let weatherIcon = UIImageView()
        weatherIcon.translatesAutoresizingMaskIntoConstraints = false
        return weatherIcon
    }()
    
    private lazy var tempLabel: UILabel = {
        let tempLabel = UILabel()
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        tempLabel.font = .systemFont(ofSize: 16, weight: .regular)
        tempLabel.textColor = .blue
        tempLabel.text = "13°"
        return tempLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
        setupSubviews()
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 22
        contentView.backgroundColor = .white
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.blue.cgColor
    }
    
    private func setupSubviews() {
        contentView.addSubview(hourlyForecastView)
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            hourlyForecastView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hourlyForecastView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hourlyForecastView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            hourlyForecastView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            
            weatherIcon.heightAnchor.constraint(equalToConstant: 16),
            weatherIcon.widthAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    func toFormattedString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }

}

extension HourlyCollectionViewCell: Configurable {
    func configure(with model: Weather, at index: Int) {
        guard let timePeriod = (model.timePeriod?.allObjects as? [TimePeriod]),
              index < timePeriod.count && index < 24 else {
            return
        }
        
        let sortedTimePeriod = timePeriod.sorted(by: { ($0.time ?? "") < ($1.time ?? "")})

        var forecastFor24Hours: [TimePeriod] = []
        for i in 0..<min(24, sortedTimePeriod.count) {
            forecastFor24Hours.append(sortedTimePeriod[i])
        }
        
        guard let currentData = forecastFor24Hours[index].timePeriodData?.instantData,
              let next1Hoursforecast = forecastFor24Hours[index].timePeriodData?.next1HoursForecast else {
            return
        }
        
        if let savedTime = forecastFor24Hours[index].time {
            if let time = ISO8601DateFormatter().date(from: savedTime) {
                let currentTime = toFormattedString(date: time)
                hourLabel.text = "\(currentTime)"
                weatherIcon.image = UIImage(named: next1Hoursforecast.symbolCode ?? "")
                tempLabel.text = "\(currentData.airTemperature)°"
            }
            
        }
        
//        let stringTime = ISO8601DateFormatter().string(from: Date())
//        let roundedTime = stringTime.prefix(13)
//        
//        if let index = sortedTimePeriod.firstIndex(where: {
//            if let time = $0.time?.prefix(13) {
//                return roundedTime == time
//            }
//            return false
//        }) {
//            self.currentHourIndex = index
//            self.isCurrentTimeItem = true
//        } else {
//            print("Ошибка поиска индекса текущего времени в массиве")
//        }
    }
}



