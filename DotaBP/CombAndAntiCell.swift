//
//  CombAndAntiCell.swift
//  DotaBP
//
//  Created by 陈小奔 on 2016/12/12.
//  Copyright © 2016年 陈小奔. All rights reserved.
//

import UIKit

class CombAndAntiCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var rateLabel: UILabel!
    
    var combHero : CombHeroInfo? {
        didSet {
            self.nameLabel.text = combHero?.name;
            
            //胜率改为不同英雄针对胜率
            self.rateLabel.text = "胜率:" + (combHero?.win_rate!)!;
            
            //头像
            self.icon.sd_setImage(with: URL.init(string: (combHero?.image)!),placeholderImage: UIImage.init(named: "default_logo"));
        }
    }
    
    var antiHero : AntiHeroInfo? {
        didSet {

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
