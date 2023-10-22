
import UIKit
import CoreData

final class MainViewController: UIViewController {
    
    private var mainView: MainView?
        
    private let interactor: WeatherInteractorProtocol = WeatherInteractor(fetchDataService: FetchDataService<WeatherJsonModel>(), coreDataService: CoreDataService.shared, locationService: LocationService())
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        fetchWeather()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let backButton = UIBarButtonItem()
        backButton.title = "Назад"
        navigationItem.backBarButtonItem = backButton
    }
    
    private func setupView() {
        let weathersArray = interactor.getWeatherFromCoreData(withPredicate: nil)
        if let weather = weathersArray.last {
            mainView = MainView(frame: self.view.bounds, weather: weather)
            guard let mainView = mainView else { return }
            mainView.delegate = self
            mainView.tableView.refreshControl = UIRefreshControl()
            mainView.tableView.refreshControl?.addTarget(self, action: #selector(refreshWeatherData), for: .valueChanged)
            view = mainView
        } else {
            view = UIView()
        }
    }
    
    private func setupNavigationBar() {
                
        let settingsBarButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(showSettings))
        let locationBarButton = UIBarButtonItem(image: UIImage(systemName: "location"), style: .plain, target: self, action: #selector(showLocation))
        
        navigationItem.leftBarButtonItem = settingsBarButton
        navigationItem.rightBarButtonItem = locationBarButton
        
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    private func updateNavigationBarTitle() {
        let request: NSFetchRequest<Weather> = Weather.fetchRequest()
        request.fetchLimit = 1
            
            do {
                let result = try CoreDataService.shared.setContext().fetch(request)
                if let weather = result.last {
                    if let locationName = weather.location?.name {
                        navigationItem.title = locationName
                    }
                }
            } catch {
                print("Error fetching weather data: \(error.localizedDescription)")
            }
    }
    
    private func fetchWeather() {
        guard let mainView else { return }
        mainView.tableView.refreshControl?.beginRefreshing()
        interactor.fetchFromNetwork { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(_ ):
                    mainView.tableView.refreshControl?.endRefreshing()
                    self.updateNavigationBarTitle()
                case .failure(let error):
                    print("FetchWeather error \(error.localizedDescription)")
                    mainView.tableView.refreshControl?.endRefreshing()
                }
            }
        }
    }
    
    @objc private func refreshWeatherData() {
        self.fetchWeather()
    }
    
    @objc private func showSettings(_ sender: UIBarButtonItem) {
        let settingsViewController = SettingsViewController()
        navigationController?.modalPresentationStyle = .formSheet
        navigationController?.modalTransitionStyle = .flipHorizontal
        navigationController?.present(settingsViewController, animated: true)
    }
    
    @objc private func showLocation(_ sender: UIBarButtonItem) {
        let onboardingViewController = OnboardingViewController()
        navigationController?.modalPresentationStyle = .automatic
        navigationController?.modalTransitionStyle = .coverVertical
        navigationController?.present(onboardingViewController, animated: true)
    }
}

extension MainViewController: MainViewDelegate {

    func showHourlyForecast() {
        let hourlyForecastViewController = HourlyForecastViewController()
        hourlyForecastViewController.headerTitle = navigationItem.title
        navigationController?.pushViewController(hourlyForecastViewController, animated: true)
    }
    
    func showDailyForecast(forDate date: String) {
        let dailyForecastViewController = DailyForecastViewController()
        dailyForecastViewController.navigationItem.title = "Погода \(date)"
        dailyForecastViewController.headerTitle = navigationItem.title
        navigationController?.pushViewController(dailyForecastViewController, animated: true)
    }

}
