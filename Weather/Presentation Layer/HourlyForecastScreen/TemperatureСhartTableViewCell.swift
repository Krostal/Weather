
import DGCharts
import UIKit

final class TemperatureСhartTableViewCell: UITableViewCell {
    
    static let id = "TemperatureСhartTableViewCell"
    
    var temperatureData: [ChartDataEntry] = []
    
    var timeData: [ChartDataEntry] = []
    
    lazy var temperatureChartView: TemperatureChartView = {
        let chartView = TemperatureChartView()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        return chartView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemBlue.withAlphaComponent(0.1)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(temperatureChartView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            temperatureChartView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            temperatureChartView.leadingAnchor.constraint(equalTo: leadingAnchor),
            temperatureChartView.trailingAnchor.constraint(equalTo: trailingAnchor),
            temperatureChartView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ])
    }
    
    func setupChartData(timePeriod: [ThreeHoursForecast]) {
        timePeriod.forEach {
            let index = Double($0.index)
            let temperature = Double($0.instantData.airTemperature)
            let chartDataEntry = ChartDataEntry(x: index, y: temperature)
            temperatureData.append(chartDataEntry)
            temperatureChartView.updateChartWithWeatherData(temperatureData)
            guard let time = Double($0.time) else { return }
            let timeDataEntry = ChartDataEntry(x: time, y: 0)
            timeData.append(timeDataEntry)
            temperatureChartView.updateXAxisWithTimeData(timeData)
        }
    }
}
    
