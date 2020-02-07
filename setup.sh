# ${PACKAGE_NAME}
# _USER_NAME

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PACKAGE_NAME=`basename $DIR`
USER_NAME=`basename $(dirname $(git remote get-url origin))`


swift package init --type library
#LC_ALL=C find . -type f -exec sed -i '' "s/_PACKAGE_NAME/$PACKAGE_NAME/g" {} +
#grep -rl _PACKAGE_NAME . | xargs sed -i "s/_PACKAGE_NAME/$PACKAGE_NAME/g"
#find . -type f -name "*" -print0 | xargs -0 sed -i '' -e 's/_PACKAGE_NAME/${PACKAGE_NAME}/g'
sed -i '' "s/_PACKAGE_NAME/$PACKAGE_NAME/g" .github/workflows/macOS.yml
sed -i '' "s/_PACKAGE_NAME/$PACKAGE_NAME/g" .github/workflows/ubuntu.yml
sed -i '' "s/_PACKAGE_NAME/$PACKAGE_NAME/g" .travis.yml
sed -i '' "s/_PACKAGE_NAME/$PACKAGE_NAME/g" README.md
#sed -i '' "s/_PACKAGE_NAME/$PACKAGE_NAME/g" _PACKAGE_NAME.podspec
sed -i '' "s/_PACKAGE_NAME/$PACKAGE_NAME/g" LICENSE

sed -i '' "s/_USER_NAME/$USER_NAME/g" .github/workflows/macOS.yml
sed -i '' "s/_USER_NAME/$USER_NAME/g" .github/workflows/ubuntu.yml
sed -i '' "s/_USER_NAME/$USER_NAME/g" .travis.yml
sed -i '' "s/_USER_NAME/$USER_NAME/g" README.md
#sed -i '' "s/_USER_NAME/$USER_NAME/g" _PACKAGE_NAME.podspec
sed -i '' "s/_USER_NAME/$USER_NAME/g" LICENSE
sed -i '' "s/_USER_NAME/$USER_NAME/g" Example/project.yml

pod spec create $(git remote get-url origin) --silent

sed -i '' 's|spec.source_files  =.*|spec.source_files  = "Sources/**/*.swift"|g' $PACKAGE_NAME.podspec 
sed -i '' 's|spec.exclude_files.*|spec.swift_versions = "5"|g' $PACKAGE_NAME.podspec 

swift build
swift test
sourcedocs generate --spm-module $PACKAGE_NAME --output-folder docs