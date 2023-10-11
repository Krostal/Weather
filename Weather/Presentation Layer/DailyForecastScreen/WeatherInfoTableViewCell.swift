

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
            
            iconImage.widthAnchor.constraint(equalToConstant: 24),
            categorylabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 10),
            valueLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 10)
        ])
    }
    
    func configureRow1() {
        iconImage.image = UIImage(systemName: "thermometer.sun")
        categorylabel.text = "По ощущениям"
        valueLabel.text = "13°"
    }
    
    func configureRow2() {
        iconImage.image = UIImage(systemName: "wind")
        categorylabel.text = "Ветер"
        valueLabel.text = "3 м/с ССЗ"
    }
    
    func configureRow3() {
        iconImage.image = UIImage(systemName: "sun.min")
        categorylabel.text = "УФ  индекс"
        valueLabel.text = "4 (умеренный)"
    }
    
    func configureRow4() {
        iconImage.image = UIImage(systemName: "cloud.rain")
        categorylabel.text = "Дождь"
        valueLabel.text = "55%"
    }
    
    func configureRow5() {
        iconImage.image = UIImage(systemName: "cloud")
        categorylabel.text = "Облачность"
        valueLabel.text = "72%"
    }
    
}

