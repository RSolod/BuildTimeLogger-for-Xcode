//
//  NetworkManager.swift
//  BuildTimeLogger
//
//  Created by Marcin Religa on 07/03/2017.
//  Copyright © 2017 Marcin Religa. All rights reserved.
//

import Foundation
import os

enum NetworkError: Error {
	case didFailToFetchData
}

final class NetworkManager {
	private let remoteStorageURL: URL

	init(remoteStorageURL: URL) {
		self.remoteStorageURL = remoteStorageURL
	}

	// TODO: use single BuildHistoryEntry object as an argument.
    func sendData(username: String, timestamp: Int, buildTime: Int, schemeName: String, buildType: String) {
		let semaphore = DispatchSemaphore(value: 0)

		let data: [String: Any] = [
			BuildHistoryEntryKey.username.rawValue: username,
			BuildHistoryEntryKey.timestamp.rawValue: timestamp,
			BuildHistoryEntryKey.buildTime.rawValue: buildTime,
			BuildHistoryEntryKey.schemeName.rawValue: schemeName,
            BuildHistoryEntryKey.type.rawValue: buildType
		]
        var urlComponents = URLComponents(string: remoteStorageURL.absoluteString)!
        urlComponents.queryItems = [
            URLQueryItem(name: BuildHistoryEntryKey.username.rawValue, value: username),
            URLQueryItem(name: BuildHistoryEntryKey.buildTime.rawValue, value: "\(buildTime)"),
            URLQueryItem(name: BuildHistoryEntryKey.schemeName.rawValue, value: schemeName),
            URLQueryItem(name: BuildHistoryEntryKey.type.rawValue, value: buildType)]
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [])
        let jsonString = String(data: jsonData!, encoding: String.Encoding.utf8)!
        request.httpBody = jsonString.data(using: .utf8)
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			if let error = error {
                os_log("HTTP error: %@", log: .responseError, type: .error, error.localizedDescription)
			}

			semaphore.signal()
		}
		task.resume()
		semaphore.wait();
	}

	func fetchData(completion: @escaping (Result<Data, NetworkError>) -> Void) {
		let semaphore = DispatchSemaphore(value: 0)

		var request = URLRequest(url: remoteStorageURL)
		request.httpMethod = "GET"
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			guard let data = data, error == nil else {
				completion(.failure(NetworkError.didFailToFetchData))
                os_log("HTTP error: %@", log: .responseError, type: .error, error!.localizedDescription)
				return
			}

			completion(.success(data))
			semaphore.signal()
		}
		task.resume()
		semaphore.wait();
	}

	private func formatPOSTString(data: [String: Any]) -> String {
		var resultArr: [String] = []

		for (key, value) in data {
			resultArr.append("\"\(key)\": \"\(value)\"")
		}

		return "{ " + resultArr.joined(separator: ", ") + " }"
	}
}
