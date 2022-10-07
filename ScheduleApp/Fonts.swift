//
//  Fonts.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 27.09.2022.
//

import UIKit

extension UIFont {
    static let title = roundedSystemFont(ofSize: 21, weight: .semibold)
    static let text = roundedSystemFont(ofSize: 16)
    static let secondaryText = roundedSystemFont(ofSize: 14)

    static func roundedSystemFont(ofSize size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        let systemFont = UIFont.systemFont(ofSize: size, weight: weight)
        let roundedFont: UIFont
        if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
            roundedFont = UIFont(descriptor: descriptor, size: size)
        } else {
            roundedFont = systemFont
        }
        return roundedFont
    }
}
