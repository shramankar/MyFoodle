# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'fooddle' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for fooddle

pod 'Firebase'
pod 'Firebase/Core'
pod 'Firebase/Firestore'
# pod 'Firebase/Database'
pod 'Firebase/Auth'
pod 'SVProgressHUD'
pod 'ChameleonFramework'
pod 'Firebase/Storage'
end
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
        end
    end
end
