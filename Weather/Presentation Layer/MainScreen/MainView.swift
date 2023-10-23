
import UIKit
import CoreData

protocol MainViewDelegate: AnyObject {
    func showHourlyForecast()
    func showDailyForecast(forDate date: String)
}

final class MainView: UIView {
    
    private enum Constants {
        static let heightHeaderOfCurrentCellSection: CGFloat = 212
        static let heightHeaderOfDailyCellSection: CGFloat = 56
        static let spacing: CGFloat = 16
    }
    
    weak var delegate: MainViewDelegate?
    
    private var selectedDate: String?
    
    private var numberOfDays: Int = 7
    private var isDailyToggleOn = false
    
    let weather: Weather
    let currentTimePeriod: CurrentTimePeriod
    let dailyTimePeriod: DailyTimePeriod
    
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
    
    init(frame: CGRect, weather: Weather) {
        self.weather = weather
        self.currentTimePeriod = CurrentTimePeriod(model: weather) ?? CurrentTimePeriod()
        self.dailyTimePeriod = DailyTimePeriod(model: weather) ?? DailyTimePeriod()
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
            currentCell.configure(with: currentTimePeriod, at: indexPath.row)
            return currentCell
        } else if indexPath.section == 1 {
            guard let hourlyCell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.id, for: indexPath) as? HourlyTableViewCell else {
                return UITableViewCell()
            }
            hourlyCell.weather = weather
            
            
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
            dailyCell.configure(with: dailyTimePeriod, at: indexPath.row)
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
            headerForDailyCell.isToggled = isDailyToggleOn
            headerForDailyCell.maxNumberOfDays = dailyTimePeriod.dailyForecast.keys.count
        
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
    func changeNumberOfRows() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            isDailyToggleOn.toggle()
            numberOfDays = isDailyToggleOn ? dailyTimePeriod.dailyForecast.keys.count : 7
            
            self.tableView.reloadSections(IndexSet(integer: 2), with: .automatic)
            if let headerView = tableView.headerView(forSection: 2) as? HeaderForDailyCell {
                headerView.isToggled = isDailyToggleOn
                headerView.updateButtonText()
            }
        }
    }
}

