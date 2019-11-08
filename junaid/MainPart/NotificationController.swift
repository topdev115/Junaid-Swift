//
//  NotificationController.swift
//  junaid
//
//  Created by Administrator on 2019/10/27.
//  Copyright © 2019 Zemin Li. All rights reserved.
//

import UIKit

class NotificationController: UITableViewController {
    
    var notifications: [Notification] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableView.automaticDimension
        
        loadNotification()
    }
    
    func loadNotification() {
        if Reachability.isConnectedToNetwork() {
            self.serverRequestStart();
            
            var request = URLRequest(url: URL(string: Constants.API.FETCH_NOTIFICATIONS)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: Constants.REQUEST_TIMEOUT)
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
                        // fetch notifications
                        
                        if let data = response["data"] as? [Dictionary<String, AnyObject>] {
                            
                            self.notifications.removeAll()
                            
                            for _one in data {
                                let newNotification = Notification(_one)
                                self.notifications.append(newNotification)
                            }
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
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
            
        } else {
            // network disconnected
            DispatchQueue.main.async {
                let alert = UIAlertController(title: APP_NAME, message: "Could not connect to the server.\nPlease check the internet connection!".localizedString, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK".localizedString, style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notifications.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationCell

        // Configure the cell...
        cell.createdByLabel.text = self.notifications[indexPath.row].createdBy
        cell.descriptionLabel.text = self.notifications[indexPath.row].description
        cell.timeLabel.text = prettyDate(self.notifications[indexPath.row].createdAt)
        
        return cell
    }
}


// NotificationCell

class NotificationCell: UITableViewCell {
    
    @IBOutlet weak var createdByLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
