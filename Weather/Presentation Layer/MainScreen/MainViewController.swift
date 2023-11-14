
import UIKit
import CoreData

protocol MainViewControllerDelegate: AnyObject {
    func updateCurrentPage(at index: Int)
}

final class MainViewController: UIViewController {
    
    var weather: Weather?
        
    var pageViewController: PageViewController?
    
    var cities: [Weather] = []
    
    var currentIndex: Int = 0
    
    var isPageUpdated: Bool = false
    
    private let interactor: WeatherInteractorProtocol = WeatherInteractor()
    
    var mainView: MainView?
    var emptyView: EmptyView?
    private var onboardingView: OnboardingView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        start()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let backButton = UIBarButtonItem()
        backButton.title = "Назад"
        navigationItem.backBarButtonItem = backButton
    }
    
    private func start() {
        if interactor.isDetermind() {
            configurePageViewController()
        } else {
            showOnboardingScreen()
        }
    }
    
    private func configurePageViewController() {
        interactor.getCitiesWithWeatherData { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let allWeatherModels):
                if let existingPageViewController = pageViewController {
                    existingPageViewController.cities = cities
                    setupNavigationBar()
                    updateTitle(with: self.cities.first?.locationName)
                } else {
                    if let city = allWeatherModels.first {
                        self.mainView = MainView(frame: self.view.bounds, weather: city)
                        updateCity(at: 0, with: allWeatherModels) {
                            guard let mainView = self.mainView else { return }
                            self.weather = city
                            self.createNewPageViewController(with: mainView)
                        }
                    }
                }
            case .failure(_):
                showEmptyView()
            }
        }
    }
    
    private func updateCity(at index: Int, with allWeatherModels: [Weather], completion: @escaping () -> Void) {
        
        var array = allWeatherModels
        let model = array[index]
        
        interactor.updateWeatherInCoreData(coordinates: (latitude: model.latitude, longitude: model.longitude), locationName: model.locationName) { result in
            switch result {
            case .success(let city):
                array[index] = city
                self.cities = array
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func createNewPageViewController(with mainView: MainView) {
        let newPageViewController = PageViewController(cities: self.cities, mainView: mainView)
        newPageViewController.updateDelegate = self
        self.addChild(newPageViewController)
        self.didMove(toParent: self)
        self.view.addSubview(newPageViewController.view)
        self.pageViewController = newPageViewController
        self.setupNavigationBar()
        self.updateTitle(with: self.cities.first?.locationName)
    }
    
    func setupNavigationBar() {
        
        let settingsBarButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(showSettings))
        let locationBarButton = UIBarButtonItem(image: UIImage(systemName: "location"), style: .plain, target: self, action: #selector(showLocation))
        
        navigationItem.leftBarButtonItem = settingsBarButton
        navigationItem.rightBarButtonItem = locationBarButton
        
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem?.tintColor = .black
        
    }
    
    private func updateTitle(with locationName: String?) {
        if let location = locationName {
            navigationItem.title = location
        }
    }
    
    
    private func showOnboardingScreen() {
        onboardingView = OnboardingView()
        onboardingView?.delegate = self
        view = self.onboardingView
    }
    
    func showEmptyView() {
        emptyView = EmptyView()
        emptyView?.delegate = self
        view = emptyView
        setupNavigationBar()
    }
    
    private func showSearchBar() {
        let searchLocationViewController = SearchLocationViewController()
        searchLocationViewController.delegate = self
        navigationController?.modalPresentationStyle = .fullScreen
        navigationController?.modalTransitionStyle = .partialCurl
        navigationController?.present(searchLocationViewController, animated: true)
    }
    
    func markPageAsUpdated() {
        isPageUpdated = true
    }
    
    //                    let group = DispatchGroup()
    //
    //                    var array = allWeatherModels
    //                    guard let model = array.first else { return }
    //
    //                    group.enter()
    //
    //                    self.interactor.updateWeatherInCoreData(coordinates: (latitude: model.latitude, longitude: model.longitude), locationName: model.locationName) { result in
    //
    //                        defer {
    //                            group.leave()
    //                        }
    //
    //                        switch result {
    //                        case .success(let city):
    //                            array[0] = city
    //                            self.cities = array
    //                            print(city.locationName)
    //                        case .failure(let error):
    //                            print(error.localizedDescription)
    //                        }
    //                    }
    //
    //                    group.notify(queue: .main) {
    //                        self.createNewPageViewController()
    //                    }
    //                }
    //
    //            case .failure(_):
    //                showEmptyView()
    //            }
    //        }
    //    }
    
//    private func setupView() {
//        interactor.getWeatherFromCoreData() { [weak self] weatherArray in
//            guard let self = self else { return }
//            if let model = weatherArray.first {
//                weather = model
//                guard let weatherModel = self.weather else { return }
//                DispatchQueue.main.async {
//                    self.showMainView(with: weatherModel)
//                }
//            } else {
//                DispatchQueue.main.async {
//                    self.showEmptyView()
//                }
//            }
//        }
//    }
    
    
    
//    func showMainView(with weather: Weather) {
//        mainView = MainView(frame: self.view.bounds, weather: weather)
//        mainView?.delegate = self
//        mainView?.tableView.refreshControl = UIRefreshControl()
//        mainView?.tableView.refreshControl?.addTarget(self, action: #selector(self.refreshWeatherData), for: .valueChanged)
//        view = self.mainView
//        setupNavigationBar()
//        if let locationName = weather.locationName {
//            navigationItem.title = locationName
//        }
//    }
//    
//    
//    
//    private func updateNavigationBarTitle() {
//        if let weather = self.weather {
//            if let locationName = weather.locationName {
//                DispatchQueue.main.async {
//                    self.navigationItem.title = locationName
//                }
//            }
//        } else {
//            interactor.getWeatherFromCoreData() { [weak self] weatherArray in
//                guard let self else { return }
//                if let weather = weatherArray.first {
//                    if let locationName = weather.locationName {
//                        DispatchQueue.main.async {
//                            self.navigationItem.title = locationName
//                        }
//                    }
//                } else {
//                    print ("Ошибка получения модели Weather")
//                }
//            }
//        }
//    }
//    
//    private func fetchWeather() {
//        guard let mainView else { return }
//        mainView.tableView.refreshControl?.beginRefreshing()
//        interactor.fetchWeatherFromNetwork { [weak self] result in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                switch result {
//                case .success(_ ):
//                    mainView.tableView.refreshControl?.endRefreshing()
//                    self.updateNavigationBarTitle()
//                case .failure(let error):
//                    print("FetchWeather error \(error.localizedDescription)")
//                    mainView.tableView.refreshControl?.endRefreshing()
//                }
//            }
//        }
//    }
//    
//    private func checkLocationPermission() {
//        interactor.checkPermission { [weak self] isAuthorized in
//            guard let self else { return }
//            if isAuthorized {
//                DispatchQueue.main.async {
//                    self.fetchWeather()
//                }
//            } else {
//                self.mainView?.tableView.refreshControl?.endRefreshing()
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                    self.showLocationServicesAlert(message: "Для использования местоположения необходимо разрешение. Пожалуйста, разрешите в настройках приложения.")
//                }
//            }
//        }
//    }
//    
//    private func showLocationServicesAlert(message: String) {
//        let alertController = UIAlertController(
//            title: "Разрешение местоположения",
//            message: message,
//            preferredStyle: .alert
//        )
//
//        let settingsAction = UIAlertAction(
//            title: "Настройки приложения",
//            style: .default
//        ) { _ in
//            if let bundleIdentifier = Bundle.main.bundleIdentifier, let settingsURL = URL(string: UIApplication.openSettingsURLString + bundleIdentifier) {
//                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
//            }
//        }
//
//        let cancelAction = UIAlertAction(
//            title: "Отмена",
//            style: .cancel
//        )
//
//        alertController.addAction(settingsAction)
//        alertController.addAction(cancelAction)
//
//        present(alertController, animated: true, completion: nil)
//    }
    

//    
//    func updateView(with weather: Weather) {
//        self.weather = weather
//        interactor.fetchWeatherFromNetwork { [weak self] result in
//            guard let self else { return }
//            DispatchQueue.main.async {
//                switch result {
//                case .success(_ ):
//                    self.mainView?.tableView.reloadData()
//                    self.showMainView(with: weather)
//                case .failure(let error):
//                    print("FetchWeather error \(error.localizedDescription)")
//                }
//            }
//        }
//    }
    
//    @objc private func refreshWeatherData() {
//        checkLocationPermission()
//        interactor.fetchWeatherFromNetwork { [weak self] result in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                switch result {
//                case .success(_ ):
//                    self.mainView?.tableView.reloadData()
//                    self.setupView()
//                case .failure(let error):
//                    print("FetchWeather error \(error.localizedDescription)")
//                }
//            }
//        }
//    }
    
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
        let hourlyForecastViewController = HourlyForecastViewController(headerTitle: weatherModel.locationName ?? "", weather: weatherModel, selectedHour: selectedHour ?? 0)
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
        
        dailyForecastViewController.headerTitle = weatherModel.locationName
    
        navigationController?.pushViewController(dailyForecastViewController, animated: true)
    }

}

extension MainViewController: OnboardingViewDelegate {
    func showEmptyScreen() {
        self.showEmptyView()
    }
    
    func showMainScreen() {
//        self.refreshWeatherData()
    }
}

extension MainViewController: EmptyViewDelegate {
    func addLocationAction() {
        showSearchBar()
    }
}

extension MainViewController: SettingsViewControllerDelegate {
    func updatedSettings() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            mainView?.tableView.reloadData()
            pageViewController?.removeFromParent()
            pageViewController = nil
            pageViewController?.willMove(toParent: nil)
            configurePageViewController()
        }
    }
}

extension MainViewController: SearchLocationViewControllerDelegate {
    
    func fetchCoordinates(coordinates: (latitude: Double, longitude: Double)) {
        interactor.updateCoordinates(with: coordinates)
        emptyView?.showActivityIndicator()
//        refreshWeatherData()
    }
    
}

extension MainViewController: PageViewControllerUpdateDelegate {
    
    func updateCurrentPage(index: Int) {
        currentIndex = index
        updateTitle(with: cities[index].locationName)
    }
    
    func updateWeatherData(index: Int) {
        self.updateCity(at: index, with: cities) { [weak self] in
            guard let self else { return }
            weather = cities[index]
            pageViewController?.updateCurrentPageView(at: index, with: cities)
            print("✅ страница обновлена")
        }
    }
}
