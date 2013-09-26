CREATE TABLE "connections" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer, "contact_id" integer, "is_pending" boolean, "created_at" datetime, "updated_at" datetime, "is_rejected" boolean DEFAULT 'f');
CREATE TABLE "locations" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "session_id" integer, "lat" float, "lon" float, "bearing" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "sessions" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "session_id" text, "sender_token" text, "recipient_token" text, "sender_id" integer, "recipient_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "phone" varchar(255), "email" varchar(255), "role" integer, "created_at" datetime, "updated_at" datetime, "encrypted_password" varchar(255) DEFAULT '' NOT NULL, "authentication_token" varchar(255), "reset_password_token" varchar(255), "reset_password_sent_at" datetime, "remember_created_at" datetime, "sign_in_count" integer DEFAULT 0 NOT NULL, "current_sign_in_at" datetime, "last_sign_in_at" datetime, "current_sign_in_ip" varchar(255), "last_sign_in_ip" varchar(255));
CREATE INDEX "index_locations_on_session_id" ON "locations" ("session_id");
CREATE INDEX "index_sessions_on_recipient_id" ON "sessions" ("recipient_id");
CREATE INDEX "index_sessions_on_sender_id" ON "sessions" ("sender_id");
CREATE UNIQUE INDEX "index_users_on_email" ON "users" ("email");
CREATE UNIQUE INDEX "index_users_on_reset_password_token" ON "users" ("reset_password_token");
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20130820165845');

INSERT INTO schema_migrations (version) VALUES ('20130820184249');

INSERT INTO schema_migrations (version) VALUES ('20130825131442');

INSERT INTO schema_migrations (version) VALUES ('20130910123149');

INSERT INTO schema_migrations (version) VALUES ('20130920205148');

INSERT INTO schema_migrations (version) VALUES ('20130926112229');
