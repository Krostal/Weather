
import UIKit

final class HeaderForHourlyCell: UIView {
    
    private lazy var hourlyForecastLabel: UILabel = {
        let hourlyForecastLabel = UILabel()
        hourlyForecastLabel.text = "Подробнее на 24 часа"
        hourlyForecastLabel.textColor = .blue
        hourlyForecastLabel.font = .systemFont(ofSize: 16, weight: .regular)
        hourlyForecastLabel.translatesAutoresizingMaskIntoConstraints = false
        return hourlyForecastLabel
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
        setupConstraints()
        addTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(hourlyForecastLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            hourlyForecastLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            hourlyForecastLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            hourlyForecastLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])
    }
        
    private func addTarget() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapOnLabel))
        hourlyForecastLabel.isUserInteractionEnabled = true
        hourlyForecastLabel.addGestureRecognizer(gesture)
    }
        
    @objc private func tapOnLabel() {
        print("Лейбл был нажат")
    }
    
}
