#
# Be sure to run `pod lib lint ZHRefresh.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZHRefresh'
  s.version          = '0.1.5'
  s.summary          = 'a refresh control write by Swift which like MJRefresh'
  s.swift_version    = '4.0'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: 1. add Custom refresh style
      2. Adaptive iPhoneX and other device  
                       DESC

  s.homepage         = 'https://github.com/SummerHF/ZHRefresh'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'SummerHF' => '391565521@qq.com' }
  s.source           = { :git => 'https://github.com/SummerHF/ZHRefresh.git', :tag => s.version.to_s }
  s.social_media_url = 'http://summerhf.cn'
  s.ios.deployment_target = '8.0'
  s.source_files = 'ZHRefresh/Classes/*.*'
  s.frameworks = 'UIKit', 'Foundation'
  s.module_name = 'ZHRefresh'
  s.resources = "ZHRefresh/Assets/ZHRefresh.bundle"
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.dependency 'AFNetworking', '~> 2.3'
end
