//
//  Mine.swift
//  Mine!
//
//  Created by WzxJiang on 17/2/21.
//  Copyright © 2017年 WORDOOR. All rights reserved.
//

import UIKit

class Chess: UIView {
    var coverView: UILabel!
    var numLabel: UILabel!
    var isMine = false
    var uncovered = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createUI() -> Void {
        numLabel = UILabel(frame: self.bounds)
        numLabel.backgroundColor = UIColor.gray
        numLabel.textColor = UIColor.white
        numLabel.textAlignment = .center
        numLabel.font = UIFont.systemFont(ofSize: 13)
        self.addSubview(numLabel)
        
        coverView = UILabel(frame: self.bounds)
        coverView.isUserInteractionEnabled = true
        coverView.layer.borderColor = UIColor.gray.cgColor
        coverView.layer.borderWidth = 1
        coverView.textAlignment = .center
        coverView.font = UIFont.systemFont(ofSize: 13)
        coverView.backgroundColor = UIColor.white
        self.addSubview(coverView)
    }
    
    func uncover() -> Void {
        guard uncovered == false else {
            return
        }
        uncovered = true
        coverView.removeFromSuperview()
    }
    
    func set(isMine: Bool) -> Void {
        self.isMine = isMine
        if isMine {
            numLabel.text = "💣"
        }
    }
}
