//
//  HeaderView.swift
//  dragSelectDemo
//
//  Created by clearlove on 2017/7/5.
//  Copyright © 2017年 clearlove. All rights reserved.
//

import UIKit

class HeaderView: UICollectionReusableView {
    lazy var line:UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 1))
        view.backgroundColor = UIColor.orange
        return view
    
    }()
    
    lazy var label:UILabel = {
        let label1 = UILabel(frame: CGRect(x: 10, y: 10, width: kScreenW - 10, height: self.bounds.size.height - 10))
        label1.textColor = UIColor.lightGray
        label1.adjustsFontSizeToFitWidth = true
        label1.font = UIFont.systemFont(ofSize: 12.0)
        return label1
    }()
    
    var title = "" {
    
        didSet{
            label.text = title
        }
    
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(line)
        addSubview(label)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
