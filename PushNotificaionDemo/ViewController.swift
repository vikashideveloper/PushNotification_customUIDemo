//
//  ViewController.swift
//  PushNotificaionDemo
//
//  Created by Vikash Kumar on 04/04/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var lbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        lbl.text = (UIApplication.shared.delegate as! AppDelegate).appStateString
        NotificationCenter.default.addObserver(self, selector: #selector(self.setText), name: NSNotification.Name(rawValue: "notificationReceive"), object: nil)
    }

    func setText() {
        lbl.text = (UIApplication.shared.delegate as! AppDelegate).appStateString
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

