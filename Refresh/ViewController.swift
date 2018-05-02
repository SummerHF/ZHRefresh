//
//  ViewController.swift
//  Refresh
//
//  Created by SummerHF on 27/04/2018.
//  Copyright © 2018 summer. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    lazy var textLable: UILabel = {
        let lable = UILabel()
        lable.backgroundColor = UIColor.black
        lable.text = "海飞"
        lable.textColor = UIColor.white
        lable.textAlignment = .center
        return lable
    }()

    lazy var tableView: UITableView = {
        let view = UITableView(frame: self.view.bounds)
        view.backgroundColor = UIColor.red
        view.delegate = self
        view.dataSource = self
        view.rowHeight = 64
        return view
    }()

    override func viewDidLoad() {

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.header = ZHRefreshChiBaoZiHeader.headerWithRefreshing {
            printf("Test")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.tableView.header?.endRefreshing()
            })
        }
        self.view.addSubview(tableView)

    }

    // MARK: - dataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "testCell") {
             cell.textLabel?.text = "\(indexPath.row)"
             cell.textLabel?.textColor = UIColor.black
             return cell
        } else {
             /// 下移一个状态栏的高度, iPhoneX上是44
             let cell = UITableViewCell(style: .default, reuseIdentifier: "testCell")
             cell.textLabel?.text = "\(indexPath.row)"
             cell.textLabel?.textColor = UIColor.black
             return cell
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        printf(scrollView.zh_inset)
        printf(scrollView.zh_offsetY)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        printf(self.tableView.frame)
//        printf(self.tableView.header!.frame)
//        printf(self.tableView.header?.scrollView.contentOffset)
//        printf(self.tableView.header?.scrollView.contentInset)
    }
}
