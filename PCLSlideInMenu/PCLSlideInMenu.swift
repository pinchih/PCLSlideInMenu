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
    @objc optional func menuItemClickedAt(Index:Int)
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
    case slideIn
    case rotate
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
    var animation : animationType = .slideIn
    
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
    
    func setupMenu(_ info:MenuItemInfo,window:UIWindow,Index:Int) -> UIImageView{
        
        let view = UIImageView()
        
        view.image = info.iconImage
        
        if Index == 0{
            view.frame = CGRect(x: window.frame.width, y: window.frame.height - self.offSetInX,width: info.iconWidthAndHeight, height: info.iconWidthAndHeight)
        }else{
            view.frame = CGRect(x: window.frame.width, y: window.frame.height - self.offSetInX - spacing*CGFloat(Index),width: info.iconWidthAndHeight, height: info.iconWidthAndHeight)
        }
        
        
        view.layer.masksToBounds = true
        view.layer.cornerRadius = view.frame.width/2
        view.backgroundColor = info.backgroundColor
        
        view.isUserInteractionEnabled = true
        view.tag = Index
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(menuItemClicked)))
        
        return view
    }

    
    // MARK : - Animation
    func showMenu(){
        
        if let window = UIApplication.shared.keyWindow{
            
            backView.frame = window.frame

            if viewArr.count == 0{
                
                window.addSubview(backView)
                
                for i in 0..<itemCount{
                    let menuItem = dataSource!.menuItemAt(Index: i)
                    let viewToAdd = setupMenu(menuItem, window: window,Index: i)
                    viewArr.append(viewToAdd)
                    window.addSubview(viewToAdd)
                }
                
                
            }
            
            // Show background View
            UIView.animate(withDuration: 0.5, animations: {
                self.backView.alpha = 1
            }, completion: nil)
            
            // Show menu items
            animateRecursive(0)
            
        }
        
        
    }
    
    func animateRecursive(_ Index:Int){
        
        
        if Index == self.viewArr.count {

            return

        }else{
            
         
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
                let view = self.viewArr[Index]
                
                switch self.animation{
                    
                    case .slideIn:
                        view.frame = CGRect(x: view.frame.origin.x - self.offSetInX, y: view.frame.origin.y,width: view.frame.width, height: view.frame.height)
                        break
                    case .rotate:
                        
                        view.frame = CGRect(x: view.frame.origin.x - self.offSetInX, y: view.frame.origin.y,width: view.frame.width, height: view.frame.height)
                        view.transform = CGAffineTransform(rotationAngle: 270.degreesToRadians)
                        break
                }
                
            }, completion: { (finished) in
                
                if finished{
                    
                    return self.animateRecursive(Index+1)
                    
                }
                
            })
            
        }
        
    }
    
    func menuItemClicked(_ sender:UITapGestureRecognizer){
        
        
        guard let userDelegate = self.delegate?.menuItemClickedAt else{
            fatalError("Delegate method menuItemClickedAt(Index:Int) is not implemented")
        }
        
        let imgView = sender.view as! UIImageView
        userDelegate(imgView.tag)
        dismissView()
        
    }
    
    
    func dismissView(){
        
        UIView.animate(withDuration: 0.3, animations: {
        
            self.backView.alpha = 0
            
            for i in 0..<self.viewArr.count{
                let view = self.viewArr[i]
                
                
                switch self.animation{
                    
                    case .slideIn:
                        view.frame = CGRect(x: view.frame.origin.x + self.offSetInX, y: view.frame.origin.y, width: view.frame.width, height: view.frame.height)
                        break
                    case .rotate:
                        view.frame = CGRect(x: view.frame.origin.x + self.offSetInX, y: view.frame.origin.y, width: view.frame.width, height: view.frame.height)
                        //view.transform = CGAffineTransformMakeRotation(180.degreesToRadians)
                        view.transform = CGAffineTransform.identity
                        break
                }
                
            }
            
        })
        
        
    }
    
}
