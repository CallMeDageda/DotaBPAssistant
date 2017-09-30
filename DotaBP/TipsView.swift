//
//  TipsView.swift
//  DotaBP
//
//  Created by 陈小奔 on 2016/12/28.
//  Copyright © 2016年 陈小奔. All rights reserved.
//

import UIKit

class TipsView: UIView {
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var closeBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        view = Bundle.main.loadNibNamed("TipsView", owner: self, options: nil)?.first as! UIView;
        view.frame = self.bounds;
        self.addSubview(view);
        
        closeBtn.addTarget(self, action: #selector(TipsView.closeView), for: UIControlEvents.touchUpInside);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func closeView() -> Void {
        self.removeFromSuperview();
    }
}
