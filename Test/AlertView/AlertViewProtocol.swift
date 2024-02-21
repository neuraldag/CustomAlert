//
//  AlertViewProtocol.swift
//  Test
//
//  Created by Gamid Gapizov on 21.02.2024.
//

import Foundation
import UIKit

@objc protocol AlertViewDelegate: AnyObject {
    @objc optional func alertView(alertView: AlertView, clickedButtonAtIndex buttonIndex: Int)
}
