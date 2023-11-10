

import UIKit

final class OnboardingViewController: UIViewController {
    
    private lazy var onboardingView = OnboardingView()
    
    private let interactor: WeatherInteractorProtocol = WeatherInteractor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = onboardingView
    }
}
