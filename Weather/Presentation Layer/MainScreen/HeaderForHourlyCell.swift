
import UIKit

protocol HeaderForHourlyCellDelegate: AnyObject {
    func buttonTapped()
}

final class HeaderForHourlyCell: UITableViewHeaderFooterView {
    
    static let id = "HeaderForHourlyCell"
    
    weak var delegate: HeaderForHourlyCellDelegate?
    
    private lazy var hourlyForecastButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Подробнее на 24 часа", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(hourlyForecastButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(hourlyForecastButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            hourlyForecastButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            hourlyForecastButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            hourlyForecastButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])
    }
        
    @objc private func hourlyForecastButtonTapped() {
        delegate?.buttonTapped()
    }
    
}
