//
//  TopScoreController.swift
//  junaid
//
//  Created by Administrator on 2019/10/30.
//  Copyright © 2019 Zemin Li. All rights reserved.
//

import UIKit
import Kingfisher

class TopScoreController: UIViewController {
    @IBOutlet weak var weekTopTableView: UITableView!
    @IBOutlet weak var tableViewHeight1: NSLayoutConstraint!
    
    @IBOutlet weak var monthTopTableView: UITableView!
    @IBOutlet weak var tableViewHeight2: NSLayoutConstraint!
    
    var weekScorers: [TopScorer] = []
    var monthScorers: [TopScorer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        weekTopTableView.delegate = self
        weekTopTableView.dataSource = self
        
        monthTopTableView.delegate = self
        monthTopTableView.dataSource = self
        
        self.loadTopScorers()
    }
    
    func loadTopScorers() {
        if Reachability.isConnectedToNetwork() {
            self.serverRequestStart()
            
            var request = URLRequest(url: URL(string: Constants.API.GET_USERS_SCORECARD)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: Constants.REQUEST_TIMEOUT)
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
                    
                    if status! {
                        // fetch products
                        if let data = response["data"] as? Dictionary<String, AnyObject> {
                            if let weekly = data["weekly"] as? [Dictionary<String, AnyObject>] {
                                for _w in weekly {
                                    self.weekScorers.append(TopScorer(_w))
                                }
                            }
                            if let monthly = data["monthly"] as? [Dictionary<String, AnyObject>] {
                                for _m in monthly {
                                    self.monthScorers.append(TopScorer(_m))
                                }
                            }
                            
                            DispatchQueue.main.async {
                                self.weekTopTableView.reloadData()
                                self.monthTopTableView.reloadData()
                            }
                        }
                    }
                    
                    DispatchQueue.main.async() {
                        self.serverRequestEnd()
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
}

extension TopScoreController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == weekTopTableView {
            return self.weekScorers.count
        } else {
            return self.monthScorers.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "topScorerCell", for: indexPath) as! TopScorerCell
        
        // Configure cell...
        let topScorer = (tableView == weekTopTableView) ?  self.weekScorers[indexPath.row] : self.monthScorers[indexPath.row]
        
        if let profilePicUrl = topScorer.profilePicUrl {
            cell.profilePicView.kf.setImage(with: profilePicUrl)
        }
        cell.fullNameLabel.text = topScorer.firstName + " " + topScorer.lastName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        super.updateViewConstraints()
        
        if tableView == weekTopTableView {
            self.tableViewHeight1.constant = weekTopTableView.contentSize.height
        } else {
            self.tableViewHeight2.constant = monthTopTableView.contentSize.height
        }
    }
}

// TopScorerCell --- UITableViewCell

class TopScorerCell: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var profilePicView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        cardView.layer.cornerRadius = 8.0
        cardView.layer.borderColor = UIColor.init(red: 0.0/255.0, green: 156.0/255.0, blue: 221.0/255.0, alpha: 1.0).cgColor
        cardView.layer.borderWidth = 3.0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}


