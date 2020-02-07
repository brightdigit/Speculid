DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PACKAGE_NAME=`basename $DIR`
USER_NAME=`basename $(dirname $(git remote get-url origin))`

swift package init --type library

sed -i '' "s/_PACKAGE_NAME/$PACKAGE_NAME/g" .github/workflows/macOS.yml
sed -i '' "s/_PACKAGE_NAME/$PACKAGE_NAME/g" .github/workflows/ubuntu.yml
sed -i '' "s/_PACKAGE_NAME/$PACKAGE_NAME/g" .travis.yml
sed -i '' "s/_PACKAGE_NAME/$PACKAGE_NAME/g" README.md
sed -i '' "s/_PACKAGE_NAME/$PACKAGE_NAME/g" LICENSE

sed -i '' "s/_USER_NAME/$USER_NAME/g" .github/workflows/macOS.yml
sed -i '' "s/_USER_NAME/$USER_NAME/g" .github/workflows/ubuntu.yml
sed -i '' "s/_USER_NAME/$USER_NAME/g" .travis.yml
sed -i '' "s/_USER_NAME/$USER_NAME/g" README.md
sed -i '' "s/_USER_NAME/$USER_NAME/g" LICENSE
sed -i '' "s/_USER_NAME/$USER_NAME/g" Example/project.yml

pod spec create $(git remote get-url origin) --silent

perl -pi -e '$_ .= qq(Lorem Description\n) if /spec.description  = <<-DESC/' $PACKAGE_NAME.podspec
sed -i '' 's|spec.summary.*|spec.summary      = "Lorem Ipsum"|g' $PACKAGE_NAME.podspec 
sed -i '' 's|"MIT (example)"|{ :type => "MIT", :file => "LICENSE" }|g' $PACKAGE_NAME.podspec
sed -i '' 's|spec.source_files  =.*|spec.source_files  = "Sources/**/*.swift"|g' $PACKAGE_NAME.podspec 
sed -i '' 's|spec.exclude_files.*|spec.swift_versions = "5"|g' $PACKAGE_NAME.podspec 

sed -i '' 's|spec.ios.deployment_target.*|spec.ios.deployment_target = "8.0"|g' $PACKAGE_NAME.podspec
sed -i '' 's|spec.osx.deployment_target.*|spec.osx.deployment_target = "10.9"|g' $PACKAGE_NAME.podspec
sed -i '' 's|spec.watchos.deployment_target.*|spec.watchos.deployment_target = "2.0"|g' $PACKAGE_NAME.podspec
sed -i '' 's|spec.tvos.deployment_target.*|spec.tvos.deployment_target = "9.0"|g' $PACKAGE_NAME.podspec

swift build
swift test
sourcedocs generate --spm-module $PACKAGE_NAME --output-folder docs
pushd Example
xcodegen generate
pod init
sed -i '' "s|# Pods for.*|pod '$PACKAGE_NAME', :path => '../'|g" Podfile 
pod install
popd 

xcodebuild -workspace Example/Example.xcworkspace -scheme "iOS_Example"  ONLY_ACTIVE_ARCH=NO  CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO  CODE_SIGNING_ALLOWED=NO &
xcodebuild -workspace Example/Example.xcworkspace -scheme "tvOS_Example"  ONLY_ACTIVE_ARCH=NO   CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO  CODE_SIGNING_ALLOWED=NO &
xcodebuild -workspace Example/Example.xcworkspace -scheme "macOS_Example"  ONLY_ACTIVE_ARCH=NO CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO  CODE_SIGNING_ALLOWED=NO &
wait
