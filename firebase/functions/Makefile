include ../Makefile

export PROJECT_ID=someapp-dev-dfa74
watch.tsc:
	npx tsc --watch

start:
	firebase emulators:start  --inspect-functions --project=${PROJECT_ID} --only firestore
test:
	firebase emulators:start
	npx jest --detectOpenHandles --runInBand --forceExit tests/*