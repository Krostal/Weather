

import UIKit

final class OnboardingViewController: UIViewController {
    
    private lazy var onboardingView = OnboardingView()
    
    private let interactor: WeatherInteractorProtocol = WeatherInteractor(fetchDataService: FetchDataService<WeatherJsonModel>(), coreDataService: CoreDataService.shared)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onboardingView.delegate = self
        view = onboardingView
    }
}

extension OnboardingViewController: OnboardingViewDelegate {
    func startFetchingWeatherData() {
//        interactor.fetchFromNetwork {  result in
//            switch result {
//            case .success(let weather):
//                print(weather.geometry.coordinates)
//            case .failure(let error):
//                print("Error: \(error.localizedDescription)")
//            }
//        }
//        self.dismiss(animated: true)
    }
}
