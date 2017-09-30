//
//  FirstHeroAntiTableViewCell.swift
//  DotaBP
//
//  Created by 陈小奔 on 2016/12/12.
//  Copyright © 2016年 陈小奔. All rights reserved.
//

import UIKit

class FirstHeroAntiTableViewCell: UITableViewCell {
    var antiHeroInfo : AntiHeroInfo? {
        didSet{
            self.nameLabel.text = antiHeroInfo?.name;
            
            //胜率改为不同英雄针对胜率
            let str = (antiHeroInfo?.win_rate!)!;
            let val : Double = 100 - (str as NSString).doubleValue
            //print("cyk-----\(val)");
            let disstr = String.init(format: "%.2f", val);
            self.rateLabel.text = "胜率:\(disstr)%";
            
            //self.countLabel.text = "使用次数: " +  (heroInfo?.count!)!;
            //设置头像
            self.icon.sd_setImage(with: URL.init(string: (antiHeroInfo?.image)!), placeholderImage: UIImage.init(named: "default_logo"));
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!

    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
