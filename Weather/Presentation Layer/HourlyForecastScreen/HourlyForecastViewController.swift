

import UIKit

final class HourlyForecastViewController: UIViewController {
    
    var headerTitle: String?
    
    private lazy var hourlyForecastView = HourlyForecastView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
    }
    
    private func setupView() {
        view = hourlyForecastView
        hourlyForecastView.headerTitle = headerTitle
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Прогноз на 24 часа"
        
    }
    
}
