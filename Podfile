platform :ios, '12.1'
inhibit_all_warnings!
use_frameworks!

target 'OrangeBank' do
    pod 'Alamofire', '~> 4.7'
    pod 'DateToolsSwift', '~> 4.0'
    pod 'DZNEmptyDataSet', '~> 1.8'
    pod 'MaterialComponents', '~> 59.2'
    pod 'SnapKit', '~> 4.2'
    pod 'Unbox', '~> 2.5'
    pod 'UnboxedAlamofire', '~> 2.0'
end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end
