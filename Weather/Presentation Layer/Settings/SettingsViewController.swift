

import UIKit

final class SettingsViewController: UIViewController {
    
    private lazy var settingsView = SettingsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = settingsView
    }
}
