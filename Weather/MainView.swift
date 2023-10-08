
import UIKit

final class MainView: UIView {
    
    private enum Constants {
        static let spacing: CGFloat = 16
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CurrentTableViewCell.self, forCellReuseIdentifier: CurrentTableViewCell.id)
        tableView.register(HourlyTableViewCell.self, forCellReuseIdentifier: HourlyTableViewCell.id)
        tableView.register(DailyTableViewCell.self, forCellReuseIdentifier: DailyTableViewCell.id)
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addSubviews()
        setupTableView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupView() {
        backgroundColor = .white
    }
    
    private func addSubviews() {
        addSubview(tableView)
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.separatorInset = UIEdgeInsets(
            top: Constants.spacing,
            left: Constants.spacing,
            bottom: Constants.spacing,
            right: Constants.spacing
        )
    }
    
    private func setupLayout() {
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Constants.spacing),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Constants.spacing),
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.spacing),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Constants.spacing)
        ])
        
    }
}

extension MainView: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let currentCell = tableView.dequeueReusableCell(withIdentifier: CurrentTableViewCell.id, for: indexPath) as? CurrentTableViewCell else {
                return UITableViewCell()
            }

            return currentCell
            
        } else if indexPath.section == 1 {
            guard let hourlyCell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.id, for: indexPath) as? HourlyTableViewCell else {
                return UITableViewCell()
            }
           
            return hourlyCell
        } else {
            guard let dailyCell = tableView.dequeueReusableCell(withIdentifier: DailyTableViewCell.id, for: indexPath) as? DailyTableViewCell else {
                return UITableViewCell()
            }
           
            return dailyCell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 212
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            return HeaderForHourlyCell()
        }
        
        return nil
    }
    
}
