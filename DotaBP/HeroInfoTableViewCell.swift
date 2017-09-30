//
//  HeroInfoTableViewCell.swift
//  DotaBP
//
//  Created by 陈小奔 on 2016/12/11.
//  Copyright © 2016年 陈小奔. All rights reserved.
//

import UIKit
import SDWebImage.UIImageView_WebCache

class HeroInfoTableViewCell: UITableViewCell {
    
    var heroInfo : HeroInfo? {
        didSet{
            self.nameLabel.text = heroInfo?.name;
            self.rateLabel.text = "胜率: " +  (heroInfo?.win_rate!)!;
            self.countLabel.text = "使用次数: " +  (heroInfo?.count!)!;
            //设置头像
            self.icon.sd_setImage(with: URL.init(string: (heroInfo?.image)!),placeholderImage: UIImage.init(named: "default_logo"));
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!

    override func awakeFromNib() {

        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
