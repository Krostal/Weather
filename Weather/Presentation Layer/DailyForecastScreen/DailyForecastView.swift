

import UIKit

final class DailyForecastView: UIView {
    
    var headerTitle: String?
        
    private enum Constants {
        static let spacing: CGFloat = 0
        static let separatorInsets: CGFloat = 16
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DatesTableViewCell.self, forCellReuseIdentifier: DatesTableViewCell.id)
        tableView.register(PartOfTheDayTableViewCell.self, forCellReuseIdentifier: PartOfTheDayTableViewCell.id)
        tableView.register(WeatherInfoTableViewCell.self, forCellReuseIdentifier: WeatherInfoTableViewCell.id)
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
        tableView.sectionFooterHeight = 0
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .black
        tableView.separatorInset = UIEdgeInsets(
            top: 0,
            left: Constants.separatorInsets,
            bottom: 0,
            right: Constants.separatorInsets
        )
    }
    
    private func setupLayout() {
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Constants.spacing),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Constants.spacing),
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.spacing),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Constants.spacing)
        ])
        
    }
}

extension DailyForecastView: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 6
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let datesCell = tableView.dequeueReusableCell(withIdentifier: DatesTableViewCell.id, for: indexPath) as? DatesTableViewCell else {
                return UITableViewCell()
            }
            
            return datesCell
            
        } else if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                guard let partOfTheDayCell = tableView.dequeueReusableCell(withIdentifier: PartOfTheDayTableViewCell.id, for: indexPath) as? PartOfTheDayTableViewCell else {
                    return UITableViewCell()
                }
                partOfTheDayCell.selectionStyle = .none
                
                return partOfTheDayCell
            } else {
                guard let weatherInfoCell = tableView.dequeueReusableCell(withIdentifier: WeatherInfoTableViewCell.id, for: indexPath) as? WeatherInfoTableViewCell else {
                    return UITableViewCell()
                }
                weatherInfoCell.selectionStyle = .none
                
                if indexPath.row == 1 {
                    weatherInfoCell.configureRow1()
                } else if indexPath.row == 2 {
                    weatherInfoCell.configureRow2()
                } else if indexPath.row == 3 {
                    weatherInfoCell.configureRow3()
                } else if indexPath.row == 4 {
                    weatherInfoCell.configureRow4()
                } else if indexPath.row == 5 {
                    weatherInfoCell.configureRow5()
                }
                
                return weatherInfoCell
            }
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return headerTitle
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Скрываем разделитель для первой и второй строки
        if indexPath.section == 1 && indexPath.row == 0 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.frame.size.width, bottom: 0, right: 0)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: Constants.separatorInsets, bottom: 0, right: Constants.separatorInsets)
        }
    }
    
}
