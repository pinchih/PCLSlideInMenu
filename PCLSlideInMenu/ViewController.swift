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
        return 70.0
    }
    

    func menuItemAt(Index: Int) -> MenuItemInfo {
        
        
        let menuItem1 = MenuItemInfo(iconImage: UIImage(named: "delete")!, iconWidthAndHeight: 60,backgroundColor: UIColor.clearColor())
        let menuItem2 = MenuItemInfo(iconImage: UIImage(named: "contacts")!, iconWidthAndHeight: 60,backgroundColor:UIColor.clearColor())
        let menuItem3 = MenuItemInfo(iconImage: UIImage(named: "menu")!, iconWidthAndHeight: 60,backgroundColor:UIColor.clearColor())
        
        return [menuItem1,menuItem2,menuItem3][Index]
        
        
    }
    
    
    func menuItemClickedAt(Index: Int) {
        
        print(Index)
        
        
    }
 
}

