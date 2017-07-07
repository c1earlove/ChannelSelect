//
//  ViewController.swift
//  dragSelectDemo
//
//  Created by clearlove on 2017/7/5.
//  Copyright © 2017年 clearlove. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 130, y: 150, width: 80, height: 80)
        button.setTitle("开始", for: .normal)
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(click(button:)), for: .touchUpInside)
        view.addSubview(button)
    }
    
    func click(button:UIButton) {
        let vc = SubViewController()
        vc.channelBlock = { (modelArr) in
            for model in modelArr {
                print(model.cname)
            }
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

