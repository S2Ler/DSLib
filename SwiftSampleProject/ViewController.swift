//
//  ViewController.swift
//  SwiftSampleProject
//
//  Created by Alexander Belyavskiy on 12/27/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

import UIKit
import DSLibFramework

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    let d = NSDate()


    print("isToday:\(d.isToday())")
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

