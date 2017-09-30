//
//  FirstHeroAntiViewController.swift
//  DotaBP
//
//  Created by 陈小奔 on 2016/12/12.
//  Copyright © 2016年 陈小奔. All rights reserved.
//

import UIKit
import MBProgressHUD

class FirstHeroAntiViewController: UITableViewController,UISearchBarDelegate {
    var antiHeroArray : [AntiHeroInfo]?
    
    var myClosure : callbackClosure?
    
    var unlockDelegate : UnlockNextViewProtocol?
    
    var viewTag : Int = 0;
    
    var searchBar : UISearchBar?
    
    var searchResultArray : [AntiHeroInfo]?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        //MBProgressHUD.hide(for: (UIApplication.shared.keyWindow?.rootViewController?.view)!, animated: true)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.register(UINib.init(nibName: "FirstHeroAntiTableViewCell", bundle: nil), forCellReuseIdentifier: "reuseanti");
        
        searchResultArray = antiHeroArray;
//        print(searchResultArray?.count)
        
        searchBar = UISearchBar.init();
        searchBar?.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 48);
        searchBar?.delegate = self;
        
        //TableView滚动、自动收起键盘
        self.tableView.keyboardDismissMode = .onDrag;
        
        
        let ges = UITapGestureRecognizer.init(target: self, action: #selector(HeroTableViewController.hideKeyboard));
        ges.numberOfTapsRequired = 1;
        ges.cancelsTouchesInView = false;
        self.view.addGestureRecognizer(ges);
    }
    
    func hideKeyboard() -> Void {
        self.searchBar?.resignFirstResponder();
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var resultArray : [AntiHeroInfo]? = [AntiHeroInfo]();
        
        let predicate = NSPredicate.init(format: "SELF CONTAINS[cd] %@", searchText);
        for item in antiHeroArray! {
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
            self.searchResultArray = antiHeroArray;
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


    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 48));
        titleView.addSubview(self.searchBar!);
        return titleView;
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 48;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (searchResultArray?.count)!;
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> FirstHeroAntiTableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseanti");
        
        let antiHero = searchResultArray?[indexPath.row];
        let newCell = cell as! FirstHeroAntiTableViewCell;
        
        newCell.antiHeroInfo = antiHero;
        
        if indexPath.row % 2 == 0 {
            newCell.contentView.backgroundColor = UIColor.darkText
        } else {
            newCell.contentView.backgroundColor = UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0);
        }
        return newCell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hud = MBProgressHUD.showAdded(to: (self.navigationController?.view)!, animated: true)
        hud.label.text = "正在缓存英雄数据..."
        hud.mode = MBProgressHUDMode.indeterminate;
        
        let antiHero = searchResultArray?[indexPath.row];
        //print("选中了\((antiHero?.anti_eng_name)!),\((antiHero?.name)!)");
        //将选中的heroinfo传递给heroview显示
        if myClosure != nil {
            myClosure!(antiHero! as HeroInfo);
        }
        
        
        
        DispatchQueue.global().async {
            //保存选中英雄的anti和comb信息
            self.saveHeroData(heroEngName: (antiHero?.anti_eng_name)!, heroName: (antiHero?.name)!)
            DispatchQueue.main.async {
                self.unlockDelegate?.unlockNextHeroView(tag: self.viewTag,info: antiHero!);
                hud.hide(animated: true)
                _ = self.navigationController?.popViewController(animated: true);
            }
        }
    }

}
