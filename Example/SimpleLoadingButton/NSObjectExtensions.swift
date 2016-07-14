//
//  NSObjectExtensions.swift
//  SimpleLoadingButton
//
//  Created by Ruvim Micsanschi on 7/13/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

extension NSObject {
   class func doSomeAsyncWork(secondsToWait seconds:NSTimeInterval, completion:()->Void) -> Void {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { completion() }
    }
}