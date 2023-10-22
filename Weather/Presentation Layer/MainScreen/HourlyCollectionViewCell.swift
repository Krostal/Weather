

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
        hourLabel.textColor = .black
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
        tempLabel.textColor = .black
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
        contentView.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.5).cgColor
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
            
            weatherIcon.heightAnchor.constraint(equalToConstant: 20),
            weatherIcon.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
}

extension HourlyCollectionViewCell: Configurable {
    func configure(with timePeriod: HourlyTimePeriod, at index: Int) {
        hourLabel.text = timePeriod.time
        weatherIcon.image = UIImage(named: timePeriod.next1HoursForecast.symbolCode ?? "")
        tempLabel.text = "\(timePeriod.instantData.airTemperature)°"
    }
}


