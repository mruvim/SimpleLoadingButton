//
//  ExampleController.swift
//  SimpleLoadingButton
//
//  Created by Ruva on 07/01/2016.
//  Copyright (c) 2016 Ruva. All rights reserved.
//

import UIKit
import SimpleLoadingButton

class ExampleController: UIViewController {
    
    @IBOutlet weak var loadingButton: SimpleLoadingButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Font must be set programmatically, because it's not inspectable in IB */
        loadingButton.titleFont = UIFont.systemFont(ofSize: 14, weight: .bold)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBAction func buttonTapped(_ sender: SimpleLoadingButton) {
        NSObject.doSomeAsyncWork(secondsToWait: 4) {
            sender.stop()
        }
    }
}
