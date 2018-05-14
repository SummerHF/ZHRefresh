//  WebViewController.swift
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
import ZHRefresh
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    lazy var webView: WKWebView = {
         let view = WKWebView(frame: CGRect.zero)
         view.navigationDelegate = self
         return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.webView)
        self.webView.snp.makeConstraints { (make) in
            if let navgationBar = self.navigationController?.navigationBar {
                make.top.equalTo(navgationBar.frame.maxY)
            } else {
                make.top.equalToSuperview()
            }
            make.left.right.bottom.equalToSuperview()
        }
        /// 个人主页
        let request = URLRequest(url: URL(string: "http://summerhf.cn/")!)
        /// 加载页面
        self.webView.load(request)
        self.perform(Selector(self.method))
    }

    @objc func action19() {
        /// 设置回调, 一旦进入刷新状态 就会调用block
        self.webView.scrollView.header = ZHRefreshNormalHeader.headerWithRefreshing { [weak self] in
            guard let `self` = self else { return }
            self.webView.reload()
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webView.scrollView.header?.endRefreshing()
    }

}
