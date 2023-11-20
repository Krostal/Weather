
import UIKit
import CoreData

final class MainViewController: UIViewController {
    
    private let interactor: WeatherInteractorProtocol = WeatherInteractor()
    
    var weather: Weather?
    var pageViewController: PageViewController?

    var cities: [Weather] = []
    var isPageUpdated: Bool = false

    var mainView: MainView?
    var emptyView: EmptyView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePageViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let backButton = UIBarButtonItem()
        backButton.title = "Назад"
        navigationItem.backBarButtonItem = backButton
    }
    
    private func configurePageViewController() {
        if interactor.isAuthorizedToUseLocation() {
            print("Есть разрешение на использование местоположения")
            // запрос погоды для текущей локации и устанавливаем pageViewController
            fetchAndShowWeatherForCurrentLocation()
        } else {
            print("Нет разрешения на использование местоположения")
            // получаем сущестующие модели из Core Data и устанавливаем pageViewController
            fetchAndShowExistingWeatherData()
        }
    }
    
    private func fetchAndShowWeatherForCurrentLocation() {
        interactor.fetchWeatherFromNetwork { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(_ ):
                interactor.getCitiesWithWeatherData { cities in
                    self.cities = cities
                    DispatchQueue.main.async {
                        self.createNewPageViewController()
                    }
                }
            case .failure(let error):
                print("FetchWeather error \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchAndShowExistingWeatherData() {
        interactor.getCitiesWithWeatherData { [weak self] cities in
            guard let self else { return }
            self.cities = cities
            DispatchQueue.main.async {
                self.createNewPageViewController()
            }
        }
    }
    
    private func fetchWeatherForCurrentPage(with weather: Weather, at index: Int) {
        guard let pageViewController = pageViewController else { return }
        if !isPageUpdated {
            interactor.updateWeatherInCoreData(coordinates: (latitude: weather.latitude, longitude: weather.longitude), locationName: weather.locationName) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let updatedWeather):
                    cities[index] = updatedWeather
                    pageViewController.cities[index] = updatedWeather
                    isPageUpdated = true
                    DispatchQueue.main.async {
                        pageViewController.pages[index].mainView?.tableView.reloadData()
                        pageViewController.updateCurrentPage(with: updatedWeather, at: index)
                    }
                case .failure(let error):
                    print("FetchWeather error \(error.localizedDescription)")
                }
            }
        } else {
            DispatchQueue.main.async {
                pageViewController.pages[index].mainView?.tableView.reloadData()
                pageViewController.updateCurrentPage(with: weather, at: index)
                print("Страница уже была обновлена")
            }
        }
    }
    
    private func createNewPageViewController() {
        if let existingPageViewController = pageViewController {
            print("❌", existingPageViewController.children)
            print("❌", view.subviews)
            existingPageViewController.removeFromParent()
            existingPageViewController.view.removeFromSuperview()
            print("✅", existingPageViewController.children)
            print("✅", view.subviews)
        }
        
        let newPageViewController = PageViewController(cities: cities)
        newPageViewController.updateDelegate = self
        addChild(newPageViewController)
        didMove(toParent: self)
        view.addSubview(newPageViewController.view)
        pageViewController = newPageViewController
        setupNavigationBar()
        if !cities.isEmpty {
            updateTitle(with: cities[0].locationName)
        } else {
            navigationItem.title = "Добавьте локацию"
        }
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
    
    private func showSearchBar() {
        let searchLocationViewController = SearchLocationViewController()
        searchLocationViewController.delegate = self
        navigationController?.modalPresentationStyle = .fullScreen
        navigationController?.modalTransitionStyle = .coverVertical
        navigationController?.present(searchLocationViewController, animated: true)
    }
    
    @objc private func showSettings(_ sender: UIBarButtonItem) {
        let settingsViewController = SettingsViewController()
        settingsViewController.delegate = self
        navigationController?.modalPresentationStyle = .formSheet
        navigationController?.modalTransitionStyle = .flipHorizontal
        navigationController?.present(settingsViewController, animated: true)
    }
    
    @objc private func showLocation(_ sender: UIBarButtonItem) {
//        let onboardingViewController = OnboardingViewController()
//        navigationController?.modalPresentationStyle = .automatic
//        navigationController?.modalTransitionStyle = .coverVertical
//        navigationController?.present(onboardingViewController, animated: true)
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

extension MainViewController: EmptyViewDelegate {
    func addLocationAction() {
        showSearchBar()
    }
}

extension MainViewController: SettingsViewControllerDelegate {
    func updatedSettings() {
        guard let pageViewController = pageViewController else { return }
        let index = pageViewController.pageControl.currentPage
        print(index)
        DispatchQueue.main.async {
            pageViewController.pages[index].mainView?.tableView.reloadData()
            if let weather = pageViewController.pages[index].weather {
                pageViewController.updateCurrentPage(with: weather, at: index)
            }
        }
    }
}

extension MainViewController: SearchLocationViewControllerDelegate {
    
    func fetchCoordinates(coordinates: (latitude: Double, longitude: Double)) {
        interactor.updateCoordinates(with: coordinates)
        interactor.fetchWeatherFromNetwork { [weak self] result in
            guard let self,
                  let pageViewController = pageViewController
            else {
                return
            }
            switch result {
            case .success():
                if pageViewController.cities.isEmpty {
                    fetchAndShowExistingWeatherData()
                } else {
                    interactor.getWeatherFromCoreData { weatherArray in
                        if let weather = weatherArray.first {
                            DispatchQueue.main.async {
                                pageViewController.newCityAdded(city: weather)
                            }
                        }
                    }
                }
            case .failure(let error):
                print("FetchWeather error \(error.localizedDescription)")
            }
        }
    }
}

extension MainViewController: PageViewControllerUpdateDelegate {
    
    func removeTitle() {
        updateTitle(with: "Добавьте локацию")
    }
    
    func updateTitle(with weather: Weather) {
        updateTitle(with: weather.locationName)
    }
    
    func updateCurrentPage(with weather: Weather, at index: Int) {
        updateTitle(with: weather.locationName)
        fetchWeatherForCurrentPage(with: weather, at: index)
    }
}
