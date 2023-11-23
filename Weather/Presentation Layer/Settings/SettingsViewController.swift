

import UIKit

protocol SettingsViewControllerDelegate: AnyObject {
    func updatedSettings()
    func deleteButtonPressed()
}

final class SettingsViewController: UIViewController {
    
    lazy var settingsView = SettingsView()
    
    weak var delegate: SettingsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = settingsView
        settingsView.delegate = self
    }
}

extension SettingsViewController: SettingsViewDelegate {
    
    func deleteButtonTapped() {
        delegate?.deleteButtonPressed()
        
        self.dismiss(animated: true, completion: nil)
    }
    
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
