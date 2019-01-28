//
//  BuildTimeLoggerApp.swift
//  BuildTimeLogger
//
//  Created by Marcin Religa on 01/03/2017.
//  Copyright © 2017 Marcin Religa. All rights reserved.
//

import Foundation

final class BuildTimeLoggerApp {
	private let buildHistoryDatabase: BuildHistoryDatabase
	private let notificationManager: NotificationManager
	private let dataParser: DataParser
	private let xcodeDatabaseManager: XcodeDatabaseManager
	private let systemInfoManager: SystemInfoManager
    private let urlString = "https://docs.google.com/forms/d/e/1FAIpQLSdfGtMRF7MToMBfhp6pufLZ1cohRDb40J5RL3EwdcRJR5wuKw/formResponse"

	private var buildHistory: [BuildHistoryEntry]?

	init(buildHistoryDatabase: BuildHistoryDatabase = BuildHistoryDatabase(),
	     notificationManager: NotificationManager = NotificationManager(),
	     dataParser: DataParser = DataParser(),
	     xcodeDatabaseManager: XcodeDatabaseManager = XcodeDatabaseManager(),
	     systemInfoManager: SystemInfoManager = SystemInfoManager()) {
		self.buildHistoryDatabase = buildHistoryDatabase
		self.notificationManager = notificationManager
		self.dataParser = dataParser
		self.xcodeDatabaseManager = xcodeDatabaseManager
		self.systemInfoManager = systemInfoManager
	}

	func run() {
        updateBuildHistory()
            showNotification()
        guard let buildHistory = buildHistory, let latestBuildData = buildHistory.last else { return }
        if let remoteStorageURL = URL(string: urlString) {
            storeDataRemotely(buildData: latestBuildData, atURL: remoteStorageURL)
        }
	}

	private func storeDataRemotely(buildData: BuildHistoryEntry, atURL url: URL) {
		let systemInfo = systemInfoManager.read()
		let networkManager = NetworkManager(remoteStorageURL: url)
		networkManager.sendData(username: buildData.username, timestamp: Int(NSDate().timeIntervalSince1970), buildTime: buildData.buildTime, schemeName: buildData.schemeName, systemInfo: systemInfo)
	}

	private func showNotification() {
		guard let buildHistory = buildHistory, let latestBuildData = buildHistory.last else {
			return
		}

		let buildEntriesFromToday = dataParser.buildEntriesFromToday(in: buildHistory)
		let totalTime = dataParser.totalBuildTime(for: buildEntriesFromToday)

		let latestBuildTimeFormatted = TimeFormatter.format(time: latestBuildData.buildTime)
		let totalBuildsTimeTodayFormatted = TimeFormatter.format(time: totalTime)

		let numberOfBuildsToday = buildEntriesFromToday.count
		let averageBuildtimeToday = TimeFormatter.format(time: totalTime / numberOfBuildsToday)

		notificationManager.showNotification(message: "current          \(latestBuildTimeFormatted)\ntotal today    \(totalBuildsTimeTodayFormatted) / avg \(averageBuildtimeToday) / \(numberOfBuildsToday) builds")
	}

	private func updateBuildHistory() {
		guard let latestBuildData = xcodeDatabaseManager.latestBuildData else {
			return
		}

		let updatedBuildHistoryData: [BuildHistoryEntry]

		if var buildHistoryData = buildHistoryDatabase.read() {
			buildHistoryData.append(latestBuildData.buildHistoryEntry)
			updatedBuildHistoryData = buildHistoryData
		} else {
			updatedBuildHistoryData = [latestBuildData.buildHistoryEntry]
		}

		buildHistoryDatabase.save(history: updatedBuildHistoryData)
		buildHistory = updatedBuildHistoryData
	}
}
