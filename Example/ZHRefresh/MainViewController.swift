//  MainViewController.swift
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
import SnapKit
import ZHRefresh

/// 分组类型
enum ZHRefreshGroup: Int {
    /// UITableView下拉刷新
    case tableViewPullDown
    /// UITableView上拉刷新
    case tableViewPullUp
    /// CollectionView下拉刷新
    case collectionViewPullDown
    /// CollectionView上拉刷新
    case collectionViewPullUp
}

/// 演示程序入口
class MainViewController: UIViewController {

    /// 模型数据
    lazy var examleArray: [Example] = {
         return Example.retriveData()
    }()

    lazy var tableView: UITableView = {
         let tableView = UITableView(frame: CGRect.zero, style: .grouped)
         tableView.delegate = self
         tableView.dataSource = self
         return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = examleArray[indexPath.section]
        guard let vcType = model.vcType as? UIViewController.Type else { return }
        let viewController = vcType.init()
        viewController.title = model.titles[indexPath.row]
        viewController.method = model.methods[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return examleArray.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model = examleArray[section]
        return model.titles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: Example.reuseIdentifier)
        let model = examleArray[indexPath.section]
        if  cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: Example.reuseIdentifier)
        }
        cell?.textLabel?.text = model.titles[indexPath.row]
        cell?.detailTextLabel?.text = "\(model.vcType) - \(model.methods[indexPath.row])"
        return cell!
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return examleArray[section].header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Example.headerHeight
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return Example.footerHeight
    }
}

