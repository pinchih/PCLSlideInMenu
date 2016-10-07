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
        myMenu.animation = .slideIn
        
    }
    
    
    
    @IBAction func triggerMenu(){

        myMenu.showMenu()
        
    }
    
    
    // PCLSlideInMenuDataSource
    
    func menuItemCount() -> Int {
        return 3
    }

    
    func menuItemSpacing() -> CGFloat {
        return 60.0
    }
    

    func menuItemAt(Index: Int) -> MenuItemInfo {
        
        
        let menuItem1 = MenuItemInfo(iconImage: UIImage(named: "demo0_default")!, iconWidthAndHeight: 50,backgroundColor:UIColor.clear)
        let menuItem2 = MenuItemInfo(iconImage: UIImage(named: "demo1_default")!, iconWidthAndHeight: 50,backgroundColor:UIColor.clear)
        let menuItem3 = MenuItemInfo(iconImage: UIImage(named: "demo2_default")!, iconWidthAndHeight: 50,backgroundColor:UIColor.clear)
        
        /* 
        
         // If you're using the rotate animation, please rotate your original image by 90 degree clockwise to get the best effect
         
        let menuItem1 = MenuItemInfo(iconImage: UIImage(named: "demo0")!, iconWidthAndHeight: 50,backgroundColor:UIColor.clearColor())
        let menuItem2 = MenuItemInfo(iconImage: UIImage(named: "demo1")!, iconWidthAndHeight: 50,backgroundColor:UIColor.clearColor())
        let menuItem3 = MenuItemInfo(iconImage: UIImage(named: "demo2")!, iconWidthAndHeight: 50,backgroundColor:UIColor.clearColor())
        */
        
        return [menuItem1,menuItem2,menuItem3][Index]
        
        
    }
    
    // PCLSlideInMenuDelegate
    
    func menuItemClickedAt(Index: Int) {
        
        myLabel.text = String(Index)
        
        
    }
 
}

