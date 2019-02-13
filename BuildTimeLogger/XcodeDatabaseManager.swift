//
//  XcodeDatabaseManager.swift
//  BuildTimeLogger
//
//  Created by Marcin Religa on 08/03/2017.
//  Copyright © 2017 Marcin Religa. All rights reserved.
//

import Foundation
import os

struct XcodeDatabaseManager {
	var latestBuildData: XcodeDatabase? {
		let dataSource = DerivedDataManager.derivedData().compactMap{
			XcodeDatabase(fromPath: $0.url.appendingPathComponent("Logs/Build/LogStoreManifest.plist").path)
		}.sorted(by: { $0.modificationDate > $1.modificationDate })

		guard let latestBuildDatabase = dataSource.first else {
            os_log("No build history or latest build data found in XcodeDatabaseManager", log: .wrapError, type: .fault)
			return nil
		}

		return latestBuildDatabase
	}
}
