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
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var overallLabel: UILabel!
    @IBOutlet weak var progressFrame: UIView!
    @IBOutlet weak var progressConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var viewTopScoreButton: UIButton!
    
    enum QuizKind : Int {
        case weekly = 0
        case monthly  = 1
        case salesPitch  = 2
    }
    
    var productQuestions: [QuizQuestionsItem] = []
    var relatedProductQuestions: [QuizQuestionsItem] = []
    var salesPitchQuestions: [QuizQuestionsItem] = []
    var monthlyQuestions: [QuizQuestionsItem] = []
    
    var totalAnsweredCount = 0
    var totalQuestionCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        overallFrame.layer.cornerRadius = 10.0
        viewTopScoreButton.layer.cornerRadius = viewTopScoreButton.frame.size.height / 2
        
        self.loadQuestions()
    }
    
    func loadQuestions() {
        if Reachability.isConnectedToNetwork() {
            self.serverRequestStart()
            
            var request = URLRequest(url: URL(string: Constants.API.GET_QUESTION_BY_TYPE)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: Constants.REQUEST_TIMEOUT)
            request.httpMethod = "GET"
            
            request.setValue("Bearer \(SettingManager.sharedInstance.token)", forHTTPHeaderField:"Authorization")
            
            URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
                let err = error as NSError?
                guard let data = data, err == nil else {
                    print(err!.localizedDescription)
                    
                    DispatchQueue.main.async() {
                        self.serverRequestEnd()
                    }
                    return
                }
                
                do {
                    let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let status = response["status"] as? Bool
                    
                    if (status ?? false) {
                        if let dataQ = response["data"] as? Dictionary<String, AnyObject> {
                            if let productQ = dataQ["product"] as? Dictionary<String, AnyObject> {
                                if let productDataQ = productQ["data"] as? [Dictionary<String, AnyObject>] {
                                    for _question in productDataQ {
                                        self.productQuestions.append(QuizQuestionsItem(_question))
                                    }
                                }
                            }
                            
                            if let relatedProductQ = dataQ["related_product"] as? Dictionary<String, AnyObject> {
                                if let relatedProductDataQ = relatedProductQ["data"] as? [Dictionary<String, AnyObject>] {
                                    for _question in relatedProductDataQ {
                                        self.relatedProductQuestions.append(QuizQuestionsItem(_question))
                                    }
                                }
                            }
                            
                            if let salesPitchQ = dataQ["sales_pitch"] as? Dictionary<String, AnyObject> {
                                if let salesPitchDataQ = salesPitchQ["data"] as? [Dictionary<String, AnyObject>] {
                                    for _question in salesPitchDataQ {
                                        self.salesPitchQuestions.append(QuizQuestionsItem(_question))
                                    }
                                }
                            }
                            
                            if let monthlyQ = dataQ["monthly"] as? Dictionary<String, AnyObject> {
                                if let monthlyDataQ = monthlyQ["data"] as? [Dictionary<String, AnyObject>] {
                                    for _question in monthlyDataQ {
                                        self.monthlyQuestions.append(QuizQuestionsItem(_question))
                                    }
                                }
                            }
                        }
                    }
                    
                    DispatchQueue.main.async() {
                        self.serverRequestEnd()
                        
                        self.displayCharts()
                    }
                } catch let err {
                    print(err.localizedDescription)
                    
                    DispatchQueue.main.async() {
                        self.serverRequestEnd()
                    }
                }
            }).resume()
        }
    }
    
    func calculatePercent(_ questions: [QuizQuestionsItem], forKind kind: QuizKind) -> ChartData {
        var answeredCount = 0
        
        for _question in questions {
            if kind == .salesPitch {
                if !_question.answerText.isEmpty {
                    answeredCount += 1
                }
            } else {
                if !_question.answerId.isEmpty {
                    answeredCount += 1
                }
            }
        }
        
        self.totalAnsweredCount += answeredCount
        self.totalQuestionCount += questions.count
        
        return ChartData(answerCount: answeredCount, questionCount: questions.count)
    }
    
    func calcPerformanceGrade(percent: Int) -> String {
        switch percent {
        case 0...25:
            return "Poor".localizedString
        case 26...50:
            return "Fair".localizedString
        case 51...75:
            return "Moderate".localizedString
        case 76...85:
            return "Good".localizedString
        case 86...95:
            return "Very Good".localizedString
        default:
            return "Excellent".localizedString
        }
    }
    
    func displayCharts() {
        
        var chartData = calculatePercent(productQuestions, forKind: .weekly)
        displayPie(ratio: chartData.percent, color: .init(red: 0.0/255.0, green: 164.0/255.0, blue: 243.0/255.0, alpha: 1.0), target: weekProductFrame)
        productLabel.text = chartData.label
        
        chartData = calculatePercent(relatedProductQuestions, forKind: .weekly)
        displayPie(ratio: chartData.percent, color: .init(red: 147.0/255.0, green: 0.0/255.0, blue: 170.0/255.0, alpha: 1.0), target: weekRelatedProductFrame)
        relatedProductLabel.text = chartData.label
        
        chartData = calculatePercent(salesPitchQuestions, forKind: .salesPitch)
        displayPie(ratio: chartData.percent, color: .init(red: 0.0/255.0, green: 164.0/255.0, blue: 243.0/255.0, alpha: 1.0), target: weekSalesPitchFrame)
        salesPitchLabel.text = chartData.label
        
        chartData = calculatePercent(monthlyQuestions, forKind: .monthly)
        displayPie(ratio: chartData.percent, color: .init(red: 229.0/255.0, green: 0.0/255.0, blue: 50.0/255.0, alpha: 1.0), target: monthFrame)
        monthLabel.text = chartData.label
        
        let overallPercent = self.totalQuestionCount == 0 ? 0 : self.totalAnsweredCount * 100 / self.totalQuestionCount
        
        gradeLabel.text = calcPerformanceGrade(percent: overallPercent)
        overallLabel.text = String(overallPercent) + "%"
        progressConstraint.constant =  progressFrame.frame.size.width * CGFloat(overallPercent) / 100.0
    }
    
    func displayPie(ratio: Int, color: UIColor, target viewFrame: UIView) {
        
        let pieItem: PieChartItem = PieChartItem(ratio: CGFloat(ratio), color: color, title: "")
        
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

struct ChartData {
    var percent: Int = 0
    var label: String = ""
    
    init(answerCount: Int, questionCount: Int) {
        percent = answerCount * 100 / questionCount
        label = String(format: "%d of %d answered".localizedString, answerCount, questionCount)
    }
}
