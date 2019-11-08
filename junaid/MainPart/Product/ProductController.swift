//
//  ProductController.swift
//  junaid
//
//  Created by Administrator on 2019/10/27.
//  Copyright © 2019 Zemin Li. All rights reserved.
//

import UIKit
import Kingfisher

class ProductController: UITableViewController {
    
    private var newProducts: [Product] = []
    private var allProducts: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        self.refreshControl!.beginRefreshing()
        refreshData(self.refreshControl!)
    }
    
    @objc private func refreshData(_ sender: Any) {
        if Reachability.isConnectedToNetwork() {
            
            self.loadProductHome()
            
        } else {
            // network disconnected
            DispatchQueue.main.async {
                self.refreshControl!.endRefreshing()
                
                let alert = UIAlertController(title: APP_NAME, message: "Could not connect to the server.\nPlease check the internet connection!".localizedString, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK".localizedString, style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func loadProductHome() {
        var request = URLRequest(url: URL(string: Constants.API.FETCH_PRODUCT_HOME)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: Constants.REQUEST_TIMEOUT)
        request.httpMethod = "GET"
        
        request.setValue("Bearer \(SettingManager.sharedInstance.token)", forHTTPHeaderField:"Authorization")
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            let err = error as NSError?
            guard let data = data, err == nil else {
                print(err!.localizedDescription)
                
                DispatchQueue.main.async() {
                    self.refreshControl!.endRefreshing()
                }
                return
            }
            
            do {
                let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String, AnyObject>
                let status = response["status"] as? Bool
                
                if status! {
                    // fetch products
                    if let data = response["data"] as? Dictionary<String, AnyObject> {
                        if let newProducts = data["new_products"] as? [Dictionary<String, AnyObject>] {
                            self.newProducts.removeAll()
                            for _product in newProducts {
                                self.newProducts.append(Product(_product))
                            }
                        }
                        if let allProducts = data["all_products"] as? [Dictionary<String, AnyObject>] {
                            self.allProducts.removeAll()
                            for _product in allProducts {
                                self.allProducts.append(Product(_product))
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.refreshControl!.endRefreshing()
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.refreshControl!.endRefreshing()
                    }
                }
            } catch let err {
                print(err.localizedDescription)
                
                DispatchQueue.main.async() {
                    self.refreshControl!.endRefreshing()
                }
            }
        }).resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let searchVC = segue.destination as? SearchProductController {            
            if segue.identifier == "segueNewProduct" {
                searchVC.category = "New".localizedString
            } else if segue.identifier == "segueAllProduct" {
                searchVC.category = "All".localizedString
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0, 2:
            return 50.0
        case 1:
            return self.newProducts.isEmpty ? 1.0 : Constants.PRODUCT_VIEW_HIEGHT
        case 3:
            return self.allProducts.isEmpty ? 1.0 : Constants.PRODUCT_VIEW_HIEGHT
        default:
            return 1.0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 1 && !self.newProducts.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "productCollectionCell", for: indexPath) as! ProductCollectionCell
            
            cell.parent = self
            cell.products = self.newProducts
            cell.reloadData(self.tableView(self.tableView, heightForRowAt: indexPath))
            
            return cell
        } else if indexPath.row == 3 && !self.allProducts.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "productCollectionCell", for: indexPath) as! ProductCollectionCell
            
            cell.parent = self
            cell.products = self.allProducts
            cell.reloadData(self.tableView(self.tableView, heightForRowAt: indexPath))
            
            return cell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
}


// ProductCollectionCell --- UITableViewCell

class ProductCollectionCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    var parent: UIViewController!
    var products: [Product] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
    }
    
    func reloadData(_ height: CGFloat) {
        if let flowLayout = productCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: height * 1.3, height: height)
        }
        
        productCollectionView.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    //UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCell
        
        // Configure cell...
        let product = products[indexPath.row]
        
        if !product.images.isEmpty {
            cell.imageView.kf.setImage(with: product.images[0].imageUrl)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let productDetailVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProductDetailController") as! ProductDetailController
        productDetailVC.product = products[indexPath.row]
        
        self.parent.navigationController?.show(productDetailVC, sender: self.parent)
    }
}


// ProductCell --- UICollectionViewCell
class ProductCell: UICollectionViewCell {
    
    @IBOutlet weak var imageBack: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var skuLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
}
