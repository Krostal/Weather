

import UIKit

protocol DatesTableViewCellDelegate: AnyObject {
    func showForecastForSelectedDate(date: Date)
}

final class DatesTableViewCell: UITableViewCell {
    
    static let id = "DatesTableViewCell"
    
    weak var delegate: DatesTableViewCellDelegate?
    
    var dailyTimePeriod: DailyTimePeriod?
    
    var currentDateIndex: Int?
    
    private lazy var collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(DatesCollectionViewCell.self, forCellWithReuseIdentifier: DatesCollectionViewCell.id)
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
            collectionView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}

extension DatesTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dailyTimePeriod?.dailyForecast.keys.count ?? 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DatesCollectionViewCell.id, for: indexPath) as? DatesCollectionViewCell else {
            return UICollectionViewCell()
        }
        if let timePeriod = dailyTimePeriod {
            cell.configure(with: timePeriod, at: indexPath.item)
        }
        return cell
    }
}
    
extension DatesTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth: CGFloat = 80
        let maxItemsInRow = max(1, Int(screenWidth / itemWidth))
        let totalSpacing = screenWidth - CGFloat(maxItemsInRow) * itemWidth
        let minimumSpacing = totalSpacing / CGFloat(maxItemsInRow + 1)
        let adjustedItemWidth = itemWidth + minimumSpacing
        return CGSize(width: adjustedItemWidth, height: 22)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DatesCollectionViewCell {
            guard let timePeriod = dailyTimePeriod else { return }
            let sortedDailyForecast = timePeriod.dailyForecast.sorted { $0.key < $1.key }
            let dateKeys = sortedDailyForecast.map { $0.key }
            if indexPath.row >= dateKeys.count {
                return
            }
            let dateKey = dateKeys[indexPath.row]
            delegate?.showForecastForSelectedDate(date: dateKey)
        }
    }
}


