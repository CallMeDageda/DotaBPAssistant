//
//  ViewController.swift
//  DotaBP
//
//  Created by 陈小奔 on 2016/12/7.
//  Copyright © 2016年 陈小奔. All rights reserved.
//

import UIKit
import MBProgressHUD

class ViewController: UIViewController,UIWebViewDelegate,ShowHeroInfoTableProtocol,UnlockNextViewProtocol{
    
    var allRadiantCombineArray : Array<Array<HeroModel>> = [];
    var allDireCombineArray : Array<Array<HeroModel>> = [];
    var allPermArray: Array<Array<HeroModel>> = [];
    
    @IBOutlet var heroViewArray: [HeroView]!
    
    @IBOutlet var rateLabelArray: [UILabel]!
    
    @IBOutlet weak var direLabel: UILabel!
    @IBOutlet weak var radiantLabel: UILabel!
    

    @IBOutlet weak var calRateBtn: UIButton!
    
    @IBAction func calWinRate(_ sender: UIButton) {
        self.radiantLabel.isHidden = false;
        self.direLabel.isHidden = false;
        //print("点击计算")
        //10个英雄选择完成后才能计算
        //套用DotaBP-Algorithm
        //print(rateLabelArray[0].text!)
        //将胜率字符串转换成double
        //let str = rateLabelArray[0].text!;
        //let val : Double = (str as NSString).doubleValue
        //print("cyk-----\(val / 100)");
        //let disstr = String.init(format: "%.2f", val);
        /*
        for (index,heroView) in heroViewArray.enumerated() {
            //print("\((heroView.heroInfo?.name!)!)");
            let heroPathStr = (documentPath as NSString).appendingPathComponent("\((heroView.heroInfo?.name!)!)");
            
            if FileManager.default.fileExists(atPath: heroPathStr) {
                
                let heroModel = NSKeyedUnarchiver.unarchiveObject(withFile: heroPathStr) as! HeroModel;
                let antiArray = heroModel.antiArray;
                let combArray = heroModel.combArray;
                
                if index == 0 {
                    for item in antiArray! {
                        if heroViewArray[1].heroInfo?.name == item.name {
                            print("anti找到了\(item.name!)",item.win_rate!)
                        }
                        if heroViewArray[3].heroInfo?.name == item.name {
                            print("anti找到了\(item.name!)",item.win_rate!)
                        }
                        if heroViewArray[5].heroInfo?.name == item.name {
                            print("anti找到了\(item.name!)",item.win_rate!)
                        }
                        if heroViewArray[7].heroInfo?.name == item.name {
                            print("anti找到了\(item.name!)",item.win_rate!)
                        }
                        if heroViewArray[9].heroInfo?.name == item.name {
                            print("anti找到了\(item.name!)",item.win_rate!)
                        }
                    }
                    
                    for item in combArray! {
                        if heroViewArray[2].heroInfo?.name == item.name {
                            print("comb找到了\(item.name!)",item.win_rate!)
                        }
                        if heroViewArray[4].heroInfo?.name == item.name {
                            print("comb找到了\(item.name!)",item.win_rate!)
                        }
                        if heroViewArray[6].heroInfo?.name == item.name {
                            print("comb找到了\(item.name!)",item.win_rate!)
                        }
                        if heroViewArray[8].heroInfo?.name == item.name {
                            print("comb找到了\(item.name!)",item.win_rate!)
                        }
                    }
                    
                }
            }
        }
        */
        /*
        var rateArray = [Double]();
        
        for label in rateLabelArray {
            let rate = (label.text! as NSString).doubleValue / 100;
            rateArray.append(rate);
        }
        //print(rateArray);
        
        let radiantWinRate = self.bpAlgorithm(r: rateArray) * 100;
        let direWinRate = 100.00 - radiantWinRate;
        
        let rwinStr = String.init(format: "%.2f", radiantWinRate);
        self.radiantLabel.text = "\(rwinStr)%";
        
        let dwinStr = String.init(format: "%.2f", direWinRate);
        self.direLabel.text = "\(dwinStr)%";
        */
        
        //获取所有应英雄的胜率
        var radiantHeroArray:[HeroModel] = [HeroModel]();
        var direHeroArray:[HeroModel] = [HeroModel]();
        
        //阵容组合胜率平均差值
        var comAvgDelta :Double = 0.0;
        
        //遍历heroview的英雄存在本地的数据
        for (index,heroView) in heroViewArray.enumerated() {
            //print(index);
            //print((heroView.heroInfo?.name!)!);
            let name = (heroView.heroInfo?.name!)!;
            let pathStr = (documentPath as NSString).appendingPathComponent("\(name)");
            let parseHero = NSKeyedUnarchiver.unarchiveObject(withFile: pathStr) as! HeroModel
            
            if ((index % 2) == 0) {
                radiantHeroArray.append(parseHero);
            } else {
                direHeroArray.append(parseHero);
            }
        }
        //print(radiantHeroArray)
        //天辉阵容的平均组合胜率
        var array2:[HeroModel] = [HeroModel(),HeroModel()];
        combine(array: radiantHeroArray, arrayIndex: 0, resultArray: &array2, resultIndex: 0);
        //print(allRadiantCombineArray)
        //print(allRadiantCombineArray.count)
        var radiantComAvg:Double = 0.0
        for item in allRadiantCombineArray {
            //print("每个组合的英雄名")
            /*
            for hero in item {
                print("\(hero.name!)\n");
            }
            */
            for heroinfo in item[0].combArray! {
                if(heroinfo.name! == item[1].name!)
                {
                    //print("天辉:\(item[0].name!) 和 \(item[1].name!) 的组合胜率是:\(heroinfo.win_rate!)")
                    let rate = (heroinfo.win_rate! as NSString).doubleValue / 100;
                    //print(rate);
                    radiantComAvg += rate;
                }
            }
        }
        radiantComAvg = radiantComAvg / 10.0;
        //print("天辉阵容平均组合胜率为\(radiantComAvg)");
        
        //夜魇阵容的平均组合胜率
        var array3:[HeroModel] = [HeroModel(),HeroModel()];
        combineDire(array: direHeroArray, arrayIndex: 0, resultArray: &array3, resultIndex: 0);
        var direComAvg:Double = 0.0
        for item in allDireCombineArray {
            for heroinfo in item[0].combArray! {
                if(heroinfo.name! == item[1].name!) {
                    //print("夜魇:\(item[0].name!) 和 \(item[1].name!) 的组合胜率是:\(heroinfo.win_rate!)")
                    let rate = (heroinfo.win_rate! as NSString).doubleValue / 100;
                    //print(rate);
                    direComAvg += rate;
                }
            }
        }
        direComAvg = direComAvg / 10.0;
        //print("夜魇阵容平均组合胜率为\(direComAvg)");
        
        comAvgDelta = radiantComAvg - direComAvg;
        //print("两边阵容胜率相差\(comAvgDelta)");
        
        
        //天辉120种阵容组合和direHeroArray,用算法求平均
        var radiantEndRateAvg :Double = 0.0;
        var direEndRateAvg :Double = 0.0;
        
        perm(array: &radiantHeroArray,start: 0,end: radiantHeroArray.count - 1);
        //print(allPermArray)
        //print(allPermArray.count)
        
        //let newArray = allPermArray[0];
        for newArray in allPermArray {
            //此处循环120次
            var tempRateArray:[Double] = [Double]();
            //newArray[0]和direHeroArray[0]对比anti胜率......求出5组10个值
            for (index,item) in newArray.enumerated() {
                
                for heroinfo in item.antiArray! {
                    if heroinfo.name! == direHeroArray[index].name! {
                        //print("\(item.name!) 对\(heroinfo.name!)的胜率是:\(heroinfo.win_rate!)")
                        let radiantRate = (heroinfo.win_rate! as NSString).doubleValue / 100;
                        tempRateArray.append(radiantRate)
                        //print("\(item.name!) 对\(heroinfo.name!)的胜率是:\(radiantRate)")
                        let direRate = 1 - radiantRate;
                        tempRateArray.append(direRate)
                        //print("\(heroinfo.name!) 对\(item.name!)的胜率是:\(direRate)")
                        
                    }
                }
            }
            //print(tempRateArray)
            //print("在此按照算法算一遍,保存这个值,最后取平均")
            let onceRate = self.bpAlgorithm(r: tempRateArray);
            radiantEndRateAvg += onceRate;

        }
        //最终平均胜率
        radiantEndRateAvg = radiantEndRateAvg / 120.0;
        //将双方组合胜率加进去
        radiantEndRateAvg += (radiantComAvg - direComAvg);
        
        direEndRateAvg = 1.0 - radiantEndRateAvg;
        //print("天辉最终的平均阵容胜率:\(radiantEndRateAvg),夜魇最终的平均阵容胜率:\(direEndRateAvg)");
        
        let radiantWinRate = radiantEndRateAvg * 100;
        let direWinRate = direEndRateAvg * 100;
        
        let rwinStr = String.init(format: "%.2f", radiantWinRate);
        self.radiantLabel.text = "\(rwinStr)%";
        
        let dwinStr = String.init(format: "%.2f", direWinRate);
        self.direLabel.text = "\(dwinStr)%";
        
        //清空所有数组
        allRadiantCombineArray.removeAll();
        allDireCombineArray.removeAll();
        allPermArray.removeAll();
    }
    
    
    /*全排列算法*/
    func perm(array: inout Array<HeroModel>, start:Int ,end:Int) -> Void {
        
        if start == end {
            var newArray:[HeroModel] = [];
            for i in 0...end {
                newArray.append(array[i]);
            }
            //print(newArray)
            //添加到二维数组中
            allPermArray.append(newArray)
            
        } else {
            
            for i in start...end {
                let temp = array[start];
                array[start] = array[i];
                array[i] = temp;
                perm(array: &array, start: start + 1, end: end);
                array[i] = array[start];
                array[start] = temp;
            }
        }
        
        
    }
    
    /*组合算法*/
    func combine(array:Array<HeroModel>,arrayIndex:Int,resultArray: inout Array<HeroModel>,resultIndex:Int) -> Void {
        let resultLen = resultArray.count;
        let resultCount = resultIndex + 1;
        
        if resultCount > resultLen {
            allRadiantCombineArray.append(resultArray);
            //print(resultArray)
            return;
        }
        
        for i in arrayIndex..<(array.count + resultCount - resultLen) {
            resultArray[resultIndex] = array[i];
            combine(array: array, arrayIndex: i + 1, resultArray: &resultArray, resultIndex: resultIndex + 1);
            
        }
    }
    
    /*夜魇组合算法*/
    func combineDire(array:Array<HeroModel>,arrayIndex:Int,resultArray: inout Array<HeroModel>,resultIndex:Int) -> Void {
        let resultLen = resultArray.count;
        let resultCount = resultIndex + 1;
        
        if resultCount > resultLen {
            allDireCombineArray.append(resultArray);
            //print(resultArray)
            return;
        }
        
        for i in arrayIndex..<(array.count + resultCount - resultLen) {
            resultArray[resultIndex] = array[i];
            //注意递归的方法还是combineDire
            combineDire(array: array, arrayIndex: i + 1, resultArray: &resultArray, resultIndex: resultIndex + 1);
            
        }
    }
    
    func bpAlgorithm(r: [Double]) -> Double {
        //全胜
        let result1 = (r[0] * r[2] * r[4] * r[6] * r[8]);
        //胜4个
        let result2 = (r[1] * r[2] * r[4] * r[6] * r[8]) + (r[0] * r[3] * r[4] * r[6] * r[8]) + (r[0] * r[2] * r[5] * r[6] * r[8]) + (r[0] * r[2] * r[4] * r[7] * r[8]) + (r[0] * r[2] * r[4] * r[6] * r[9]);
        //胜3个
        let result3 = (r[1] * r[3] * r[4] * r[6] * r[8]) + (r[1] * r[2] * r[5] * r[6] * r[8]) + (r[1] * r[2] * r[4] * r[7] * r[8]) + (r[1] * r[2] * r[4] * r[6] * r[9]) + (r[0] * r[3] * r[5] * r[6] * r[8]) + (r[0] * r[3] * r[4] * r[7] * r[8]) + (r[0] * r[3] * r[4] * r[6] * r[9]) + (r[0] * r[2] * r[5] * r[7] * r[8]) + (r[0] * r[2] * r[5] * r[6] * r[9]) + (r[0] * r[2] * r[4] * r[7] * r[9]);
        
        let result = result1 + result2 + result3;
        
        
        //print(result);
        return result;
    }
    
    var htmlStr : String = ""
    var covHtmlStr : NSString = ""
    
    var htmlCombStr : String = ""
    var covHtmlCombStr : NSString = ""
    
    var htmlAntiStr : String = ""
    var covHtmlAntiStr : NSString = ""
    
    var allHeroHtmlStr : String = ""
    var covAllHeroHtmlStr : NSString = ""
    
    // Document 路径
    let documentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,FileManager.SearchPathDomainMask.userDomainMask, true)[0]
    //var heroInfoDic : [String:Any] = ["name":"","count":"","win_rate":"","image":"","anti":[],"comb":[]];
    
    var allHeroInfoArray : [HeroInfo]?

    func unlockNextHeroView(tag: Int,info: HeroInfo) {
        //print("解锁\(tag + 1)");
        //隐藏胜负胜率
        self.radiantLabel.isHidden = true;
        self.direLabel.isHidden = true;
        
        let str = info.win_rate!;
        let val : Double = 100 - (str as NSString).doubleValue
        let disstr = String.init(format: "%.2f", val);
        
        //1,3,5,7,9设置胜率
        switch tag {
        case 0:
            self.resetFirstHero(index:0,info: info);
        case 1:
            rateLabelArray[tag - 1].text = info.win_rate;
            rateLabelArray[tag].text = "\(disstr)%";
        case 2:
            self.resetFirstHero(index:2,info: info);
        case 3:
            rateLabelArray[tag - 1].text = info.win_rate;
            rateLabelArray[tag].text = "\(disstr)%";
        case 4:
            self.resetFirstHero(index:4,info: info);
        case 5:
            rateLabelArray[tag - 1].text = info.win_rate;
            rateLabelArray[tag].text = "\(disstr)%";
        case 6:
            self.resetFirstHero(index:6,info: info);
        case 7:
            rateLabelArray[tag - 1].text = info.win_rate;
            rateLabelArray[tag].text = "\(disstr)%";
        case 8:
            self.resetFirstHero(index:8,info: info);
        case 9:
            rateLabelArray[tag - 1].text = info.win_rate;
            rateLabelArray[tag].text = "\(disstr)%";
        default:
            empty();
        }
        
        
        if tag == 9 {
//            self.calRateBtn.isEnabled = true;
//            self.calRateBtn.isHighlighted = true;
            
            //发送通知,10个英雄选择完毕,显示计算按钮
//            let noti = NotificationCenter.default.post(name: NSNotification.Name(rawValue: "compelteDisplayHero"), object: nil);
            //因为其所在函数不是在主线程中,所以显示按钮的时候,会延误很久,在此处转至主线程执行,可解决
            DispatchQueue.main.async {
                self.calRateBtn.isHidden = false;
            }
            
            return;
        }
        
        heroViewArray[tag + 1].isUserInteractionEnabled = true;
        
    }
    
    func empty() {
    
    }
    
    //选择了,第二个英雄后,重新选择第一个,需要将胜率重新设置
    func resetFirstHero(index: Int,info: HeroInfo) {
        var antiArray = [AntiHeroInfo]();
        //print(info.name!)
        let heroName = heroViewArray[index + 1].heroInfo?.name!
        //print(heroName)
        if  heroName != nil {
            //print(heroViewArray[index + 1].heroInfo!.name!);
            //重新设置label的相克胜率
            //获取针对它的英雄的胜率
            var heroEngName = "";
            if (index == 0) {
                heroEngName = info.name_eng!;
            } else {
                heroEngName = (info as! AntiHeroInfo).anti_eng_name!;
            }
            //print(heroEngName)
            //判断是否已经保存了1
            let pathStr = (documentPath as NSString).appendingPathComponent("\(info.name!)");
            let isFileExist = FileManager.default.fileExists(atPath: pathStr)
            
            if isFileExist {
                let parseHero = NSKeyedUnarchiver.unarchiveObject(withFile: pathStr) as! HeroModel
                antiArray = parseHero.antiArray!;
            } else {
                //获取1的anti
                let urlAntiStr = "http://www.dotamax.com/hero/detail/match_up_anti/\(heroEngName)/?ladder=y"
                
                //print(urlAntiStr)
                let urlAnti = NSURL.init(string: urlAntiStr);
                
                do {
                    let htmlAntiStr1 = try String.init(contentsOf: urlAnti as! URL)
                    let covHtmlAntiStr1 = NSString.init(string: htmlAntiStr1);
                    
                    antiArray = self.getAntiOtherHeroInfo(htmlStr: htmlAntiStr1, nsHtmlStr: covHtmlAntiStr1);
                } catch {
                }
            }
            
            for item in antiArray {
                if item.name == heroName {
                    //print(item.name!)
                    //print(item.win_rate!)
                    rateLabelArray[index].text = "\(item.win_rate!)";
                    rateLabelArray[index + 1].text = "\(100 - (item.win_rate! as NSString).doubleValue)%";
                }
            }
        /*
            //获取1的anti
            let urlAntiStr = "http://www.dotamax.com/hero/detail/match_up_anti/\(heroEngName)/?ladder=y"
            
            //print(urlAntiStr)
            let urlAnti = NSURL.init(string: urlAntiStr);
            
            do {
                let htmlAntiStr1 = try String.init(contentsOf: urlAnti as! URL)
                let covHtmlAntiStr1 = NSString.init(string: htmlAntiStr1);
                
                antiArray = self.getAntiOtherHeroInfo(htmlStr: htmlAntiStr1, nsHtmlStr: covHtmlAntiStr1);
                
                for item in antiArray {
                    if item.name == heroName {
                        //print(item.name!)
                        //print(item.win_rate!)
                        rateLabelArray[index].text = "\(item.win_rate!)";
                        rateLabelArray[index + 1].text = "\(100 - (item.win_rate! as NSString).doubleValue)%";
                    }
                }
            } catch {
                
            }
        */
        }
 
    }
    
    func show(sender:HeroView) {
        //print(sender.tag)
        switch sender.tag {
            
        case 0:
            //print("加载所有英雄的胜率列表")
//            if allHeroInfoArray?.count == 0 {
//                //重新加载网络
//                self.allHeroInfo();
//            }
            
            let pathStr = (self.documentPath as NSString).appendingPathComponent("全部英雄");
            let isFileExist = FileManager.default.fileExists(atPath: pathStr)
            
            if !isFileExist {
                self.allHeroInfo();
            }
            
            //初始化
            let heroTableVC = HeroTableViewController.init();
            heroTableVC.allHeroInfoArray = allHeroInfoArray;
            heroTableVC.view.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            
            heroTableVC.myClosure = sender.heroInfoClosure;
            
            //将获得的数据传递给herotabelVC负责展示
            heroTableVC.unlockDelegate = self;
            heroTableVC.viewTag = sender.tag;
            
            
            self.navigationController?.pushViewController(heroTableVC, animated: true);
            
        case 1:
            //print("加载0英雄的所有anti英雄列表");
            //将0英雄的英文名传过来,获取其anti数组,传递给tableVC展示
            let heroView = heroViewArray[0];
            //let heroEngName = (heroView.heroInfo?.name_eng!)!;
            
            let pathStr = (documentPath as NSString).appendingPathComponent("\((heroView.heroInfo?.name!)!)");
            
            var antiArray = [AntiHeroInfo]();
            //var combArray = [CombHeroInfo]();
            
            //判断本机内是否有所选0英雄的缓存,没有就请求URL,有就直接获取其中的antiarray
            let isFileExist = FileManager.default.fileExists(atPath: pathStr)
            //print(isFileExist)
            if isFileExist {
                let parseHero = NSKeyedUnarchiver.unarchiveObject(withFile: pathStr) as! HeroModel
                //print(parseHero.name_eng,parseHero.name,parseHero.antiArray?.count,parseHero.combArray?.count);
                
                antiArray = parseHero.antiArray!;
                
//                for item in parseHero.antiArray! {
//                      print(item.anti_eng_name);
//                }
            } /* else {
            
                //print(heroEngName);
                
                //用英文名加载anti列表
                let urlAntiStr = "http://www.dotamax.com/hero/detail/match_up_anti/\(heroEngName)/?ladder=y";
                let urlAnti = NSURL.init(string: urlAntiStr);
                
                //加载HTML解析
                do {
                    htmlStr = try String.init(contentsOf: urlAnti as! URL)
                    covHtmlStr = NSString.init(string: htmlStr);
                } catch {
                    
                }
                //获取克制0英雄的列表
                antiArray = self.getAntiOtherHeroInfo(htmlStr:htmlStr, nsHtmlStr: covHtmlStr);
                
                //获取配合0英雄的列表
                let urlCombStr = "http://www.dotamax.com/hero/detail/match_up_comb/\(heroEngName)/?ladder=y";
                let urlComb = NSURL.init(string: urlCombStr);
                
                do {
                    htmlCombStr = try String.init(contentsOf: urlComb as! URL)
                    covHtmlCombStr = NSString.init(string: htmlCombStr);
                } catch {
                    
                }
                
                combArray = self.getCombOtherHeroInfo(htmlStr:htmlCombStr, nsHtmlStr: covHtmlCombStr);
                
                //将0英雄的克制数据保存
                let heroModel : HeroModel = HeroModel();
                heroModel.name = heroView.heroInfo?.name!;
                heroModel.name_eng = heroEngName;
                heroModel.antiArray = antiArray;
                heroModel.combArray = combArray;
                
//                print(heroView.heroInfo?.name!,heroEngName)
                
                _ = NSKeyedArchiver.archiveRootObject(heroModel, toFile: pathStr);
                //print(res)
                //print(antiArray);
                
//                let parseHero = NSKeyedUnarchiver.unarchiveObject(withFile: pathStr) as! HeroModel
                //print(parseHero.name_eng,parseHero.name,parseHero.antiArray?.count,parseHero.combArray?.count);
                
//                for item in parseHero.combArray! {
//                      print(item.win_rate);
//                }
//                
//                for item in parseHero.antiArray! {
//                    print("敌对\(item.anti_eng_name)")
//                }
            }
            */
            //将antiheroarray传递
            let antiHeroTableVC = FirstHeroAntiViewController.init();
            antiHeroTableVC.antiHeroArray = antiArray;
            antiHeroTableVC.view.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            antiHeroTableVC.myClosure = sender.heroInfoClosure;
            antiHeroTableVC.unlockDelegate = self;
            antiHeroTableVC.viewTag = sender.tag;
            //标题
            
            antiHeroTableVC.title = "各英雄对 " + (heroView.heroInfo?.name!)! + " 胜率 ⬇︎";
            
            self.navigationController?.pushViewController(antiHeroTableVC, animated: true);
            
            
        case 2:
            //print("加载0英雄的comb英雄列表和1英雄的anti列表");
            //将113个英雄去掉上面所选的两个,避免重复选择,combtable去掉1的英雄,antitable去掉0的英雄
            //显示mbprogresshud
//            let hud = MBProgressHUD.showAdded(to: self.view, animated: true);
//            hud.mode = MBProgressHUDMode.indeterminate;
//            hud.label.text = "正在加载数据..."
            
            var antiArray = [AntiHeroInfo]();
            var combArray = [CombHeroInfo]();
            
            //获取0英雄,获取0英雄必须使用heroinfo
            let hero0 = heroViewArray[0].heroInfo;
            //let hero0EngName = (hero0?.name_eng)!;
            
            //print(hero0?.name!);
            
            //判断本地是否有0英雄,没有就把0英雄的所有数据加载了
            let hero0PathStr = (documentPath as NSString).appendingPathComponent("\((hero0?.name!)!)");
            let isFileExist0 = FileManager.default.fileExists(atPath: hero0PathStr)
            
            if isFileExist0 {
                let parseHero0 = NSKeyedUnarchiver.unarchiveObject(withFile: hero0PathStr) as! HeroModel;
                combArray = parseHero0.combArray!;
            } /*else {
                //print("没有这个英雄哦")
                //获取0的anti
                //获取1的anti
                let urlAntiStr = "http://www.dotamax.com/hero/detail/match_up_anti/\(hero0EngName)/?ladder=y"
                let urlAnti = NSURL.init(string: urlAntiStr);
                
                do {
                    htmlAntiStr = try String.init(contentsOf: urlAnti as! URL)
                    covHtmlAntiStr = NSString.init(string: htmlAntiStr);
                } catch {
                    
                }
                
                let newAntiArray = self.getAntiOtherHeroInfo(htmlStr: htmlAntiStr, nsHtmlStr: covHtmlAntiStr);
                
                //获取0的comb
                let urlCombStr = "http://www.dotamax.com/hero/detail/match_up_comb/\(hero0EngName)/?ladder=y"
                let urlComb = NSURL.init(string: urlCombStr);
                
                do {
                    htmlCombStr = try String.init(contentsOf: urlComb as! URL)
                    covHtmlCombStr = NSString.init(string: htmlCombStr);
                } catch {
                    
                }
                
                combArray = self.getCombOtherHeroInfo(htmlStr:htmlCombStr, nsHtmlStr: covHtmlCombStr);
                
                //将数据保存
                let heroModel : HeroModel = HeroModel();
                heroModel.name = hero0?.name!;
                heroModel.name_eng = hero0EngName;
                heroModel.antiArray = newAntiArray;
                heroModel.combArray = combArray;
                
                _ = NSKeyedArchiver.archiveRootObject(heroModel, toFile: hero0PathStr);
            }
            */

            //获取1的anti,1英雄必须使用antiheroinfo
            let hero1 = (heroViewArray[1].heroInfo) as! AntiHeroInfo;
            //let hero1EngName = (hero1.anti_eng_name)!;
            
            let hero1PathStr = (documentPath as NSString).appendingPathComponent("\(hero1.name!)");
            
            let isFileExist = FileManager.default.fileExists(atPath: hero1PathStr)
            //print(isFileExist)
            if isFileExist {
                let parseHero = NSKeyedUnarchiver.unarchiveObject(withFile: hero1PathStr) as! HeroModel
                //print(parseHero.name_eng,parseHero.name,parseHero.antiArray?.count,parseHero.combArray?.count);
                
                antiArray = parseHero.antiArray!;
                
                //for item in parseHero.antiArray! {
                //      print(item.win_rate);
                //}
            } /*else {

                //获取1的anti
                let urlAntiStr = "http://www.dotamax.com/hero/detail/match_up_anti/\(hero1EngName)/?ladder=y"
                let urlAnti = NSURL.init(string: urlAntiStr);
                
                do {
                    htmlAntiStr = try String.init(contentsOf: urlAnti as! URL)
                    covHtmlAntiStr = NSString.init(string: htmlAntiStr);
                } catch {
                    
                }
                
                antiArray = self.getAntiOtherHeroInfo(htmlStr: htmlAntiStr, nsHtmlStr: covHtmlAntiStr);
                
                //获取1的comb
                let urlCombStr = "http://www.dotamax.com/hero/detail/match_up_comb/\(hero1EngName)/?ladder=y"
                let urlComb = NSURL.init(string: urlCombStr);
                
                do {
                    htmlCombStr = try String.init(contentsOf: urlComb as! URL)
                    covHtmlCombStr = NSString.init(string: htmlCombStr);
                } catch {
                    
                }
                let newCombArray = self.getCombOtherHeroInfo(htmlStr:htmlCombStr, nsHtmlStr: covHtmlCombStr);
                
                //将1英雄的克制数据保存
                let heroModel : HeroModel = HeroModel();
                heroModel.name = hero1.name!;
                heroModel.name_eng = hero1EngName;
                heroModel.antiArray = antiArray;
                heroModel.combArray = newCombArray;
                
                _ = NSKeyedArchiver.archiveRootObject(heroModel, toFile: hero1PathStr);
            }
            */
            //将combArray中的1英雄去掉
            for (index,combHero) in combArray.enumerated() {
                if combHero.name == hero1.name {
                    //print("去掉了左侧\(combHero.name)");
                    combArray.remove(at: index);
                    //print(combArray.count);
                }
            }
            //将antiArray中的0英雄去掉
            for (index,antiHero) in antiArray.enumerated() {
                if antiHero.name == hero0?.name {
                    //print("去掉了右侧\(antiHero.name)");
                    antiArray.remove(at: index);
                    //print(combArray.count);
                }
            }
            
            //print("左侧数量:\(combArray.count)");
            //print("右侧数量:\(antiArray.count)");

            let combAndAntiVC = CombAndAntiController.init();
            combAndAntiVC.view.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            
            combAndAntiVC.combHeroArray = combArray;
            combAndAntiVC.antiHeroArray = antiArray;
            
            combAndAntiVC.combHeroName = hero0?.name;
            combAndAntiVC.antiHeroName = hero1.name;
            
            combAndAntiVC.myClosure = sender.heroInfoClosure;
            combAndAntiVC.unlockDelegate = self;
            combAndAntiVC.viewTag = sender.tag;
            
            self.navigationController?.pushViewController(combAndAntiVC, animated: true);
            
        case 3:
            //print("加载1英雄的comb英雄列表和2英雄的anti列表");
            var antiArray = [AntiHeroInfo]();
            var combArray = [CombHeroInfo]();
            //获取1英雄的name
            let hero1 = (heroViewArray[1].heroInfo) as! AntiHeroInfo;
            //let hero1EngName = (hero1.anti_eng_name)!;
            //print(hero1EngName);
            //判断有没有1英雄
            let hero1PathStr = (documentPath as NSString).appendingPathComponent("\(hero1.name!)");
            let isFileExist1 = FileManager.default.fileExists(atPath: hero1PathStr)
            
            if isFileExist1 {
                let parseHero1 = NSKeyedUnarchiver.unarchiveObject(withFile: hero1PathStr) as! HeroModel;
                combArray = parseHero1.combArray!;
            } /*else {
                //print("没有这个英雄哦")
                //获取1的anti
                let urlAntiStr = "http://www.dotamax.com/hero/detail/match_up_anti/\(hero1EngName)/?ladder=y"
                let urlAnti = NSURL.init(string: urlAntiStr);
                
                do {
                    htmlAntiStr = try String.init(contentsOf: urlAnti as! URL)
                    covHtmlAntiStr = NSString.init(string: htmlAntiStr);
                } catch {
                    
                }
                
                let newAntiArray = self.getAntiOtherHeroInfo(htmlStr: htmlAntiStr, nsHtmlStr: covHtmlAntiStr);
                
                //获取1的comb
                let urlCombStr = "http://www.dotamax.com/hero/detail/match_up_comb/\(hero1EngName)/?ladder=y"
                let urlComb = NSURL.init(string: urlCombStr);
                
                do {
                    htmlCombStr = try String.init(contentsOf: urlComb as! URL)
                    covHtmlCombStr = NSString.init(string: htmlCombStr);
                } catch {
                    
                }
                combArray = self.getCombOtherHeroInfo(htmlStr:htmlCombStr, nsHtmlStr: covHtmlCombStr);
                
                //将数据保存
                let heroModel : HeroModel = HeroModel();
                heroModel.name = hero1.name!;
                heroModel.name_eng = hero1EngName;
                heroModel.antiArray = newAntiArray;
                heroModel.combArray = combArray;
                
                _ = NSKeyedArchiver.archiveRootObject(heroModel, toFile: hero1PathStr);
            }
            */
            
            //获取2英雄,判断是点击了comb还是anti
            let hero2 = heroViewArray[2].heroInfo;
//            var hero2EngName = "";
//            if (hero2?.isKind(of: CombHeroInfo.self))! {
//                hero2EngName = (hero2 as! CombHeroInfo).comb_eng_name!;
//            } else {
//                hero2EngName = (hero2 as! AntiHeroInfo).anti_eng_name!;
//            }
            //print(hero2EngName);
            //判断是否有2的英雄
            let hero2PathStr = (documentPath as NSString).appendingPathComponent("\((hero2?.name!)!)");
            
            let isFileExist2 = FileManager.default.fileExists(atPath: hero2PathStr)
            //print(isFileExist)
            if isFileExist2 {
                //有就直接加载2英雄的anti
                let parseHero = NSKeyedUnarchiver.unarchiveObject(withFile: hero2PathStr) as! HeroModel
                //print(parseHero.name_eng,parseHero.name,parseHero.antiArray?.count,parseHero.combArray?.count);
                
                antiArray = parseHero.antiArray!;
                
                //for item in parseHero.antiArray! {
                //      print(item.win_rate);
                //}
            } /*else {
                //没有就直接加载2英雄的anti和comb
                //获取2的anti
                let urlAntiStr = "http://www.dotamax.com/hero/detail/match_up_anti/\(hero2EngName)/?ladder=y"
                let urlAnti = NSURL.init(string: urlAntiStr);
                
                do {
                    htmlAntiStr = try String.init(contentsOf: urlAnti as! URL)
                    covHtmlAntiStr = NSString.init(string: htmlAntiStr);
                } catch {
                    
                }
                
                antiArray = self.getAntiOtherHeroInfo(htmlStr: htmlAntiStr, nsHtmlStr: covHtmlAntiStr);
                
                //获取2的comb
                let urlCombStr = "http://www.dotamax.com/hero/detail/match_up_comb/\(hero2EngName)/?ladder=y"
                let urlComb = NSURL.init(string: urlCombStr);
                
                do {
                    htmlCombStr = try String.init(contentsOf: urlComb as! URL)
                    covHtmlCombStr = NSString.init(string: htmlCombStr);
                } catch {
                    
                }
                let newCombArray = self.getCombOtherHeroInfo(htmlStr:htmlCombStr, nsHtmlStr: covHtmlCombStr);
                
                //将2英雄的克制数据保存
                let heroModel : HeroModel = HeroModel();
                heroModel.name = hero1.name!;
                heroModel.name_eng = hero1EngName;
                heroModel.antiArray = antiArray;
                heroModel.combArray = newCombArray;
                
                _ = NSKeyedArchiver.archiveRootObject(heroModel, toFile: hero2PathStr);
            }
            */
            
//            print("刚进入左侧数量:\(combArray.count)");
//            print("刚进入右侧数量:\(antiArray.count)");
            

            //将combArray中的2英雄去掉
            for (index,combHero) in combArray.enumerated() {
                //遍历viewtag
                if combHero.name == hero2?.name {
                    combArray.remove(at: index);
                }
//                
            }
            //将antiArray中的1英雄去掉
            for (index,antiHero) in antiArray.enumerated() {
                if antiHero.name == hero1.name {
                    //print("去掉了右侧\(antiHero.name)");
                    antiArray.remove(at: index);
                    //print(combArray.count);
                }
                
            }
//            print("==========左侧数量:\(combArray.count)");
//            print("==========右侧数量:\(antiArray.count)");
            
            //将左右两侧中的0英雄删除
//            for i in 0..<111 {
//                if combArray[i].name == heroViewArray[0].heroInfo?.name {
//                    combArray.remove(at: i);
//                }
//                
//                if antiArray[i].name == heroViewArray[0].heroInfo?.name {
//                    antiArray.remove(at: i);
//                }
//            }
            for (index,combHero) in combArray.enumerated() {
                //遍历viewtag
                if combHero.name == heroViewArray[0].heroInfo?.name {
                    combArray.remove(at: index);
                }
                //
            }
            //将antiArray中的1英雄去掉
            for (index,antiHero) in antiArray.enumerated() {
                if antiHero.name == heroViewArray[0].heroInfo?.name {
                    //print("去掉了右侧\(antiHero.name)");
                    antiArray.remove(at: index);
                    //print(combArray.count);
                }
                
            }
//            print("左侧数量:\(combArray.count)");
//            print("右侧数量:\(antiArray.count)");

            let combAndAntiVC = CombAndAntiController.init();
            combAndAntiVC.view.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            
            combAndAntiVC.combHeroArray = combArray;
            combAndAntiVC.antiHeroArray = antiArray;
            
            combAndAntiVC.combHeroName = hero1.name;
            combAndAntiVC.antiHeroName = hero2?.name;
            
            combAndAntiVC.myClosure = sender.heroInfoClosure;
            combAndAntiVC.unlockDelegate = self;
            combAndAntiVC.viewTag = sender.tag;
            
            self.navigationController?.pushViewController(combAndAntiVC, animated: true);
            
        case 4:
            //print("加载2英雄的comb英雄列表和3英雄的anti列表");

            let hero2EngName = self.getHeroEngNameFromIndex(index: 2);
            let hero3EngName = self.getHeroEngNameFromIndex(index: 3);
            
            self.heroTableList(name1: hero2EngName, name2: hero3EngName, myHeroView: sender);
            
        case 5:
            //print("加载3英雄的comb英雄列表和4英雄的anti列表");
            let hero3EngName = self.getHeroEngNameFromIndex(index: 3);
            let hero4EngName = self.getHeroEngNameFromIndex(index: 4);
            
            self.heroTableList(name1: hero3EngName, name2: hero4EngName, myHeroView: sender);
        case 6:
            //print("加载4英雄的comb英雄列表和5英雄的anti列表");
            let hero4EngName = self.getHeroEngNameFromIndex(index: 4);
            let hero5EngName = self.getHeroEngNameFromIndex(index: 5);
            
            self.heroTableList(name1: hero4EngName, name2: hero5EngName, myHeroView: sender);
        case 7:
            //print("加载5英雄的comb英雄列表和6英雄的anti列表");
            let hero5EngName = self.getHeroEngNameFromIndex(index: 5);
            let hero6EngName = self.getHeroEngNameFromIndex(index: 6);
            
            self.heroTableList(name1: hero5EngName, name2: hero6EngName, myHeroView: sender);
        case 8:
            //print("加载6英雄的comb英雄列表和7英雄的anti列表");
            let hero6EngName = self.getHeroEngNameFromIndex(index: 6);
            let hero7EngName = self.getHeroEngNameFromIndex(index: 7);
            
            self.heroTableList(name1: hero6EngName, name2: hero7EngName, myHeroView: sender);
        case 9:
            //print("加载7英雄的comb英雄列表和8英雄的anti列表");
            let hero7EngName = self.getHeroEngNameFromIndex(index: 7);
            let hero8EngName = self.getHeroEngNameFromIndex(index: 8);
            
            self.heroTableList(name1: hero7EngName, name2: hero8EngName, myHeroView: sender);
        default:
            print("无其他情况")
        }
        
    }
    
    func getHeroDataFromNetOrDevice(heroName: String, heroEngName: String,combArray: inout [CombHeroInfo],antiArray : inout [AntiHeroInfo]) -> Void {
        let heroPathStr = (documentPath as NSString).appendingPathComponent("\(heroEngName)");
        let isFileExist = FileManager.default.fileExists(atPath: heroPathStr)
        
        if isFileExist {
            let parseHero = NSKeyedUnarchiver.unarchiveObject(withFile: heroPathStr) as! HeroModel;
            combArray = parseHero.combArray!;
        } else {
            //print("没有这个英雄哦")
            //获取1的anti
            let urlAntiStr = "http://www.dotamax.com/hero/detail/match_up_anti/\(heroEngName)/?ladder=y"
            let urlAnti = NSURL.init(string: urlAntiStr);
            
            do {
                htmlAntiStr = try String.init(contentsOf: urlAnti as! URL)
                covHtmlAntiStr = NSString.init(string: htmlAntiStr);
            } catch {
                
            }
            
            let newAntiArray = self.getAntiOtherHeroInfo(htmlStr: htmlAntiStr, nsHtmlStr: covHtmlAntiStr);
            
            //获取1的comb
            let urlCombStr = "http://www.dotamax.com/hero/detail/match_up_comb/\(heroEngName)/?ladder=y"
            let urlComb = NSURL.init(string: urlCombStr);
            
            do {
                htmlCombStr = try String.init(contentsOf: urlComb as! URL)
                covHtmlCombStr = NSString.init(string: htmlCombStr);
            } catch {
                
            }
            combArray = self.getCombOtherHeroInfo(htmlStr:htmlCombStr, nsHtmlStr: covHtmlCombStr);
            
            //将数据保存
            let heroModel : HeroModel = HeroModel();
            heroModel.name = heroName;
            heroModel.name_eng = heroEngName;
            heroModel.antiArray = newAntiArray;
            heroModel.combArray = combArray;
            
            _ = NSKeyedArchiver.archiveRootObject(heroModel, toFile: heroPathStr);
        }

    }
    
    func getHeroEngNameFromIndex(index:Int) -> String {
        let hero = heroViewArray[index].heroInfo;
        var heroEngName = "";
        if (hero?.isKind(of: CombHeroInfo.self))! {
            heroEngName = (hero as! CombHeroInfo).comb_eng_name!;
        } else {
            heroEngName = (hero as! AntiHeroInfo).anti_eng_name!;
        }
        return heroEngName;
    }
    
    func heroTableList(name1:String,name2:String,myHeroView:HeroView) -> Void {
        //左右显示所需的combarray和antiarray
        var combArray = [CombHeroInfo]();
        var antiArray = [AntiHeroInfo]();
        
        //获取1和2的中文名
        let hero1name = heroViewArray[myHeroView.tag - 2].heroInfo!.name;
        let hero2name = heroViewArray[myHeroView.tag - 1].heroInfo!.name;
        
        //判断有没有1的comb,有就加载,没有就全部加载
        let hero1PathStr = (documentPath as NSString).appendingPathComponent("\(hero1name!)");
        let isFileExist1 = FileManager.default.fileExists(atPath: hero1PathStr)
        
        if isFileExist1 {
            let parseHero = NSKeyedUnarchiver.unarchiveObject(withFile: hero1PathStr) as! HeroModel;
            combArray = parseHero.combArray!;
        } /*else {
            //print("没有这个英雄哦")
            //获取1的anti
            let urlAntiStr = "http://www.dotamax.com/hero/detail/match_up_anti/\(name1)/?ladder=y"
            let urlAnti = NSURL.init(string: urlAntiStr);
            
            do {
                htmlAntiStr = try String.init(contentsOf: urlAnti as! URL)
                covHtmlAntiStr = NSString.init(string: htmlAntiStr);
            } catch {
                
            }
            
            let newAntiArray = self.getAntiOtherHeroInfo(htmlStr: htmlAntiStr, nsHtmlStr: covHtmlAntiStr);
            
            //获取1的comb
            let urlCombStr = "http://www.dotamax.com/hero/detail/match_up_comb/\(name1)/?ladder=y"
            let urlComb = NSURL.init(string: urlCombStr);
            
            do {
                htmlCombStr = try String.init(contentsOf: urlComb as! URL)
                covHtmlCombStr = NSString.init(string: htmlCombStr);
            } catch {
                
            }
            combArray = self.getCombOtherHeroInfo(htmlStr:htmlCombStr, nsHtmlStr: covHtmlCombStr);
            
            //将数据保存
            let heroModel : HeroModel = HeroModel();
            heroModel.name = hero1name;
            heroModel.name_eng = name1;
            heroModel.antiArray = newAntiArray;
            heroModel.combArray = combArray;
            
            _ = NSKeyedArchiver.archiveRootObject(heroModel, toFile: hero1PathStr);
        }
        */
        
        //判断有没有2的anti没有就全部加载保存
        let hero2PathStr = (documentPath as NSString).appendingPathComponent("\(hero2name!)");
        let isFileExist2 = FileManager.default.fileExists(atPath: hero2PathStr)
        //print(isFileExist)
        if isFileExist2 {
            //有就直接加载2英雄的anti
            let parseHero = NSKeyedUnarchiver.unarchiveObject(withFile: hero2PathStr) as! HeroModel
            //print(parseHero.name_eng,parseHero.name,parseHero.antiArray?.count,parseHero.combArray?.count);
            antiArray = parseHero.antiArray!;
            
            //for item in parseHero.antiArray! {
            //      print(item.win_rate);
            //}
        } /*else {
            //没有就直接加载2英雄的anti和comb
            //获取2的anti
            let urlAntiStr = "http://www.dotamax.com/hero/detail/match_up_anti/\(name2)/?ladder=y"
            let urlAnti = NSURL.init(string: urlAntiStr);
            
            do {
                htmlAntiStr = try String.init(contentsOf: urlAnti as! URL)
                covHtmlAntiStr = NSString.init(string: htmlAntiStr);
            } catch {
                
            }
            
            antiArray = self.getAntiOtherHeroInfo(htmlStr: htmlAntiStr, nsHtmlStr: covHtmlAntiStr);
            
            //获取2的comb
            let urlCombStr = "http://www.dotamax.com/hero/detail/match_up_comb/\(name2)/?ladder=y"
            let urlComb = NSURL.init(string: urlCombStr);
            
            do {
                htmlCombStr = try String.init(contentsOf: urlComb as! URL)
                covHtmlCombStr = NSString.init(string: htmlCombStr);
            } catch {
                
            }
            let newCombArray = self.getCombOtherHeroInfo(htmlStr:htmlCombStr, nsHtmlStr: covHtmlCombStr);
            
            //将2英雄的克制数据保存
            let heroModel : HeroModel = HeroModel();
            heroModel.name = hero2name;
            heroModel.name_eng = name2;
            heroModel.antiArray = antiArray;
            heroModel.combArray = newCombArray;
            
            _ = NSKeyedArchiver.archiveRootObject(heroModel, toFile: hero2PathStr);
        }*/
        
        /*
        //获取1的comb
        let urlCombStr = "http://www.dotamax.com/hero/detail/match_up_comb/\(name1)/?ladder=y"
        let urlComb = NSURL.init(string: urlCombStr);
        
        do {
            htmlCombStr = try String.init(contentsOf: urlComb as! URL)
            covHtmlCombStr = NSString.init(string: htmlCombStr);
        } catch {
            
        }
        var combArray = self.getCombOtherHeroInfo(htmlStr:htmlCombStr, nsHtmlStr: covHtmlCombStr);
        
        //获取2的anti
        let urlAntiStr = "http://www.dotamax.com/hero/detail/match_up_anti/\(name2)/?ladder=y"
        let urlAnti = NSURL.init(string: urlAntiStr);
        
        do {
            htmlAntiStr = try String.init(contentsOf: urlAnti as! URL)
            covHtmlAntiStr = NSString.init(string: htmlAntiStr);
        } catch {
            
        }
        
        var antiArray = self.getAntiOtherHeroInfo(htmlStr: htmlAntiStr, nsHtmlStr: covHtmlAntiStr);

        //获取1和2的中文名
        let hero1name = heroViewArray[myHeroView.tag - 2].heroInfo!.name;
        let hero2name = heroViewArray[myHeroView.tag - 1].heroInfo!.name;
         */

        //将combArray中的2英雄去掉
        for (index,combHero) in combArray.enumerated() {
            //遍历viewtag
            if combHero.name == hero2name {
                combArray.remove(at: index);
            }
            
        }
        //将antiArray中的1英雄去掉
        for (index,antiHero) in antiArray.enumerated() {
            if antiHero.name == hero1name {
                //print("去掉了右侧\(antiHero.name)");
                antiArray.remove(at: index);
                //print(combArray.count);
            }
            
        }
//        print(antiArray.count)
//        print(combArray.count)
        
        //由于是4,还需要删除0,和1的英雄
        //将左右两侧中的0英雄删除
        //用for循环会导致问题
//        for i in 0..<111 {
//            
//            for j in 0..<(myHeroView.tag) {
//                if combArray[i].name == heroViewArray[j].heroInfo?.name {
//                    print("删除了左侧\(combArray[i].name)")
//                    combArray.remove(at: i);
//                }
//                
//                if antiArray[i].name == heroViewArray[j].heroInfo?.name {
//                    print("右侧删除了\(antiArray[i].name)")
//                    antiArray.remove(at: i);
//                }
//            }
//        }
        //
        
//        //将combArray中的2英雄去掉
//        for (index,combHero) in combArray.enumerated() {
//            //遍历viewtag
//            if combHero.name == heroViewArray[0].heroInfo?.name || combHero.name == heroViewArray[1].heroInfo?.name{
//                print("删除了左侧\(combArray[index].name)")
//                combArray.remove(at: index);
//            }
//            
//        }
//        //将antiArray中的1英雄去掉
//        for (index,antiHero) in antiArray.enumerated() {
//            for j in 0..<(myHeroView.tag - 2) {
//                if antiHero.name == heroViewArray[j].heroInfo?.name {
//                    print("删除了右侧\(antiArray[index].name)")
//                    antiArray.remove(at: index);
//                }
//            
//            }
//        }
//        
//        
//        print("左侧剩余总数\(combArray.count)")
//        print("右侧剩余总数\(antiArray.count)")
        
        let combAndAntiVC = CombAndAntiController.init();
        combAndAntiVC.view.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        
        combAndAntiVC.combHeroArray = combArray;
        combAndAntiVC.antiHeroArray = antiArray;
        
        combAndAntiVC.combHeroName = hero1name;
        combAndAntiVC.antiHeroName = hero2name;
        
        combAndAntiVC.myClosure = myHeroView.heroInfoClosure;
        combAndAntiVC.unlockDelegate = self;
        combAndAntiVC.viewTag = myHeroView.tag;
        
        self.navigationController?.pushViewController(combAndAntiVC, animated: true);
    }
    
//    func deleteFrontItem(<#parameters#>) -> <#return type#> {
//        <#function body#>
//    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //self.calRateBtn.isEnabled = false;
        
        self.navigationItem.title = "刀塔BP助手";
        
        //设置所有Push进入的控制器的导航栏左侧都是"返回",而不是"DotaBP助手"
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "返回", style: .plain, target: nil, action: nil);
        
        //设置右边更新数据按钮,把documents文件夹的英雄数据全部删除
        let refreshBtn = UIButton.init();
        refreshBtn.frame = CGRect.init(x: 0, y: 0, width:58, height: 24);
        //refreshBtn.backgroundColor = UIColor.red
        refreshBtn.imageView?.contentMode = .scaleAspectFit
        refreshBtn.contentHorizontalAlignment = .right
        refreshBtn.setImage(UIImage.init(named: "refresh"), for: UIControlState.normal)
        refreshBtn.addTarget(self, action: #selector(ViewController.updateAllHeroData), for: UIControlEvents.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: refreshBtn)
        //hud提示,解析网络数据 to: (self.navigationController?.view)!
        //如果没有网络则要提示
        let hud = MBProgressHUD.showAdded(to: (self.view)!, animated: true)
        hud.label.text = "加载英雄列表"
        hud.mode = MBProgressHUDMode.indeterminate;
        
        DispatchQueue.global().async {
            var array = [HeroInfo]();
            //判断是否有全部英雄数据
            //print(self.documentPath)
            let pathStr = (self.documentPath as NSString).appendingPathComponent("全部英雄");
            let isFileExist = FileManager.default.fileExists(atPath: pathStr)
            
            if isFileExist {
                array = NSKeyedUnarchiver.unarchiveObject(withFile: pathStr) as! Array<HeroInfo>
                self.allHeroInfoArray = array;
            } else {
                //判断是否是英文使用环境
                let curLang = NSLocale.preferredLanguages[0];
                
                if curLang.contains("zh-Hans") {
                    //print("当前为中文环境")
                    //获取所有英雄的胜率字典,并转成模型
                    self.allHeroInfo();
                } else {
                    //print("检测到其他语言环境，请设置中文");
                    //请设置为中文语言环境
                    //去设置语言
                }
                

            }
            DispatchQueue.main.async {
                hud.hide(animated: true)
            }
        }
        
        for heroView in heroViewArray {
            heroView.delegate = self;
            
            heroView.rateLabel = rateLabelArray[heroView.tag];
            
            if heroView.tag == 0 {
                heroView.isUserInteractionEnabled = true;
            } else {
                heroView.isUserInteractionEnabled = false;
            }
        }

//        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.compelteHero), name: NSNotification.Name(rawValue: "compelteDisplayHero"), object: nil);
    }
    
//    func compelteHero() -> Void {
//        //print("显示计算胜率按钮");
//        self.calRateBtn.isHidden = false;
//    }
    
    func updateAllHeroData() -> Void {
        //print("删除所有的本地缓存数据")
        //alertview
        //弹出警告信息
        let warningTip = UIAlertController.init(title: "更新胜率信息", message: "本操作会更新最近一月天梯英雄胜率信息,选择英雄时重新缓存数据,速度较慢!", preferredStyle: .alert);
        let alertConfirm = UIAlertAction.init(title: "确定", style: .default, handler: {(action:UIAlertAction) -> Void in //print("\(self.documentPath)")
            do {
                let allHeroData = FileManager.default.subpaths(atPath: self.documentPath);
                
                for item in allHeroData! {
                    //print(item)
                    let itemPath = (self.documentPath as NSString).appendingPathComponent("\(item)")
                    //删除全部英雄
                    let allheroPath = (self.documentPath as NSString).appendingPathComponent("全部英雄")
                    try FileManager.default.removeItem(atPath: itemPath)
                    try FileManager.default.removeItem(atPath: allheroPath)
                }
            } catch {
            
            }
            
            //清空图片,重新从第一个开始点选,清空label
            for heroView in self.heroViewArray {
                heroView.imageBtn.setImage(nil, for: UIControlState.normal);
                heroView.nameLabel.text = "";
                
                if heroView.tag == 0 {
                    heroView.isUserInteractionEnabled = true;
                } else {
                    heroView.isUserInteractionEnabled = false;
                }
            }
            
            for ratelabel in self.rateLabelArray {
                ratelabel.text = ""
            }
            
            self.radiantLabel.text = "";
            self.direLabel.text = "";
            self.calRateBtn.isHidden = true;
        });
        
        warningTip.addAction(alertConfirm);
        let alertCancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        warningTip.addAction(alertCancel);
        self.navigationController?.present(warningTip, animated: true, completion: {
            
        });
    }
    
    func allHeroInfo() -> Void {
        //初始化数组
        allHeroInfoArray = [HeroInfo]();
        
        //进入app,加载英雄胜率网页,添加到tableview上
        //正则>([^<|\s]+)<
        let allHeroUrlStr = "http://www.dotamax.com/hero/rate/?ladder=y";
        let allHeroURL = NSURL.init(string: allHeroUrlStr);
//        allHeroURL?.accessibilityLanguage = "en-US"
//        print("\(allHeroURL?.accessibilityLanguage!)")
        
        do {
            allHeroHtmlStr = try String.init(contentsOf: allHeroURL as! URL)
            
            //print(allHeroHtmlStr);
            covAllHeroHtmlStr = NSString.init(string: allHeroHtmlStr);
            
            self.getAllHero(htmlStr: allHeroHtmlStr, nsHtmlStr: covAllHeroHtmlStr);
        } catch  {
            //print("未获取到网络数据,请检查网络!")
            DispatchQueue.main.async {
                let neterror = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true);
                neterror.label.text = "未获取到网络数据,请检查网络!";
                neterror.mode = MBProgressHUDMode.text;
                neterror.hide(animated: true, afterDelay: 2.0)
            }

        }
        
        
        
    }
    
    func getAllHero(htmlStr:String,nsHtmlStr:NSString) {
        let patternStr = "<tr onclick[\\s\\S]+?</td></tr>";
        
        do {
            let regular = try NSRegularExpression(pattern: patternStr, options: .caseInsensitive);
            
            let checkresultSet = regular.matches(in: htmlStr, options: .reportCompletion, range: NSMakeRange(0,nsHtmlStr.length));
            //112个英雄的胜率信息
            for item in checkresultSet {
                let myloc = item.range.location;
                let mylen = item.range.length;
                
                let result = nsHtmlStr.substring(with: NSRange.init(location: myloc, length: mylen));
                
                //print(result)

                var dict = self.getAllHeroInfoDetail(result: result);

                getCombOtherHeroImage(&dict,result: result);
                
                //获取所有英雄的英文名
                getAllHeroEngName(&dict,result: result);
                
                //字典转模型
                let heroInfo = HeroInfo.init(dict: dict);
                
                //print(heroInfo.name!);
                allHeroInfoArray?.append(heroInfo);
                
                
            }
            
            //按照英雄胜率给allHeroInfoArray重新排序
//            let sortArray = allHeroInfoArray?.sorted(by: { (s1, s2) -> Bool in
//                let val1 : Double = (s1.win_rate! as NSString).doubleValue
//                let val2 : Double = (s2.win_rate! as NSString).doubleValue
//                if val1 > val2 {
//                    return true;
//                } else {
//                    return false;
//                }
//            });
      
            //循环打印胜率
//            for item in sortArray! {
//                print(item.win_rate!);
//            }
            //数组重新赋值
            allHeroInfoArray = self.rateSort(array: allHeroInfoArray!);
            //print(allHeroInfoArray?.count)
           
            //将数组保存在本地
            let pathStr = (documentPath as NSString).appendingPathComponent("全部英雄");
            let isFileExist = FileManager.default.fileExists(atPath: pathStr)
            
            if !isFileExist {
                _ = NSKeyedArchiver.archiveRootObject(allHeroInfoArray!, toFile: pathStr);
            }
            
//            let array = NSKeyedUnarchiver.unarchiveObject(withFile: pathStr) as! Array<HeroInfo>
//            print(array.count)
//            
//            for item in array {
//                print(item.name,item.win_rate);
//            }
            
        } catch {
            
        }
    }
    
    func getAllHeroEngName(_ dict: inout Dictionary<String,String>,result : String)  {
        let patternStr = "/hero/detail/[\\s\\S]+?'";
        
        do {
            let nsHtmlStr2 = NSString.init(string: result);
            
            let regular2 = try NSRegularExpression(pattern: patternStr, options: .caseInsensitive);
            
            let checkresultSet2 = regular2.matches(in: result, options: .reportCompletion, range: NSMakeRange(0, nsHtmlStr2.length));
            
            
            for item2 in checkresultSet2 {
                let myloc2 = item2.range.location;
                let mylen2 = item2.range.length;
                
                let result2 = nsHtmlStr2.substring(with: NSRange.init(location: myloc2, length: mylen2));
                
                //截取其他英雄信息字符串
                let nsresult2 = NSString.init(string: result2);
                let result3 = nsresult2.substring(with: NSRange.init(location: 13, length: nsresult2.length - 14));
                
                //print(result3);
                dict["name_eng"] = result3;
                
            }
            //print(dict)
        } catch {
            
        }
    }
    
    func getAllHeroInfoDetail(result:String) -> Dictionary<String,String> {
        //获取其他英雄详细信息的正则表达式
        let patternStr2 = ">([^<|\\s]+)<";
        var dict :[String:String] = ["name":"","win_rate":"","count":"","image":"","name_eng":""];
        var newArray = [String]();
        
        do {
            let nsHtmlStr2 = NSString.init(string: result);
            
            let regular2 = try NSRegularExpression(pattern: patternStr2, options: .caseInsensitive);
            
            let checkresultSet2 = regular2.matches(in: result, options: .reportCompletion, range: NSMakeRange(0, nsHtmlStr2.length));
            
            
            for item2 in checkresultSet2 {
                let myloc2 = item2.range.location;
                let mylen2 = item2.range.length;
                
                let result2 = nsHtmlStr2.substring(with: NSRange.init(location: myloc2, length: mylen2));
                
                //截取其他英雄信息字符串
                let nsresult2 = NSString.init(string: result2);
                let result3 = nsresult2.substring(with: NSRange.init(location: 1, length: nsresult2.length - 2));
                
                //print(result3);
                
                newArray.append(result3);
                
            }
                //print(newArray);
            //更新齐天大圣,暂无数据,后期需要更改
//            if (newArray[0] == "齐天大圣") {
//                dict["name"] = newArray[0];
//                dict["win_rate"] = "0";
//                dict["count"] = "0.0%";
//            } else {
                dict["name"] = newArray[0];
                dict["win_rate"] = newArray[1];
                dict["count"] = newArray[2];
//            }
        } catch  {
            print(error)
        }
        
        return dict;

    }
        /*
    func getCombOtherHeroInfo(htmlStr:String,nsHtmlStr:NSString) -> [CombHeroInfo]{
        //获取其他英雄html字段的正则表达式
        let patternStr = "<tr><td>[\\s\\S]+?</td></tr>";
        //保存其他英雄的数组
        var array = [CombHeroInfo]();
        
        do {
            let regular = try NSRegularExpression(pattern: patternStr, options: .caseInsensitive);
            
            let checkresultSet = regular.matches(in: htmlStr, options: .reportCompletion, range: NSMakeRange(0,nsHtmlStr.length));
            
            for item in checkresultSet {
                let myloc = item.range.location;
                let mylen = item.range.length;
                
                let result = nsHtmlStr.substring(with: NSRange.init(location: myloc, length: mylen));
                
                //print(result)
                
                //获取其他英雄信息的html字段
                var dict = self.getCombOherHeroInfoDetail(result: result);
                
                //获取其他英雄信息字段中的image信息,放入字典
                getCombOtherHeroImage(&dict,result: result);
                
                //print(dict)
                //字典转模型
                let combHeroInfo = CombHeroInfo.init(dict: dict);
                
                //模型添加数组
                array.append(combHeroInfo);
                
            }
            //print(array);
            //heroInfoDic["comb"] = array;
            
            //重新排序
            array = self.rateSort(array: array) as! [CombHeroInfo];
            
        } catch {
            
        }
        return array;
    }
    
    func getCombOtherHeroImage(_ dict: inout Dictionary<String,String>,result : String) {
        let patternStr = "src=\"[\\s\\S]+?>";
        
        do {
            let nsHtmlStr2 = NSString.init(string: result);
            
            let regular2 = try NSRegularExpression(pattern: patternStr, options: .caseInsensitive);
            
            let checkresultSet2 = regular2.matches(in: result, options: .reportCompletion, range: NSMakeRange(0, nsHtmlStr2.length));
            
            
            for item2 in checkresultSet2 {
                let myloc2 = item2.range.location;
                let mylen2 = item2.range.length;
                
                let result2 = nsHtmlStr2.substring(with: NSRange.init(location: myloc2, length: mylen2));
                
                //截取其他英雄信息字符串
                let nsresult2 = NSString.init(string: result2);
                let result3 = nsresult2.substring(with: NSRange.init(location: 5, length: nsresult2.length - 7));
                
                //print(result3);
                let result4 = nsresult2.substring(with: NSRange.init(location: 51, length: nsresult2.length - 65));
                //print(result4)
                dict["image"] = result3;
                dict["comb_eng_name"] = result4;
                
            }
            //print(dict)
        } catch {
            
        }
        
    }

    
    func getCombOherHeroInfoDetail(result:String) -> Dictionary<String,String>{
        //获取其他英雄详细信息的正则表达式
        let patternStr2 = ">([^<|\\s]+).<";
        var dict :[String:String] = ["name":"","comb_rate":"","win_rate":"","count":"","image":"","comb_eng_name":""];
        var newArray = [String]();
        
        do {
            let nsHtmlStr2 = NSString.init(string: result);
            
            let regular2 = try NSRegularExpression(pattern: patternStr2, options: .caseInsensitive);
            
            let checkresultSet2 = regular2.matches(in: result, options: .reportCompletion, range: NSMakeRange(0, nsHtmlStr2.length));
            
            
            for item2 in checkresultSet2 {
                let myloc2 = item2.range.location;
                let mylen2 = item2.range.length;
                
                let result2 = nsHtmlStr2.substring(with: NSRange.init(location: myloc2, length: mylen2));
                
                //截取其他英雄信息字符串
                let nsresult2 = NSString.init(string: result2);
                let result3 = nsresult2.substring(with: NSRange.init(location: 1, length: nsresult2.length - 2));
                
                //print(result3);
                
                newArray.append(result3);
                
            }
            
            if (newArray.count == 3) {
                dict["name"] = "陈";
                dict["comb_rate"] = newArray[0];
                dict["win_rate"] = newArray[1];
                dict["count"] = newArray[2];
            } else {
                //print(array);
                dict["name"] = newArray[0];
                dict["comb_rate"] = newArray[1];
                dict["win_rate"] = newArray[2];
                dict["count"] = newArray[3];
            }
            //print(dict);
            
        } catch  {
            print(error)
        }
        
        return dict;
    }

    
    func getAntiOtherHeroInfo(htmlStr:String,nsHtmlStr:NSString) -> [AntiHeroInfo]{
        //获取其他英雄html字段的正则表达式
        let patternStr = "<tr><td>[\\s\\S]+?</td></tr>";
        //保存其他英雄的数组
        var array = [AntiHeroInfo]();
        
        do {
            let regular = try NSRegularExpression(pattern: patternStr, options: .caseInsensitive);
            
            let checkresultSet = regular.matches(in: htmlStr, options: .reportCompletion, range: NSMakeRange(0,nsHtmlStr.length));

            for item in checkresultSet {
                let myloc = item.range.location;
                let mylen = item.range.length;
                
                let result = nsHtmlStr.substring(with: NSRange.init(location: myloc, length: mylen));
                
                //print(result)

                //获取其他英雄信息的html字段
                var dict = self.getAntiOherHeroInfoDetail(result: result);
                
                //获取其他英雄信息字段中的image信息,放入字典
                getAntiOtherHeroImage(&dict,result: result);
                
                //字典转模型
                let antiHeroInfo = AntiHeroInfo.init(dict: dict);
                
                //将模型放入数组,返回
                array.append(antiHeroInfo);
                
            }
            //print(array);
            //heroInfoDic["anti"] = array;
            //数组重新排序
            let sortArray = array.sorted(by: { (s1, s2) -> Bool in
                let val1 : Double = (s1.win_rate! as NSString).doubleValue
                let val2 : Double = (s2.win_rate! as NSString).doubleValue
                if val1 > val2 {
                    return false;
                } else {
                    return true;
                }
            });

            array = sortArray;
        } catch {
            
        }
        return array;
    }
    
    func rateSort(array: [HeroInfo]) -> [HeroInfo] {
        let sortArray = array.sorted(by: { (s1, s2) -> Bool in
            
            let val1 : Double = (s1.win_rate! as NSString).doubleValue
            let val2 : Double = (s2.win_rate! as NSString).doubleValue
            if val1 > val2 {
                return true;
            } else {
                return false;
            }
        });
        
        return sortArray;
    }
    
    func getAntiOtherHeroImage(_ dict: inout Dictionary<String,String>,result : String) {
        let patternStr = "src=\"[\\s\\S]+?>";
        
        do {
            let nsHtmlStr2 = NSString.init(string: result);
            
            let regular2 = try NSRegularExpression(pattern: patternStr, options: .caseInsensitive);
            
            let checkresultSet2 = regular2.matches(in: result, options: .reportCompletion, range: NSMakeRange(0, nsHtmlStr2.length));
            
            
            for item2 in checkresultSet2 {
                let myloc2 = item2.range.location;
                let mylen2 = item2.range.length;
                
                let result2 = nsHtmlStr2.substring(with: NSRange.init(location: myloc2, length: mylen2));
                
                //截取其他英雄信息字符串
                let nsresult2 = NSString.init(string: result2);
                //print(nsresult2)
                let result3 = nsresult2.substring(with: NSRange.init(location: 5, length: nsresult2.length - 7));
                
                //print(result3);
                let result4 = nsresult2.substring(with: NSRange.init(location: 51, length: nsresult2.length - 65));
                //print(result4)
                dict["image"] = result3;
                dict["anti_eng_name"] = result4;
                
            }
            //print(dict)
        } catch {
            
        }
        
    }
    
    func getAntiOherHeroInfoDetail(result:String) -> Dictionary<String,String>{
        //获取其他英雄详细信息的正则表达式
        let patternStr2 = ">([^<|\\s]+).<";
        var dict :[String:String] = ["name":"","anti_rate":"","win_rate":"","count":"","image":"","anti_eng_name":""];
        var newArray = [String]();
        
        do {
            let nsHtmlStr2 = NSString.init(string: result);
            
            let regular2 = try NSRegularExpression(pattern: patternStr2, options: .caseInsensitive);
            
            let checkresultSet2 = regular2.matches(in: result, options: .reportCompletion, range: NSMakeRange(0, nsHtmlStr2.length));
            
            
            for item2 in checkresultSet2 {
                let myloc2 = item2.range.location;
                let mylen2 = item2.range.length;
                
                let result2 = nsHtmlStr2.substring(with: NSRange.init(location: myloc2, length: mylen2));
                
                //截取其他英雄信息字符串
                let nsresult2 = NSString.init(string: result2);
                let result3 = nsresult2.substring(with: NSRange.init(location: 1, length: nsresult2.length - 2));
                
                //print(result3);
                
                newArray.append(result3);
                
            }
            
            if (newArray.count == 3) {
                dict["name"] = "陈";
                dict["anti_rate"] = newArray[0];
                dict["win_rate"] = newArray[1];
                dict["count"] = newArray[2];
            } else {
            //print(array);
                dict["name"] = newArray[0];
                dict["anti_rate"] = newArray[1];
                dict["win_rate"] = newArray[2];
                dict["count"] = newArray[3];
            }
            //print(dict);
            
        } catch  {
            print(error)
        }
        
        return dict;
    }
    */

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

