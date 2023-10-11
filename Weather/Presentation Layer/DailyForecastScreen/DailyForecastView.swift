

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
        tableView.register(SunAndMoonTableViewCell.self, forCellReuseIdentifier: SunAndMoonTableViewCell.id)
        tableView.register(AirQualityTableViewCell.self, forCellReuseIdentifier: AirQualityTableViewCell.id)
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
        5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 || section == 2 {
            return 6
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let datesCell = tableView.dequeueReusableCell(withIdentifier: DatesTableViewCell.id, for: indexPath) as? DatesTableViewCell else {
                return UITableViewCell()
            }
            
            return datesCell
            
        } else if indexPath.section == 1 || indexPath.section == 2 {
            
            if indexPath.row == 0 {
                guard let partOfTheDayCell = tableView.dequeueReusableCell(withIdentifier: PartOfTheDayTableViewCell.id, for: indexPath) as? PartOfTheDayTableViewCell else {
                    return UITableViewCell()
                }
                
                if indexPath.section == 1 {
                    partOfTheDayCell.configuresection1()
                } else {
                    partOfTheDayCell.configuresection2()
                }
                
                partOfTheDayCell.selectionStyle = .none
                return partOfTheDayCell
            } else {
                guard let weatherInfoCell = tableView.dequeueReusableCell(withIdentifier: WeatherInfoTableViewCell.id, for: indexPath) as? WeatherInfoTableViewCell else {
                    return UITableViewCell()
                }
                
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
                
                weatherInfoCell.selectionStyle = .none
                return weatherInfoCell
            }
        } else if indexPath.section == 3 {
            guard let sunAndMoonCell = tableView.dequeueReusableCell(withIdentifier: SunAndMoonTableViewCell.id, for: indexPath) as? SunAndMoonTableViewCell else {
                return UITableViewCell()
            }
            return sunAndMoonCell
        } else if indexPath.section == 4 {
            guard let airQualityCell = tableView.dequeueReusableCell(withIdentifier: AirQualityTableViewCell.id, for: indexPath) as? AirQualityTableViewCell else {
                return UITableViewCell()
            }
            return airQualityCell
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 3 {
            return 180
        }
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
        if indexPath.section == 1 && indexPath.row == 0 || indexPath.section == 2 && indexPath.row == 0 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.frame.size.width, bottom: 0, right: 0)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: Constants.separatorInsets, bottom: 0, right: Constants.separatorInsets)
        }
    }
    
}
