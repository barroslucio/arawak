//
//  PCBLoginViewController.swift
//  publiCarro
//
//  Created by Lúcio Barros on 03/11/15.
//  Copyright © 2015 tambatech. All rights reserved.
//

import UIKit

class PBCLoginViewController: UIViewController {

    @IBOutlet var bottonConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let dismiss: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(dismiss)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: self.view.window)
        
        
        navigationController?.navigationBar.hidden = false

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
    }
    
    func DismissKeyboard(){
        view.endEditing(true)
    }
    //
    //    func keyboardWillShow(sender: NSNotification){
    //
    //        let userInfo: [NSObject:AnyObject] = sender.userInfo!
    //
    //        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
    //
    //        let offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
    //
    //        if keyboardSize.height == offset.height{
    //            UIView.animateWithDuration(0.1, animations: { () -> Void in
    //                self.textfield.frame.origin.y += keyboardSize.height
    //            })
    //            print("if")
    //        }
    //        else{
    //            UIView.animateWithDuration(0.1, animations: { () -> Void in
    //                self.textfield.frame.origin.y += keyboardSize.height - offset.height
    //            })
    //            print("else")
    //
    //        }
    //    }
    //
    //    func keyboardWillHide(sender:NSNotification){
    //        let userInfo: [NSObject: AnyObject] = sender.userInfo!
    //        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
    //        self.textfield.frame.origin.y += keyboardSize.height
    //        print("hide")
    //    }
    
    func keyboardWillShow(notification:NSNotification) {
        adjustingHeight(true, notification: notification)
    }
    
    func keyboardWillHide(notification:NSNotification) {
        adjustingHeight(false, notification: notification)
    }
    
    func adjustingHeight(show:Bool, notification:NSNotification) {
        // 1
        var userInfo = notification.userInfo!
        // 2
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        // 3
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
        // 4
        let changeInHeight = (CGRectGetHeight(keyboardFrame)) * (show ? 1 : -1)
        //5
        if (show && self.bottonConstraint.constant == 0){
            UIView.animateWithDuration(animationDurarion, animations: { () -> Void in
                self.bottonConstraint.constant += changeInHeight
            })
        }
        else if (!show){
            UIView.animateWithDuration(animationDurarion, animations: { () -> Void in
                self.bottonConstraint.constant += changeInHeight
            })
        }
        
    }

}
