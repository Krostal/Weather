

import UIKit

final class PartOfTheDayTableViewCell: UITableViewCell {
    
    static let id = "PartOfTheDayTableViewCell"
    
    private enum Constants {
        static let viewSpacing: CGFloat = 16.0
        static let itemSpacing: CGFloat = 11.0
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
        tempLabel.textColor = .systemGray
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
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configureMorning() {
        partOfTheDayLabel.text = "Утро"
        weatherIcon.image = UIImage(systemName: "cloud.sun.rain")
        tempLabel.text = "18°"
        weatherLabel.text = "Кратковременный дождь"
    }
    
    func configureNoon() {
        partOfTheDayLabel.text = "День"
        weatherIcon.image = UIImage(systemName: "moon.stars")
        tempLabel.text = "25°"
        weatherLabel.text = "Ясно"
    }
    
    func configureEvening() {
        partOfTheDayLabel.text = "Вечер"
        weatherIcon.image = UIImage(systemName: "moon.stars")
        tempLabel.text = "22°"
        weatherLabel.text = "Ясно"
    }
    
    func configureNight() {
        partOfTheDayLabel.text = "Ночь"
        weatherIcon.image = UIImage(systemName: "moon.stars")
        tempLabel.text = "17°"
        weatherLabel.text = "Ясно"
    }
    
}

