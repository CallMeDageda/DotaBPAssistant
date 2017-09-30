//
//  HeroView.swift
//  DotaBP
//
//  Created by 陈小奔 on 2016/12/9.
//  Copyright © 2016年 陈小奔. All rights reserved.
//

import UIKit
import SDWebImage.UIImageView_WebCache
import MBProgressHUD

class HeroView: UIView {
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var imageBtn: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var delegate : ShowHeroInfoTableProtocol?
    
    var isLock : Bool?
    
    var hud : MBProgressHUD?
    
    //用来显示英雄信息
    var heroInfo : HeroInfo?
    
    var rateLabel : UILabel?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        
        view = Bundle.main.loadNibNamed("HeroView", owner: self, options: nil)?.first as! UIView;
        view.frame = self.bounds;
        self.addSubview(view);
        
        //imageBtn.addTarget(self, action: #selector(HeroView.displayHUD), for: .touchDown)
        imageBtn.addTarget(self, action:#selector(HeroView.buttonClick), for: UIControlEvents.touchUpInside);
        //imageBtn.addTarget(self, action:#selector(HeroView.buttonClick), for: .touchUpOutside);
    }
    
    func displayHUD() -> Void {
        hud = MBProgressHUD.showAdded(to: (UIApplication.shared.keyWindow?.rootViewController?.view)!, animated: true);
        hud?.mode = MBProgressHUDMode.indeterminate;
        hud?.label.text = "正在解析数据..."
    }

    func buttonClick() {
        //self.displayHUD();
        //弹出tableview
        //push tableviewcontroller
        delegate?.show(sender: self);
    
    }
    
    func heroInfoClosure(heroData:HeroInfo) -> Void {
        self.heroInfo = heroData;
        self.nameLabel.text = heroData.name;
        
        //self.rateLabel?.text = heroData.win_rate;
        
        //print(heroData.image!);
        //print(heroData.name_eng);
        
        let imageURL = URL.init(string: heroData.image!);
        //设置头像
        //不能对button的imageview直接设置,无法显示
        //self.imageBtn.imageView?.sd_setImage(with: imageURL, placeholderImage: nil);
        self.imageBtn.sd_setImage(with: imageURL, for: .normal)
        
    }

}

protocol ShowHeroInfoTableProtocol {
    func show(sender:HeroView)

}


