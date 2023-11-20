

import UIKit

protocol OnboardingViewControllerDelegate: AnyObject {
    func choiceIsMade()
}

final class OnboardingViewController: UIViewController {
    
    weak var delegate: OnboardingViewControllerDelegate?
    
    private lazy var onboardingView: OnboardingView = {
        let onboardingView = OnboardingView()
        onboardingView.delegate = self
        return onboardingView
    }()
    
    private let interactor: WeatherInteractorProtocol = WeatherInteractor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = onboardingView
    }
    
    private func showLocationServicesAlert(message: String) {
        let alertController = UIAlertController(
            title: "Разрешение местоположения",
            message: message,
            preferredStyle: .alert
        )

        let settingsAction = UIAlertAction(
            title: "Настройки приложения",
            style: .default
        ) { _ in
            if let bundleIdentifier = Bundle.main.bundleIdentifier, let settingsURL = URL(string: UIApplication.openSettingsURLString + bundleIdentifier) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }

        let cancelAction = UIAlertAction(
            title: "Отмена",
            style: .cancel
        )

        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: false, completion: nil)
    }
}

extension OnboardingViewController: OnboardingViewDelegate {
    func locationAllowed() {
        interactor.updateAuthorizationStatus { [weak self] isAuthorized in
            guard let self else { return }
            if isAuthorized {
                DispatchQueue.main.async {
                    self.delegate?.choiceIsMade()
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.showLocationServicesAlert(message: "Для использования местоположения необходимо разрешение. Пожалуйста, разрешите в настройках приложения.")
                }
            }
        }
    }
    
    func locationDenied() {
        delegate?.choiceIsMade()
    }
}



