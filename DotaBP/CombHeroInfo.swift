//
//  CombHeroInfo.swift
//  DotaBP
//
//  Created by 陈小奔 on 2016/12/12.
//  Copyright © 2016年 陈小奔. All rights reserved.
//

import UIKit

class CombHeroInfo: HeroInfo {
    var comb_rate : String?
    var comb_eng_name : String?

    override init(dict:Dictionary<String,String>) {
        super.init(dict: dict);

        self.comb_rate = dict["comb_rate"];
        
        self.comb_eng_name = dict["comb_eng_name"];
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder);
        self.comb_rate = aDecoder.decodeObject(forKey: "comb_rate") as! String?;
        self.comb_eng_name = aDecoder.decodeObject(forKey: "comb_eng_name") as! String?;
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder);
        aCoder.encode(comb_rate, forKey: "comb_rate");
        aCoder.encode(comb_eng_name, forKey: "comb_eng_name");
    }
}
