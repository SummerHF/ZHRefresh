//
//  ViewController.swift
//  Refresh
//
//  Created by SummerHF on 27/04/2018.
//  Copyright © 2018 summer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var tableView: UITableView = {
        let view = UITableView(frame: self.view.bounds)
        return view
    }()

    override func viewDidLoad() {

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
