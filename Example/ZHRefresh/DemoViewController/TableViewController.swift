//  TableViewController.swift
//  Refresh
//
//  Created by macbookair on 2018/5/10.
//
//
//  Copyright (c) 2018 macbookair(https://github.com/summerhf)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import ZHRefresh

class TableViewController: UITableViewController {

    /// 假数据
    lazy var fakeData: [String] = {
        let data = [String]()
        for _ in 0...5 {
            let string = "随机数据:---->\(arc4random_uniform(100000))"
        }
        return data
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .singleLineEtched
        print(self.method)
        self.perform(Selector(self.method))
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fakeData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: Example.reuseIdentifier)
        if cell == nil {
           cell = UITableViewCell(style: .default, reuseIdentifier: Example.reuseIdentifier)
        }
        cell?.textLabel?.text = fakeData[indexPath.row]
        return cell!
    }
}

// MARK: - 刷新的样式

extension TableViewController {

    // MARK: - 默认样式

    @objc func action01() {
        self.tableView.zh_reloadDataBlock
    }
    @objc func action02() {
        print("action02")
    }

    @objc func action03() {
        print("action03")
    }

    @objc func action04() {
        print("action04")
    }
}
