# Uncomment the next line to define a global platform for your project
platform :osx, '10.10'
workspace 'speculid.xcworkspace'
xcodeproj 'speculid.xcodeproj'

target 'Speculid-App' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Speculid-App
  target 'Speculid' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!

    # Pods for Speculid
    pod 'SwiftVer', '~> 2.0'

    target 'SpeculidTests' do
      inherit! :search_paths
      # Pods for testing
      pod 'RandomKit', '~> 5.2.3'
    end

  end
end
