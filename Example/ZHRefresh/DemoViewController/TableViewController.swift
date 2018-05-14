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

    // MARK: - 下拉刷新 默认样式

    @objc func action01() {
        /// 设置回调, 一旦进入刷新状态 就会调用block
        self.tableView.header = ZHRefreshNormalHeader.headerWithRefreshing { [weak self] in
            guard let `self` = self else { return }
            self.loadNewData()
        }
        /// 进入刷新状态
        self.tableView.header?.beginRefreshing()
    }

    // MARK: - 下拉刷新 动态图片

    @objc func action02() {
        /// 一旦进入刷新状态 就会调用target的action, 也就是调用self的loadNewData
        self.tableView.header = ZHRefreshChiBaoZiHeader.headerWithRefresing(target: self, action: #selector(loadNewData))
        self.tableView.header?.beginRefreshing()
    }

    // MARK: - 下拉刷新 隐藏时间

    @objc func action03() {
        /// change header type
        if let header  = ZHRefreshNormalHeader.headerWithRefresing(target: self, action: #selector(loadNewData)) as? ZHRefreshNormalHeader {
            /// 自动切换透明度
            header.automaticallyChangeAlpha = true
            /// 隐藏时间
            header.lastUpdatedTimeLable.isHidden = true
            self.tableView.header = header
            self.tableView.header?.beginRefreshing()
        }
    }

    // MARK: - 下拉刷新 隐藏状态和时间

    @objc func action04() {
        if let header  = ZHRefreshChiBaoZiHeader.headerWithRefresing(target: self, action: #selector(loadNewData)) as? ZHRefreshChiBaoZiHeader {
            /// 隐藏时间
            header.lastUpdatedTimeLable.isHidden = true
            /// 隐藏状态
            header.stateLable.isHidden = true
            self.tableView.header = header
            self.tableView.header?.beginRefreshing()
        }
    }

    // MARK: - 下拉刷新 隐藏状态和时间

    @objc func action05() {
        if let header  = ZHRefreshNormalHeader.headerWithRefresing(target: self, action: #selector(loadNewData)) as? ZHRefreshNormalHeader {
            /// 设置文字
            header.set(title: "下拉刷新...", for: .idle)
            header.set(title: "释放刷新...", for: .pulling)
            header.set(title: "加载中...", for: .refreshing)
            /// 设置字体
            header.stateLable.font = UIFont.systemFont(ofSize: 15)
            header.lastUpdatedTimeLable.font = UIFont.systemFont(ofSize: 14)
            /// 设置颜色
            header.stateLable.textColor = UIColor.red
            header.lastUpdatedTimeLable.textColor = UIColor.blue
            /// 赋值
            self.tableView.header = header
            /// 开始刷新
            self.tableView.header?.beginRefreshing()
        }
    }

    // MARK: - 自定义刷新控件

    @objc func action06() {
        if let header  = ZHDIYHeader.headerWithRefresing(target: self, action: #selector(loadNewData)) as? ZHDIYHeader {
            /// 赋值
            self.tableView.header = header
            /// 开始刷新
            self.tableView.header?.beginRefreshing()
        }
    }

    // MARK: - 上拉加载 默认

    @objc func action07() {
        action01()
        self.tableView.footer = ZHRefreshAutoNormalFooter.footerWithRefreshing { [weak self] in
            guard let `self` = self else { return }
            self.loadMoreData()
        }
    }

    // MARK: - 上拉加载 动画图片

    @objc func action08() {
        action01()
        self.tableView.footer = ZHRefreshChiBaoZiAutoFooter.footerWithRefreshing(target: self, action: #selector(loadMoreData))
    }

    // MARK: - 上拉加载 隐藏刷新状态的文字

    @objc func action09() {
        action01()
        if let footer = ZHRefreshChiBaoZiAutoFooter.footerWithRefreshing(target: self, action: #selector(loadMoreData)) as? ZHRefreshChiBaoZiAutoFooter {
            // 当上拉刷新控件出现50%时（出现一半），就会自动刷新。这个值默认是1.0（也就是上拉刷新100%出现时，才会自动刷新）
            //    footer.triggerAutomaticallyRefreshPercent = 0.5;
            footer.refreshingTitleHidden = true
            self.tableView.footer = footer
        }
    }

    // MARK: - 上拉加载 全部加载完毕

    @objc func action10() {
        action01()
        self.tableView.footer = ZHRefreshAutoNormalFooter.footerWithRefreshing(target: self, action: #selector(loadLastData))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "恢复数据加载", style: .plain, target: self, action: #selector(resetData))
    }

    // MARK: - 上拉加载 禁止自动加载

    @objc func action11() {
        action01()
        if let footer =  ZHRefreshAutoNormalFooter.footerWithRefreshing(target: self, action: #selector(loadMoreData)) as? ZHRefreshAutoNormalFooter {
            footer.automaticallyRefresh = false
            self.tableView.footer = footer
        }
    }

    // MARK: - 上拉加载 自定义文字

    @objc func action12() {
        action01()
        if let footer =  ZHRefreshAutoNormalFooter.footerWithRefreshing(target: self, action: #selector(loadMoreData)) as? ZHRefreshAutoNormalFooter {
            footer.set(title: "Click or drag up to refresh", for: .idle)
            footer.set(title: "Loading more...", for: .refreshing)
            footer.set(title: "No more data...", for: .nomoreData)
            /// 分别设置字体大小和文字颜色
            footer.stateLable.font = UIFont.systemFont(ofSize: 17)
            footer.stateLable.textColor = UIColor.blue
            self.tableView.footer = footer
        }
    }

    // MARK: - 上拉加载 加载后隐藏

    @objc func action13() {
        action01()
        self.tableView.footer =  ZHRefreshAutoNormalFooter.footerWithRefreshing(target: self, action: #selector(loadOnceData))
    }

    // MARK: - 上拉加载 自动回弹的上拉01

    @objc func action14() {
        action01()
        self.tableView.footer =  ZHRefreshBackNormalFooter.footerWithRefreshing(target: self, action: #selector(loadMoreData))
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        self.tableView.footer?.ignoredScrollViewContentInsetBottom = 30
    }

    // MARK: - 上拉加载 自动回弹的上拉02

    @objc func action15() {
        action01()
        self.tableView.footer =  ZHRefreshChiBaoZiFooter.footerWithRefreshing(target: self, action: #selector(loadMoreData))
        self.tableView.footer?.automaticallyChangeAlpha = true
    }

    // MARK: - 上拉加载 自定义刷新控件(自动刷新)

    @objc func action16() {
        action01()
        self.tableView.footer =  ZHDIYBackFooter.footerWithRefreshing(target: self, action: #selector(loadMoreData))
    }

    // MARK: - 上拉加载 自定义刷新控件(自动回弹)

    @objc func action17() {
        action01()
        self.tableView.footer =  ZHDIYAutoFooter.footerWithRefreshing(target: self, action: #selector(loadMoreData))
    }
}

// MARK: - 添加更多假数据

extension TableViewController {

    /// 恢复数据
    @objc private func resetData() {
        self.tableView.footer?.setRefreshing(target: self, action: #selector(loadMoreData))
        self.tableView.footer?.resetNoMoreData()
    }

    /// 加载新数据 header
    @objc private func loadNewData() {
        for _ in 0...5 {
            let string = "随机数据:---->\(arc4random_uniform(100000))"
            fakeData.insert(string, at: 0)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            /// 刷新tableView
            self.tableView.reloadData()
            /// 结束刷新
            self.tableView.header?.endRefreshing()
        }
    }

    /// 加载更多的数据 footer
    @objc private func loadMoreData() {
        for _ in 0...5 {
            let string = "随机数据:---->\(arc4random_uniform(100000))"
            fakeData.append(string)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            /// 刷新tableView
            self.tableView.reloadData()
            /// 结束刷新
            self.tableView.footer?.endRefreshing()
        }
    }

    /// 没有更多数据
    @objc private func loadLastData() {
        for _ in 0...5 {
            let string = "随机数据:---->\(arc4random_uniform(100000))"
            fakeData.append(string)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            /// 刷新tableView
            self.tableView.reloadData()
            /// 结束刷新
            self.tableView.footer?.endRefreshingWithNoMoreData()
        }
    }

    /// 加载后隐藏
    @objc private func loadOnceData() {
        for _ in 0...5 {
            let string = "随机数据:---->\(arc4random_uniform(100000))"
            fakeData.append(string)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            /// 刷新tableView
            self.tableView.reloadData()
            /// 结束刷新
            self.tableView.footer?.isHidden = true
        }
    }
}
