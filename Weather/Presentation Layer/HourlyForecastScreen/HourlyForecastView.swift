

import UIKit

final class HourlyForecastView: UIView {
    
    private let headerTitle: String
    private let weather: Weather
    private var hourlyTimePeriod: HourlyTimePeriod?
        
    private enum Constants {
        static let spacing: CGFloat = 0
        static let separatorInsets: CGFloat = 16
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TemperatureСhartTableViewCell.self, forCellReuseIdentifier: TemperatureСhartTableViewCell.id)
        tableView.register(HourlyForecastTableViewCell.self, forCellReuseIdentifier: HourlyForecastTableViewCell.id)
        return tableView
    }()
    
    init(frame: CGRect, weather: Weather, headerTitle: String) {
        self.weather = weather
        self.headerTitle = headerTitle
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
    
extension HourlyForecastView: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return hourlyTimePeriod?.time.count ?? 24
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let tempChartCell = tableView.dequeueReusableCell(withIdentifier: TemperatureСhartTableViewCell.id, for: indexPath) as? TemperatureСhartTableViewCell
            else {
                return UITableViewCell()
            }
            tempChartCell.selectionStyle = .none
            tempChartCell.temperatureChartView.weather = weather
            
            let threeHoursForecast = HourlyTimePeriod.createForEveryThirdIndex(from: weather)
            let hours = HourlyTimePeriod.createArrayOfHours(from: weather)

            tempChartCell.setupChartData(timePeriod: threeHoursForecast, hours: hours)

            return tempChartCell
    
        } else {
            guard let hourlyForecastCell = tableView.dequeueReusableCell(withIdentifier: HourlyForecastTableViewCell.id, for: indexPath) as? HourlyForecastTableViewCell else {
                return UITableViewCell()
            }
            
            hourlyTimePeriod = HourlyTimePeriod(model: weather, index: indexPath.row)
            
            if let timePeriod = hourlyTimePeriod {
                hourlyForecastCell.configure(with: timePeriod, at: indexPath.row)
            }
            
            return hourlyForecastCell
        }
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
    
}

