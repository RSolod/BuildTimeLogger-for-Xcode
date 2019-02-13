//
//  BuildHistoryDatabase.swift
//  BuildTimeLogger
//
//  Created by Marcin Religa on 01/03/2017.
//  Copyright © 2017 Marcin Religa. All rights reserved.
//

import Foundation
import os

enum BuildHistoryDatabaseKey: String {
	case buildHistory
}

struct BuildHistoryDatabase {
	func save(history: [BuildHistoryEntry]) {
		let historySerialized = history.map({ $0.serialized })
		UserDefaults.standard.set(historySerialized, forKey: BuildHistoryDatabaseKey.buildHistory.rawValue)
	}

	func read() -> [BuildHistoryEntry]? {
		guard let buildHistorySerialized = UserDefaults.standard.object(forKey: BuildHistoryDatabaseKey.buildHistory.rawValue) as? [[String: Any]] else {
            os_log("Can't serialized data from BuildHistoryDatabase", log: .serializedError, type: .error)
			return nil
		}

		let buildHistory: [BuildHistoryEntry] = buildHistorySerialized.compactMap({
			if let buildTime = $0[BuildHistoryEntryKey.buildTime.rawValue] as? Int,
				let schemeName = $0[BuildHistoryEntryKey.schemeName.rawValue] as? String,
				let timestamp = $0[BuildHistoryEntryKey.timestamp.rawValue] as? TimeInterval,
                let buildType = $0[BuildHistoryEntryKey.type.rawValue] as? String {

				// TODO: Old entries in user defaults don't have username, so this stays as not required here.
				let username = $0[BuildHistoryEntryKey.username.rawValue] as? String ?? "unknown"
                return BuildHistoryEntry(buildTime: buildTime, schemeName: schemeName, date: Date(timeIntervalSince1970: timestamp), username: username, type: BuildHistoryEntryType(rawValue: buildType)!)
			}
            os_log("Can't get build history from BuildHistoryDatabase", log: .wrapError, type: .error)
			return nil
		})

		return buildHistory
	}
}
