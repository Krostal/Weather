

import DGCharts
import UIKit

final class TemperatureChartView: UIView {
    
    private enum Constants {
        static let spacing: CGFloat = 5
    }
    
    let tempData: [ChartDataEntry] = [
        ChartDataEntry(x: 0, y: 20),
        ChartDataEntry(x: 3, y: 18),
        ChartDataEntry(x: 6, y: 14),
        ChartDataEntry(x: 9, y: 11),
        ChartDataEntry(x: 12, y: 15),
        ChartDataEntry(x: 15, y: 16),
        ChartDataEntry(x: 18, y: 17),
        ChartDataEntry(x: 21, y: 18)
    ]
    
    let emptyData: [ChartDataEntry] = [
        ChartDataEntry(x: 0, y: 0),
        ChartDataEntry(x: 3, y: 0),
        ChartDataEntry(x: 6, y: 0),
        ChartDataEntry(x: 9, y: 0),
        ChartDataEntry(x: 12, y: 0),
        ChartDataEntry(x: 15, y: 0),
        ChartDataEntry(x: 18, y: 0),
        ChartDataEntry(x: 21, y: 0)
    ]

    private lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.noDataText = "Нет данных для отображения"
        chartView.legend.enabled = false
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = false
        chartView.xAxis.enabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        
        
        
        chartView.animate(xAxisDuration: 2.5)
        
        return chartView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(InfoCollectionViewCell.self, forCellWithReuseIdentifier: InfoCollectionViewCell.id)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var xAxisView: LineChartView = {
        let xAxisView = LineChartView()
        xAxisView.translatesAutoresizingMaskIntoConstraints = false
        xAxisView.noDataText = "Нет данных для отображения"
        xAxisView.legend.enabled = false
        xAxisView.leftAxis.enabled = false
        xAxisView.rightAxis.enabled = false

        xAxisView.xAxis.drawGridLinesEnabled = false
        xAxisView.xAxis.axisLineColor = .clear
        xAxisView.xAxis.labelPosition = .bottom
        
        xAxisView.xAxis.labelCount = emptyData.count
        xAxisView.xAxis.valueFormatter = DefaultAxisValueFormatter { value, axis in
            let hour = Int(value)
            return "\(hour):00"
        }
        
        return xAxisView
    }()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        setupChartView()
        setupXAxisView()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(lineChartView)
        addSubview(collectionView)
        addSubview(xAxisView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            lineChartView.topAnchor.constraint(equalTo: topAnchor),
            lineChartView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.spacing),
            lineChartView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.spacing),
            lineChartView.heightAnchor.constraint(equalToConstant: 60),
            
            collectionView.topAnchor.constraint(equalTo: lineChartView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.spacing),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.spacing),
            collectionView.heightAnchor.constraint(equalToConstant: 30),
            
            xAxisView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            xAxisView.bottomAnchor.constraint(equalTo: bottomAnchor),
            xAxisView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.spacing),
            xAxisView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.spacing),
            xAxisView.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    private func setupChartView() {
        
        let dataSet = LineChartDataSet(entries: tempData, label: "")
        
        dataSet.circleRadius = 2
        dataSet.drawVerticalHighlightIndicatorEnabled = false
        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        dataSet.mode = .cubicBezier
        
        let gradientColors = [UIColor.blue.cgColor, UIColor.clear.cgColor] as CFArray
        let colorLocations:[CGFloat] = [1.0, 0.0]
        guard let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) else { return }
        dataSet.fill = LinearGradientFill(gradient: gradient, angle: 90)
        dataSet.drawFilledEnabled = true
        dataSet.setCircleColors(.white)
        dataSet.setColor(.blue)
        
        let data = LineChartData(dataSet: dataSet)
        data.setValueFormatter(self)

        lineChartView.data = data
    }
    
    private func setupXAxisView() {
        let dataSet = LineChartDataSet(entries: emptyData, label: "")
                
        dataSet.drawCirclesEnabled = true
        dataSet.circleRadius = 2
        dataSet.setCircleColors(.black)
        dataSet.setColor(.black)
        dataSet.drawFilledEnabled = false
        dataSet.drawValuesEnabled = false
        
        dataSet.drawVerticalHighlightIndicatorEnabled = false
        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        
        let data = LineChartData(dataSet: dataSet)
        xAxisView.data = data
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
}


extension TemperatureChartView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        emptyData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCollectionViewCell.id, for: indexPath) as? InfoCollectionViewCell else {
            return UICollectionViewCell()
        }

        return cell
    }
}
    
extension TemperatureChartView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: xAxisView.xAxis.labelWidth, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let availableWidth = lineChartView.frame.width
        let numberOfItems = emptyData.count
        let totalItemWidth = CGFloat(numberOfItems) * xAxisView.xAxis.labelWidth // 30 is the fixed height of items
        let totalSpacing = availableWidth - totalItemWidth
        let minimumSpacing = totalSpacing / CGFloat(numberOfItems - 1)
        return minimumSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension TemperatureChartView: ValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        let intValue = Int(value)
        return "\(intValue)°"
    }
}
