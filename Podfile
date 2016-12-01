source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!

platform :ios, '9.0'

def shared_pods
	pod 'OneSignal', '1.13.3'
	pod 'Fabric', '1.6.7'
    pod 'GooglePlaces', '~> 2.1'
    pod 'GoogleMaps'
	pod 'Digits', '2.3.0'
	pod 'TwitterCore', '2.3.0'
	pod 'Crashlytics', '3.7.2'
	pod 'Firebase', '3.3.0'
	pod 'FirebaseDatabase', '3.0.2'
	pod 'FirebaseStorage', '1.0.2'
	pod 'FirebaseUI', '0.4.0'
    pod 'SnapKit'
    pod 'Kingfisher'
	pod 'JVFloatLabeledTextField', '1.1.0'
end

target 'Deeno' do
    shared_pods
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
