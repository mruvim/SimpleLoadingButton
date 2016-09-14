//
//  NSObjectExtensions.swift
//  SimpleLoadingButton
//
//  Created by Ruvim Micsanschi on 7/13/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

extension NSObject {
   class func doSomeAsyncWork(secondsToWait seconds:TimeInterval, completion:@escaping ()->Void) -> Void {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { completion() }
    }
}
