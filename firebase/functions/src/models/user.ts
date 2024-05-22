import * as admin from "firebase-admin";
import { logger } from "firebase-functions/v1";
import { HttpsError } from "firebase-functions/v2/https";
import { db } from "@/init";

export class User {
  constructor(
    readonly uid: string,
    readonly displayName: string,
    readonly email: string,
    readonly photoURL: string,
    readonly lastLoggedInAt: Date
  ) {}

  toJson() {
    return {
      uid: this.uid,
      displayName: this.displayName,
      email: this.email,
      photoURL: this.photoURL,
    };
  }
  static async create(user: admin.auth.UserRecord): Promise<User> {
    const newUser = User.fromUserRecord(user);
    try {
      await db.collection("users").doc(newUser.uid).set(newUser.toJson());
      logger.debug("User created successfully: ", newUser);
      return newUser;
    } catch (error) {
      logger.error("Error creating user: ", error);
      throw new HttpsError("internal", "Error creating user.");
    }
  }
  static fromUserRecord(user: admin.auth.UserRecord): User {
    return new User(
      user.uid,
      user.displayName || user.email!.split("@")[0],
      user.email || "",
      user.photoURL || "",
      new Date()
    );
  }
  static fromDocument(snapshot: FirebaseFirestore.QueryDocumentSnapshot): User {
    const uid = snapshot.id;
    const data = snapshot.data();
    const user = {
      ...data,
      uid: uid,

      // createdAt: data.createdAt?.toDate(),
    };
    logger.debug("User fetched successfully:  ", user);
    logger.debug("uid: ", uid);
    return user as User;
  }
  static async update(uid: string, updateData: Partial<User>): Promise<void> {
    logger.debug(`Updating user with uid: ${uid}`);
    try {
      const userRef = db.collection("users").doc(uid);
      await userRef.update(updateData);
      logger.debug("User updated successfully");
    } catch (error) {
      logger.error("Error updating user: ", error);
      throw new HttpsError("internal", "Error updating user.");
    }
  }

  static async getByEmail(email: string | undefined): Promise<User | null> {
    if (!email) {
      // Check if email is undefined or empty
      logger.error("Attempted to fetch user with undefined or empty email.");
      throw new HttpsError(
        "invalid-argument",
        "Email must be a non-empty string."
      );
    }
    logger.debug(`Fetching user by email: ${email}`);
    try {
      const snapshot = await db
        .collection("users")
        .where("email", "==", email)
        .get();
      if (snapshot.empty) {
        logger.info(`User email: ${email} not found.`);
        return null;
      }
      let user = null;
      snapshot.forEach((doc) => {
        user = doc.data();
      });
      logger.debug("User fetched successfully: ", user);
      return user;
    } catch (error) {
      logger.error(`Error fetching user by email: ${email}`, error);
      throw new HttpsError(
        "internal",
        `Error fetching user by email: ${email}`
      );
    }
  }
}
