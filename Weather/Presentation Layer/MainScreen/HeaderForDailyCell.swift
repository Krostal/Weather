

import UIKit

protocol HeaderForDailyCellDelegate: AnyObject {
    func changeNumberOfRows()
}

final class HeaderForDailyCell: UITableViewHeaderFooterView {
    
    static let id = "HeaderForDailyCell"
    
    weak var delegate: HeaderForDailyCellDelegate?
    
    var isToggled: Bool = false
        
    var maxNumberOfDays: Int = 0 
    
    private lazy var headerStackView: UIStackView = {
        let headerStackView = UIStackView()
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        headerStackView.axis = .horizontal
        headerStackView.spacing = 10
        headerStackView.alignment = .fill
        headerStackView.addArrangedSubview(titleLabel)
        headerStackView.addArrangedSubview(dailyForecastButton)
        return headerStackView
    }()
    
    private lazy var dailyForecastButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("7 дней", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dailyForecastButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .black
        titleLabel.text = "Ежедневный прогноз"
        return titleLabel
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
        addSubview(headerStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            headerStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])
    }
    
    func updateButtonText() {
        let buttonText = isToggled ? "Показать 7 дней" : "Показать \(maxNumberOfDays) дней"
        dailyForecastButton.setTitle(buttonText, for: .normal)
    }
        
    @objc private func dailyForecastButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.isToggled.toggle()
            self.delegate?.changeNumberOfRows()
            self.updateButtonText()
        }
    }
    
}
