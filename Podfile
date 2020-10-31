# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'NimbleSurvey' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!

  # Pods for NimbleSurvey
  pod 'SwiftyComponent', :git => 'https://github.com/markgravity/swifty-component.git'
  pod 'SwiftyBase', :git => 'https://github.com/markgravity/swifty-base.git'
  pod 'LNZCollectionLayouts', '~> 1.2.2'
  pod 'AlamofireNetworkActivityLogger', '~> 3.0'
  
  post_install do |pi|
     pi.pods_project.targets.each do |t|
        t.build_configurations.each do |config|
           config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
        end
     end
  end
  
  target 'NimbleSurveyTests' do
    inherit! :search_paths
    use_frameworks!
    inhibit_all_warnings!
    
    pod 'MockingbirdFramework', '~> 0.10.0'
    pod 'Nimble', '~> 8.0.4'
  end

  target 'NimbleSurveyUITests' do
    # Pods for testing
  end

end
