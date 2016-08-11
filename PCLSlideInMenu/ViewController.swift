//
//  ViewController.swift
//  PCLSlideInMenu
//
//  Created by Pin-Chih on 8/6/16.
//  Copyright © 2016 Pin-Chih. All rights reserved.
//

import UIKit

class ViewController: UIViewController,PCLSlideInMenuDataSource,PCLSlideInMenuDelegate{
    
    let myMenu = PCLSlideInMenu()
    @IBOutlet weak var myLabel:UILabel!
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        myMenu.dataSource = self
        myMenu.delegate = self
        myMenu.animation = .Rotate
        
    }
    
    
    
    @IBAction func triggerMenu(){

        myMenu.showMenu()
        
    }
    
    
    func menuItemCount() -> Int {
        return 3
    }

    
    func menuItemSpacing() -> CGFloat {
        return 60.0
    }
    

    func menuItemAt(Index: Int) -> MenuItemInfo {
        
        
        let menuItem1 = MenuItemInfo(iconImage: UIImage(named: "demo0")!, iconWidthAndHeight: 50,backgroundColor:UIColor.clearColor())
        let menuItem2 = MenuItemInfo(iconImage: UIImage(named: "demo1")!, iconWidthAndHeight: 50,backgroundColor:UIColor.clearColor())
        let menuItem3 = MenuItemInfo(iconImage: UIImage(named: "demo2")!, iconWidthAndHeight: 50,backgroundColor:UIColor.clearColor())
        
        return [menuItem1,menuItem2,menuItem3][Index]
        
        
    }
    
    
    func menuItemClickedAt(Index: Int) {
        
        myLabel.text = String(Index)
        
        
    }
 
}

