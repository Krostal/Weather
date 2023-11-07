

import UIKit

final class OnboardingViewController: UIViewController {
    
    private lazy var onboardingView = OnboardingView()
    
    private let interactor: WeatherInteractorProtocol = WeatherInteractor(fetchDataService: FetchDataService(), coreDataService: CoreDataService.shared, locationService: LocationService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = onboardingView
    }
}
