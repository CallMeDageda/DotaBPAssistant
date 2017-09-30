//
//  test.swift
//  DotaBP
//
//  Created by 陈小奔 on 2016/12/12.
//  Copyright © 2016年 陈小奔. All rights reserved.
//

import UIKit

class test: NSObject {
/*
     
     //1.英雄名称
     let heroName = "axe";
     
     //1.1英雄头像地址
     let heroImage = "http://cdn.dota2.com/apps/dota2/images/heroes/\(heroName)_hphover.png"
     heroInfoDic["image"] = heroImage;
     
     //2.获取克制英雄链接
     let urlAntiStr = "http://www.dotamax.com/hero/detail/match_up_anti/\(heroName)/?ladder=y";
     let urlAnti = NSURL.init(string: urlAntiStr);
     //2.2获取配合英雄链接
     let urlCombStr = "http://www.dotamax.com/hero/detail/match_up_comb/\(heroName)/?ladder=y"
     let urlComb = NSURL.init(string: urlCombStr);
     
     //3.抓取页面url,先获取当前英雄的信息,名称,胜率,次数,头像url
     do {
     htmlStr = try String.init(contentsOf: urlAnti as! URL)
     covHtmlStr = NSString.init(string: htmlStr);
     
     htmlCombStr = try String.init(contentsOf: urlComb as! URL)
     covHtmlCombStr = NSString.init(string: htmlCombStr);
     } catch {
     
     }
     //获取当前英雄的数据
     self.getCurrentHeroInfo(htmlStr:htmlStr, nsHtmlStr: covHtmlStr);
     
     //获取其他英雄的克制数据
     self.getAntiOtherHeroInfo(htmlStr:htmlStr, nsHtmlStr: covHtmlStr);
     
     //获取其他英雄的配合数据
     self.getCombOtherHeroInfo(htmlStr:htmlCombStr, nsHtmlStr: covHtmlCombStr);
     
     print(heroInfoDic);
     
     
     func getCurrentHeroInfo(htmlStr:String,nsHtmlStr:NSString) {
     //获取当前英雄html字段的正则表达式
     let patternStr = "<tr><td style[\\s\\S]+?</td></tr>";
     
     do {
     let regular = try NSRegularExpression(pattern: patternStr, options: .caseInsensitive);
     
     let checkresultSet = regular.firstMatch(in: htmlStr, options: .reportCompletion, range: NSMakeRange(0,nsHtmlStr.length));
     
     //print((checkresultSet?.range)!.location);
     let myloc = checkresultSet?.range.location;
     let mylen = checkresultSet?.range.length;
     
     //截取出含有当前英雄信息的html字段
     let result = nsHtmlStr.substring(with: NSRange.init(location: myloc!, length: mylen!));
     
     //print(result)
     
     let patternInfo = ">([^<]+).<"
     
     do {
     let curHeroInfoStr = NSString.init(string: result);
     
     let regularInfo = try NSRegularExpression(pattern: patternInfo, options: .caseInsensitive);
     
     let heroInfoSet = regularInfo.matches(in: result, options: .reportCompletion, range: NSMakeRange(0, curHeroInfoStr.length));
     
     //定义存储当前英雄信息的数组
     var array = [String]();
     //遍历正则结果集,取出属性字段
     for item in heroInfoSet {
     let myloc2 = item.range.location;
     let mylen2 = item.range.length;
     
     let result2 = curHeroInfoStr.substring(with: NSRange.init(location: myloc2, length: mylen2));
     let temp1 = result2.replacingOccurrences(of: "\n", with: "");
     let result3 = temp1.replacingOccurrences(of: " ", with: "");
     let nsresult = NSString.init(string: result3);
     //截取字符串
     let result4 = nsresult.substring(with: NSRange.init(location: 1, length: nsresult.length - 2));
     //print(result4);
     //放入字典
     array.append(result4);
     
     }
     heroInfoDic["name"] = array[0];
     heroInfoDic["count"] = array[1];
     heroInfoDic["win_rate"] = array[2];
     
     //print(heroInfoDic)
     
     } catch  {
     print(error)
     }
     } catch {
     
     }
     }

     
     case 4:
     print("加载2英雄的comb英雄列表和3英雄的anti列表");
     //            //获取2英雄,判断是点击了comb还是anti
     //            let hero2 = heroViewArray[2].heroInfo;
     //            var hero2EngName = "";
     //            if (hero2?.isKind(of: CombHeroInfo.self))! {
     //                hero2EngName = (hero2 as! CombHeroInfo).comb_eng_name!;
     //            } else {
     //                hero2EngName = (hero2 as! AntiHeroInfo).anti_eng_name!;
     //            }
     //            //print(hero2EngName);
     //
     //            //获取3英雄,判断是点击comb还是anti
     //            let hero3 = heroViewArray[3].heroInfo;
     //            var hero3EngName = "";
     //            if (hero3?.isKind(of: CombHeroInfo.self))! {
     //                hero3EngName = (hero3 as! CombHeroInfo).comb_eng_name!;
     //            } else {
     //                hero3EngName = (hero3 as! AntiHeroInfo).anti_eng_name!;
     //            }
     //            //print(hero3EngName);
     
     
     
     //    func deleteRepeatItem(hero:HeroInfo , array:[HeroInfo],viewTag : Int, index:Int) -> [HeroInfo]{
     //        var newArray = array;
     //                        for i in 0 ..< viewTag {
     //                            if hero.name! == heroViewArray[i].heroInfo?.name! {
     //                                print(heroViewArray[i].heroInfo?.name!)
     //                                print("左侧删除\(hero.name)");
     //                                newArray.remove(at: index);
     //                            }
     //                        }
     //        return newArray;
     //    }
     */
}
