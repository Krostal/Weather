import UIKit

final class DailyForecastViewController: UIViewController {
    
    private let dailyTimePeriod: DailyTimePeriod
    private var dateIndex: Int
    private var selectedDate: Date
    
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
        dailyForecastView = DailyForecastView(frame: self.view.bounds, dailyTimePeriod: dailyTimePeriod, dateIndex: dateIndex, selectedDate: selectedDate)
        dailyForecastView?.delegate = self
        view = dailyForecastView
        dailyForecastView?.headerTitle = headerTitle
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

