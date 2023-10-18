
import UIKit
import CoreData

final class MainViewController: UIViewController {
    
    private lazy var mainView = MainView()
        
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
        mainView.delegate = self
        mainView.tableView.refreshControl = UIRefreshControl()
        mainView.tableView.refreshControl?.addTarget(self, action: #selector(refreshWeatherData), for: .valueChanged)
        view = mainView
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
        self.mainView.tableView.refreshControl?.beginRefreshing()
        interactor.fetchFromNetwork { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(_ ):
                    self.mainView.tableView.refreshControl?.endRefreshing()
                    self.updateNavigationBarTitle()
                    self.updateCurrentCell()
                    
                    for hour in 0..<24 {
                        self.updateHourlyCell(at: hour)
                    }
                    
                    for day in 0..<self.mainView.numberOfDays {
                        self.updateDailyCell(at: day)
                    }
                    
                case .failure(let error):
                    print("FetchWeather error \(error.localizedDescription)")
                    self.mainView.tableView.refreshControl?.endRefreshing()
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
    
    func updateCurrentCell() {
        
        let currentDate = Date()
        let calendar = Calendar.current
        guard let startDate = calendar.date(byAdding: .minute, value: -59, to: currentDate),
              let endDate = calendar.date(byAdding: .second, value: 59, to: currentDate) else { return }

            
        let predicate = NSPredicate(format: "ANY timePeriod.time >= %@ AND ANY timePeriod.time <= %@", startDate as CVarArg, endDate as CVarArg)
            
            let request: NSFetchRequest<Weather> = Weather.fetchRequest()
            request.predicate = predicate
            request.fetchLimit = 1
            
        do {
            let result = try CoreDataService.shared.setContext().fetch(request)
            if let weather = result.last {
                if let currentCell = mainView.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CurrentTableViewCell {
                    currentCell.configure(with: weather, at: 0)
                }
            }
        } catch {
            print("updateCurrentCell: Error fetching weather data: \(error.localizedDescription)")
        }
    }
    
    func updateHourlyCell(at index: Int) {
        let request: NSFetchRequest<Weather> = Weather.fetchRequest()
        
        do {
            let result = try CoreDataService.shared.setContext().fetch(request)
            if let weather = result.last {
                let indexPath = IndexPath(item: index, section: 0)
                if let hourlyCell = self.mainView.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? HourlyTableViewCell {
                    if let hourlyCollectionCell = hourlyCell.collectionView.cellForItem(at: indexPath) as? HourlyCollectionViewCell {
                        hourlyCollectionCell.configure(with: weather, at: index)
                    }
                }
            }
        } catch {
            print("updateHourlyCell: Error fetching weather data: \(error.localizedDescription)")
        }
    }
    
    func updateDailyCell(at index: Int) {
//        guard let weatherModel = fetchedResultsController?.fetchedObjects?.last else { return }
//        if let dailyCell = self.mainView.tableView.cellForRow(at: IndexPath(row: index, section: 2)) as? DailyTableViewCell {
//            dailyCell.configure(with: weatherModel, at: index)
//        }
    }
    
    func changeForecastDays() {
        DispatchQueue.main.async {
            for day in 0..<self.mainView.numberOfDays {
                self.updateDailyCell(at: day)
            }
        }
    }

}
