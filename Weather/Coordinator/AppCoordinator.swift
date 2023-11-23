

import UIKit

protocol AppCoordinatorProtocol: AnyObject {
    func startApp(completion: @escaping (UINavigationController) -> Void)
}

final class AppCoordinator: AppCoordinatorProtocol {
    
    static let shared = AppCoordinator()
    
    let locationService = LocationService.shared
    
    private init() {
    }
    
    private lazy var mainViewController: UINavigationController = {
        let mainViewController = MainViewController()
        mainViewController.delegate = self
        return UINavigationController(rootViewController: mainViewController)
    }()
    
    private lazy var onboardingViewController: UINavigationController = {
        let onboardingViewController = OnboardingViewController()
        onboardingViewController.delegate = self
        return UINavigationController(rootViewController: onboardingViewController)
    }()
    
    func startApp(completion: @escaping (UINavigationController) -> Void) {
        locationService.checkIsDetermined { [weak self] isDetermined in
            guard let self = self else { return }
            let navigationController: UINavigationController
            if isDetermined {
                navigationController = mainViewController
            } else {
                navigationController = onboardingViewController
            }
            completion(navigationController)
        }
    }
    
    func updateRootViewController() {
        locationService.checkIsDetermined{ [weak self] isDetermined in
            guard let self = self else { return }
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

extension AppCoordinator: MainViewControllerDelegate {
    func showLocationSettings() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = self.onboardingViewController
        }
    }
}

