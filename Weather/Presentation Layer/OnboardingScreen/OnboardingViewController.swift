

import UIKit

final class OnboardingViewController: UIViewController {
    
    private lazy var onboardingView = OnboardingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = onboardingView
    }
    
    
    
    
}
