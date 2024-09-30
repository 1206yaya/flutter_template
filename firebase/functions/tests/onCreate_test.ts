import _test from "firebase-functions-test";
import { onUserCreated as _onUserCreated } from "../src/index";
import { UserRecord } from "firebase-functions/v1/auth";
import { firestore } from "firebase-admin";
import { initializeApp, credential } from "firebase-admin";
import * as serviceAccountKey from "../serviceAccountKey.json";

const serviceAccount = {
  type: serviceAccountKey.type,
  projectId: serviceAccountKey.project_id,
  privateKeyId: serviceAccountKey.private_key_id,
  privateKey: serviceAccountKey.private_key.replace(/\\n/g, "\n"),
  clientEmail: serviceAccountKey.client_email,
  clientId: serviceAccountKey.client_id,
  authUri: serviceAccountKey.auth_uri,
  tokenUri: serviceAccountKey.token_uri,
  authProviderX509CertUrl: serviceAccountKey.auth_provider_x509_cert_url,
  clientX509CertUrl: serviceAccountKey.client_x509_cert_url,
};

console.log(serviceAccount);
// initializeApp({ credential: credential.cert(serviceAccount) });

// tests/onCreate_test.ts
const projectId = "someapp-dev-dfa74";
const test = _test(
  {
    projectId: projectId,
  },
  // storage や database など他のサービスを使う場合はここに追加する
  "../serviceAccountKey.json"
);

const onUserCreated = test.wrap(_onUserCreated);

const user: UserRecord = test.auth.exampleUserRecord();

describe("onUserCreated", () => {
  it("should return null", async () => {
    const result = await onUserCreated(user);
    // expect(result).toBeNull();

    const snapshot = await firestore().collection("users").doc(user.uid).get();

    expect(snapshot.data()).toBeTruthy();
    expect(snapshot.id).toEqual(user.uid);
  });
});
