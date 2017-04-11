source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target 'Shingo Events' do
        pod 'Alamofire', '~> 4.0'
        pod 'AlamofireImage', '~> 3.0'
        pod 'Fabric'
        pod 'Crashlytics'
        pod 'PureLayout'
        pod 'ReachabilitySwift', '~> 3.0'
        pod 'SwiftyJSON', git: 'https://github.com/BaiduHiDeviOS/SwiftyJSON.git', branch: 'swift3'
        pod 'SwiftDate', '~> 4.0'
	pod 'DropDown', git: 'https://github.com/AssistoLab/DropDown.git', branch: 'master'
end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
