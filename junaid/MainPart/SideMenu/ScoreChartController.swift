//
//  ScoreChartController.swift
//  junaid
//
//  Created by Administrator on 2019/10/29.
//  Copyright © 2019 Zemin Li. All rights reserved.
//

import UIKit

class ScoreChartController: UIViewController {
    
    @IBOutlet weak var weekProductFrame: UIView!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var weekRelatedProductFrame: UIView!
    @IBOutlet weak var relatedProductLabel: UILabel!
    @IBOutlet weak var weekSalesPitchFrame: UIView!
    @IBOutlet weak var salesPitchLabel: UILabel!
    
    @IBOutlet weak var monthFrame: UIView!
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var overallFrame: UIView!
    @IBOutlet weak var overallLabel: UILabel!
    @IBOutlet weak var progressFrame: UIView!
    @IBOutlet weak var progressConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var viewTopScoreButton: UIButton!
    
    var count1 : Int!
    var count2 : Int!
    var count3 : Int!
    var count4 : Int!
    var count5 : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        overallFrame.layer.cornerRadius = 10.0
        viewTopScoreButton.layer.cornerRadius = viewTopScoreButton.frame.size.height / 2
        
        count1 = 2
        count2 = 5
        count3 = 0
        count4 = 13
        count5 = 50
        
        displayCharts()
    }
    
    func displayCharts() {
        displayPie(ratio: count1 * 100 / 6, color: .init(red: 0.0/255.0, green: 164.0/255.0, blue: 243.0/255.0, alpha: 1.0), target: weekProductFrame)
        productLabel.text = String(format: "%d of %d answered".localizedString, count1, 6)
        
        displayPie(ratio: count2 * 100 / 6, color: .init(red: 0.0/255.0, green: 164.0/255.0, blue: 243.0/255.0, alpha: 1.0), target: weekRelatedProductFrame)
        relatedProductLabel.text = String(format: "%d of %d answered".localizedString, count2, 6)
        
        displayPie(ratio: count3 * 100 / 1, color: .init(red: 0.0/255.0, green: 164.0/255.0, blue: 243.0/255.0, alpha: 1.0), target: weekSalesPitchFrame)
        salesPitchLabel.text = String(format: "%d of %d answered".localizedString, count3, 1)
        
        displayPie(ratio: count4 * 100 / 20, color: .init(red: 229.0/255.0, green: 0.0/255.0, blue: 50.0/255.0, alpha: 1.0), target: monthFrame)
        monthLabel.text = String(format: "%d of %d answered".localizedString, count4, 20)
        
        overallLabel.text = String(count5) + "%"
        progressConstraint.constant =  progressFrame.frame.size.width * CGFloat(count5) / 100.0
    }
    
    func displayPie(ratio: Int, color: UIColor, target viewFrame: UIView) {
        
        let pieItem: PieChartItem = PieChartItem(ratio: uint(ratio), color: color, title: "")
        
        let chartView = PieChartView(items: [pieItem], centerTitle: String(ratio) + "%")
        chartView.circleColor = .white
        chartView.innerCircleColor = .init(red: 27.0/255.0, green: 44.0/255.0, blue: 78.0/255.0, alpha: 1.0)
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.arcWidth = viewFrame.frame.size.width / 8
        chartView.isIntensityActivated = false
        chartView.style = .butt
        chartView.isTitleViewHidden = true
        chartView.isAnimationActivated = true
        
        viewFrame.addSubview(chartView)
        
        chartView.widthAnchor.constraint(equalTo: viewFrame.widthAnchor, multiplier: 1.0).isActive = true
        chartView.heightAnchor.constraint(equalTo: viewFrame.heightAnchor, multiplier: 1.0).isActive = true
        chartView.centerXAnchor.constraint(equalTo: viewFrame.centerXAnchor).isActive = true
        chartView.centerYAnchor.constraint(equalTo: viewFrame.centerYAnchor).isActive = true
    }
    
    @IBAction func onBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
}
