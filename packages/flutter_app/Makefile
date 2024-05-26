
# include functions/Makefile

PROJECT_ID=

watch: 
	fvm flutter pub run build_runner build --delete-conflicting-outputs; flutter pub run build_runner watch 


gen: # build_runner build 
	fvm flutter pub run build_runner build 

genf: # build_runner build --delete-conflicting-outputs
	fvm flutter pub run build_runner build --delete-conflicting-outputs

genintl: # gen-l10n
	fvm flutter gen-l10n

genicon:
	fvm flutter pub run flutter_launcher_icons:main

get: # pub get
	fvm flutter pub get
	
flutter_connect:
	flutterfire configure --project=${PROJECT_ID}

clean.ios: # rm Podfile.lock Pods
	flutter clean
	rm -rf ios/Pods
	rm -rf ios/Podfile.lock
	flutter pub get
	pod install --project-directory=ios

#=================== Packages ===================
add.firebase.store:
	fvm flutter pub add \
		firebase_core \
		cloud_firestore \
		firebase_ui_firestore \
		

add.firebase:
	fvm flutter pub add \
		firebase_auth \
		firebase_ui_auth \
		firebase_core \
		cloud_firestore \
		cloud_firestore_web \
		firebase_ui_firestore \
		firebase_storage \
		cloud_functions

add.util.riverpod:
	fvm flutter pub add \
		flutter_riverpod \
		riverpod_annotation \
		flutter_hooks \
		hooks_riverpod 

	fvm flutter pub add \
		flutter_lints \
		riverpod_lint \
		custom_lint \
		build_runner \
		riverpod_generator \
		json_serializable \
		--dev 

	fvm flutter pub add \
		freezed 
	@echo ""
	@echo "--------------------------------------------------"
	@echo "pubspec.yamlに以下を追加"
	@echo "analyzer:"
	@echo "\tplugins:"
	@echo "\t\t- custom_lint"

add.util:
	fvm flutter pub add \
		flutter_hooks \
		freezed_annotation \
		json_annotation

	fvm flutter pub add \
		flutter_lints \
		custom_lint \
		build_runner \
		json_serializable \
		--dev 

	fvm flutter pub add \
		freezed 

add.util.extra:
	fvm flutter pub add \
		intl:^0.18.0 \
		go_router:^9.0.3 \
		path_provider \
		flutter_launcher_icons \
		cached_network_image \
		image_picker \
		image_picker_web 

	@echo ""
	@echo "--------------------------------------------------"
	@echo "pubspec.yamlに以下を追加"
	@echo "dependencies:"
	@echo "\tflutter:"
	@echo "\t\tsdk: flutter"
	@echo "\tflutter_localizations:"
	@echo "\t\tsdk: flutter"
	@echo ""
	@echo "flutter:"
	@echo "\tgenerate: true"

#=================== Run ===================

run:
	flutter run --dart-define-from-file=dart_defines/dev.env
run.all: #
	make runios &
	make runandroid &
	make runchrome &
	make runmac &
run.mac:
	fvm flutter run -d macos
run.chrome:
	fvm flutter run -d chrome
# アンドロイドは手動でないと、一つのAVDでエミュレーターが複数起動するエラーが発生する
# runandroid:
# 	emulator -avd Pixel_3a_API_33_arm64-v8a-10GB &
# # エミュレータがオフラインから完全に起動するのを待つ
# 	@while adb shell getprop sys.boot_completed 2>/dev/null | grep -vq 1; do sleep 5; done
# 	@ANDROID_DEVICE_ID=$(shell fvm flutter devices | grep "android" | awk '{print $$6}') && \
# 	echo "@@@@ $$ANDROID_DEVICE_ID"
# 	fvm flutter run -d $$ANDROID_DEVICE_ID &
run.ios: # シミュレーターを起動する
	open -a Simulator
# シミュレータが完全に起動するのを待つ
	@while ! xcrun simctl list devices | grep Booted; do sleep 5; done
	@IOS_DEVICE_ID=$(shell fvm flutter devices | grep "iOS" | awk '{print $$7}') && \
	fvm flutter run -d $$IOS_DEVICE_ID &


start:
	firebase emulators:start --only auth,firestore,functions --import=seed --inspect-functions

#=================== Release ===================
buildios:
	flutter build ios --dart-define-from-file=dart_defines/dev.env

gendsym: # after buildios
	ditto -c -k --sequesterRsrc --keepParent build/ios/Debug-iphonesimulator/Runner.app.dSYM Runner.app.dSYM.zip

showuuid:
	dwarfdump --uuid build/ios/Debug-iphonesimulator/Runner.app.dSYM
	
archive:
	flutter build ipa --release --dart-define-from-file=dart_defines/dev.env
