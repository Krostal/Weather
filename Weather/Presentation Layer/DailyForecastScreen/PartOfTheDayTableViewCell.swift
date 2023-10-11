

import UIKit

final class PartOfTheDayTableViewCell: UITableViewCell {
    
    static let id = "PartOfTheDayTableViewCell.swift"
    
    private enum Constants {
        static let viewSpacing: CGFloat = 16.0
        static let itemSpacing: CGFloat = 11.0
    }
    
    private lazy var partOfTheDayLabel: UILabel = {
        let partOfTheDayLabel = UILabel()
        partOfTheDayLabel.translatesAutoresizingMaskIntoConstraints = false
        partOfTheDayLabel.font = .systemFont(ofSize: 18, weight: .regular)
        partOfTheDayLabel.textColor = .black
        partOfTheDayLabel.text = "День"
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
        tempLabel.text = "13°"
        return tempLabel
    }()
    
    private lazy var weatherLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        timeLabel.textColor = .black
        timeLabel.text = "Ливни"
        return timeLabel
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
            partOfTheDayLabel.widthAnchor.constraint(equalToConstant: 50),
            partOfTheDayLabel.centerYAnchor.constraint(equalTo: tempLabel.centerYAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.viewSpacing),
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: partOfTheDayLabel.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
}

