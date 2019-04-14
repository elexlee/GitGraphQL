//
//  UIViewExtension.swift
//  GitGraphQL
//
//  Created by Elex Lee on 4/11/19.
//  Copyright © 2019 Elex Lee. All rights reserved.
//

import UIKit

extension UIView {
    func bounce(completion: ((Bool) -> Void)? = nil) {
        self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.1, options: .beginFromCurrentState, animations: {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: completion)
    }
}
