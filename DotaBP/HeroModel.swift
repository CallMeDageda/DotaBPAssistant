//
//  HeroModel.swift
//  DotaBP
//
//  Created by 陈小奔 on 2016/12/20.
//  Copyright © 2016年 陈小奔. All rights reserved.
//

import UIKit

class HeroModel: NSObject,NSCoding {
    var name:String?
    var name_eng:String?
    var antiArray:[AntiHeroInfo]?
    var combArray:[CombHeroInfo]?
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name");
        aCoder.encode(self.name_eng, forKey: "name_eng");
        aCoder.encode(self.antiArray, forKey: "antiArray");
        aCoder.encode(self.combArray, forKey: "combArray");
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init();
        self.name = aDecoder.decodeObject(forKey: "name") as! String?;
        self.name_eng = aDecoder.decodeObject(forKey: "name_eng") as! String?;
        self.antiArray = aDecoder.decodeObject(forKey: "antiArray") as! [AntiHeroInfo]?;
        self.combArray = aDecoder.decodeObject(forKey: "combArray") as! [CombHeroInfo]?;
    }
    
    override init() {
        super.init()
    }
}
