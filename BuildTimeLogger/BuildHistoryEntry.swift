//
//  BuildHistoryEntry.swift
//  BuildTimeLogger
//
//  Created by Marcin Religa on 01/03/2017.
//  Copyright © 2017 Marcin Religa. All rights reserved.
//

import Foundation

enum BuildHistoryEntryKey: String {
	case buildTime = "entry.828447071"
	case schemeName = "entry.1409414588"
	case timestamp
	case username = "entry.40726498"
}

struct BuildHistoryEntry {
	let buildTime: Int
	let schemeName: String
	let date: Date
	let username: String

	var serialized: [String: Any] {
		return [
			BuildHistoryEntryKey.buildTime.rawValue: buildTime,
			BuildHistoryEntryKey.schemeName.rawValue: schemeName,
			BuildHistoryEntryKey.timestamp.rawValue: date.timeIntervalSince1970,
			BuildHistoryEntryKey.username.rawValue: username
		]
	}
}
