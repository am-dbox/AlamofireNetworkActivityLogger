//
//  DBoxNetworkLog.swift
//  AlamofireNetworkActivityLogger iOS
//
//  Created by Albanot Makolli on 1/21/22.
//  Copyright © 2022 RKT Studio. All rights reserved.
//

import Foundation

public struct DBoxNetworkLog: TextOutputStream {
    
    let logQueue:DispatchQueue
    
    init() {
        logQueue = DispatchQueue(label: "DBoxNetworkLogger", qos: .background, attributes: [], autoreleaseFrequency: .inherit, target: nil)
    }
    
    public func write(_ string: String) {
        logQueue.sync {
            if let handle = try? FileHandle(forWritingTo: log) {
                handle.seekToEndOfFile()
                handle.write(string.data(using: .utf8)!)
                handle.closeFile()
            } else {
                try? string.data(using: .utf8)?.write(to: log)
            }
        }
    }
    
    public func clearLog() {
        logQueue.sync {
            let fm = FileManager.default
            if fm.isDeletableFile(atPath: log.path) {
                try? fm.removeItem(at: log)
            }
        }
    }
    
    public var log:URL {
        get {
            let fm = FileManager.default
            return fm.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("networklog.txt")
        }
    }
}
