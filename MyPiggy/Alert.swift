//
//  Alert.swift
//  MyPiggy
//
//  Created by Noel Rosario on 11/29/22.
//

import Foundation
import UIKit

func showAlert(withTitle title: String, Message message: String, controller: UIViewController)
{
    let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    ac.addAction(UIAlertAction(title: "Ok", style: .default))
    
    
    controller.present(ac, animated: true)
}



