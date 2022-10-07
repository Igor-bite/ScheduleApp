//
//  Labels.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 27.09.2022.
//

import UIKit

extension UILabel {
    static var titleLabel: UILabel {
        let label = UILabel()
        label.font = .title
        label.textColor = .Pallette.textColor
        return label
    }

    static var textLabel: UILabel {
        let label = UILabel()
        label.font = .text
        label.textColor = .Pallette.textColor
        return label
    }

    static var secondaryTextLabel: UILabel {
        let label = UILabel()
        label.font = .secondaryText
        label.textColor = .Pallette.secondaryTextColor
        return label
    }
}
