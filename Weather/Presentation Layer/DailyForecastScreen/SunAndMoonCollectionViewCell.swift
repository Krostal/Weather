

import UIKit

final class SunAndMoonCollectionViewCell: UICollectionViewCell {
    
    static let id = "SunAndMoonCollectionViewCell"
    
    private enum Constants {
        static let viewSpacing: CGFloat = 16.0
        static let itemSpacing: CGFloat = 11.0
    }
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(durationStackView)
        stackView.addArrangedSubview(riseStackView)
        stackView.addArrangedSubview(setStackView)
        return stackView
    }()
    
    private lazy var durationStackView: UIStackView = {
        let durationStackView = UIStackView()
        durationStackView.translatesAutoresizingMaskIntoConstraints = false
        durationStackView.axis = .horizontal
        durationStackView.spacing = Constants.itemSpacing
        durationStackView.alignment = .center
        durationStackView.distribution = .equalSpacing
        durationStackView.addArrangedSubview(icon)
        durationStackView.addArrangedSubview(durationLabel)
        return durationStackView
    }()

    private lazy var icon: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.tintColor = .systemYellow
        return icon
    }()
    
    private lazy var durationLabel: UILabel = {
        let durationLabel = UILabel()
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        durationLabel.textColor = .black
        return durationLabel
    }()
    
    private lazy var riseStackView: UIStackView = {
        let riseStackView = UIStackView()
        riseStackView.translatesAutoresizingMaskIntoConstraints = false
        riseStackView.axis = .horizontal
        riseStackView.spacing = Constants.itemSpacing
        riseStackView.alignment = .center
        riseStackView.distribution = .equalSpacing
        riseStackView.addArrangedSubview(riseLabel)
        riseStackView.addArrangedSubview(riseTimeLabel)
        return riseStackView
    }()
    
    private lazy var riseLabel: UILabel = {
        let riseLabel = UILabel()
        riseLabel.translatesAutoresizingMaskIntoConstraints = false
        riseLabel.font = .systemFont(ofSize: 16, weight: .regular)
        riseLabel.textColor = .systemGray
        riseLabel.text = "Восход"
        return riseLabel
    }()
    
    private lazy var riseTimeLabel: UILabel = {
        let riseTimeLabel = UILabel()
        riseTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        riseTimeLabel.font = .systemFont(ofSize: 16, weight: .regular)
        riseTimeLabel.textColor = .black
        return riseTimeLabel
    }()
    
    private lazy var setStackView: UIStackView = {
        let setStackView = UIStackView()
        setStackView.translatesAutoresizingMaskIntoConstraints = false
        setStackView.axis = .horizontal
        setStackView.spacing = Constants.itemSpacing
        setStackView.alignment = .center
        setStackView.distribution = .equalSpacing
        setStackView.addArrangedSubview(setLabel)
        setStackView.addArrangedSubview(setTimeLabel)
        return setStackView
    }()
    
    private lazy var setLabel: UILabel = {
        let setLabel = UILabel()
        setLabel.translatesAutoresizingMaskIntoConstraints = false
        setLabel.font = .systemFont(ofSize: 16, weight: .regular)
        setLabel.textColor = .systemGray
        setLabel.text = "Закат"
        return setLabel
    }()
    
    private lazy var setTimeLabel: UILabel = {
        let setTimeLabel = UILabel()
        setTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        setTimeLabel.font = .systemFont(ofSize: 16, weight: .regular)
        setTimeLabel.textColor = .black
        return setTimeLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupSubviews()
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(stackView)
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func calculateDuration(rise: String, set: String) -> String {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        if let startDate = dateFormatter.date(from: rise),
           let endDate = dateFormatter.date(from: set) {
            
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute], from: startDate, to: endDate)
            
            let hours = abs(components.hour ?? 0)
            let minutes = abs(components.minute ?? 0)
            
            return String(format: "%02d ч %02d мин", hours, minutes)
        }
        return "не определено"
    }
}

extension SunAndMoonCollectionViewCell: Configurable {
    func configure(with model: Astronomy, units: Settings, at index: Int, at section: Int? = nil, at row: Int?) {
        guard let forecastSet = model.astronomyForecast,
              let forecast = Array(forecastSet) as? [AstronomyForecast] else {
            return
        }
        
        let filteredForecast = Array(forecast.dropFirst())
        
        if index < filteredForecast.count {
            if row == 0 {
                icon.image = UIImage(systemName: "sun.max.fill")
                
                if let sunrise = filteredForecast[index].sunrise,
                   let sunset = filteredForecast[index].sunset {
                    switch units.timeFormat {
                    case .twelveHour:
                        riseTimeLabel.text = CustomDateFormatter().formattedStringToString(date: sunrise, dateFormat: "hh:mm a", locale: nil)
                        setTimeLabel.text = CustomDateFormatter().formattedStringToString(date: sunset, dateFormat: "hh:mm a", locale: nil)
                    case .twentyFourHour:
                        riseTimeLabel.text = CustomDateFormatter().formattedStringToString(date: sunrise, dateFormat: "HH:mm", locale: nil)
                        setTimeLabel.text = CustomDateFormatter().formattedStringToString(date: sunset, dateFormat: "HH:mm", locale: nil)
                    }
                    durationLabel.text = calculateDuration(rise: sunrise, set: sunset)
                }
            } else if row == 1 {
                icon.image = UIImage(systemName: "moon.fill")
                
                if let moonrise = filteredForecast[index].moonrise,
                   let moonset = filteredForecast[index].moonset {
                    switch units.timeFormat {
                    case .twelveHour:
                        riseTimeLabel.text = CustomDateFormatter().formattedStringToString(date: moonrise, dateFormat: "hh:mm a", locale: nil)
                        setTimeLabel.text = CustomDateFormatter().formattedStringToString(date: moonset, dateFormat: "hh:mm a", locale: nil)
                    case .twentyFourHour:
                        riseTimeLabel.text = CustomDateFormatter().formattedStringToString(date: moonrise, dateFormat: "HH:mm", locale: nil)
                        setTimeLabel.text = CustomDateFormatter().formattedStringToString(date: moonset, dateFormat: "HH:mm", locale: nil)
                    }
                    durationLabel.text = calculateDuration(rise: moonrise, set: moonset)
                }
            }
        } else {
            icon.image = UIImage(systemName: "moon.zzz")
            riseTimeLabel.text = "?"
            setTimeLabel.text = "?"
            durationLabel.text = ""
        }
    }
}
