//
//  AlertHelper.swift
//  bubbletime
//
//  Created by Jonathan Moallem on 3/5/18.
//  Copyright © 2018 Sudo-Code Software. All rights reserved.
//

import UIKit

class AlertHelper {
    
    // Fields
    weak var delegate: AlertDelegate?
    let alertController: UIAlertController
    
    init(withText title: String, and message: String) {
        alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    }
    
    func addTextField(for description: String) {
        alertController.addTextField { (textField : UITextField) -> Void in
            textField.placeholder = description
        }
    }
    
    func displayAlert(for controller: UIViewController) {
        // Add the actions to the controller
        for action in standardActions() {
            alertController.addAction(action)
        }
        
        // Present the controller
        controller.present(alertController, animated: true, completion: nil)
    }
    
    func standardActions() -> [UIAlertAction] {
        var actions: [UIAlertAction] = [UIAlertAction]()
        
        // Define standard actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            self.delegate?.onSubmit(text: self.alertController.textFields?.first?.text)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
            self.delegate?.onCancelAction()
        }
        
        // Add the actions
        actions.append(okAction)
        actions.append(cancelAction)
        
        return actions
    }
}

protocol AlertDelegate: AnyObject {
    func onCancelAction()
    func onSubmit(text: String?)
}
