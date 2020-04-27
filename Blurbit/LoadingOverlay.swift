//
//  LoadingOverlay.swift
//  Blurbit
//
//  Created by user163612 on 4/21/20.
//  Copyright © 2020 Team-Blurbit. All rights reserved.
//
import UIKit

class LoadingOverlay{
    
    var overlayView:UIView!
    var loadingIndicator : UIActivityIndicatorView!

    //singleton overlay screen to avoid creating new overlay screens
    static let shared:LoadingOverlay = {
        let instance=LoadingOverlay()
        return instance
    }()

    init(){
        print("in init")
        self.overlayView = UIView()
        self.loadingIndicator = UIActivityIndicatorView()
        overlayView.frame = CGRect(x:0, y:0, width:80, height:80)
        overlayView.backgroundColor = .white
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 10
        overlayView.layer.zPosition = 1
        loadingIndicator.frame = CGRect(x:0, y:0, width:40, height:40)
        loadingIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
        loadingIndicator.style = .large
        overlayView.addSubview(loadingIndicator)
        print("end init")
    }

    public func displayOverlay(backgroundView:UIView){
        print("load1")
        overlayView.center = backgroundView.center
        overlayView.frame = backgroundView.frame
        loadingIndicator.frame = CGRect(x:0, y:0, width:40, height:40)
        loadingIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
        loadingIndicator.style = .large
        overlayView.addSubview(loadingIndicator)
        print("load2")
        backgroundView.addSubview(overlayView)
        backgroundView.bringSubviewToFront(overlayView)
        overlayView.bringSubviewToFront(loadingIndicator)
        print("load3")
        loadingIndicator.startAnimating()
        print("load4")
    }

    public func hideOverlay(){
        loadingIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }

}
