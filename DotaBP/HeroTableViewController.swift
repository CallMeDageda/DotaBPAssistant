//
//  HeroTableViewController.swift
//  DotaBP
//
//  Created by 陈小奔 on 2016/12/11.
//  Copyright © 2016年 陈小奔. All rights reserved.
//

import UIKit
import MBProgressHUD

typealias callbackClosure = (_ heroData:HeroInfo)->Void

class HeroTableViewController: UITableViewController,UISearchBarDelegate{
    
    var allHeroInfoArray : [HeroInfo]?
    
    var myClosure : callbackClosure?
    
    var unlockDelegate : UnlockNextViewProtocol?
    
    var viewTag : Int = 0;
    
    var searchBar : UISearchBar?
    
    var searchResultArray : [HeroInfo]?
    
    var htmlStr : String = ""
    var covHtmlStr : NSString = ""
    
    var htmlCombStr : String = ""
    var covHtmlCombStr : NSString = ""
    
    var hud:MBProgressHUD?

    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func unlockHeroView(currentState: Int, unlockState: Int) {
        //print(currentState);
    }
    
    override func viewDidLoad() {
        
        //MBProgressHUD.hide(for: (UIApplication.shared.keyWindow?.rootViewController?.view)!, animated: true)
        
        super.viewDidLoad()
        
        searchResultArray = allHeroInfoArray;

        self.title = "英雄天梯平均胜率 ⬇︎";
        
        searchBar = UISearchBar.init();
        searchBar?.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 48);
        searchBar?.delegate = self;
        
        //xi
        //self.tableView.separatorColor = UIColor.clear;
        
        self.tableView.register(UINib.init(nibName: "HeroInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "reuse");
        
        //TableView滚动、自动收起键盘
        self.tableView.keyboardDismissMode = .onDrag;
        
        hud = MBProgressHUD.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        hud?.label.text = "正在缓存英雄数据..."
        hud?.mode = MBProgressHUDMode.indeterminate;
        //hud?.show(animated: true)
        //self.view.addSubview(hud!)
        //self.navigationController?.view.addSubview(hud!)
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(hud!)
        
        let ges = UITapGestureRecognizer.init(target: self, action: #selector(HeroTableViewController.hideKeyboard));
        ges.numberOfTapsRequired = 1;
        ges.cancelsTouchesInView = false;
        self.view.addGestureRecognizer(ges);
    }
    
    func hideKeyboard() -> Void {
        self.searchBar?.resignFirstResponder();
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var resultArray : [HeroInfo]? = [HeroInfo]();
        
        let predicate = NSPredicate.init(format: "SELF CONTAINS[cd] %@", searchText);
        for item in allHeroInfoArray! {
            let result = predicate.evaluate(with: item.name);
            if result {
                resultArray?.append(item);
                //print(resultArray)
            }
        }
        self.searchResultArray = resultArray;
        
        //更新tableView
        self.tableView.reloadData();
        
        //self.view.endEditing(true);
        
        if searchText == "" {
            self.searchResultArray = allHeroInfoArray;
            self.tableView.reloadData();
        }
    }
    
    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        //显示所有
//        self.searchResultArray = allHeroInfoArray;
//        self.tableView.reloadData();
//    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar?.resignFirstResponder();
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (searchResultArray?.count)!;
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 48));
        titleView.addSubview(self.searchBar!);
        return titleView;
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 48;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> HeroInfoTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuse");

        let heroInfo = searchResultArray?[indexPath.row];
        let newCell = cell as! HeroInfoTableViewCell;
        newCell.heroInfo = heroInfo;
        //根据cell的序号,显示不同颜色
        if indexPath.row % 2 == 0 {
            newCell.contentView.backgroundColor = UIColor.darkText
        } else {
            newCell.contentView.backgroundColor = UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0);
        }
        return newCell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let hud = MBProgressHUD.showAdded(to: (self.navigationController?.view)!, animated: true)
//        hud.label.text = "正在缓存英雄数据..."
//        hud.mode = MBProgressHUDMode.indeterminate;
        self.hud?.show(animated: true)
        
        //mbprogress 提示缓存数据
        let heroInfo = searchResultArray?[indexPath.row];
        //print("选中了 \((heroInfo?.name_eng!)!),\((heroInfo?.name!)!)");
        //将选中的heroinfo传递给heroview显示
        if myClosure != nil {
            myClosure!(heroInfo!);
        }
        

        //unlockDelegate?.unlockNextHeroView(tag: viewTag, info: heroInfo!);
        
        //现在的方案有点问题,最后一个英雄无法保存在本地,应该在tableview点击之后,保存其数据
        //saveHeroData(heroEngName: (heroInfo?.name_eng!)!, heroName: (heroInfo?.name!)!);
    
        DispatchQueue.global().async {
            //点击了cell通知,解锁下一关,参数,主界面view
            
            self.saveHeroData(heroEngName: (heroInfo?.name_eng!)!, heroName: (heroInfo?.name!)!);
            DispatchQueue.main.async {
                self.unlockDelegate?.unlockNextHeroView(tag: self.viewTag, info: heroInfo!);
                self.hud?.hide(animated: true)
                _ = self.navigationController?.popViewController(animated: true);
            }
        }
        
    }


}
protocol UnlockNextViewProtocol {
    func unlockNextHeroView(tag:Int,info: HeroInfo);
}
