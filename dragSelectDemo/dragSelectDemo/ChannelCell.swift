//
//  ChannelCell.swift
//  dragSelectDemo
//
//  Created by clearlove on 2017/7/5.
//  Copyright © 2017年 clearlove. All rights reserved.
//

import UIKit

class ChannelCell: UICollectionViewCell {
 
    var titleLabel:UILabel?
    
    var model:ChannelModel?{
    
        didSet{
            titleLabel?.text = model?.cname
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel = UILabel(frame: self.bounds)
        titleLabel?.textColor = UIColor.red
        titleLabel?.clipsToBounds = true
        titleLabel?.textAlignment = NSTextAlignment.center
        titleLabel?.layer.borderColor = UIColor.green.cgColor
        titleLabel?.layer.borderWidth = 0.5
        titleLabel?.layer.cornerRadius = frame.size.height / 2
        addSubview(titleLabel!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
