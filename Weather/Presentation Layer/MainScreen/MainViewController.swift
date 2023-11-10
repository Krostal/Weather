
import UIKit
import CoreData

final class MainViewController: UIViewController {
    
    private var mainView: MainView?
    
    private var emptyView: EmptyView?
    
    private var onboardingView: OnboardingView?
    
    private var weather: Weather?
    
    private let interactor: WeatherInteractorProtocol = WeatherInteractor()
    
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
        
        interactor.getWeatherFromCoreData() { [weak self] weatherArray in
            guard let self = self else { return }
            if let model = weatherArray.last {
                self.weather = model
                guard let weatherModel = self.weather else { return }
                
                DispatchQueue.main.async {
                    self.createAndShowMainView(with: weatherModel)
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
    
    private func createAndShowMainView(with weather: Weather) {
        mainView = MainView(frame: self.view.bounds, weather: weather)
        mainView?.delegate = self
        mainView?.tableView.refreshControl = UIRefreshControl()
        mainView?.tableView.refreshControl?.addTarget(self, action: #selector(self.refreshWeatherData), for: .valueChanged)
        view = self.mainView
        setupNavigationBar()
        updateNavigationBarTitle()
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
        if let weather = self.weather {
            if let locationName = weather.locationName {
                DispatchQueue.main.async {
                    self.navigationItem.title = locationName
                }
            }
        } else {
            interactor.getWeatherFromCoreData() { [weak self] weatherArray in
                guard let self else { return }
                if let weather = weatherArray.last {
                    if let locationName = weather.locationName {
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
        interactor.fetchWeatherFromNetwork { [weak self] result in
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
    
    private func showLocationServicesAlert(message: String) {
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
    
    private func showSearchBar() {
        let searchLocationViewController = SearchLocationViewController()
        searchLocationViewController.delegate = self
        navigationController?.modalPresentationStyle = .fullScreen
        navigationController?.modalTransitionStyle = .partialCurl
        navigationController?.present(searchLocationViewController, animated: true)
    }
    
    private func showEmptyView() {
        emptyView = EmptyView()
        emptyView?.delegate = self
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            view = emptyView
            setupNavigationBar()
        }
    }
    
    @objc private func refreshWeatherData() {
        checkLocationPermission()
        interactor.fetchWeatherFromNetwork { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(_ ):
                    self.mainView?.tableView.reloadData()
                    self.setupView()
                case .failure(let error):
                    print("FetchWeather error \(error.localizedDescription)")
                }
            }
        }
    }
    
    @objc private func showSettings(_ sender: UIBarButtonItem) {
        let settingsViewController = SettingsViewController()
        settingsViewController.delegate = self
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
    func showHourlyForecast(with selectedHour: Int?) {
        guard let weatherModel = self.weather else {
            return
        }
        let hourlyForecastViewController = HourlyForecastViewController(headerTitle: navigationItem.title ?? "", weather: weatherModel, selectedHour: selectedHour ?? 0)
        navigationController?.pushViewController(hourlyForecastViewController, animated: true)
    }
    
    func showDailyForecast(forDate date: Date, dateIndex: Int) {
        guard let weatherModel = weather,
              let dailyTimePeriod = DailyTimePeriod(weather: weatherModel)
        else {
            return
        }
        
        let dailyForecastViewController = DailyForecastViewController(weather: weatherModel, dailyTimePeriod: dailyTimePeriod, dateIndex: dateIndex, selectedDate: date)
        let dateString = CustomDateFormatter().formattedDateToString(date: date, dateFormat: "dd MMMM, EEEE", locale: Locale(identifier: "ru_RU"))
        dailyForecastViewController.navigationItem.title = dateString
        
        dailyForecastViewController.headerTitle = navigationItem.title
    
        navigationController?.pushViewController(dailyForecastViewController, animated: true)
    }

}

extension MainViewController: OnboardingViewDelegate {
    func showEmptyScreen() {
        self.showEmptyView()
    }
    
    func requestLocationWhenInUseAuthorization() {
        self.refreshWeatherData()
    }
}

extension MainViewController: SettingsViewControllerDelegate {
    func updatedSettings() {
        self.refreshWeatherData()
    }
}

extension MainViewController: EmptyViewDelegate {
    func addLocationAction() {
        showSearchBar()
    }
}

extension MainViewController: SearchLocationViewControllerDelegate {
    
    func fetchCoordinates(coordinates: (latitude: Double, longitude: Double)) {
        interactor.updateCoordinates(with: coordinates)
        emptyView?.showActivityIndicator()
        refreshWeatherData()
    }
    
}
