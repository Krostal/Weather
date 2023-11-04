import UIKit

final class DailyForecastViewController: UIViewController {
    
    private let interactor: WeatherInteractorProtocol = WeatherInteractor(fetchWeatherDataService: FetchDataService<WeatherJsonModel>(), fetchAirQualityDataService: FetchDataService<AirQualityJsonModel>(), coreDataService: CoreDataService.shared, locationService: LocationService())
    
    private let dailyTimePeriod: DailyTimePeriod
    private var dateIndex: Int
    private var selectedDate: Date
    private var airQuality: AirQuality?
    
    private var dailyForecastView: DailyForecastView?
    
    var headerTitle: String?
    
    init(dailyTimePeriod: DailyTimePeriod, dateIndex: Int, selectedDate: Date) {
        self.dailyTimePeriod = dailyTimePeriod
        self.dateIndex = dateIndex
        self.selectedDate = selectedDate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        interactor.getAirQualityFromCoreData { [weak self] airQualityArray in
            guard let self else { return }
            if let model = airQualityArray.last {
                self.airQuality = model
                guard let airQualityModel = self.airQuality else { return }
                self.dailyForecastView = DailyForecastView(frame: self.view.bounds, dailyTimePeriod: self.dailyTimePeriod, dateIndex: self.dateIndex, selectedDate: self.selectedDate, airQuality: airQualityModel)
                self.dailyForecastView?.delegate = self
                self.view = self.dailyForecastView
                self.dailyForecastView?.headerTitle = self.headerTitle
            } else {
                print("в CoreData отсутствует модель AirQuality")
            }
        }
    }
}

extension DailyForecastViewController: DailyForecastViewDelegate {
    func updateView(date: Date, index: Int) {
        selectedDate = date
        dateIndex = index
        setupView()
        navigationItem.title = CustomDateFormatter().formattedDateToString(date: date, dateFormat: "dd MMMM, EEEE", locale: Locale(identifier: "ru_RU"))
    }
    
    
}

