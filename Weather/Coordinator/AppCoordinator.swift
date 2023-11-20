

import UIKit

protocol AppCoordinatorProtocol: AnyObject {
    func startApp(completion: @escaping (UINavigationController) -> Void)
}

final class AppCoordinator: AppCoordinatorProtocol {
    
    static let shared = AppCoordinator()
    
    let weatherInteractor: WeatherInteractorProtocol = WeatherInteractor()
    
    private init() {
    }
    
    private lazy var mainViewController: UINavigationController = {
        let mainViewController = MainViewController()
        return UINavigationController(rootViewController: mainViewController)
    }()
    
    private lazy var onboardingViewController: UINavigationController = {
        let onboardingViewController = OnboardingViewController()
        onboardingViewController.delegate = self
        return UINavigationController(rootViewController: onboardingViewController)
    }()
    
    
    func startApp(completion: @escaping (UINavigationController) -> Void) {
        weatherInteractor.isDetermined { [weak self] isDetermined in
            guard let self else { return }
            if isDetermined {
                completion(mainViewController)
            } else {
                completion(onboardingViewController)
            }
        }
    }
    
    func updateRootViewController() {
        weatherInteractor.isDetermined { [weak self] isDetermined in
            guard let self else { return }
            if isDetermined {
                DispatchQueue.main.async {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let window = windowScene.windows.first {
                        window.rootViewController = self.mainViewController
                    }
                }
            }
        }
    }
}

extension AppCoordinator: OnboardingViewControllerDelegate {
    func choiceIsMade() {
        updateRootViewController()
    }
}

