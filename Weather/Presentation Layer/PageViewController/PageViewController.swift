

import UIKit

protocol PageViewControllerUpdateDelegate: AnyObject {
    func updateCurrentPage(index: Int)
    func updateWeatherData(index: Int)
}

class PageViewController: UIPageViewController {
    
    weak var updateDelegate: PageViewControllerUpdateDelegate?
    
    var cities: [Weather]
    var mainView: MainView
    
    private var pages: [MainViewController] = []
    private var currentIndex: Int = 0
    
    private let interactor: WeatherInteractorProtocol = WeatherInteractor()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = cities.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .systemBlue
        pageControl.pageIndicatorTintColor = .systemGray
        return pageControl
    }()
    
    init(cities: [Weather], mainView: MainView) {
        self.cities = cities
        self.mainView = mainView
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageControl()
        setupView(at: 0)
    }
    
    private func setupView(at index: Int) {
        dataSource = self
        delegate = self
        
        if let viewController = contentViewController(at: index) {
            setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func contentViewController(at index: Int) -> MainViewController? {
        
        print(index, "эта цифра")
        
        guard index >= 0, index < cities.count else {
            return nil
        }
        
        currentIndex = index
        
        if index < pages.count {
            print("уже есть")
            return(pages[index])
        }
        
        let newMainViewController = MainViewController()
        configureMainViewController(newMainViewController, at: index) { [weak self] in
            guard let self else { return }
            pages.append(newMainViewController)
            print("создан новый")
        }
        return newMainViewController
    }
    
    //    private func contentViewController(at index: Int, completion: @escaping (MainViewController?) -> Void) {
    //
    //        print(index, "эта цифра")
    //
    //        guard index >= 0, index < cities.count else {
    //            completion(nil)
    //            return
    //        }
    //
    //        currentIndex = index
    //
    //        if index < pages.count {
    //            print("уже есть")
    //            completion(pages[index])
    //        }
    //
    //        let newMainViewController = MainViewController()
    //        configureMainViewController(newMainViewController, at: index) { [weak self] in
    //            guard let self else { return }
    //            pages.append(newMainViewController)
    //            print("создан новый")
    //            completion(newMainViewController)
    //        }
    //    }
    
    private func configureMainViewController(_ mainViewController: MainViewController, at index: Int, completion: @escaping () -> Void) {
        mainView = MainView(frame: self.view.bounds, weather: cities[index])
        mainView.delegate = mainViewController
        mainViewController.weather = cities[index]
        mainViewController.mainView = mainView
        mainViewController.currentIndex = currentIndex
        mainViewController.view = mainView
        completion()
    }
    
    private func setupPageControl() {
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -8)
        ])
    }
    
    func updateCurrentPageView(at index: Int, with cities: [Weather]) {
        guard index >= 0,
              index < cities.count,
              index < pages.count
        else {
            return
        }
        
        self.cities = cities
        let currentViewController = pages[index]
        currentViewController.weather = cities[index]
        currentViewController.markPageAsUpdated()
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            mainView.tableView.reloadData()
            pages[index] = currentViewController
        }
    }
    
    func reloadPageViewController() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            pages = []
            mainView.tableView.reloadData()
            removeFromParent()
            setupView(at: 0)
            currentIndex = 0
            pageControl.currentPage = 0
            
        }
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = cities.firstIndex(where: { $0 === (viewController as? MainViewController)?.weather }),
              currentIndex > 0 else {
            return nil
        }
        
        let previousIndex = currentIndex - 1
        
        return contentViewController(at: previousIndex)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = cities.firstIndex(where: { $0 === (viewController as? MainViewController)?.weather }),
              currentIndex < cities.count - 1 else {
            return nil
        }

        let nextIndex = currentIndex + 1
        
        return contentViewController(at: nextIndex)
    }
}

extension PageViewController: UIPageViewControllerDelegate {
    

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let currentViewController = pageViewController.viewControllers?.first as? MainViewController,
              let currentIndex = cities.firstIndex(where: { $0 === currentViewController.weather }) else {
            return
        }
        
        self.currentIndex = currentIndex
        print("текущий индекс", currentIndex)
        print("текущий pages", pages.count)
        print("текущий cities", cities.count)
        print(cities[currentIndex].latitude, cities[currentIndex].longitude)
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.pageControl.currentPage = currentIndex
            self.updateDelegate?.updateCurrentPage(index: currentIndex)
            if !currentViewController.isPageUpdated {
                self.updateDelegate?.updateWeatherData(index: currentIndex)
            }
        }
    }
}


