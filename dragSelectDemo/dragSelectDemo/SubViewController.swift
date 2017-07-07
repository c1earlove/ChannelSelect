//
//  SubViewController.swift
//  dragSelectDemo
//
//  Created by clearlove on 2017/7/5.
//  Copyright © 2017年 clearlove. All rights reserved.
//

import UIKit

let kScreenW = UIScreen.main.bounds.width
let kScreenH = UIScreen.main.bounds.height
let kItemMargin : CGFloat = 10
let kHeaderViewH : CGFloat = 50
let kNormalItemW = (kScreenW - 3 * kItemMargin) / 2
let kNormalItemH = kNormalItemW * 3 / 4

private let kItemW:CGFloat = (kScreenW - 6 * kItemMargin) / 3
private let kItemH:CGFloat = 30
private let kCellFlag:String = "flag"
//返回选择的频道数组
typealias selectChannelBlock = ([ChannelModel]) -> ()
class SubViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    var channelBlock :selectChannelBlock?
    fileprivate lazy var unselectrdChannels = [ChannelModel]() //未选择的频道
    fileprivate lazy var selectedChannels = [ChannelModel]() //已选择的频道
      fileprivate lazy var channels = [ChannelModel]()           // 频道数组
    fileprivate lazy var collectionView:UICollectionView = { [unowned self]
        in
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kItemW, height: kItemH)
        layout.minimumLineSpacing = kItemMargin
        layout.minimumInteritemSpacing = kItemMargin
        layout.sectionInset = UIEdgeInsets(top: kItemMargin, left: kItemMargin, bottom: kItemMargin, right: kItemMargin)
        let collectionView:UICollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        collectionView.register(ChannelCell.self, forCellWithReuseIdentifier: kCellFlag)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "headerView")
        //添加长按手势
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(lPress:)))
        collectionView.addGestureRecognizer(gesture)
        return collectionView
        }()
    //添加长按手势
    func longPress(lPress:UILongPressGestureRecognizer) {
        let point: CGPoint = lPress.location(in: lPress.view)
        guard let indexpath = self.collectionView.indexPathForItem(at: point) else { return }
        
        switch lPress.state {
            
        case .began:
            self.collectionView.beginInteractiveMovementForItem(at: indexpath)
            break
            
        case .changed:
            self.collectionView.updateInteractiveMovementTargetPosition(point)
            break
            
        case .ended:
            self.collectionView.endInteractiveMovement()
            break
            
        default:
            self.collectionView.cancelInteractiveMovement()
            break
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
        downloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
      
        if channels.count > 0 {
            channelBlock!(channels)
        }else{
           channelBlock!(selectedChannels)
        }
    }
    
    
    func setupUI() {
        view.addSubview(collectionView)
    }
    
    func downloadData() {
        CRMNetTool.share.getWithPath(path: "http://api.m.panda.tv/ajax_get_all_subcate", paras: ["__version":"1.1.7.1305", "__plat":"ios", "__channel":"appstore"], success: { (result) in
 
            //将result 转为字典
            let resultDic = result as? [String:Any]
            //根据data读key 获取数组
            let dataArray = resultDic?["data"] as?[[String:Any]]
            
            for dict in dataArray!{
                let allSubCate = ChannelModel(dict: dict)
                self.unselectrdChannels.append(allSubCate)
            }
            DispatchQueue.main.async {
               self.collectionView.reloadData()
            }
            
        }) { (error) in
            
        }
    }
    
    //MARK: -- 代理
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return selectedChannels.count
        }else{
            return unselectrdChannels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellFlag, for: indexPath) as! ChannelCell
        if indexPath.section == 0 {
            cell.model = selectedChannels[indexPath.item]
        }else{
            cell.model = unselectrdChannels[indexPath.item]
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            selectedChannels.append(unselectrdChannels[indexPath.item])
            unselectrdChannels.remove(at: indexPath.item)
            let indexPath1 = NSIndexPath(item: selectedChannels.count - 1, section: 0)
            let indexPath2 = NSIndexPath(item: indexPath.item, section: 1)
            
            //从当前位置移动到新的位置
            collectionView.moveItem(at: indexPath2 as IndexPath, to: indexPath1 as IndexPath)
 
        }else{
            unselectrdChannels.append(selectedChannels[indexPath.item])
            selectedChannels.remove(at: indexPath.item)
            let path1 = NSIndexPath.init(item: unselectrdChannels.count-1, section: 1)
            let path2 = NSIndexPath.init(item: indexPath.item, section: 0)
            collectionView.moveItem(at: path2 as IndexPath, to: path1 as IndexPath)
        }
        self.collectionView.reloadData()
    }
    
    //MARK: -- 头部视图
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView", for: indexPath) as! HeaderView
        if indexPath.section == 0 {
            headView.title = "常用频道(长按可拖动调整频道顺序，点击删除)"
        }else{
            headView.title = "所有频道(点击添加您感兴趣的频道)"
        }
        
        let attributeStr = NSMutableAttributedString(string: headView.title)
        attributeStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.magenta, range: NSMakeRange(0, 4))
        attributeStr.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 14.0), range: NSMakeRange(0, 4))
        headView.label.attributedText = attributeStr
        return headView
        
    }
    
    //设置HeaderView的宽高
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: kScreenW, height: 44)
    }
    //是否可以移动
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return true
        }else{
            return false
        }
    }
    
    //MARK: -- 设置拖动（手势拖动触发）
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath.section == 0 && destinationIndexPath.section == 0 {
            collectionView.exchangeSubview(at: sourceIndexPath.item, withSubviewAt: destinationIndexPath.item)
        }
        
        let array = NSMutableArray(array: selectedChannels)
        array.exchangeObject(at: sourceIndexPath.item, withObjectAt: destinationIndexPath.item)
        for model in array {
            channels.append(model as! ChannelModel)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
