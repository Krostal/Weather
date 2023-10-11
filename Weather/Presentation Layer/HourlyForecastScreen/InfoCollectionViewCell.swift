

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
        infoStackView.addArrangedSubview(precipitationIcon)
        infoStackView.addArrangedSubview(precipitationLabel)
        return infoStackView
    }()
    
    private lazy var precipitationIcon: UIImageView = {
        let precipitationIcon = UIImageView(image: UIImage(systemName: "cloud.rain"))
        precipitationIcon.translatesAutoresizingMaskIntoConstraints = false
        precipitationIcon.contentMode = .scaleAspectFit
        return precipitationIcon
    }()
    
    private lazy var precipitationLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = .systemFont(ofSize: 10, weight: .regular)
        dateLabel.textColor = .black
        dateLabel.text = "50%"
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
