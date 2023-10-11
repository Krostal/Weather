

import UIKit

final class TemperatureСhartTableViewCell: UITableViewCell {
    
    static let id = "TemperatureСhartTableViewCell"
    
    private lazy var temperatureChartView: TemperatureChartView = {
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
    
}
