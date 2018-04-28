//
//  ViewController.swift
//  Refresh
//
//  Created by SummerHF on 27/04/2018.
//  Copyright © 2018 summer. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    lazy var tableView: UITableView = {
        let view = UITableView(frame: self.view.bounds)
//        view.backgroundColor = UIColor.red
        view.delegate = self
        view.dataSource = self
        view.rowHeight = 64
        return view
    }()

    override func viewDidLoad() {

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.header = ZHRefreshHeader.headerWithRefreshing(block: {
            printf("test")
        })
        tableView.header?.beginRefreshing()
        self.view.addSubview(tableView)
    }

    // MARK: - dataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "testCell") {
             cell.textLabel?.text = "\(indexPath.row)"
             cell.textLabel?.textColor = UIColor.black
             return cell
        } else {
             /// 下移可一个状态栏的高度, iPhoneX上是44
             let cell = UITableViewCell(style: .default, reuseIdentifier: "testCell")
             cell.textLabel?.text = "\(indexPath.row)"
             cell.textLabel?.textColor = UIColor.black
             return cell
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        printf(self.tableView.frame)
    }

//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        printf("scrollView.contentOffset:\(scrollView.contentOffset)")
//    }
}
