//
//  AntiHeroInfo.swift
//  DotaBP
//
//  Created by 陈小奔 on 2016/12/12.
//  Copyright © 2016年 陈小奔. All rights reserved.
//

import UIKit

class AntiHeroInfo: HeroInfo {
    //var name : String?
    //var count : String?
    //var win_rate : String?
    var anti_rate : String?
    //var image : String?
    var anti_eng_name : String?
    
    override init(dict:Dictionary<String,String>) {
        super.init(dict: dict);
        //self.name = dict["name"];
        //self.count = dict["count"];
        //self.win_rate = dict["win_rate"];
        self.anti_rate = dict["anti_rate"];
        self.anti_eng_name = dict["anti_eng_name"];
        //self.image = dict["image"];
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //self.win_rate = aDecoder.decodeObject(forKey: "win_rate") as! String?;
        self.anti_eng_name = aDecoder.decodeObject(forKey: "anti_eng_name") as! String?
        self.anti_rate = aDecoder.decodeObject(forKey: "anti_rate") as! String?
    }

    override func encode(with aCoder: NSCoder) {
        //aCoder.encode(win_rate, forKey: "win_rate")
        super.encode(with: aCoder)
        aCoder.encode(anti_eng_name, forKey: "anti_eng_name");
        aCoder.encode(anti_rate, forKey: "anti_rate");
    }

}
