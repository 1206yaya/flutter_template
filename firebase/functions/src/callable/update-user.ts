import { CallableRequest, HttpsError } from "firebase-functions/v2/https";
import { logger } from "firebase-functions";
import { User, updateUser } from "@/models/user";

interface Data {
  uid: string;
  displayName: string;
}

export async function updateUserHandler(
  req: CallableRequest<Data>
): Promise<string> {
  if (!req.auth) {
    throw new HttpsError("unauthenticated", "User must be authenticated");
  }

  const { uid, displayName } = req.data;
  try {
    logger.debug(`Start Update User uid: ${uid}`);
    await updateUser(uid, { displayName: displayName });
  } catch (error: any) {
    logger.error(`Error updating user uid: ${uid}`, error);
    throw new HttpsError("internal", `Error updating user with uid: ${uid}`);
  }
  return "User updated successfully.";
}
