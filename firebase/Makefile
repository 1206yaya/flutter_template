
export PROJECT_ID=someapp-dev-dfa74

deploy:
	firebase deploy

# .firebaserc に記載されているプロジェクト名を指定してデプロイ
deployprod:
	firebase deploy -P prod

start:
	firebase emulators:start --project=${PROJECT_ID} 

startdebug:
	firebase emulators:start  --inspect-functions --project=${PROJECT_ID} 