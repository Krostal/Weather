
import UIKit

final class MainViewController: UIViewController {
    
    private lazy var mainView = MainView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let backButton = UIBarButtonItem()
        backButton.title = "Назад"
        navigationItem.backBarButtonItem = backButton
    }
    
    private func setupView() {
        mainView.delegate = self
        view = mainView
        
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Current location"
                
        let settingsBarButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(showSettings))
        let locationBarButton = UIBarButtonItem(image: UIImage(systemName: "location"), style: .plain, target: self, action: #selector(showLocation))
        
        navigationItem.leftBarButtonItem = settingsBarButton
        navigationItem.rightBarButtonItem = locationBarButton
        
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    @objc private func showSettings(_ sender: UIBarButtonItem) {
        
    }
    
    @objc private func showLocation(_ sender: UIBarButtonItem) {
        
    }
    
}

extension MainViewController: MainViewDelegate {
    func showHourlyForecast() {
        let hourlyForecastViewController = HourlyForecastViewController()
        hourlyForecastViewController.headerTitle = navigationItem.title
        navigationController?.pushViewController(hourlyForecastViewController, animated: true)
       
    }
}