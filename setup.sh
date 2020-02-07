# ${PACKAGE_NAME}
# _USER_NAME

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PACKAGE_NAME=`basename $DIR`
USER_NAME=`basename $(dirname $(git remote get-url origin))`


#LC_ALL=C find . -type f -exec sed -i '' "s/_PACKAGE_NAME/$PACKAGE_NAME/g" {} +
#grep -rl _PACKAGE_NAME . | xargs sed -i "s/_PACKAGE_NAME/$PACKAGE_NAME/g"
#find . -type f -name "*" -print0 | xargs -0 sed -i '' -e 's/_PACKAGE_NAME/${PACKAGE_NAME}/g'
sed -i '' 's/_PACKAGE_NAME/$PACKAGE_NAME/g' .github/workflows/macOS.yml
sed -i '' 's/_PACKAGE_NAME/$PACKAGE_NAME/g' .github/workflows/ubuntu.yml
sed -i '' 's/_PACKAGE_NAME/$PACKAGE_NAME/g' .travis.yml
sed -i '' 's/_PACKAGE_NAME/$PACKAGE_NAME/g' README.md
sed -i '' 's/_PACKAGE_NAME/$PACKAGE_NAME/g' _PACKAGE_NAME.podspec
sed -i '' 's/_PACKAGE_NAME/$PACKAGE_NAME/g' LICENSE

sed -i '' 's/_USER_NAME/$USER_NAME/g' .github/workflows/macOS.yml
sed -i '' 's/_USER_NAME/$USER_NAME/g' .github/workflows/ubuntu.yml
sed -i '' 's/_USER_NAME/$USER_NAME/g' .travis.yml
sed -i '' 's/_USER_NAME/$USER_NAME/g' README.md
sed -i '' 's/_USER_NAME/$USER_NAME/g' _PACKAGE_NAME.podspec
sed -i '' 's/_USER_NAME/$USER_NAME/g' LICENSE