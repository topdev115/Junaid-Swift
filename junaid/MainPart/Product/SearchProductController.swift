//
//  SearchProductController.swift
//  junaid
//
//  Created by Administrator on 2019/10/28.
//  Copyright © 2019 Zemin Li. All rights reserved.
//

import UIKit
import PagingTableView
import Kingfisher

class SearchProductController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: PagingTableView!
    
    var category: String = ""
    
    let searchResult = SearchResult()
    var products: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = category
        
        searchBar.delegate = self
        
        if category == "All" {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.pagingDelegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        searchBar.endEditing(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func onTappedBackground(_ sender: UITapGestureRecognizer) {
        searchBar.endEditing(true)
    }
}

extension SearchProductController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.endEditing(true)
        
        self.products.removeAll()
        self.tableView.reset()
        self.tableView.reloadData()
    }
}

extension SearchProductController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productTableCell", for: indexPath) as! ProductTableViewCell
        
        // Configure cell...
        let product = products[indexPath.row]
        
        if !product.images.isEmpty {
            cell.productImageView.kf.setImage(with: product.images[0].imageUrl)
        }
        
        cell.imageBack.layer.cornerRadius = 8.0
        cell.imageBack.layer.borderColor = UIColor.lightGray.cgColor
        cell.imageBack.layer.borderWidth = 1.0
        
        cell.imageBack.layer.shadowColor = UIColor.darkGray.cgColor
        cell.imageBack.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        cell.imageBack.layer.shadowRadius = 3.0
        cell.imageBack.layer.shadowOpacity = 0.6
        
        cell.nameLabel.text = product.name
        
        cell.skuLabel.text = product.sku
        cell.genderLabel.text = product.gender
        cell.categoryLabel.text = product.categoryName
        cell.quantityLabel.text = product.quantity
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productDetailVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProductDetailController") as! ProductDetailController
        productDetailVC.product = products[indexPath.row]
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back".localizedString
        //navigationItem.backBarButtonItem = backItem
        
        self.navigationController?.show(productDetailVC, sender: self)
    }
}

extension SearchProductController: PagingTableViewDelegate {
    func paginate(_ tableView: PagingTableView, to page: Int) {
        self.tableView.isLoading = true
        
        DispatchQueue.main.async {
            self.searchResult.loadData(at: page, keyword: self.searchBar.text) { contents in
                self.products.append(contentsOf: contents)
                self.tableView.isLoading = false
            }
        }
    }
}

// ProductTableViewCell --- UITableViewCell

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageBack: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var skuLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

class SearchResult {
    
    func loadData(at page: Int, keyword: String?, onComplete: @escaping ([Product]) -> Void) {
        
        var products: [Product] = []
        
        if !Reachability.isConnectedToNetwork() {
            onComplete(products)
            return
        }
        
        var strLink: String!
        if keyword == nil || keyword!.isEmpty {
            strLink = Constants.API.FETCH_PRODUCT + "?"
        } else {
            strLink = Constants.API.SEARCH_PRODUCT + "?keyword=\(keyword!)&"
        }
        
        strLink += "page_size=\(Constants.PAGE_SIZE)&page=\(page + 1)"
        print(strLink)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            var request = URLRequest(url: URL(string: strLink)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: Constants.REQUEST_TIMEOUT)
            request.httpMethod = "GET"
            
            request.setValue("Bearer \(SettingManager.sharedInstance.token)", forHTTPHeaderField:"Authorization")
            
            URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
                let err = error as NSError?
                guard let data = data, err == nil else {
                    print(err!.localizedDescription)
                    
                    DispatchQueue.main.async {
                        onComplete(products)
                    }
                    return
                }
                
                do {
                    let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let status = response["status"] as? Bool
                    
                    if status! {
                        if let total = response["total"] as? Int {
                            print("Total Items : \(total)")
                        }
                        // fetch products
                        
                        if let data = response["data"] as? [Dictionary<String, AnyObject>] {
                            for _product in data {
                                products.append(Product(_product))
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        onComplete(products)
                    }
                } catch let err {
                    print(err.localizedDescription)
                    
                    DispatchQueue.main.async {
                        onComplete(products)
                    }
                }
            }).resume()
        }
    }
}
