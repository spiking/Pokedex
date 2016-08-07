//
//  InfoVC.swift
//  pokedex-by-devslopes
//
//  Created by Adam Thuvesen on 2016-08-07.
//  Copyright © 2016 devslopes. All rights reserved.
//

import UIKit

class InfoVC: UIViewController {

    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Info"
    }

    override func viewDidLayoutSubviews() {
        textView.setContentOffset(CGPointZero, animated: false)
    }

}
