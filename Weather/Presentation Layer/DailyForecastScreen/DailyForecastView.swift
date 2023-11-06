

import UIKit

protocol DailyForecastViewDelegate: AnyObject {
    func updateView(date: Date, index: Int)
}

final class DailyForecastView: UIView {
    
    private enum Constants {
        static let spacing: CGFloat = 0
        static let separatorInsets: CGFloat = 16
    }
    
    weak var delegate: DailyForecastViewDelegate?
    
    private let dailyTimePeriod: DailyTimePeriod
    private var dateIndex: Int
    private var selectedDate: Date
    private let airQuality: AirQuality
    private let astronomy: Astronomy
    
    private var numberOfSections: Int = 0
    
    var headerTitle: String?
    
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
    
    init(frame: CGRect, dailyTimePeriod: DailyTimePeriod, dateIndex: Int, selectedDate: Date, airQuality: AirQuality, astronomy: Astronomy) {
        self.dailyTimePeriod = dailyTimePeriod
        self.dateIndex = dateIndex
        self.selectedDate = selectedDate
        self.airQuality = airQuality
        self.astronomy = astronomy
        super.init(frame: frame)
        setupView()
        addSubviews()
        setupTableView()
        setupLayout()
        calculateNumberOfSections()
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
    
    private func calculateNumberOfSections(){
        let selectedDay = CustomDateFormatter().formattedDateToString(date: selectedDate, dateFormat: "yyyy-MM-dd", locale: nil)
        
        var count: Int = 0
        for (date, timePeriods) in dailyTimePeriod.dailyForecast {
            let dateString = CustomDateFormatter().formattedDateToString(date: date, dateFormat: "yyyy-MM-dd", locale: nil)
            if dateString == selectedDay {
                count += timePeriods.count
            }
        }
        numberOfSections = count + 3
    }
    
    private func updateViewWithSelectedDate() {
        
    }
}

extension DailyForecastView: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == numberOfSections - 1 || section == numberOfSections - 2 {
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
            datesCell.dailyTimePeriod = dailyTimePeriod
            datesCell.selectedIndex = dateIndex
            datesCell.delegate = self
            return datesCell
        } else if indexPath.section == numberOfSections - 2 {
            guard let sunAndMoonCell = tableView.dequeueReusableCell(withIdentifier: SunAndMoonTableViewCell.id, for: indexPath) as? SunAndMoonTableViewCell else {
                return UITableViewCell()
            }
            sunAndMoonCell.selectionStyle = .none
            sunAndMoonCell.dateIndex = dateIndex
            sunAndMoonCell.astronomy = astronomy
            sunAndMoonCell.configure(with: astronomy, at: dateIndex)
            
            return sunAndMoonCell
        } else if indexPath.section == numberOfSections - 1 {
            guard let airQualityCell = tableView.dequeueReusableCell(withIdentifier: AirQualityTableViewCell.id, for: indexPath) as? AirQualityTableViewCell else {
                return UITableViewCell()
            }
            airQualityCell.selectionStyle = .none
            airQualityCell.configure(with: airQuality, at: dateIndex)
            return airQualityCell
        } else {
            if indexPath.row == 0 {
                guard let partOfTheDayCell = tableView.dequeueReusableCell(withIdentifier: PartOfTheDayTableViewCell.id, for: indexPath) as? PartOfTheDayTableViewCell else {
                    return UITableViewCell()
                }
                partOfTheDayCell.selectionStyle = .none
                partOfTheDayCell.configure(with: dailyTimePeriod, at: dateIndex, at: indexPath.section)
                return partOfTheDayCell
            } else {
                guard let weatherInfoCell = tableView.dequeueReusableCell(withIdentifier: WeatherInfoTableViewCell.id, for: indexPath) as? WeatherInfoTableViewCell else {
                    return UITableViewCell()
                }
                weatherInfoCell.selectionStyle = .none
                weatherInfoCell.configure(with: dailyTimePeriod, at: dateIndex, at: indexPath.section, at: indexPath.row)
                return weatherInfoCell
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == numberOfSections - 2 {
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
        if indexPath.section == 1 && indexPath.row == 0 || indexPath.section == 2 && indexPath.row == 0 || indexPath.section == 3 && indexPath.row == 0 || indexPath.section == 4 && indexPath.row == 0 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.frame.size.width, bottom: 0, right: 0)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: Constants.separatorInsets, bottom: 0, right: Constants.separatorInsets)
        }
    }
    
}

extension DailyForecastView: DatesTableViewCellDelegate {
    func showForecastForSelectedDate(date: Date, index: Int) {
        dateIndex = index
        selectedDate = date
        delegate?.updateView(date: date, index: index)
    }
    
    
}
