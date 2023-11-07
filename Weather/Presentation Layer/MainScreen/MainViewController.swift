
import UIKit
import CoreData

final class MainViewController: UIViewController {
    
    private var mainView: MainView?
    
    private var onboardingView: OnboardingView?
    
    private let interactor: WeatherInteractorProtocol = WeatherInteractor(fetchDataService: FetchDataService(), coreDataService: CoreDataService.shared, locationService: LocationService())
    
    private var weather: Weather?
    private var astronomy: Astronomy?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if interactor.isDetermined() {
            refreshWeatherData()
        } else {
            setupView()
            fetchWeather()
            fetchAirQuality()
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
                interactor.getAstronomyFromCoreData(withPredicate: nil) { astronomyArray in
                    if let model = astronomyArray.last {
                        self.astronomy = model
                    } else {
                        print("в CoreData отсутствует модель Astronomy")
                    }
                }
                
                DispatchQueue.main.async {
                    self.mainView = MainView(frame: self.view.bounds, weather: weatherModel, astronomy: self.astronomy)
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
        interactor.fetchWeatherFromNetwork { [weak self] result in
            guard let self = self else { return }
            fetchAstronomy()
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
    
    private func fetchAirQuality() {
        interactor.fetchAirQualityFromNetwork { result in
            switch result {
            case .success(_ ):
                print("Данные о качестве воздуха успешно получены")
            case .failure(let error):
                print("AirQuality error \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchAstronomy() {
        interactor.fetchAstronomyFromNetwork { result in
            switch result {
            case .success(_ ):
                print("Астрономические данные успешно получены")
            case .failure(let error):
                print("Astronomy error \(error.localizedDescription)")
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
        fetchAirQuality()
        interactor.fetchWeatherFromNetwork { [weak self] result in
            guard let self = self else { return }
            fetchAstronomy()
            DispatchQueue.main.async {
                switch result {
                case .success(_ ):
                    self.mainView?.tableView.reloadData()
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
        guard let weatherModel = self.weather else { return }
        let hourlyForecastViewController = HourlyForecastViewController(headerTitle: navigationItem.title ?? "", weatherModel: weatherModel, selectedHour: selectedHour ?? 0)
        navigationController?.pushViewController(hourlyForecastViewController, animated: true)
    }
    
    func showDailyForecast(forDate date: Date, dateIndex: Int) {
        guard let weather = weather,
              let dailyTimePeriod = DailyTimePeriod(model: weather)
        else {
            return
        }
        
        let dailyForecastViewController = DailyForecastViewController(dailyTimePeriod: dailyTimePeriod, astronomy: self.astronomy, dateIndex: dateIndex, selectedDate: date)
        let dateString = CustomDateFormatter().formattedDateToString(date: date, dateFormat: "dd MMMM, EEEE", locale: Locale(identifier: "ru_RU"))
        dailyForecastViewController.navigationItem.title = dateString
        
        dailyForecastViewController.headerTitle = navigationItem.title
    
        navigationController?.pushViewController(dailyForecastViewController, animated: true)
    }

}

extension MainViewController: OnboardingViewDelegate {
    func requestLocationWhenInUseAuthorization() {
        self.refreshWeatherData()
    }
}

extension MainViewController: SettingsViewControllerDelegate {
    func updatedSettings() {
        self.refreshWeatherData()
    }
}
