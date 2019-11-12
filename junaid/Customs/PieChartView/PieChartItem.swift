//
//  PieChartItem.swift
//  PieChartView
//
//  Created by Administrator on 2019/10/28.
//  Copyright © 2019 Zemin Li. All rights reserved.
//

import UIKit

class PieChartItem {
    
    var ratio: CGFloat
    var color: UIColor
    var startAngle: CGFloat?
    var endAngle: CGFloat?
    var title: String?
    
    public init(ratio: CGFloat, color: UIColor, title: String? = nil) {
        self.ratio = ratio
        self.color = color
        self.title = title
    }
}

