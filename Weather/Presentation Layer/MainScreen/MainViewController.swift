
import UIKit
import CoreData

final class MainViewController: UIViewController {
    
    private lazy var mainView = MainView()
        
    private let interactor: WeatherInteractorProtocol = WeatherInteractor(fetchDataService: FetchDataService<WeatherJsonModel>(), coreDataService: CoreDataService.shared)
    
    private var fetchedResultsController: NSFetchedResultsController<Weather>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        fetchWeather()
        configureFetchedResultController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureFetchedResultController()
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
        navigationItem.title = "Current location"
                
        let settingsBarButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(showSettings))
        let locationBarButton = UIBarButtonItem(image: UIImage(systemName: "location"), style: .plain, target: self, action: #selector(showLocation))
        
        navigationItem.leftBarButtonItem = settingsBarButton
        navigationItem.rightBarButtonItem = locationBarButton
        
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    private func fetchWeather() {
        self.mainView.tableView.refreshControl?.beginRefreshing()
        interactor.fetchFromNetwork { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    print("получены \(weather.geometry.coordinates)")
                    self.mainView.tableView.refreshControl?.endRefreshing()
                case .failure(let error):
                    print("Ошибка при получении данных: \(error.localizedDescription)")
                    self.mainView.tableView.refreshControl?.endRefreshing()
                }
            }
        }
    }
    
    private func configureFetchedResultController() {

        let sortDescriptor = NSSortDescriptor(key: "updatedAt", ascending: true)
        let request = Weather.fetchRequest()
        request.sortDescriptors = [sortDescriptor]
        request.fetchLimit = 1
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: CoreDataService.shared.setContext(),
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
            mainView.tableView.reloadData()
        } catch {
            print("Error fetching favorite posts: \(error.localizedDescription)")
        }
        
    }
    
    @objc private func refreshWeatherData() {
        fetchWeather()
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

extension MainViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        mainView.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
//            guard let newIndexPath else { return }
//            mainView.tableView.insertRows(at: [newIndexPath], with: .left)
            mainView.tableView.reloadData()
        case .delete:
//            guard let indexPath else { return }
//            mainView.tableView.deleteRows(at: [indexPath], with: .right)
            mainView.tableView.reloadData()
        case .move:
//            guard let indexPath, let newIndexPath else { return }
//            mainView.tableView.deleteRows(at: [indexPath], with: .right)
//            mainView.tableView.insertRows(at: [newIndexPath], with: .left)
            mainView.tableView.reloadData()
        case .update:
//            guard let indexPath else { return }
//            mainView.tableView.reloadRows(at: [indexPath], with: .fade)
            mainView.tableView.reloadData()
        @unknown default:
            fatalError()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        mainView.tableView.endUpdates()
        if let latestWeather = fetchedResultsController?.fetchedObjects?.first {
            // Извлечение данных из объекта latestWeather, чтобы установить их как заголовок
            // Например:
            let location = latestWeather.location
            let latitude = location?.latitude
            let longitude = location?.longitude
            let title = "Location: Lat \(latitude), Lon \(longitude)"
            self.navigationItem.title = title
        }
    }
}

