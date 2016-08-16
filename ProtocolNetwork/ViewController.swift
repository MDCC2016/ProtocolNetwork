//
//  ViewController.swift
//  ProtocolNetwork
//
//  Created by WANG WEI on 2016/08/16.
//  Copyright © 2016年 OneV's Den. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        nameLabel.text = ""
        messageLabel.text = ""
        
        RequestSender().send(UserRequest(name: "onevcat")) { user in
            self.nameLabel.text = user?.name ?? ""
            self.messageLabel.text = user?.message ?? ""
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

