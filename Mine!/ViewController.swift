//
//  ViewController.swift
//  Mine!
//
//  Created by WzxJiang on 17/2/21.
//  Copyright © 2017年 WORDOOR. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // 一行row个
    let ROW = 20
    
    // line 行
    let LINE = 25
    
    // 概率 30/100
    let CHANCE: UInt32 = 30
    
    var collectionView: UICollectionView!
    
    var datas: [Bool] = []
    
    var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getData()
        self.createUI()
    }
    
    func getData() -> Void {
        for _ in 0..<(ROW * LINE) {
            if arc4random()%100 <= CHANCE {
                datas.append(true)
            } else {
                datas.append(false)
            }
        }
    }
    
    func createUI() -> Void {
        contentView = UIView(frame: CGRect(x: 0, y: 20, width: self.view.bounds.width, height: self.view.bounds.height-20))
        self.view.addSubview(contentView)
        
        let width = self.view.bounds.width/CGFloat(ROW)
        
        for i in 0..<(ROW * LINE) {
            let mine = Chess(frame: CGRect(x: CGFloat(i%ROW)*width, y: CGFloat(i/ROW)*width, width: width, height: width))
            contentView.addSubview(mine)
            
            mine.coverView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(click(sender:))))
            mine.coverView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPress(sender:))))
            mine.set(isMine: datas[i])
            mine.tag = i + 10000
        }
    }
    
    func longPress(sender: UILongPressGestureRecognizer) -> Void {
        guard let coverLabel: UILabel = sender.view as? UILabel else {
            return
        }
        
        if sender.state == .began {
            if coverLabel.text == "🇨🇳" {
                coverLabel.text = ""
            } else {
                coverLabel.text = "🇨🇳"
            }
        }
    }
    
    func click(sender: UITapGestureRecognizer) -> Void {
        guard let chess: Chess = sender.view!.superview as? Chess else {
            return
        }
        
        chess.uncover()
        if chess.isMine {
            let alertController =
                UIAlertController(title: "Tip", message: "GAME OVER", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "😢", style: .cancel))
            
            self.present(alertController, animated: true)
            
        } else {
            analyse(chess: chess)
        }
    }
    
    func analyse(chess: Chess) {
        let tag = chess.tag
        var num = 0
        var offsets: [Int] = []
        
        let rect = chess.frame
        
        for (x, y) in [(-1, -1), (0, -1), (1, -1),
                       (-1, 0),           (1, 0),
                       (-1, 1),  (0, 1),  (1, 1)] {
            guard contentView.bounds.contains(rect.differRect(x_multiple: x, y_multiple: y)) else {
                continue
            }
                        
            let offset = x + y*ROW
                        
            if let neighbouring_mine = contentView.viewWithTag(tag + offset) as? Chess {
                num += (neighbouring_mine.isMine ? 1 : 0)
                if neighbouring_mine.uncovered == false {
                    offsets.append(offset)
                }
            }
        }
        
        if num == 0 {
            chess.numLabel.text = "🍀"
            for offset in offsets {
                let neighbouringChess = contentView.viewWithTag(tag + offset) as! Chess
                neighbouringChess.uncover()
                analyse(chess: neighbouringChess)
            }
        } else {
            chess.numLabel.text = "\(num)"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CGRect {
    func differRect(x_multiple: Int, y_multiple: Int) -> CGRect {
        var rect = self
        rect.origin.x += (CGFloat(x_multiple)*rect.width)
        rect.origin.y += (CGFloat(y_multiple)*rect.width)
        return rect
    }
}
