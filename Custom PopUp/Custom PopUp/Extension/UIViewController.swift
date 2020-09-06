//
//  UIViewController.swift
//  Custom PopUp
//
//  Created by Jitengiri Goswami on 06/09/20.
//  Copyright © 2020 Jitengiri Goswami. All rights reserved.
//

import UIKit

@objc class ClosureSleeve: NSObject {
    let closure: ()->()
    
    init (_ closure: @escaping ()->()) {
        self.closure = closure
    }
    
    @objc func invoke () {
        closure()
    }
}

extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping ()->()) {
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, "[\(arc4random())]", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}

extension UIViewController{
    
    private func getFontFamily() -> UIFont{
        return UIFont(name: "HelveticaNeue-Bold", size: 14.0)!
    }
    
    @available(iOS 13.0, *)
    private func getStatusBarHeight() -> CGFloat{
        var heightToReturn: CGFloat = 0.0
             for window in UIApplication.shared.windows {
                 if let height = window.windowScene?.statusBarManager?.statusBarFrame.height, height > heightToReturn {
                     heightToReturn = height
                 }
             }
        return heightToReturn
    }
    
    func topPopUp(strText: String, imgName: String, duration: Int){
        
        var topBarHeight = CGFloat()
        
        if #available(iOS 13, *) {
            topBarHeight = getStatusBarHeight() + (self.navigationController?.navigationBar.frame.height ?? 0.0) + 20
        }else{
            topBarHeight = UIApplication.shared.statusBarFrame.size.height + (self.navigationController?.navigationBar.frame.height ?? 0.0) + 20
        }
        
        let btnAlert = UIButton(frame:CGRect(x:10, y:topBarHeight, width:UIScreen.main.bounds.width - 20, height:50))
        btnAlert.setTitle(strText, for: .normal)
        btnAlert.titleLabel?.lineBreakMode = .byTruncatingTail
        btnAlert.setImage(UIImage(named: imgName), for: .normal)
        btnAlert.setTitleColor(.black, for: .normal)
        btnAlert.backgroundColor = .cPopUpBg
        btnAlert.imageEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: (btnAlert.bounds.width - 45))
        btnAlert.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 5)
        btnAlert.titleLabel?.numberOfLines = 2
        btnAlert.titleLabel?.textAlignment = .left
        self.view.addSubview(btnAlert)
        
        let time = duration
        let whenWhen = DispatchTime.now() + DispatchTimeInterval.seconds(time)
        DispatchQueue.main.asyncAfter(deadline: whenWhen){
            btnAlert.removeFromSuperview()
        }
    }
    
    func popUpWithButtons(imgName: String, btnYesText: String, btnNoText: String, txtMessage: String, numOfButtons: Int, completion: @escaping (_ success: Bool) -> ()) {
        
        if imgName == ""{
            print("image name cannot be blank")
            return
        }
        
        var topBarHeight = CGFloat()
        
        if #available(iOS 13, *) {
            topBarHeight = getStatusBarHeight() + (self.navigationController?.navigationBar.frame.height ?? 0.0) + 100
        }else{
            topBarHeight = UIApplication.shared.statusBarFrame.size.height + (self.navigationController?.navigationBar.frame.height ?? 0.0) + 100
        }
        
        let screenRect = UIScreen.main.bounds
        let bgView = UIView.init(frame: CGRect(x: 0.0, y: 0.0, width: screenRect.size.width, height: screenRect.size.height))
        bgView.backgroundColor = .cFullViewBg
        
        let vAlert = UIView.init(frame: CGRect(x: 15, y: topBarHeight, width: screenRect.width - 30, height: 190))
        vAlert.backgroundColor = .cPopUpBg
        
        let imgAlert = UIImageView.init(frame: CGRect(x: (vAlert.frame.width / 2) - 15, y: 30, width: 35, height: 35))
        imgAlert.image = UIImage(named: imgName)
        
        let vButtons = UIView.init(frame: CGRect(x: vAlert.frame.origin.x + 30, y: vAlert.frame.height - 65, width: vAlert.frame.width - 90, height: 40))
        
        var btnNo = UIButton()
        var btnYes = UIButton()
        
        if (numOfButtons == 1){
            btnYes = .init(frame: CGRect(x: 0, y: 0, width: vButtons.frame.width, height: vButtons.frame.height))
        }
        else if (numOfButtons == 2){
            btnNo = .init(frame: CGRect(x: 0, y: 0, width: (vButtons.frame.width / 2) - 10, height: vButtons.frame.height))
            vButtons.addSubview(btnNo)
            
            btnYes = .init(frame:CGRect(x: btnNo.frame.origin.x + btnNo.frame.width + 20, y: 0, width: (vButtons.frame.width / 2) - 10, height: vButtons.frame.height))
        }
        
        btnNo.setTitle(btnNoText.uppercased(), for: .normal)
        btnNo.backgroundColor = .cBtnBg
        btnNo.titleLabel?.font = getFontFamily()
        btnNo.setTitleColor(.cBtnFontColor, for: .normal)
        
        btnNo.addAction(for: .touchUpInside) {
            bgView.removeFromSuperview()
            vAlert.removeFromSuperview()
            completion(false)
        }
        
        btnYes.setTitle(btnYesText.uppercased(), for: .normal)
        btnYes.backgroundColor = .cBtnBg
        btnYes.titleLabel?.font = getFontFamily()
        btnYes.setTitleColor(.cBtnFontColor, for: .normal)
        
        btnYes.addAction(for: .touchUpInside) {
            bgView.removeFromSuperview()
            vAlert.removeFromSuperview()
            completion(true)
        }
        
        let lblAlertText = UILabel.init(frame: CGRect(x: vButtons.frame.origin.x, y: imgAlert.frame.origin.y + imgAlert.frame.height + 10, width: vButtons.frame.width, height: 20))
        lblAlertText.text = txtMessage
        lblAlertText.textColor = .cPopUpText
        lblAlertText.textAlignment = .center
        lblAlertText.font = getFontFamily()
        
        vAlert.addSubview(imgAlert)
        vAlert.addSubview(lblAlertText)
        vButtons.addSubview(btnYes)
        vAlert.addSubview(vButtons)
        view.addSubview(bgView)
        view.addSubview(vAlert)
    }
}
