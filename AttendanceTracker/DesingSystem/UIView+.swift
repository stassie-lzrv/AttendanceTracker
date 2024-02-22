//
//  UIKit+.swift
//  AttendanceTracker
//
//  Created by Настя Лазарева on 21.02.2024.
//

import Foundation
import UIKit

extension UIView {

    public func addToEdges(
            subview: UIView,
            top: CGFloat = 0,
            left: CGFloat = 0,
            right: CGFloat = 0,
            bottom: CGFloat = 0
        ) {
            subview.translatesAutoresizingMaskIntoConstraints = false
            addSubview(subview)

            NSLayoutConstraint.activate([
                subview.topAnchor.constraint(equalTo: topAnchor, constant: top),
                subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: left),
                subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: right),
                subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottom)
            ])
        }

        public func add(subviews: [UIView]) {
            subviews.forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                addSubview($0)
            }
        }
}
