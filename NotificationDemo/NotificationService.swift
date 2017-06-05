//
//  NotificationService.swift
//  NotificationDemo
//
//  Created by Vikash Kumar on 04/04/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            bestAttemptContent.subtitle = bestAttemptContent.userInfo["subtitle"] as! String
            bestAttemptContent.body = bestAttemptContent.userInfo["body"] as! String
            
            if let attachmentURl = bestAttemptContent.userInfo["webhook_url"] as? String {
                    let fileUrl = URL(string: attachmentURl)!
                    URLSession.shared.downloadTask(with: fileUrl) { (location, response, error) in
                        if let location = location {
                            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                            if var documentURLPath = urls.first {
                                documentURLPath.appendPathComponent(fileUrl.lastPathComponent)
                                if FileManager.default.fileExists(atPath: documentURLPath.path) {
                                   try! FileManager.default.removeItem(at: documentURLPath)
                                }
                                try! FileManager.default.moveItem(at: location, to: documentURLPath)
                                // Add the attachment to the notification content
                                if let attachment = try? UNNotificationAttachment(identifier: "abc", url: documentURLPath) {
                                    self.bestAttemptContent?.attachments = [attachment]
                                }

                            }
                            
                        }
                        
                        // Serve the notification content
                        self.contentHandler!(self.bestAttemptContent!)
                        }.resume()

            }

            
        }
        
        
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
