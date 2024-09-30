/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */
import "./fixTsPaths";
import { auth } from "firebase-functions/v1";
import { onCall, onRequest } from "firebase-functions/v2/https";

import { onUserCreatedHandler } from "@trigger/on-user-created";
import { updateUserHandler } from "@callable/update-user";
// User
export const onUserCreated = auth
  .user()
  .onCreate(async (user) => onUserCreatedHandler(user));

export const updateUser = onCall(updateUserHandler);

export const simpleHttp = onRequest((request, response) => {
  response.send(`text: ${request.query.text}`);
});
