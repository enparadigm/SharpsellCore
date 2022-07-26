//
//  Helper.swift
//  SmartsellCore
//
//  Created by Surya on 30/08/21.
//

import os


private let subsystem = "com.enparadigm.sharpsellcore"

struct Log {
  static let tracking = OSLog(subsystem: subsystem, category: "SmartSell Log")
  static let flutterError = OSLog(subsystem: subsystem, category: "SmartSell Log Flutter Error")
}
