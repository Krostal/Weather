

import Foundation
import UIKit

final class DailyTableViewCell: UITableViewCell {
    
    static let id = "DailyTableViewCell"
    
    private enum Constants {
        static let horizontalPadding: CGFloat = 10.0
        static let verticalSpacing: CGFloat = 17.0
    }
    
    private lazy var infoView: UIView = {
        let infoView = UIView()
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.backgroundColor = .systemGray3
        infoView.layer.cornerRadius = 5
        return infoView
    }()
    
    private lazy var leftStackView: UIStackView = {
        let leftStackView = UIStackView()
        leftStackView.translatesAutoresizingMaskIntoConstraints = false
        leftStackView.axis = .vertical
        leftStackView.spacing = 0
        leftStackView.alignment = .center
        leftStackView.distribution = .fillEqually
        leftStackView.addArrangedSubview(dateLabel)
        leftStackView.addArrangedSubview(precipitationStackView)
        return leftStackView
    }()
    
    private(set) lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = .systemFont(ofSize: 16, weight: .regular)
        dateLabel.textColor = .black
        return dateLabel
    }()
    
    private lazy var precipitationStackView: UIStackView = {
        let precipitationStackView = UIStackView()
        precipitationStackView.translatesAutoresizingMaskIntoConstraints = false
        precipitationStackView.axis = .horizontal
        precipitationStackView.spacing = 1
        precipitationStackView.addArrangedSubview(precipitationIcon)
        precipitationStackView.addArrangedSubview(precipitationLabel)
        return precipitationStackView
    }()
    
    private lazy var precipitationIcon: UIImageView = {
        let precipitationIcon = UIImageView()
        precipitationIcon.translatesAutoresizingMaskIntoConstraints = false
        precipitationIcon.contentMode = .scaleAspectFit
        return precipitationIcon
    }()
    
    private lazy var precipitationLabel: UILabel = {
        let precipitationAmountLabel = UILabel()
        precipitationAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        precipitationAmountLabel.font = .systemFont(ofSize: 12, weight: .regular)
        precipitationAmountLabel.textColor = .black
        return precipitationAmountLabel
    }()
    
    private lazy var rightStackView: UIStackView = {
        let rightStackView = UIStackView()
        rightStackView.translatesAutoresizingMaskIntoConstraints = false
        rightStackView.axis = .horizontal
        rightStackView.spacing = 1
        rightStackView.alignment = .fill
        rightStackView.distribution = .fill
        rightStackView.addArrangedSubview(infoLabel)
        rightStackView.addArrangedSubview(temperatureLabel)
        infoLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        temperatureLabel.setContentHuggingPriority(.required, for: .horizontal)
        return rightStackView
    }()
    
    private lazy var infoLabel: UILabel = {
        let infoLabel = UILabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.font = .systemFont(ofSize: 16, weight: .regular)
        infoLabel.textColor = .black
        infoLabel.numberOfLines = 2
        return infoLabel
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let temperatureLabel = UILabel()
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.font = .systemFont(ofSize: 18, weight: .regular)
        temperatureLabel.textColor = .black
        return temperatureLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(infoView)
        infoView.addSubview(leftStackView)
        infoView.addSubview(rightStackView)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            infoView.topAnchor.constraint(equalTo: contentView.topAnchor),
            infoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            infoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            leftStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            leftStackView.widthAnchor.constraint(equalToConstant: 55),
            leftStackView.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 5),
            leftStackView.bottomAnchor.constraint(equalTo: infoView.bottomAnchor, constant: -5),
            
            rightStackView.leadingAnchor.constraint(equalTo: leftStackView.trailingAnchor, constant: 5),
            rightStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            rightStackView.topAnchor.constraint(equalTo: infoView.topAnchor),
            rightStackView.bottomAnchor.constraint(equalTo: infoView.bottomAnchor),
        ])
    }
    
    func toFormattedString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd'T'HH"
        dateFormatter.locale = .current
        return dateFormatter.string(from: date)
    }
    
    private func formattedDay(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: date)
    }
    
    private func formatterToUTC(date: String) -> String? {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.timeZone =  TimeZone.current
        
        if let localDate = dateFormatter.date(from: date) {
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            return dateFormatter.string(from: localDate)
        }
        return nil
    }

}

extension DailyTableViewCell: Configurable {
    func configure(with model: Weather, at index: Int) {
        guard let timePeriodSet = model.timePeriod,
              let timePeriod = Array(timePeriodSet) as? [TimePeriod] else {
            return
        }
        
        // Конвертируем в местный часовой пояс и отсеиваем текущий день
        
        let timePeriodForNextDays = timePeriod.filter {
            if let time = $0.time {
                if let savedTime = ISO8601DateFormatter().date(from: time) {
                    let formattedTime = formattedDay(date: savedTime)
                    return formattedDay(date: Date()) != formattedTime
                }
            }
            return true
        }
        
        // Конвертируем в формат времени UTC, так как из JSON мы получаем именно такой формат
        
        let forecast = timePeriodForNextDays.filter {
            if let time = $0.time,
               let _ = formatterToUTC(date: time) {
                return true
            }
            return true
        }
        
        // оставляем 4 временных периода
        
        let timesToKeep = ["00:00:00Z", "06:00:00Z", "12:00:00Z", "18:00:00Z"]
        
        let filteredTimePeriods = forecast.filter { timePeriod in
            if let time = timePeriod.time,
               let timeComponents = time.components(separatedBy: "T").last {
                return timesToKeep.contains(timeComponents)
            }
            return false
        }
        
        // массив orderedTimePeriods содержит массивы по дням currentDayTimePeriods в последовательности утро, день, вечер, ночь.
        
        var dailyForecast: [[TimePeriod]] = []
        
        var partsOfDay: [TimePeriod] = []
        
        for (index, timePeriod) in filteredTimePeriods.dropFirst().enumerated() {
            partsOfDay.append(timePeriod)
            
            if partsOfDay.count == 4 || index == filteredTimePeriods.count - 2 {
                dailyForecast.append(partsOfDay)
                partsOfDay = []
            }
        }
        
        if dailyForecast.count > index && dailyForecast[index].count > 2 {
            if let date = dailyForecast[index][1].time,
               let range = date.range(of: "T") {
                let dateString = date.prefix(upTo: range.lowerBound)
                let components = dateString.split(separator: "-")
                
                let currentDate = ISO8601DateFormatter().string(from: Date())
                if let rangeCurrentDate = currentDate.range(of: "T") {
                let currentDateString = currentDate.prefix(upTo: rangeCurrentDate.lowerBound)
                let componentsCurrentDate = currentDateString.split(separator: "-")
                
                    if components.count == 3 && componentsCurrentDate.count == 3 {
                        if components[2] != componentsCurrentDate[2] {
                            let formattedString = "\(components[2])/\(components[1])"
                            dateLabel.text = formattedString
                        } else {
                            if let alternateDate = dailyForecast[index][2].time, let rangeAlternate = alternateDate.range(of: "T") {
                                let alternateDateString = alternateDate.prefix(upTo: rangeAlternate.lowerBound)
                                let alternateComponents = alternateDateString.split(separator: "-")
                                
                                if alternateComponents.count == 3 {
                                    let formattedString = "\(alternateComponents[2])/\(alternateComponents[1])"
                                    dateLabel.text = formattedString
                                }
                            }
                        }
                    }
                } else {
                    print("Invalid date format")
                }
            } else {
                print("Invalid date format")
            }
        }
        
        if let forecast = dailyForecast[index][1].timePeriodData?.next6HoursForecast {
            precipitationIcon.image = UIImage(named: forecast.symbolCode ?? "xmark.icloud")
            precipitationLabel.text = "\(forecast.precipitationAmount)%"
            infoLabel.text = forecast.symbolCode
            temperatureLabel.text = "\(forecast.airTemperatureMin)° - \(forecast.airTemperatureMax)°"
        }
    }
}


