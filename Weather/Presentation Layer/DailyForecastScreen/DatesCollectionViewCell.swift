

import UIKit

final class DatesCollectionViewCell: UICollectionViewCell {
    
    static let id = "DatesCollectionViewCell"
        
    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = .systemFont(ofSize: 18, weight: .regular)
        dateLabel.textColor = .black
        dateLabel.text = "16/04 ПТ"
        dateLabel.textAlignment = .center
        return dateLabel
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
        contentView.layer.cornerRadius = 5
        contentView.backgroundColor = .systemBlue.withAlphaComponent(0.1)
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.1).cgColor
    }
    
    private func setupSubviews() {
        contentView.addSubview(dateLabel)
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
}



