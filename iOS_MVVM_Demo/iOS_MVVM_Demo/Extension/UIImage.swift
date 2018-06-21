//
//  UIImage.swift
//  RxSwift_Part1
//
//  Created by shengling on 2018/6/11.
//  Copyright © 2018年 ShengLing. All rights reserved.
//

import Foundation
import UIKit
extension UIImage {
    
    class func imageFromColor(color: UIColor,size: CGSize = CGSize(width: 50, height: 50)) -> (UIImage){
        
        let rect = CGRect(x:0, y:0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
