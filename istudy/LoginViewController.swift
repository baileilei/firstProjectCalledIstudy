//
//  LoginViewController.swift
//  istudy
//
//  Created by hznucai on 16/3/3.
//  Copyright © 2016年 hznucai. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON
class LoginViewController: UIViewController {
   
    @IBOutlet weak var textFieldToBtn: NSLayoutConstraint!
    @IBOutlet weak var topLayout: NSLayoutConstraint!
    @IBOutlet weak var userName:UITextField?
    @IBOutlet weak var passWord:UITextField?
    @IBOutlet weak var forgetPasswordBtn:UIButton?
    var dic = [String:AnyObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
       
   //键盘出现时的挡住问题
        XKeyBoard.registerKeyBoardHide(self)
        XKeyBoard.registerKeyBoardShow(self)
        //设置button的下划线
        //设置前景色
        self.navigationController?.navigationBar.barTintColor = RGB(0, g: 153, b: 255)
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()

        let str1 = NSMutableAttributedString(string: (self.forgetPasswordBtn?.titleLabel?.text)!)
        let range1 = NSRange(location: 0, length: str1.length)
        let number = NSNumber(integer: NSUnderlineStyle.StyleSingle.rawValue)
        str1.addAttribute(NSUnderlineStyleAttributeName, value: number, range: range1)
       str1.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor(), range: range1)
        self.forgetPasswordBtn?.setAttributedTitle(str1, forState: .Normal)
        self.forgetPasswordBtn?.addTarget(self, action: #selector(LoginViewController.forgetPassWord(_:)), forControlEvents: .TouchUpInside)
        // Do any additional setup after loading the view.
    }
   override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func keyBoardHide(sender: UIControl) {
        self.userName?.resignFirstResponder()
        self.passWord?.resignFirstResponder()
    }
    @IBAction func login(sender:UIButton){
        self.userName?.resignFirstResponder()
        self.passWord?.resignFirstResponder()
        ProgressHUD.show("请稍候")
         self.dic = ["username":(self.userName?.text)!,
        "password":(self.passWord?.text)!,
        "devicetoken":"",
        "os":"",
        "clienttype":"1"]
Alamofire.request(.GET, "http://dodo.hznu.edu.cn/api/login", parameters: self.dic, encoding: ParameterEncoding.URL, headers: nil).responseJSON { (response ) -> Void in
            switch response.result{
            case .Success(let data):
                let json = JSON(data)
                if(json["retcode"].int != 0){
                    ProgressHUD.showError("登录失败")
                }else{
let userDefaults = NSUserDefaults.standardUserDefaults()
userDefaults.setValue(self.userName?.text, forKey: "userName")
userDefaults.setValue(self.passWord?.text, forKey: "passWord")
userDefaults.setValue(json["authtoken"].string, forKey: "authtoken")
userDefaults.setValue(json["info"]["name"].string, forKey: "name")
userDefaults.setValue(json["info"]["gender"].string, forKey: "sex")
userDefaults.setValue(json["info"]["cls"].string, forKey: "cls")
userDefaults.setValue(json["info"]["phone"].string, forKey: "phone")
userDefaults.setValue(json["info"]["email"].string, forKey: "email")
ProgressHUD.showSuccess("登录成功")
let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("tabBarVC") as! UITabBarController
self.presentViewController(mainVC, animated: true, completion: nil)
                }
            case .Failure( _):
            ProgressHUD.showError("登录失败")
            }
        }
        }
    //忘记密码的操作
     func forgetPassWord(sender:UIButton){
        let writeEmailVC = UIStoryboard(name: "LoginAndReset", bundle: nil).instantiateViewControllerWithIdentifier("writeEmialOrMobilePhoneVC") as! writeEmialOrMobilePhoneViewController
        writeEmailVC.title = "密码找回"
        self.navigationController?.pushViewController(writeEmailVC, animated: true)
    }
    func keyboardWillHideNotification(notifacition:NSNotification) {
        UIView.animateWithDuration(0.3) { () -> Void in
            self.topLayout.constant = 10
           self.textFieldToBtn.constant = 38
            //加载新的约束
            self.view.layoutIfNeeded()
        }
    }
    func keyboardWillShowNotification(notifacition:NSNotification) {
        //做一个动画
        UIView.animateWithDuration(0.3) { () -> Void in
            self.topLayout.constant = -100
            self.textFieldToBtn.constant = 15
            //加载新的约束
            self.view.layoutIfNeeded()
        }
    }
}
