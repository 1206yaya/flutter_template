import { auth, logger } from "firebase-functions/v1";
import { User, getUserByEmail } from "@/models/user";
import { HttpsError } from "firebase-functions/v2/https";
import { createUser } from "../models/user";

export async function onUserCreatedHandler(authUser: auth.UserRecord) {
  const { uid, email, displayName } = authUser;
  logger.info("start onUserCreatedHandler: ", { uid, email, displayName });

  try {
    const user = await getUserByEmail(email);

    if (user) {
      logger.info("User already exists ", email);
      return;
    }

    await createUser(authUser);
    logger.info("User created successfully: ", { uid, email, displayName });
  } catch (error) {
    logger.error("Error creating User: ", error);
    throw new HttpsError("internal", `Error creating User: ${email}`);
  }
}
