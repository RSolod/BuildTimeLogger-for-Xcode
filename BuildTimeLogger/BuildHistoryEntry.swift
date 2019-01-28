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
    case type = "entry.334614319"
}

enum BuildHistoryEntryType: String {
    case clean
    case build
    case archive
    case undefined
}

struct BuildHistoryEntry {
	let buildTime: Int
	let schemeName: String
	let date: Date
	let username: String
    let type: BuildHistoryEntryType

	var serialized: [String: Any] {
		return [
			BuildHistoryEntryKey.buildTime.rawValue: buildTime,
			BuildHistoryEntryKey.schemeName.rawValue: schemeName,
			BuildHistoryEntryKey.timestamp.rawValue: date.timeIntervalSince1970,
			BuildHistoryEntryKey.username.rawValue: username,
            BuildHistoryEntryKey.type.rawValue: type.rawValue
		]
	}
}
