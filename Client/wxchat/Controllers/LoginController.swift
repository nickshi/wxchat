//
//  LoginController.swift
//  wxchat
//
//  Created by nick.shi on 4/7/16.
//  Copyright © 2016 nick. All rights reserved.
//

import UIKit


class LoginController: UIViewController {
    
    @IBOutlet weak var btnLogin: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SendMgr.mgr.connect()
        
    }
    
    
    @IBAction func btnLoginPressed(sender:UIButton) {
        SendMgr.mgr.login("nick", password: "12345") { (response) in
            if response.hasError {
                let alert = UIAlertView(title: "Error", message: response.errorMessage, delegate: nil, cancelButtonTitle: "Cancel");
                alert.show()
            }
            else
            {
                let storyboard = self.storyboard
                let controller = storyboard?.instantiateViewControllerWithIdentifier("Main")
                self.presentViewController(controller!, animated: false) {
                    
                }
            }
        }
       
    }
    

}
