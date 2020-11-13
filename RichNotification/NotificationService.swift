//
//  NotificationService.swift
//  RichNotification
//
//  Created by Kuldip Mac on 13/09/20.
//  Copyright © 2020 Nyusoft. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
  var content        : UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest,
                             withContentHandler contentHandler:
        @escaping (UNNotificationContent) -> Void) {
        print("DataResponseUtor")
        
        self.contentHandler = contentHandler
        self.content        = (request.content.mutableCopy()
            as? UNMutableNotificationContent)
        print(" self.content:-",self.content)
        if let bca = self.content {
            
            func save(_ identifier: String,
                      data: Data, options: [AnyHashable: Any]?)
                -> UNNotificationAttachment? {
                    
                    let directory = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(ProcessInfo.processInfo.globallyUniqueString,
                                                                                                        isDirectory: true)
                    
                    do {
                        try FileManager.default.createDirectory(at: directory,
                                                                withIntermediateDirectories: true,
                                                                attributes: nil)
                        let fileURL = directory.appendingPathComponent(identifier)
                        try data.write(to: fileURL, options: [])
                        return try UNNotificationAttachment.init(identifier: identifier,
                                                                 url: fileURL,
                                                                 options: options)
                        
                    } catch {
                    }
                    
                    return nil
            }
            
            func exitGracefully(_ reason: String = "") {
                let bca    = request.content.mutableCopy()
                    as? UNMutableNotificationContent
                bca!.title = reason
                
                contentHandler(bca!)
            }
            
            DispatchQueue.main.async {
                guard let content = (request.content.mutableCopy()
                    as? UNMutableNotificationContent) else {
                        return exitGracefully()
                }
                let userInfo : [AnyHashable: Any] = request.content.userInfo
                
             
                
                guard let attachmentURL = userInfo["image"]
                    as? String else {
                        return exitGracefully()
                }
                guard let imageData  =
                    try? Data(contentsOf: URL(string: attachmentURL)!)
                    else {
                        return exitGracefully()
                }
                guard let attachment =
                    save("image.png", data: imageData, options: nil)
                    else {
                        return exitGracefully()
                }
                content.attachments = [attachment]
                contentHandler(content.copy() as! UNNotificationContent)
                
            }
            
        }}
    
    /*override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            print("NotificationResponse:-",bestAttemptContent)
            bestAttemptContent.title = "\(bestAttemptContent.title)"
            
            contentHandler(bestAttemptContent)
        }
    }
    */
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
