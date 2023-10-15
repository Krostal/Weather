
import UIKit
import CoreData

protocol MainViewDelegate: AnyObject {
    func showHourlyForecast()
    func showDailyForecast(forDate date: String)
    func updateCurrentCell()
    func updateHourlyCell(at index: Int)
}

final class MainView: UIView {
    
    weak var delegate: MainViewDelegate?
    
    private var numberOfDays: Int = 7
    
    private var selectedDate: String?
    
    private var fetchedResultsController: NSFetchedResultsController<Weather>?
    
    private enum Constants {
        static let heightHeaderOfCurrentCellSection: CGFloat = 212
        static let heightHeaderOfDailyCellSection: CGFloat = 56
        static let spacing: CGFloat = 16
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CurrentTableViewCell.self, forCellReuseIdentifier: CurrentTableViewCell.id)
        tableView.register(HourlyTableViewCell.self, forCellReuseIdentifier: HourlyTableViewCell.id)
        tableView.register(DailyTableViewCell.self, forCellReuseIdentifier: DailyTableViewCell.id)
        tableView.register(HeaderForHourlyCell.self, forHeaderFooterViewReuseIdentifier: HeaderForHourlyCell.id)
        tableView.register(HeaderForDailyCell.self, forHeaderFooterViewReuseIdentifier: HeaderForDailyCell.id)
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addSubviews()
        setupTableView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupView() {
        backgroundColor = .white
    }
    
    private func addSubviews() {
        addSubview(tableView)
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 0
    }
    
    private func setupLayout() {
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Constants.spacing),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Constants.spacing),
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.spacing),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Constants.spacing)
        ])
    }
    
    @objc private func dailyCellTapped() {
        delegate?.showDailyForecast(forDate: selectedDate ?? "???")
    }
}

extension MainView: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else {
            return numberOfDays
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let currentCell = tableView.dequeueReusableCell(withIdentifier: CurrentTableViewCell.id, for: indexPath) as? CurrentTableViewCell else {
                return UITableViewCell()
            }
            delegate?.updateCurrentCell()
            
            return currentCell
            
        } else if indexPath.section == 1 {
            guard let hourlyCell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.id, for: indexPath) as? HourlyTableViewCell else {
                return UITableViewCell()
            }
            hourlyCell.delegate = self
           
            return hourlyCell
        } else {
            guard let dailyCell = tableView.dequeueReusableCell(withIdentifier: DailyTableViewCell.id, for: indexPath) as? DailyTableViewCell else {
                return UITableViewCell()
            }
            dailyCell.accessoryType = .disclosureIndicator
            
            let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(dailyCellTapped))
            doubleTapGesture.numberOfTapsRequired = 2
            dailyCell.isUserInteractionEnabled = true
            dailyCell.addGestureRecognizer(doubleTapGesture)
            
            if let dateLabel = dailyCell.dateLabel.text {
                selectedDate = dateLabel
            } else {
                selectedDate = nil
            }

            return dailyCell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return Constants.heightHeaderOfCurrentCellSection
        } else if indexPath.section == 2 {
            return Constants.heightHeaderOfDailyCellSection + Constants.spacing
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            guard let headerForHourlyCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderForHourlyCell.id) as? HeaderForHourlyCell else {
                return UITableViewHeaderFooterView()
            }
            headerForHourlyCell.delegate = self
            return headerForHourlyCell
        } else if section == 2 {
            guard let headerForDailyCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderForDailyCell.id) as? HeaderForDailyCell else {
                return UITableViewHeaderFooterView()
            }
            headerForDailyCell.delegate = self
            return headerForDailyCell
        }
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return HeaderForHourlyCell().intrinsicContentSize.height
        } else if section == 2 {
            return HeaderForDailyCell().intrinsicContentSize.height
        }
        return 0
    }
    
}

extension MainView: HeaderForHourlyCellDelegate {
    func buttonTapped() {
        delegate?.showHourlyForecast()
    }
}

extension MainView: HeaderForDailyCellDelegate {
    func updateDaysCount(_ daysCount: Int) {
        self.numberOfDays = daysCount
        tableView.reloadSections(IndexSet(integer: 2), with: .fade)
        
        if let headerForDailyCell = tableView.headerView(forSection: 2) as? HeaderForDailyCell {
            headerForDailyCell.updateButtonText("\(numberOfDays) дней")
        }
    }
}

extension MainView: HourlyTableViewCellDelegate {
    func updateHourlyCollectionCell(at index: Int) {
        delegate?.updateHourlyCell(at: index)
    }
    
    
}

