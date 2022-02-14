source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '12.0'
use_frameworks!

install! 'cocoapods',
         :deterministic_uuids => false

# ignore all warnings from all pods
inhibit_all_warnings!

$git_root = "https://github.com/pia-foss"
$gitlab_vpn_root = "git@gitlab.kape.com:pia-mobile/ios"
$gitlab_kn_root = "git@gitlab.kape.com:pia-mobile/shared"

$regions_repo = 'mobile-common-regions'
$accounts_repo = 'mobile-common-account'

$regions_gitlab_repo = 'regions.git'
$accounts_gitlab_repo = 'account.git'
$csi_gitlab_repo = 'csi.git'
$kpi_gitlab_repo = 'kpi.git'

abstract_target 'PIALibrary' do
    pod 'SwiftyBeaver', '~> 1.7.0'
    pod 'Gloss', '~> 2'
    pod 'Alamofire', '~> 4'
    pod 'ReachabilitySwift', '4.3.0'
    pod 'SwiftEntryKit', '0.7.2'
    pod 'lottie-ios'
    pod 'FXPageControl'
    pod 'PopupDialog'
    pod 'TunnelKit', :git => 'https://github.com/pia-foss/tunnelkit', :branch => 'master'
    pod 'OpenSSL-Apple', :git => 'https://github.com/keeshux/openssl-apple'
    pod 'PIAWireguard', :git => "#{$gitlab_vpn_root}/pia-wireguard.git", :branch => 'develop'
    pod "PIAAccountModule", :git => "#{$gitlab_kn_root}/#{$accounts_gitlab_repo}", :branch => 'release/1.2.0'
    pod "PIARegionsModule", :git => "#{$gitlab_kn_root}/#{$regions_gitlab_repo}", :branch => 'release/1.3.1'
    pod "PIACSIModule", :git => "#{$gitlab_kn_root}/#{$csi_gitlab_repo}", :commit => 'b62d1bab'
    pod "PIAKPIModule", :git => "#{$gitlab_kn_root}/#{$kpi_gitlab_repo}", :branch => 'release/1.1.0'

    target 'PIALibrary-iOS' do
        platform :ios, '12.0'
    end
    target 'PIALibraryTests-iOS' do
        platform :ios, '12.0'
    end
    target 'PIALibraryHost-iOS' do
        platform :ios, '12.0'
    end

    #target 'PIALibrary-macOS' do
    #    platform :osx, '10.11'
    #end
    #target 'PIALibraryTests-macOS' do
    #    platform :osx, '10.11'
    #end
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if ['PopupDialog'].include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.2'
            end
        end
        if ['SwiftEntryKit', 'QuickLayout'].include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.0'
            end
        end
    end
end
