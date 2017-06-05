//
//  NotificationViewController.swift
//  NotificationContentEx
//
//  Created by Vikash Kumar on 04/04/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    @IBOutlet var lbl2: UILabel?
    @IBOutlet var lbl3: UILabel?
    
    @IBOutlet var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
        print("NotificationController")
    }
    
    func didReceive(_ notification: UNNotification) {
        let userinfo = notification.request.content.userInfo
        self.label?.text = notification.request.content.body
        self.lbl2?.text = userinfo["detail"] as? String
        self.lbl3?.text = userinfo["address"] as? String
        
        
        if let attachment = notification.request.content.attachments.first {
            if attachment.url.startAccessingSecurityScopedResource() {
                print(attachment.url.path)
                let image = UIImage(contentsOfFile: attachment.url.path)
                image?.imageFlippedForRightToLeftLayoutDirection()
                self.imgView.image = image
                print("notificaiton received")
               attachment.url.stopAccessingSecurityScopedResource()
            }
        }

    
}
    
    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        if response.actionIdentifier == "accept" {
            completion(.dismissAndForwardAction)
            
        } else if response.actionIdentifier == "invitationReply" {
            if let textResponse = response as? UNTextInputNotificationResponse {
                 lbl3?.text = textResponse.userText
            }
        } else {
            completion(.dismiss)
        }
    }
}
