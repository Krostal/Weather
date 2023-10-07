
import UIKit

final class MainViewController: UIViewController {
    
    private lazy var mainView = MainView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
    }
    
    private func setupView() {
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
    
    @objc private func showSettings(_ sender: UIBarButtonItem) {
        
    }
    
    @objc private func showLocation(_ sender: UIBarButtonItem) {
        
    }
    
}
