//
//  ChartTitleView.swift
//  PieChartView
//
//  Created by Administrator on 2019/10/28.
//  Copyright © 2019 Zemin Li. All rights reserved.
//

import UIKit

protocol Configurable {
    func configureSubviews()
    var item: PieChartItem { get set }
}

class ChartTitleView: UIView, Configurable {
    
    var item: PieChartItem
    
    init(item: PieChartItem){
        self.item = item
        super.init(frame: .zero)
        configureSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureSubviews() {
        
        let iconView = UIView(frame: .zero)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.backgroundColor = item.color
        iconView.layer.cornerRadius = 4
        iconView.clipsToBounds = true
        addSubview(iconView)
        
        let titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = item.title
        titleLabel.font = UIFont(name: "HelveticaNeue", size: 12.0)
        titleLabel.numberOfLines = 1
        addSubview(titleLabel)
        
        iconView.heightAnchor.constraint(equalToConstant: 8).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 8).isActive = true
        iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 35).isActive = true
        iconView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
    }
}
