

import UIKit

final class SunAndMoonCollectionViewCell: UICollectionViewCell {
    
    static let id = "SunAndMoonCollectionViewCell"
    
    private enum Constants {
        static let viewSpacing: CGFloat = 16.0
        static let itemSpacing: CGFloat = 11.0
    }
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(durationStackView)
        stackView.addArrangedSubview(riseStackView)
        stackView.addArrangedSubview(setStackView)
        return stackView
    }()
    
    private lazy var durationStackView: UIStackView = {
        let durationStackView = UIStackView()
        durationStackView.translatesAutoresizingMaskIntoConstraints = false
        durationStackView.axis = .horizontal
        durationStackView.spacing = Constants.itemSpacing
        durationStackView.alignment = .center
        durationStackView.distribution = .equalSpacing
        durationStackView.addArrangedSubview(icon)
        durationStackView.addArrangedSubview(durationLabel)
        return durationStackView
    }()

    private lazy var icon: UIImageView = {
        let weatherIcon = UIImageView()
        weatherIcon.translatesAutoresizingMaskIntoConstraints = false
        weatherIcon.tintColor = .systemYellow
        return weatherIcon
    }()
    
    private lazy var durationLabel: UILabel = {
        let durationLabel = UILabel()
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        durationLabel.textColor = .black
        return durationLabel
    }()
    
    private lazy var riseStackView: UIStackView = {
        let riseStackView = UIStackView()
        riseStackView.translatesAutoresizingMaskIntoConstraints = false
        riseStackView.axis = .horizontal
        riseStackView.spacing = Constants.itemSpacing
        riseStackView.alignment = .center
        riseStackView.distribution = .equalSpacing
        riseStackView.addArrangedSubview(riseLabel)
        riseStackView.addArrangedSubview(riseTimeLabel)
        return riseStackView
    }()
    
    private lazy var riseLabel: UILabel = {
        let riseLabel = UILabel()
        riseLabel.translatesAutoresizingMaskIntoConstraints = false
        riseLabel.font = .systemFont(ofSize: 16, weight: .regular)
        riseLabel.textColor = .systemGray
        riseLabel.text = "Восход"
        return riseLabel
    }()
    
    private lazy var riseTimeLabel: UILabel = {
        let riseTimeLabel = UILabel()
        riseTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        riseTimeLabel.font = .systemFont(ofSize: 16, weight: .regular)
        riseTimeLabel.textColor = .black
        return riseTimeLabel
    }()
    
    private lazy var setStackView: UIStackView = {
        let setStackView = UIStackView()
        setStackView.translatesAutoresizingMaskIntoConstraints = false
        setStackView.axis = .horizontal
        setStackView.spacing = Constants.itemSpacing
        setStackView.alignment = .center
        setStackView.distribution = .equalSpacing
        setStackView.addArrangedSubview(setLabel)
        setStackView.addArrangedSubview(setTimeLabel)
        return setStackView
    }()
    
    private lazy var setLabel: UILabel = {
        let setLabel = UILabel()
        setLabel.translatesAutoresizingMaskIntoConstraints = false
        setLabel.font = .systemFont(ofSize: 16, weight: .regular)
        setLabel.textColor = .systemGray
        setLabel.text = "Закат"
        return setLabel
    }()
    
    private lazy var setTimeLabel: UILabel = {
        let setTimeLabel = UILabel()
        setTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        setTimeLabel.font = .systemFont(ofSize: 16, weight: .regular)
        setTimeLabel.textColor = .black
        return setTimeLabel
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
        addSubview(stackView)
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func configureSunInfo() {
        icon.image = UIImage(systemName: "sun.max.fill")
        durationLabel.text = "12 ч 47 мин"
        riseTimeLabel.text = "05:45"
        setTimeLabel.text = "18:32"
    }
    
    func configureMoonInfo() {
        icon.image = UIImage(systemName: "moon.fill")
        durationLabel.text = "11 ч 13 мин"
        riseTimeLabel.text = "18:32"
        setTimeLabel.text = "05:45"
    }
    
}
