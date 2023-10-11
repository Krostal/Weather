

import UIKit

final class AirQualityTableViewCell: UITableViewCell {
    
    static let id = "AirQualityTableViewCell"
    
    private enum Constants {
        static let viewSpacing: CGFloat = 16.0
        static let itemSpacing: CGFloat = 11.0
    }
    
    private lazy var airQualityView: UIView = {
        let airQualityView = UIView()
        airQualityView.translatesAutoresizingMaskIntoConstraints = false
        return airQualityView
    }()
    
    private lazy var airLabel: UILabel = {
        let airLabel = UILabel()
        airLabel.translatesAutoresizingMaskIntoConstraints = false
        airLabel.font = .systemFont(ofSize: 18, weight: .medium)
        airLabel.textColor = .black
        airLabel.text = "Качество воздуха"
        airLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return airLabel
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(levelLabel)
        stackView.addArrangedSubview(qualityLabel)
        return stackView
    }()
    
    private lazy var levelLabel: UILabel = {
        let levelLabel = UILabel()
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        levelLabel.font = .systemFont(ofSize: 30, weight: .semibold)
        levelLabel.textColor = .black
        levelLabel.text = "42"
        return levelLabel
    }()
    
    private lazy var qualityLabel: UILabel = {
        let qualityLabel = UILabel()
        qualityLabel.translatesAutoresizingMaskIntoConstraints = false
        qualityLabel.font = .systemFont(ofSize: 16, weight: .regular)
        qualityLabel.textColor = .black
        qualityLabel.textAlignment = .center
        qualityLabel.layer.cornerRadius = 5
        qualityLabel.clipsToBounds = true
        qualityLabel.backgroundColor = .systemMint
        qualityLabel.text = "хорошо"
        return qualityLabel
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let qualityLabel = UILabel()
        qualityLabel.translatesAutoresizingMaskIntoConstraints = false
        qualityLabel.font = .systemFont(ofSize: 16, weight: .regular)
        qualityLabel.textColor = .systemGray
        qualityLabel.textAlignment = .natural
        qualityLabel.numberOfLines = 0
        qualityLabel.text = "Качество воздуха считается удовлетворительным и загрязнение воздуха представляется незначительным в пределах нормы"
        return qualityLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemBlue.withAlphaComponent(0.1)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(airQualityView)
        airQualityView.addSubview(airLabel)
        airQualityView.addSubview(stackView)
        airQualityView.addSubview(descriptionLabel)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            airQualityView.topAnchor.constraint(equalTo: contentView.topAnchor),
            airQualityView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            airQualityView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            airQualityView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            airLabel.leadingAnchor.constraint(equalTo: airQualityView.leadingAnchor, constant: Constants.viewSpacing),
            airLabel.trailingAnchor.constraint(equalTo: airQualityView.trailingAnchor, constant: -Constants.viewSpacing),
            airLabel.topAnchor.constraint(equalTo: airQualityView.topAnchor, constant: Constants.viewSpacing),
            
            stackView.topAnchor.constraint(equalTo: airLabel.bottomAnchor, constant: Constants.itemSpacing),
            stackView.leadingAnchor.constraint(equalTo: airQualityView.leadingAnchor, constant: Constants.viewSpacing),
            stackView.trailingAnchor.constraint(equalTo: airQualityView.trailingAnchor, constant: -Constants.viewSpacing),
            
            qualityLabel.heightAnchor.constraint(equalTo: levelLabel.heightAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: Constants.itemSpacing),
            descriptionLabel.leadingAnchor.constraint(equalTo: airQualityView.leadingAnchor, constant: Constants.viewSpacing),
            descriptionLabel.trailingAnchor.constraint(equalTo: airQualityView.trailingAnchor, constant: -Constants.viewSpacing),
            descriptionLabel.bottomAnchor.constraint(equalTo: airQualityView.bottomAnchor, constant: -Constants.itemSpacing),
        ])
    }

    
}
