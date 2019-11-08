//
//  CountryController.swift
//  junaid
//
//  Created by Administrator on 2019/10/30.
//  Copyright © 2019 Zemin Li. All rights reserved.
//

import UIKit
import Kingfisher

class CountryController: UITableViewController {
    
    var countries: [Country] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCountries()
    }
    
    func loadCountries() {
        if Reachability.isConnectedToNetwork() {
            self.serverRequestStart()
            
            var request = URLRequest(url: URL(string: Constants.API.FETCH_COUNTRIES_STORES)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: Constants.REQUEST_TIMEOUT)
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
                        // fetch countries
                        if let countries = response["countries"] as? [Dictionary<String, AnyObject>] {
                            for _country in countries {
                                self.countries.append(Country(_country))
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
        }
    }

    @IBAction func onBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath) as! CountryCell

        // Configure the cell...
        let country = countries[indexPath.row]
        
        if let iconUrl = country.iconUrl {
            cell.flagView.kf.setImage(with: iconUrl)
        }
        cell.countryLabel.text = country.name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueCity", sender: countries[indexPath.row])
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueCity", let cityVC = segue.destination as? CityController {
            cityVC.country = sender as? Country
        }
    }
}


// CountryCell --- UITableViewCell

class CountryCell: UITableViewCell {
    
    @IBOutlet weak var flagView: UIImageView!
    @IBOutlet weak var countryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
