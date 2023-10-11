import UIKit

final class DailyForecastViewController: UIViewController {
    
    var headerTitle: String?
    
    private lazy var dailyForecastView = DailyForecastView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
    }
    
    private func setupView() {
        view = dailyForecastView
        dailyForecastView.headerTitle = headerTitle
    }
    
    private func setupNavigationBar() {
        
    }
    
}

