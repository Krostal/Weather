

import UIKit

protocol SettingsViewControllerDelegate: AnyObject {
    func updatedSettings()
}

final class SettingsViewController: UIViewController {
    
    private lazy var settingsView = SettingsView()
    
    weak var delegate: SettingsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = settingsView
        settingsView.delegate = self
    }
}

extension SettingsViewController: SettingsViewDelegate {
    func setUnits(temperatureUnit: String, windSpeedUnit: String, timeFormat: String, precipitationUnit: String) {
        
        SettingsManager.shared.settings = Settings(
            temperatureUnit: TemperatureUnit(rawValue: temperatureUnit) ?? .celsius,
            windSpeedUnit: WindSpeedUnit(rawValue: windSpeedUnit) ?? .metersPerSecond,
            timeFormat: TimeFormat(rawValue: timeFormat) ?? .twentyFourHour,
            precipitationUnit: PrecipitationUnit(rawValue: precipitationUnit) ?? .millimeters
        )
        
        delegate?.updatedSettings()
        
        self.dismiss(animated: true, completion: nil)
    }
}
