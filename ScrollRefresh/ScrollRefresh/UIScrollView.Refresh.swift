//
//  UIScrollView.Refresh.swift
//  ScrollRefresh
//
//  Created by admin on 8/7/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

let REFRESH_VALUE_HEIGHT            = 50 as CGFloat

extension UIScrollView
{
    private struct AssociatedKeys
    {
        static var lastTime = "lastTime"
        static var headerView = "headerView"
        static var topView = "topView"
        static var lblStatus = "lblStatus"
        static var topLoader = "topLoader"
        static var lblTime = "lblTime"
    }
    
    private var lastTime: Date
    {
        get {
            guard let lastTime = objc_getAssociatedObject(self, &AssociatedKeys.lastTime) as? Date else {
                return Date()
            }

            return lastTime
        }

        set(value) {
            objc_setAssociatedObject(self, &AssociatedKeys.lastTime, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var headerView: UIView
    {
        get {
            guard let headerView = objc_getAssociatedObject(self, &AssociatedKeys.headerView) as? UIView else {
                return UIView()
            }

            return headerView
        }

        set(value) {
            objc_setAssociatedObject(self, &AssociatedKeys.headerView, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var topView: UIView
    {
        get {
            guard let topView = objc_getAssociatedObject(self, &AssociatedKeys.topView) as? UIView else {
                return UIView()
            }

            return topView
        }

        set(value) {
            objc_setAssociatedObject(self, &AssociatedKeys.topView, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var lblStatus: UILabel
    {
        get {
            guard let lblStatus = objc_getAssociatedObject(self, &AssociatedKeys.lblStatus) as? UILabel else {
                return UILabel()
            }

            return lblStatus
        }

        set(value) {
            objc_setAssociatedObject(self, &AssociatedKeys.lblStatus, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var topLoader: UIActivityIndicatorView
    {
        get {
            guard let topLoader = objc_getAssociatedObject(self, &AssociatedKeys.topLoader) as? UIActivityIndicatorView else {
                return UIActivityIndicatorView()
            }

            return topLoader
        }

        set(value) {
            objc_setAssociatedObject(self, &AssociatedKeys.topLoader, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var lblTime: UILabel
    {
        get {
            guard let lblTime = objc_getAssociatedObject(self, &AssociatedKeys.lblTime) as? UILabel else {
                return UILabel()
            }

            return lblTime
        }

        set(value) {
            objc_setAssociatedObject(self, &AssociatedKeys.lblTime, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func addRefreshView()
    {
        self.layoutIfNeeded()
        
        self.lastTime = Date()
        
        self.headerView = UIView(frame: CGRect(x: 0, y: -REFRESH_VALUE_HEIGHT, width: self.bounds.size.width, height: REFRESH_VALUE_HEIGHT))
        self.headerView.backgroundColor = .clear
        self.addSubview(self.headerView)
        
        var transform = CATransform3DIdentity
        transform.m34 = -1/500.0
        self.headerView.layer.sublayerTransform = transform
        
        self.topView = UIView(frame: CGRect(x: 0, y: -REFRESH_VALUE_HEIGHT, width: self.headerView.bounds.size.width, height: REFRESH_VALUE_HEIGHT))
        self.topView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        self.headerView.addSubview(self.topView)
        
        self.lblStatus = UILabel()
        self.lblStatus.textAlignment = .center
        self.lblStatus.font = UIFont.systemFont(ofSize: 12)
        self.lblStatus.text = "Pull to refresh"
        self.lblStatus.sizeToFit()
        self.topView.addSubview(self.lblStatus)
        self.lblStatus.frame = CGRect(x: 5, y: 5, width: self.topView.bounds.size.width - 10, height: self.lblStatus.bounds.height + 2)
        
        self.lblTime = UILabel()
        self.lblTime.textAlignment = .center
        self.lblTime.font = UIFont.systemFont(ofSize: 12)
        self.lblTime.text = "Test"
        self.lblTime.sizeToFit()
        self.topView.addSubview(self.lblTime)
        self.lblTime.frame = CGRect(x: 5,
                                    y: self.lblStatus.frame.origin.y + self.lblStatus.bounds.size.height,
                                    width: self.topView.bounds.size.width - 10,
                                    height: self.lblStatus.bounds.height)
        
        self.topLoader = UIActivityIndicatorView(style: .gray)
        self.topView.addSubview(self.topLoader)
        self.topLoader.center = self.lblTime.center
        self.topLoader.frame = CGRect(x: (self.topView.bounds.size.width - self.topLoader.bounds.size.width)/2,
                                      y: self.lblTime.frame.origin.y + self.lblTime.bounds.size.height,
                                      width: self.topLoader.bounds.size.width,
                                      height: self.topLoader.bounds.size.height)
        self.topLoader.isHidden = true
    }
    
    func checkRefreshFlag() -> Bool
    {
        return self.contentOffset.y < -REFRESH_VALUE_HEIGHT
    }
    
    func unfoldHeader()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        
        self.lblTime.text = "Las update: \(formatter.string(from: self.lastTime))"
        
        var fraction = self.contentOffset.y / -REFRESH_VALUE_HEIGHT
        
        if(fraction < 1)
        {
            self.lblStatus.text = "Pull to refresh"
        }
        else
        {
            self.lblStatus.text = "Let refresh now"
        }
        
        if (fraction < 0)
        {
            fraction = 0.0
        }
        
        if (fraction > 1)
        {
            fraction = 1.0
        }
        
        let radian =  CGFloat(asinf(Float(fraction))) + .pi*3/2 as CGFloat
        
        self.topView.layer.transform = CATransform3DMakeRotation(radian, 1, 0, 0)
        self.topView.frame = CGRect(x: 0, y: REFRESH_VALUE_HEIGHT*(1 - fraction), width: self.bounds.size.width, height: REFRESH_VALUE_HEIGHT/2)
    }
    
    func freezeRefreshHeader()
    {
        self.contentInset = UIEdgeInsets(top: REFRESH_VALUE_HEIGHT, left: 0, bottom: 0, right: 0)
        
        self.lblStatus.isEnabled = true
        self.lblTime.isEnabled = true
        
        self.topLoader.isHidden = false
        self.topLoader.startAnimating()
    }
    
    func finishRefreshData()
    {
        self.lastTime = Date()
        
        self.topLoader.stopAnimating()
        self.topLoader.isHidden = true
        
        UIView.animate(withDuration: 0.125, animations: {
            
            self.contentInset = .zero
            
        }) { (finish) in
            
            self.lblStatus.isEnabled = false
            self.lblTime.isEnabled = false
        }
    }
}
