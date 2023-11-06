

import UIKit

final class SunAndMoonTableViewCell: UITableViewCell {
    
    var dateIndex: Int?
    var astronomy: Astronomy?
    
    static let id = "SunAndMoonTableViewCell"
    
    private enum Constants {
        static let viewSpacing: CGFloat = 16.0
        static let itemHorizontalSpacing: CGFloat = 30.0
        static let itemVerticalSpacing: CGFloat = 10.0
    }
    
    private lazy var stackView: UIStackView = {
        let weatherStackView = UIStackView()
        weatherStackView.translatesAutoresizingMaskIntoConstraints = false
        weatherStackView.axis = .horizontal
        weatherStackView.spacing = Constants.itemHorizontalSpacing
        weatherStackView.alignment = .fill
        weatherStackView.distribution = .fill
        weatherStackView.addArrangedSubview(sunAndMoonLabel)
        weatherStackView.addArrangedSubview(moonPhaseIcon)
        weatherStackView.addArrangedSubview(moonPhaseLabel)
        return weatherStackView
    }()
    
    private lazy var sunAndMoonLabel: UILabel = {
        let sunAndMoonLabel = UILabel()
        sunAndMoonLabel.translatesAutoresizingMaskIntoConstraints = false
        sunAndMoonLabel.font = .systemFont(ofSize: 18, weight: .medium)
        sunAndMoonLabel.textColor = .black
        sunAndMoonLabel.text = "Солнце и Луна"
        sunAndMoonLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return sunAndMoonLabel
    }()
    
    private lazy var moonPhaseIcon: UIImageView = {
        let moonPhaseIcon = UIImageView(image: UIImage(systemName: "moonphase.waxing.gibbous.inverse"))
        moonPhaseIcon.translatesAutoresizingMaskIntoConstraints = false
        moonPhaseIcon.contentMode = .scaleAspectFit
        return moonPhaseIcon
    }()
    
    private lazy var moonPhaseLabel: UILabel = {
        let moonPhaseLabel = UILabel()
        moonPhaseLabel.translatesAutoresizingMaskIntoConstraints = false
        moonPhaseLabel.font = .systemFont(ofSize: 14, weight: .regular)
        moonPhaseLabel.textColor = .black
        moonPhaseLabel.text = "Растущая Луна"
        moonPhaseLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return moonPhaseLabel
    }()
    
    private lazy var collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(SunAndMoonCollectionViewCell.self, forCellWithReuseIdentifier: SunAndMoonCollectionViewCell.id)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var separatorView: UIView = {
        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .black
        return separatorView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemBlue.withAlphaComponent(0.1)
        addSubviews()
        setupCollectionView()
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(stackView)
        contentView.addSubview(collectionView)
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.addSubview(separatorView)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.viewSpacing),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.viewSpacing),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.viewSpacing),
                        
            collectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: Constants.itemVerticalSpacing),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.viewSpacing),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.viewSpacing),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.itemVerticalSpacing),
            
            separatorView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            separatorView.widthAnchor.constraint(equalToConstant: 0.5),
            separatorView.heightAnchor.constraint(equalTo: collectionView.heightAnchor, constant: -Constants.viewSpacing),
            separatorView.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
        ])
    }
    
}

extension SunAndMoonTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SunAndMoonCollectionViewCell.id, for: indexPath) as? SunAndMoonCollectionViewCell else {
            return UICollectionViewCell()
        }
        if let astronomyModel = astronomy,
        let index = dateIndex {
            cell.configure(with: astronomyModel, at: index, at: 0, at: indexPath.item)
        }
        return cell
    }
}
    
extension SunAndMoonTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewWidth = collectionView.bounds.width
        let collectionViewHeight = collectionView.bounds.height
        let itemWidth = collectionViewWidth / 2 - Constants.itemHorizontalSpacing / 2
        return CGSize(width: itemWidth, height: collectionViewHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.itemHorizontalSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.itemHorizontalSpacing
    }
    
}

extension SunAndMoonTableViewCell: Configurable {
    func configure(with model: Astronomy, at index: Int, at section: Int? = nil, at row: Int? = nil) {
        guard let forecastSet = model.astronomyForecast,
              let forecast = Array(forecastSet) as? [AstronomyForecast] else {
            return
        }
        
        let filteredForecast = Array(forecast.dropFirst())
        
        if index < filteredForecast.count {
            moonPhaseLabel.text = MoonPhases(value: filteredForecast[index].moonPhase).rawValue
            moonPhaseIcon.image = UIImage(systemName: MoonPhases(value: filteredForecast[index].moonPhase).systemImageName)
        } else {
            moonPhaseLabel.text = "?"
            moonPhaseIcon.image = UIImage(systemName: "moon.zzz")
        }
    }
}


