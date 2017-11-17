//
//  ATTimer.swift
//  Pods
//
//  Created by 凯文马 on 2017/11/16.
//

import UIKit

public typealias ATTimerHandler = (ATTimer,Int) -> Void

public class ATTimer : NSObject{

    public init(interval:TimeInterval,repeatTimes:UInt = UInt.max, queue:DispatchQueue = .main ,handler:@escaping ATTimerHandler) {
        self.interval = interval
        internalTimer = DispatchSource.makeTimerSource(flags: [], queue: queue)
        super.init()
        internalTimer.setEventHandler { [weak self] in
            if let ss = self {
                handler(ss,Int(ss.times))
                ss.times = ss.times + 1
                if ss.times >= repeatTimes {
                    ss.internalTimer.cancel()
                }
            }
        }
    }
    
    /*
     * start timer ,call this method only the first time start
     * resume or suspend to control the timer
     */
    public func fire(){
        if !hasFired {
            internalTimer.schedule(deadline: .now() + DispatchTimeInterval.milliseconds(Int(1000 * interval)), repeating: interval)
            internalTimer.resume()
            hasFired = true
            isRunning = true
        }
    }
    
    /*
     * restart the timer,you need fire the timer first
     */
    public func resume() {
        if hasFired && !isRunning {
            internalTimer.resume()
            isRunning = true
        }
    }
    
    /*
     * pause the timer,you need fire the timer first
     */
    public func suspend() {
        if hasFired && isRunning {
            internalTimer.suspend()
            isRunning = false
        }
    }
    
    deinit {
        internalTimer.cancel()
    }
    
    private var internalTimer : DispatchSourceTimer
    
    private var isRunning = false
    
    private let interval : TimeInterval
    
    private var hasFired : Bool = false
    
    private var times : UInt = 0
    
}
