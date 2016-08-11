//
//  PCLSlideInMenu.swift
//  PCLSlideInMenu
//
//  Created by Pin-Chih on 8/6/16.
//  Copyright © 2016 Pin-Chih. All rights reserved.
//

import UIKit

public protocol PCLSlideInMenuDataSource{
     func menuItemAt(Index:Int) -> MenuItemInfo
     func menuItemCount() -> Int
     func menuItemSpacing() -> CGFloat
}

@objc protocol PCLSlideInMenuDelegate{
    optional func menuItemClickedAt(Index:Int)
}


public struct MenuItemInfo {
    var iconImage : UIImage
    var iconWidthAndHeight : CGFloat
    var backgroundColor : UIColor
}

extension Int {
    var degreesToRadians: CGFloat { return CGFloat(Double(self) * M_PI / 180) }
    var radiansToDegrees: CGFloat { return CGFloat(Double(self) * 180 / M_PI) }
}

enum animationType {
    case Default
    case Rotate
}


class PCLSlideInMenu: NSObject {
    
    let backView = UIView()
    
    
    var dataSource : PCLSlideInMenuDataSource?{
        didSet{
            itemCount = dataSource!.menuItemCount()
            spacing = dataSource!.menuItemSpacing()
        }
    }
    
    var delegate : PCLSlideInMenuDelegate?
    
    var itemCount : Int = 0
    var spacing : CGFloat = 0.0
    var viewArr : [UIImageView] = []
    let offSetInX : CGFloat = 80.0
    let offSetInY : CGFloat = 60.0
    var animation : animationType = .Default
    
    override init() {
        super.init()
        backgroundViewSetup()
        
    }
    
    
    // MARK : - View setup    
    func backgroundViewSetup(){
        backView.backgroundColor = UIColor.init(white: 0, alpha: 0.3)
        backView.alpha = 0
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissView)))
    }
    
    func setupMenu(info:MenuItemInfo,window:UIWindow,Index:Int) -> UIImageView{
        
        let view = UIImageView()
        
        view.image = info.iconImage
        
        if Index == 0{
            view.frame = CGRectMake(window.frame.width, window.frame.height - self.offSetInX,info.iconWidthAndHeight, info.iconWidthAndHeight)
        }else{
            view.frame = CGRectMake(window.frame.width, window.frame.height - self.offSetInX - spacing*CGFloat(Index),info.iconWidthAndHeight, info.iconWidthAndHeight)
        }
        
        
        view.layer.masksToBounds = true
        view.layer.cornerRadius = view.frame.width/2
        view.backgroundColor = info.backgroundColor
        
        view.userInteractionEnabled = true
        view.tag = Index
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(menuItemClicked)))
        
        return view
    }

    
    // MARK : - Animation
    func showMenu(){
        
        if let window = UIApplication.sharedApplication().keyWindow{
            
            backView.frame = window.frame

            if viewArr.count == 0{
                
                window.addSubview(backView)
                
                for i in 0..<itemCount{
                    let menuItem = dataSource!.menuItemAt(i)
                    let viewToAdd = setupMenu(menuItem, window: window,Index: i)
                    viewArr.append(viewToAdd)
                    window.addSubview(viewToAdd)
                }
                
                
            }
            
            // Show background View
            UIView.animateWithDuration(0.5, animations: {
                self.backView.alpha = 1
            }, completion: nil)
            
            // Show menu items
            animateRecursive(0)
            
        }
        
        
    }
    
    func animateRecursive(Index:Int){
        
        
        if Index == self.viewArr.count {

            return

        }else{
            
         
            
            UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .CurveEaseOut, animations: {
            
                let view = self.viewArr[Index]
                
                switch self.animation{
                    
                    case .Default:
                        view.frame = CGRectMake(view.frame.origin.x - self.offSetInX, view.frame.origin.y,view.frame.width, view.frame.height)
                        break
                    case .Rotate:
                        
                        view.frame = CGRectMake(view.frame.origin.x - self.offSetInX, view.frame.origin.y,view.frame.width, view.frame.height)
                        view.transform = CGAffineTransformMakeRotation(270.degreesToRadians)
                        break
                }
                
            }, completion: { (finished) in
                
                if finished{
                    
                    return self.animateRecursive(Index+1)
                    
                }
                
            })
            
        }
        
    }
    
    func menuItemClicked(sender:UITapGestureRecognizer){
        
        
        guard let userDelegate = self.delegate?.menuItemClickedAt else{
            fatalError("Delegate method menuItemClickedAt(Index:Int) is not implemented")
        }
        
        let imgView = sender.view as! UIImageView
        userDelegate(imgView.tag)
        dismissView()
        
    }
    
    
    func dismissView(){
        
        UIView.animateWithDuration(0.3, animations: {
        
            self.backView.alpha = 0
            
            for i in 0..<self.viewArr.count{
                let view = self.viewArr[i]
                
                
                switch self.animation{
                    
                    case .Default:
                        view.frame = CGRectMake(view.frame.origin.x + self.offSetInX, view.frame.origin.y, view.frame.width, view.frame.height)
                        break
                    case .Rotate:
                        view.frame = CGRectMake(view.frame.origin.x + self.offSetInX, view.frame.origin.y, view.frame.width, view.frame.height)
                        //view.transform = CGAffineTransformMakeRotation(180.degreesToRadians)
                        view.transform = CGAffineTransformIdentity
                        break
                }
                
            }
            
        })
        
        
    }
    
}
