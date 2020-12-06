//
//  FloatingButton.swift
//  iDo
//
//  Created by Abdihakin Elmi on 11/29/20.
//

import UIKit

extension UIButton {
    func floatingActionButton()  {
        layer.cornerRadius = layer.frame.height/2
        layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        layer.shadowOpacity = 0.25
    }
}

