//
//  DataParser.swift
//  BuildTimeLogger
//
//  Created by Marcin Religa on 08/03/2017.
//  Copyright © 2017 Marcin Religa. All rights reserved.
//

import Foundation

struct DataParser {

	func buildEntriesFromToday(in buildHistoryData: [BuildHistoryEntry]) -> [BuildHistoryEntry] {
		return buildHistoryData.filter({
			Calendar.current.isDateInToday($0.date)
		})
	}

	func totalBuildTime(for buildHistoryData: [BuildHistoryEntry]) -> Int {
		return buildHistoryData.reduce(0, {
			return $0 + $1.buildTime
		})
	}
    
}
