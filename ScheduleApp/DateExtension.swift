//
//  DateExtension.swift
//  ScheduleApp
//
//  Created by Игорь Клюжев on 20.09.2022.
//

import Foundation

extension Date {
	func isBetweeen(date date1: Date, andDate date2: Date) -> Bool {
		date1.compare(self) == self.compare(date2)
	}
	
	func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
		return calendar.component(component, from: self)
	}
}
