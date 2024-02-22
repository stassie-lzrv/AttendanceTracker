//
//  Coordinator.swift
//  AttendanceTracker
//
//  Created by Настя Лазарева on 21.02.2024.
//

import Foundation
import UIKit

protocol Coordinator {
    func build() async -> UINavigationController?
}
