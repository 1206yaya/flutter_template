
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
	

clean.ios: # rm Podfile.lock Pods
	flutter clean
	rm -rf ios/Pods
	rm -rf ios/Podfile.lock
	flutter pub get
	pod install --project-directory=ios


run:
	flutter run --dart-define-from-file=dart_defines/dev.env

run.mac:
	fvm flutter run -d macos
run.chrome:
	fvm flutter run -d chrome


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
