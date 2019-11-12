//
//  ProductDetailController.swift
//  junaid
//
//  Created by Administrator on 2019/10/28.
//  Copyright © 2019 Zemin Li. All rights reserved.
//

import UIKit
import Kingfisher
import ImageSlideshow

class ProductDetailController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var infoStackView: UIStackView!
    @IBOutlet weak var skuLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var flagView: UIImageView!
    @IBOutlet weak var imageSlideshow: ImageSlideshow!
    @IBOutlet weak var relatedProductCollectionView: UICollectionView!
    
    var product: Product?
    var productDetail: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let product = self.product {
            
            self.navigationItem.title = product.name
            
            self.loadProductDetail(product.id)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func loadProductDetail(_ productId: Int) {
        if Reachability.isConnectedToNetwork() {
            self.serverRequestStart()
            
            var request = URLRequest(url: URL(string: Constants.API.FETCH_PRODUCT_DETAIL + String(productId))!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: Constants.REQUEST_TIMEOUT)
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
                        // get product detail
                        if let productDetail = response["data"] as? Dictionary<String, AnyObject> {
                            self.productDetail = Product(productDetail)
                        
                            DispatchQueue.main.async {
                                self.displayData()
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
    
    func displayData() {
        if !productDetail.images.isEmpty {
            imageView.kf.setImage(with: productDetail.images[0].imageUrl)
        }
        
        nameLabel.text = productDetail.name
        descriptionLabel.text = productDetail.description
        skuLabel.text = productDetail.sku
        genderLabel.text = productDetail.gender
        categoryLabel.text = productDetail.categoryName
        quantityLabel.text = productDetail.quantity
        infoStackView.isHidden = false
        noteLabel.text = productDetail.note
        
        if !productDetail.countries.isEmpty {
            flagView.kf.setImage(with: productDetail.countries[0].iconUrl)
        }
        
        // Image Slideshow
        imageSlideshow.slideshowInterval = 0
        imageSlideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        imageSlideshow.contentScaleMode = UIViewContentMode.scaleAspectFit
        
        imageSlideshow.layer.borderColor = UIColor.lightGray.cgColor
        imageSlideshow.layer.borderWidth = 1.0
        
        let pageControl = UIPageControl()
        pageControl.backgroundColor = UIColor.white
        pageControl.currentPageIndicatorTintColor = UIColor.blue
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        imageSlideshow.pageIndicator = pageControl
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        imageSlideshow.activityIndicator = DefaultActivityIndicator()
        imageSlideshow.delegate = self
        
        var inputs: [InputSource] = []
        for image in productDetail.images {
            if let imageUrl = image.imageUrl {
                let inputSource = KingfisherSource(url: imageUrl)
                inputs.append(inputSource)
            }
        }
        
        imageSlideshow.setImageInputs(inputs)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onSlideshow))
        imageSlideshow.addGestureRecognizer(recognizer)
        
        // Related Product
        relatedProductCollectionView.delegate = self
        relatedProductCollectionView.dataSource = self
        
        relatedProductCollectionView.reloadData()
    }
    
    @objc func onSlideshow() {
        let fullScreenController = imageSlideshow.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
}

extension ProductDetailController: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        //print("current page:", page)
    }
}

extension ProductDetailController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productDetail.related.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.PRODUCT_VIEW_HIEGHT * 1.3, height: Constants.PRODUCT_VIEW_HIEGHT)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "relatedProductCell", for: indexPath) as! RelatedProductCell
        
        // Configure cell...
        let product = productDetail.related[indexPath.row]
        
        print(product.images.count)
        
        if !product.images.isEmpty {
            cell.imageView.kf.setImage(with: product.images[0].imageUrl)
        }
        
        cell.imageBack.layer.cornerRadius = 8.0
        cell.imageBack.layer.borderColor = UIColor.init(red: 148.0/255.0, green: 190.0/255.0, blue: 205.0/255.0, alpha: 1.0).cgColor
        cell.imageBack.layer.borderWidth = 3.0
        
        cell.imageBack.layer.shadowColor = UIColor.darkGray.cgColor
        cell.imageBack.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        cell.imageBack.layer.shadowRadius = 2.0
        cell.imageBack.layer.shadowOpacity = 0.6
        
        cell.nameLabel.text = product.name
        
        cell.genderLabel.text = product.gender
        
        cell.layoutIfNeeded()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let productDetailVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProductDetailController") as! ProductDetailController
        productDetailVC.product = productDetail.related[indexPath.row]
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back".localizedString
        navigationItem.backBarButtonItem = backItem
        
        self.navigationController?.show(productDetailVC, sender: self)
    }
}


// RelatedProductCell --- UICollectionViewCell
class RelatedProductCell: UICollectionViewCell {
    
    @IBOutlet weak var imageBack: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
}
