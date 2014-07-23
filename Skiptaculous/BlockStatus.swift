//
//  BlockStatus.swift
//  Skiptaculous
//
//  Created by German Pereyra on 7/23/14.
//  Copyright (c) 2014 P0nj4. All rights reserved.
//

import Foundation

class BlockStatus{
    var isRunning = false
    var timeGap = UInt32(0)
    var currentInterval = UInt32(0)
    
    init(isRunning:Bool, timeGapForNextRun:UInt32, currentInterval:UInt32){
        self.timeGap = timeGapForNextRun
        self.isRunning = isRunning
        self.currentInterval = currentInterval
    }
    
    func isReadyToRun () -> Bool{
        
        return currentInterval >= timeGap 
    }
}