//  Record.swift
//  Refresh
//
//  Created by SummerHF on 11/05/2018.
//
//
//  Copyright (c) 2018 SummerHF(https://github.com/summerhf)
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

/// 1. about willMoveToSuperview?
/// - https://stackoverflow.com/questions/25996906/willmovetosuperview-is-called-twice
/// When a view is added to a superview, the system sends willMoveToSuperview: to the view. The parameter is the new superview.
/// When a view is removed from a superview, the system sends willMoveToSuperview: to the view. The parameter is nil.
/// You can't prevent the system from sending willMoveToSuperview: when you remove the view from its superview, but you can check the parameter:

/// run time?
/// - https://academy.realm.io/posts/mobilization-roy-marmelstein-objective-c-runtime-swift-dynamic/
/// - https://github.com/marmelroy/ObjectiveKit

///Any and AnyObject?
/// - https://cocoacasts.com/what-is-any-in-swift
/// - https://medium.com/@markohlebar/5-things-you-can-do-in-objective-c-but-cant-do-in-pure-swift-31bb66b4aab8
/// - https://medium.com/@mimicatcodes/any-vs-anyobject-in-swift-3-b1a8d3a02e00
///What is escaping and nonescaping meaning?
/// - https://medium.com/@kumarpramod017/what-do-mean-escaping-and-nonescaping-closures-in-swift-d404d721f39d
/// In Swift 3, they made a change: closure parameters are no-escaping by default, if you wanna to escape the closure execution, you have to use @escaping with the closure parameters.
/// In this case you have no idea when the closure will get executed.
/// When are passing the closure in function’s arguments, using it after the function’s body gets execute and returns the compiler back. When the function ends, the scope of the passed closure exist and have existence in memory, till the closure gets executed. There are several ways to escaping the closure in containing function:
/// Storage: When you need to store the closure in the global variable, property or any other storage that exist in the memory past of the calling function get executed and return the compiler back.
/// Asynchronous Execution: When you are executing the closure asynchronously on despatch queue, the queue will hold the closure in memory for you, can be used in future. In this case you have no idea when the closure will get executed.


/// view 加载的次序
/// init frame ----> willMove toSuperview ----> layoutSubviews ----> draw
/// 调用setNeedsLayout方法, 会触发layoutSubviews方法
/// 调用setNeedsDisolay方法, 会触发draw方法
/// 详情参考
/// https://bradbambara.wordpress.com/2015/01/18/object-life-cycle-uiview/
/// 对于一个UIView, setNeedsLayout的方法告诉系统，您希望它在更新周期的时间内布局并重新绘制该视图及其所有子视图。这是一个异步的活动，因为方法会立即完成并返回，但是直到以后的一些时间，布局和重绘才会实际发生，而且您不知道什么时候会出现更新周期。
/// 相反，layoutifneeded方法是一个同步调用，它告诉系统您想要一个视图和它的子视图的布局和重画，并且您希望它在不等待更新周期的情况下立即完成。当对该方法的调用完成时，该布局已经根据在方法调用之前已经注意到的所有更改进行了调整和绘制。
/// 所以，简洁地说，layoutifneed说请立即更新，而setNeedsLayout说请更新，但是你可以等到下一个更新周期。
/// http://www.iosinsight.com/setneedslayout-vs-layoutifneeded-explained/
/// Assigning a property to itself
/// - https://stackoverflow.com/questions/31930257/what-if-i-want-to-assign-a-property-to-itself
/// - 使用临时变量
/// scrollView contentInset explain
/// - http://blog.fujianjin6471.com/2015/07/27/gain-an-insight-into-contentInset-of-scroll-view.html
/// - https://fizzbuzzer.com/understanding-the-contentoffset-and-contentinset-properties-of-the-uiscrollview-class/
/// - https://www.objc.io/issues/3-views/scroll-view/
/// safe area about?
/// - https://mp.weixin.qq.com/s/W1_0VrchCO50owhJNmJnuQ
/// Is it possible to allow didSet to be called during initialization in Swift?
/// - https://stackoverflow.com/questions/25230780/is-it-possible-to-allow-didset-to-be-called-during-initialization-in-swift
/// 计算属性 存储属性 willSet didSet(属性观察)
/// https://medium.com/@abhimuralidharan/all-about-properties-in-swift-d618481b1cc1
/// podspec file meading?
/// https://www.jianshu.com/p/9eea3e7cb3a1
/// Cannot inherit from non-open class [duplicate]
/// https://stackoverflow.com/questions/39072300/xcode-8-cannot-inherit-from-non-open-class
