

import UIKit

final class HourlyForecastTableViewCell: UITableViewCell {
    
    static let id = "HourlyForecastTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {

    }
    
    private func setupConstraints() {
        
    }
}

