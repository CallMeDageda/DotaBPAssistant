//
//  SetLangView.swift
//  DotaBP
//
//  Created by 陈小奔 on 2017/1/11.
//  Copyright © 2017年 陈小奔. All rights reserved.
//

import UIKit

class SetLangView: UIView {
    @IBOutlet var view: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        view = Bundle.main.loadNibNamed("SetLangView", owner: self, options: nil)?.first as! UIView;
        view.frame = self.bounds;
        self.addSubview(view);
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
