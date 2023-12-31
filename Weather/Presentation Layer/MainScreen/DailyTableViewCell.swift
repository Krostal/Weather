

import Foundation
import UIKit

final class DailyTableViewCell: UITableViewCell {
    
    static let id = "DailyTableViewCell"
    
    private let dateFormatter = CustomDateFormatter()
    
    private enum Constants {
        static let horizontalPadding: CGFloat = 10.0
        static let verticalSpacing: CGFloat = 17.0
    }
    
    private lazy var infoView: UIView = {
        let infoView = UIView()
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.backgroundColor = .systemBlue.withAlphaComponent(0.1)
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
}



extension DailyTableViewCell: Configurable {
    
    func configure(with timePeriod: DailyTimePeriod, units: Settings, at index: Int, at part: Int? = nil, at row: Int? = nil) {
        
        let sortedDailyForecast = timePeriod.dailyForecast.sorted { $0.key < $1.key }
        
        let dateKeys = sortedDailyForecast.map { $0.key }
        
        if index >= dateKeys.count {
            return
        }
        
        let dateKey = dateKeys[index]
        
        let dailyForecast = sortedDailyForecast[index].value
        if dailyForecast.count > 1,
           let forecast = dailyForecast[1].timePeriodData?.next6HoursForecast {
            
            switch units.temperatureUnit {
            case .celsius:
                temperatureLabel.text = "\(UnitsFormatter.celsius.format(forecast.airTemperatureMin)) - \(UnitsFormatter.celsius.format(forecast.airTemperatureMax))"
            case .fahrenheit:
                temperatureLabel.text = "\(UnitsFormatter.fahrenheit.format(forecast.airTemperatureMin)) - \(UnitsFormatter.fahrenheit.format(forecast.airTemperatureMax))"
            }
            
            dateLabel.text = dateFormatter.formattedDateToString(date: dateKey, dateFormat: "dd/MM", locale: nil)
            precipitationIcon.image = UIImage(named: forecast.symbolCode ?? "xmark.icloud")
            precipitationLabel.text = "\(forecast.precipitationAmount)%"
            infoLabel.text = CurrentWeatherDescription(symbolCode: forecast.symbolCode ?? "cloud")?.description
            
            
            
        }
    }
}
