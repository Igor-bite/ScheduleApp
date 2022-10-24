//
//  Colors.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 27.09.2022.
//

import UIKit

extension UIColor {
    enum Pallette {
        static let pink = UIColor(red: 247 / 255, green: 37 / 255, blue: 133 / 255, alpha: 1)
        static let purple = UIColor(red: 114 / 255, green: 9 / 255, blue: 183 / 255, alpha: 1)
        static let blue = UIColor(red: 67 / 255, green: 97 / 255, blue: 238 / 255, alpha: 1)
        static let lightBlue = UIColor(red: 54 / 255, green: 134 / 255, blue: 247 / 255, alpha: 1)
        static let skyBlue = UIColor(red: 76 / 255, green: 201 / 255, blue: 240 / 255, alpha: 1)
        static let toxicBlue = UIColor(red: 109 / 255, green: 236 / 255, blue: 251 / 255, alpha: 1)
        static let gray = UIColor(light: UIColor(red: 233 / 255, green: 236 / 255, blue: 239 / 255, alpha: 1),
                                  dark: UIColor(red: 33 / 255, green: 37 / 255, blue: 41 / 255, alpha: 1))
        static let green = UIColor(red: 60 / 255, green: 207 / 255, blue: 78 / 255, alpha: 1)

        static let textColor = UIColor(light: .black, dark: .white)
        static let secondaryTextColor = UIColor(light: UIColor(red: 108 / 255, green: 117 / 255, blue: 125 / 255, alpha: 1),
                                                dark: UIColor(red: 173 / 255, green: 181 / 255, blue: 189 / 255, alpha: 1))
        static let cellBgColor = Pallette.gray
        static let mainBgColor = UIColor(light: .white, dark: .black)
        static let buttonBg = UIColor(light: .Pallette.lightBlue, dark: .Pallette.blue)
    }

    /// Creates a color object that generates its color data dynamically using the specified colors. For early SDKs creates light color.
    /// - Parameters:
    ///   - light: The color for light mode.
    ///   - dark: The color for dark mode.
    convenience init(light: UIColor, dark: UIColor) {
        self.init { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return dark
            }
            return light
        }
    }

    var lightThemeColor: UIColor {
        resolvedColor(with: .init(userInterfaceStyle: .light))
    }

    var darkThemeColor: UIColor {
        resolvedColor(with: .init(userInterfaceStyle: .dark))
    }

    var themeInverted: UIColor {
        .init(light: darkThemeColor, dark: lightThemeColor)
    }
}
