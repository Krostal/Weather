

import UIKit

protocol EmptyViewDelegate: AnyObject {
    func addLocationAction()
}

final class EmptyView: UIView {
    
    weak var delegate: EmptyViewDelegate?
    
    private lazy var addButton: UIButton = {
        let addButton = UIButton(type: .system)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.tintColor = .black
        addButton.setImage(UIImage(named: "customPlus"), for: .normal)
        addButton.addTarget(self, action: #selector(addLocation), for: .touchUpInside)
        return addButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupEmptyView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupEmptyView() {
        backgroundColor = .white
        addSubview(addButton)
        
        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 120),
            addButton.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    func showActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        
        subviews.forEach { $0.removeFromSuperview() }
        addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    @objc func addLocation() {
        delegate?.addLocationAction()
    }
}
