//
//  ChannelModel.swift
//  dragSelectDemo
//
//  Created by clearlove on 2017/7/5.
//  Copyright © 2017年 clearlove. All rights reserved.
//

import UIKit

class ChannelModel: NSObject {

    var cname: String = ""
    var ename: String = ""
    var img: String	= ""
    var ext: String	= ""
    var status: Int?
    var cdn_rate: Int?
    
    override init() {
        super.init()
    }
    
    init(dict:[String:Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
