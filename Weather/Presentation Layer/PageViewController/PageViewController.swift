

import UIKit

protocol PageViewControllerUpdateDelegate: AnyObject {
    func removeTitle()
    func updateTitle(with weather: Weather)
    func updateCurrentPage(with weather: Weather, at index: Int)
}

class PageViewController: UIPageViewController {
    
    weak var updateDelegate: PageViewControllerUpdateDelegate?
    
    var cities: [Weather]
    var mainView: MainView?
    var emptyView: EmptyView?
    var isLastPageAdded: Bool = false
    var mainViewController: MainViewController?
    var pages: [MainViewController] = []
        
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = cities.count + 1
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .systemBlue
        pageControl.pageIndicatorTintColor = .systemGray
        return pageControl
    }()
    
    init(cities: [Weather]) {
        self.cities = cities
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
        
        if cities.isEmpty {
            if let additionalViewController = additionalViewController() {
                setViewControllers([additionalViewController], direction: .forward, animated: true, completion: nil)
                isLastPageAdded = true
            }
        } else {
            if let cityViewController = contentViewController(at: index) {
                pages[index].isPageUpdated = true
                setViewControllers([cityViewController], direction: .forward, animated: true, completion: nil)
            }
        }
    }
    
    private func additionalViewController() -> MainViewController? {
                
        mainViewController = MainViewController()
        let lastIndex = cities.count
        
        if isLastPageAdded {
            return pages[lastIndex]
        }
        
        guard let mainViewController = mainViewController else { return nil }
        configureAdditionalViewController(mainViewController) { [weak self] in
            guard let self else { return }
            pages.append(mainViewController)
            mainViewController.pageViewController = self
        }
        return mainViewController
    }
    
    private func contentViewController(at index: Int) -> MainViewController? {
        
        guard index >= 0, index < cities.count else {
            return nil
        }
                
        if index < pages.count {
            return pages[index]
        }
        
        mainViewController = MainViewController()
        
        guard let mainViewController = mainViewController else { return nil}
        configureMainViewController(mainViewController, at: index) { [weak self] in
            guard let self else { return }
            pages.insert(mainViewController, at: index)
            mainViewController.pageViewController = self
        }
        return mainViewController
    }
    
    private func configureAdditionalViewController(_ additionalViewController: MainViewController, completion: @escaping () -> Void) {
        emptyView = EmptyView(frame: self.view.bounds)
        emptyView?.delegate = additionalViewController
        additionalViewController.view = emptyView
        completion()
    }
    
    private func configureMainViewController(_ mainViewController: MainViewController, at index: Int, completion: @escaping () -> Void) {
        mainView = MainView(frame: self.view.bounds, weather: cities[index])
        mainView?.delegate = mainViewController
        mainViewController.weather = cities[index]
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
    
    func updateCurrentPage(with weather: Weather, at index: Int) {
        cities[index] = weather
        let currentViewController = pages[index]
        configureMainViewController(currentViewController, at: index) { [weak self] in
            guard let self else { return }
            pages[index] = currentViewController
            setViewControllers([currentViewController], direction: .forward, animated: false)
        }
    }
    
    func newCityAdded(city: Weather) {
        
        cities.append(city)
        let indexToInsert = cities.count - 1
        
        mainViewController = MainViewController()
        
        guard let mainViewController = mainViewController else { return }

        mainViewController.isPageUpdated = true
        configureMainViewController(mainViewController, at: indexToInsert) { [weak self] in
            guard let self else { return }
            pages.insert(mainViewController, at: indexToInsert)
            pageControl.numberOfPages = cities.count + 1
            pageControl.currentPage = cities.count - 1
            setViewControllers([mainViewController], direction: .forward, animated: false)
            updateDelegate?.updateTitle(with: city)
        }
    }
    
    func reloadPages(cities: [Weather]) {
        self.cities = cities
        DispatchQueue.main.async {
            // перезагрузить pageViewController
        }
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = cities.firstIndex(where: { $0 === (viewController as? MainViewController)?.weather }),
              currentIndex > 0 
        else {
            return nil
        }
        
        let previousIndex = currentIndex - 1
        return contentViewController(at: previousIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = cities.firstIndex(where: { $0 === (viewController as? MainViewController)?.weather }),
              currentIndex < cities.count 
        else {
            return nil
        }
        
        if currentIndex < cities.count - 1 {
            let nextIndex = currentIndex + 1
            
            return contentViewController(at: nextIndex)
        } else {
            return additionalViewController()
        }
    }
}

extension PageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let currentViewController = pageViewController.viewControllers?.first as? MainViewController,
              let weather = currentViewController.weather,
              let currentIndex = cities.firstIndex(where: { $0 === weather }) else {
            pageControl.currentPage = pages.count
            isLastPageAdded = true
            updateDelegate?.removeTitle()
            return
        }
        
        pageControl.currentPage = currentIndex
        updateDelegate?.updateCurrentPage(with: weather, at: currentIndex)
    }
}

