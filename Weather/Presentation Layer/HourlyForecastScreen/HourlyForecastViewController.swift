

import UIKit

final class HourlyForecastViewController: UIViewController {
    
    private var hourlyForecastView: HourlyForecastView?
    private let headerTitle: String
    private let weather: Weather
    private var selectedHour: Int?
    
    init(headerTitle: String, weather: Weather, selectedHour: Int?) {
        self.headerTitle = headerTitle
        self.weather = weather
        self.selectedHour = selectedHour
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
    }
    
    private func setupView() {
        hourlyForecastView = HourlyForecastView(frame: self.view.bounds, weather: weather, headerTitle: headerTitle, selectedHour: selectedHour)
        view = hourlyForecastView
        hourlyForecastView?.scrollToRow()
        }
    
    private func setupNavigationBar() {
        navigationItem.title = "Прогноз на 24 часа"
    }
    
}
