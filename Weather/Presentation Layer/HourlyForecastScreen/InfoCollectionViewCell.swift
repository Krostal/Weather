

import UIKit

final class InfoCollectionViewCell: UICollectionViewCell {
    
    static let id = "InfoCollectionViewCell"
    
    private lazy var infoStackView: UIStackView = {
        let infoStackView = UIStackView()
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.axis = .vertical
        infoStackView.spacing = 0
        infoStackView.alignment = .center
        infoStackView.distribution = .fillEqually
        infoStackView.addArrangedSubview(weatherIcon)
        infoStackView.addArrangedSubview(precipitationLabel)
        return infoStackView
    }()
    
    private lazy var weatherIcon: UIImageView = {
        let weatherIcon = UIImageView()
        weatherIcon.translatesAutoresizingMaskIntoConstraints = false
        weatherIcon.contentMode = .scaleAspectFit
        return weatherIcon
    }()
    
    private lazy var precipitationLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = .systemFont(ofSize: 10, weight: .regular)
        dateLabel.textColor = .black
        return dateLabel
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
        addSubview(infoStackView)
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            infoStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            infoStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            infoStackView.topAnchor.constraint(equalTo: topAnchor),
            infoStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

extension InfoCollectionViewCell: Configurable {
    func configure(with timePeriod: ThreeHoursForecast, units: Settings, at index: Int, at part: Int? = nil, at row: Int? = nil) {
        weatherIcon.image = UIImage(named: timePeriod.next1HoursForecast.symbolCode ?? "xmark.icloud")
        precipitationLabel.text = "\(Int(timePeriod.instantData.relativeHumidity))%"
    }
}
