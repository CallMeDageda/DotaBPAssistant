//
//  ParseHtml.swift
//  DotaBP
//
//  Created by 陈小奔 on 2016/12/21.
//  Copyright © 2016年 陈小奔. All rights reserved.
//

import Foundation

extension UIViewController {

    func saveHeroData(heroEngName:String,heroName:String) -> Void {
        let documentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        let pathStr = (documentPath as NSString).appendingPathComponent("\(heroName)");
        let isFileExist = FileManager.default.fileExists(atPath: pathStr)
        
        if !isFileExist {
            //用英文名加载anti列表
            let urlAntiStr = "http://www.dotamax.com/hero/detail/match_up_anti/\(heroEngName)/?ladder=y";
            let urlAnti = NSURL.init(string: urlAntiStr);
            
            var htmlStr = ""
            var covHtmlStr : NSString = ""
            
            //加载HTML解析
            do {
                htmlStr = try String.init(contentsOf: urlAnti as! URL)
                covHtmlStr = NSString.init(string: htmlStr);
            } catch {
                
            }
            //获取克制0英雄的列表
            let antiArray = getAntiOtherHeroInfo(htmlStr:htmlStr, nsHtmlStr: covHtmlStr);
            
            //获取配合0英雄的列表
            let urlCombStr = "http://www.dotamax.com/hero/detail/match_up_comb/\(heroEngName)/?ladder=y";
            let urlComb = NSURL.init(string: urlCombStr);
            
            var htmlCombStr = ""
            var covHtmlCombStr : NSString = ""
            
            do {
                htmlCombStr = try String.init(contentsOf: urlComb as! URL)
                covHtmlCombStr = NSString.init(string: htmlCombStr);
            } catch {
                
            }
            
            let combArray = getCombOtherHeroInfo(htmlStr:htmlCombStr, nsHtmlStr: covHtmlCombStr);
            
            //将0英雄的克制数据保存
            let heroModel : HeroModel = HeroModel();
            heroModel.name = heroName;
            heroModel.name_eng = heroEngName;
            heroModel.antiArray = antiArray;
            heroModel.combArray = combArray;
            
            //print(heroView.heroInfo?.name!,heroEngName)
            
            _ = NSKeyedArchiver.archiveRootObject(heroModel, toFile: pathStr);
        }
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
            //print(error)
        }
        
        return dict;
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
            //print(error)
        }
        
        return dict;
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

    
}
