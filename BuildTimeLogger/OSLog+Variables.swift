//
//  OSLog+Variables.swift
//  BuildTimeLogger
//
//  Created by Roman Solodyankin on 30/01/2019.
//  Copyright © 2019 Marcin Religa. All rights reserved.
//

import Foundation
import os

extension OSLog {
    
    private static var subsystem = "BuildTimeLoggerApp"
    
    static let appCycle = OSLog(subsystem: subsystem, category: "Script Cycle")
    static let wrapError = OSLog(subsystem: subsystem, category: "Unwrapping missing variables")
    static let missingData = OSLog(subsystem: subsystem, category: "Missing data")
    static let serializedError = OSLog(subsystem: subsystem, category: "Error on serializing data")
    static let responseError = OSLog(subsystem: subsystem, category: "Network request error")
}
