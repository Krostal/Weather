

import UIKit

final class HourlyForecastTableViewCell: UITableViewCell {
    
    static let id = "HourlyForecastTableViewCell"
    
    private enum Constants {
        static let viewSpacing: CGFloat = 16.0
        static let itemSpacing: CGFloat = 11.0
    }
    
    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        dateLabel.textColor = .black
        dateLabel.text = formattedCurrentDate()
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
        leftStackView.alignment = .center
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
        timeLabel.text = "12:00"
        return timeLabel
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let temperatureLabel = UILabel()
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        temperatureLabel.textColor = .black
        temperatureLabel.text = "13°"
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
        weatherLabel.text = "Преимущественно солнечно"
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
        let windIcon = UIImageView(image: UIImage(systemName: "wind"))
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
        windSpeedLabel.text = "2 м/с ССЗ"
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
        let precipitationIcon = UIImageView(image: UIImage(systemName: "cloud"))
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
        let cloudyIcon = UIImageView(image: UIImage(systemName: "cloud"))
        cloudyIcon.translatesAutoresizingMaskIntoConstraints = false
        cloudyIcon.contentMode = .scaleAspectFit
        return cloudyIcon
    }()
    
    private lazy var cloudyLabel: UILabel = {
        let cloudyLabel = UILabel()
        cloudyLabel.translatesAutoresizingMaskIntoConstraints = false
        cloudyLabel.font = .systemFont(ofSize: 14, weight: .regular)
        cloudyLabel.textColor = .black
        cloudyLabel.text = "Атмосферные осадки"
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
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0))
//    }
    
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
            leftStackView.widthAnchor.constraint(equalToConstant: 40),
            
            rightStackView.leadingAnchor.constraint(equalTo: leftStackView.trailingAnchor, constant: Constants.itemSpacing),
            rightStackView.trailingAnchor.constraint(equalTo: hourlyWeatherView.trailingAnchor),
            rightStackView.topAnchor.constraint(equalTo: hourlyWeatherView.topAnchor),
            rightStackView.bottomAnchor.constraint(equalTo: hourlyWeatherView.bottomAnchor),
        ])
    }
    
    private func formattedCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        return formattedDate
    }
}

