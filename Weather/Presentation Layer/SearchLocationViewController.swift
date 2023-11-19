
import UIKit
import MapKit

protocol SearchLocationViewControllerDelegate: AnyObject {
    func fetchCoordinates(coordinates: (latitude: Double, longitude: Double))
}

final class SearchLocationViewController: UIViewController {
    
    weak var delegate: SearchLocationViewControllerDelegate?
    
    private var searchResults: [MKLocalSearchCompletion] = []
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Поиск города"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LocationCell")
        return tableView
    }()
    
    private lazy var completer: MKLocalSearchCompleter = {
        let completer = MKLocalSearchCompleter()
        completer.delegate = self
        completer.resultTypes = .address
        return completer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubviews()
        setupLayout()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        navigationController?.navigationBar.backgroundColor = .white
    }
    
    private func addSubviews() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
    
extension SearchLocationViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        completer.queryFragment = searchText
    }
}
    
extension SearchLocationViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        tableView.reloadData()
    }
}
    
extension SearchLocationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        let result = searchResults[indexPath.row]
        cell.textLabel?.text = result.title + " " + result.subtitle
        return cell
    }
}

extension SearchLocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedResult = searchResults[indexPath.row]
        
        let searchRequest = MKLocalSearch.Request(completion: selectedResult)
        
        let localSearch = MKLocalSearch(request: searchRequest)
        
        localSearch.start { [weak self] (response, error) in
            guard let self,
                  let response = response,
                  let firstPlacemark = response.mapItems.first?.placemark else {
                print("Error during local search: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            let coordinates = firstPlacemark.coordinate

            print("Selected coordinates: \(coordinates)")
            
            searchBar.text = ""
            searchBar.text = selectedResult.title + " " + selectedResult.subtitle
            
            searchBar.resignFirstResponder()
            
            searchResults = []
            tableView.reloadData()
            
            delegate?.fetchCoordinates(coordinates: (coordinates.latitude, coordinates.longitude))
            
            dismiss(animated: true)
        }
    }
}

