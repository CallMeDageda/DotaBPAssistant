//
//  CombAndAntiOtherCell.swift
//  DotaBP
//
//  Created by 陈小奔 on 2016/12/12.
//  Copyright © 2016年 陈小奔. All rights reserved.
//

import UIKit

class CombAndAntiOtherCell: UITableViewCell {
    var antiHero : AntiHeroInfo? {
        didSet {
            self.nameLabel.text = antiHero?.name;
            
            //胜率改为不同英雄针对胜率
            let str = (antiHero?.win_rate!)!;
            let val : Double = 100 - (str as NSString).doubleValue
            //print("cyk-----\(val)");
            let disstr = String.init(format: "%.2f", val);
            self.rateLabel.text = "胜率:\(disstr)%";
            
            //头像
            self.icon.sd_setImage(with: URL.init(string: (antiHero?.image)!),placeholderImage: UIImage.init(named: "default_logo"));
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
