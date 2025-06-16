#export http_proxy=http://127.0.0.1:1087
pod repo update
cd macos
pod update
cd ios
pod update
#
flutter pub upgrade --major-versions
flutter gen-l10n
dart run flutter_launcher_icons

dart pub global run intl_utils:generate
dart run build_runner build
export https_proxy=127.0.0.1:1087
unset PUB_HOSTED_URL
flutter packages pub publish -f --server=https://pub.dartlang.org
