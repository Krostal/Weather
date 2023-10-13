
import UIKit

final class MainViewController: UIViewController {
    
    private lazy var mainView = MainView()
    
    private var forecastData: [WeatherJsonModel] = []
    
    let networkService = NetworkService<WeatherJsonModel>()
    
    var currentLattitude: Double?
    
    var currentLongittude: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        fetchWeatherData()
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
    
    private func fetchWeatherData() {
        networkService.fetchData(coordinates: (lattitude: currentLattitude, longittude: currentLongittude)) { result in
            switch result {
            case .success(let forecastData):
                self.forecastData.append(forecastData)

                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.mainView.tableView.reloadData()
                }
            case .failure(let error):
                print("Ошибка при получении данных: \(error.description)")
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

//extension MainViewController: NSFetchedResultsControllerDelegate {
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.beginUpdates()
//    }
//
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        switch type {
//        case .insert:
//            guard let newIndexPath else { return }
//            mainView.tableView.insertRows(at: [newIndexPath], with: .left)
//        case .delete:
//            guard let indexPath else { return }
//            mainView.tableView.deleteRows(at: [indexPath], with: .right)
//        case .move:
//            guard let indexPath, let newIndexPath else { return }
//            mainView.tableView.deleteRows(at: [indexPath], with: .right)
//            mainView.tableView.insertRows(at: [newIndexPath], with: .left)
//        case .update:
//            guard let indexPath else { return }
//            mainView.tableView.reloadRows(at: [indexPath], with: .fade)
//        @unknown default:
//            fatalError()
//        }
//    }
//
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        mainView.tableView.endUpdates()
//    }
//}

