

import UIKit

protocol HourlyTableViewCellDelegate: AnyObject {
    func updateHourlyCollectionCell(at index: Int)
}

final class HourlyTableViewCell: UITableViewCell {
    
    weak var delegate: HourlyTableViewCellDelegate?
    
    static let id = "HourlyTableViewCell"
    
    var weather: Weather?
    var hourlyTimePeriod: HourlyTimePeriod?
    
    lazy var collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(HourlyCollectionViewCell.self, forCellWithReuseIdentifier: HourlyCollectionViewCell.id)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCollectionView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        contentView.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 85)
        ])
    }
    
    private func isCellRepresentingCurrentTime(_ timePeriod: HourlyTimePeriod) -> Bool {
        let currentTime = CustomDateFormatter().formattedCurrentDate(dateFormat: "yyyy-MM-dd'T'HH", locale: nil, timeZone: TimeZone(identifier: "UTC"))
        let time = timePeriod.timeStringFullInUTC.prefix(13)
        return time == currentTime
    }
}

extension HourlyTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        24
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionViewCell.id, for: indexPath) as? HourlyCollectionViewCell else {
            return UICollectionViewCell()
        }
        if let model = weather {
            hourlyTimePeriod = HourlyTimePeriod(model: model, index: indexPath.item)
            if let timePeriod = hourlyTimePeriod {
                cell.configure(with: timePeriod, at: indexPath.item)
                
                let isCurrentTimeCell = isCellRepresentingCurrentTime(timePeriod)
                cell.contentView.backgroundColor = isCurrentTimeCell ? .systemYellow : .clear
            }
        }
        return cell
    }
}
    
extension HourlyTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth: CGFloat = 42
        let maxItemsInRow = max(1, Int(screenWidth / itemWidth))
        let totalSpacing = screenWidth - CGFloat(maxItemsInRow) * itemWidth
        let minimumSpacing = totalSpacing / CGFloat(maxItemsInRow + 1)
        let adjustedItemWidth = itemWidth + minimumSpacing
        return CGSize(width: adjustedItemWidth, height: 85)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
}
