
import UIKit
import CoreData

final class MainViewController: UIViewController {
    
    private var mainView: MainView?
    
    private var onboardingView: OnboardingView?
    
    private let interactor: WeatherInteractorProtocol = WeatherInteractor(fetchDataService: FetchDataService<WeatherJsonModel>(), coreDataService: CoreDataService.shared, locationService: LocationService())
    
    private var weather: Weather?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if interactor.isDetermined() {
            refreshWeatherData()
        } else {
            setupView()
            fetchWeather()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let backButton = UIBarButtonItem()
        backButton.title = "Назад"
        navigationItem.backBarButtonItem = backButton
    }
    
    private func setupView() {
        interactor.getWeatherFromCoreData(withPredicate: nil) { [weak self] weatherArray in
            guard let self = self else { return }
            if let model = weatherArray.last {
                self.weather = model
                guard let weatherModel = self.weather else { return }
                DispatchQueue.main.async {
                    self.mainView = MainView(frame: self.view.bounds, weather: weatherModel)
                    self.mainView?.delegate = self
                    self.mainView?.tableView.refreshControl = UIRefreshControl()
                    self.mainView?.tableView.refreshControl?.addTarget(self, action: #selector(self.refreshWeatherData), for: .valueChanged)
                    self.view = self.mainView
                    self.setupNavigationBar()
                }
            } else {
                self.onboardingView = OnboardingView()
                self.onboardingView?.delegate = self
                DispatchQueue.main.async {
                    self.view = self.onboardingView
                }
            }
        }
    }
    
    private func setupNavigationBar() {
        
        let settingsBarButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(showSettings))
        let locationBarButton = UIBarButtonItem(image: UIImage(systemName: "location"), style: .plain, target: self, action: #selector(showLocation))
        
        navigationItem.leftBarButtonItem = settingsBarButton
        navigationItem.rightBarButtonItem = locationBarButton
        
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        updateNavigationBarTitle()
    }
    
    private func updateNavigationBarTitle() {
        if let weatherModel = self.weather {
            if let locationName = weatherModel.location?.name {
                DispatchQueue.main.async {
                    self.navigationItem.title = locationName
                }
            }
        } else {
            interactor.getWeatherFromCoreData(withPredicate: nil) { [weak self] weatherArray in
                guard let self else { return }
                if let weather = weatherArray.last {
                    if let locationName = weather.location?.name {
                        DispatchQueue.main.async {
                            self.navigationItem.title = locationName
                        }
                    }
                } else {
                    print ("Ошибка получения модели Weather")
                }
            }
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
    
    private func checkLocationPermission() {
        interactor.checkPermission { [weak self] isAuthorized in
            guard let self else { return }
            if isAuthorized {
                DispatchQueue.main.async {
                    self.fetchWeather()
                }
            } else {
                self.mainView?.tableView.refreshControl?.endRefreshing()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.showLocationServicesAlert(message: "Для использования местоположения необходимо разрешение. Пожалуйста, разрешите в настройках приложения.")
                }
            }
        }
    }
    
    func showLocationServicesAlert(message: String) {
        let alertController = UIAlertController(
            title: "Разрешение местоположения",
            message: message,
            preferredStyle: .alert
        )

        let settingsAction = UIAlertAction(
            title: "Настройки приложения",
            style: .default
        ) { _ in
            if let bundleIdentifier = Bundle.main.bundleIdentifier, let settingsURL = URL(string: UIApplication.openSettingsURLString + bundleIdentifier) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }

        let cancelAction = UIAlertAction(
            title: "Отмена",
            style: .cancel
        )

        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    func showLocationSettingsAlert(message: String) {
        let alertController = UIAlertController(
            title: "Настройки геолокации",
            message: message,
            preferredStyle: .alert
        )

        let settingsAction = UIAlertAction(
            title: "Настройки",
            style: .default
        ) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        }

        let cancelAction = UIAlertAction(
            title: "Отмена",
            style: .cancel
        )

        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func refreshWeatherData() {
        checkLocationPermission()
        interactor.fetchFromNetwork { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(_ ):
                    self.setupView()
                    self.updateNavigationBarTitle()
                case .failure(let error):
                    print("FetchWeather error \(error.localizedDescription)")
                }
            }
        }
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
        guard let weatherModel = self.weather else { return }
        let hourlyForecastViewController = HourlyForecastViewController(headerTitle: navigationItem.title ?? "", weatherModel: weatherModel)
        navigationController?.pushViewController(hourlyForecastViewController, animated: true)
    }
    
    func showDailyForecast(forDate date: String) {
        let dailyForecastViewController = DailyForecastViewController()
        dailyForecastViewController.navigationItem.title = "Погода \(date)"
        dailyForecastViewController.headerTitle = navigationItem.title
        navigationController?.pushViewController(dailyForecastViewController, animated: true)
    }

}

extension MainViewController: OnboardingViewDelegate {
    func requestLocationWhenInUseAuthorization() {
        self.refreshWeatherData()
    }
}
