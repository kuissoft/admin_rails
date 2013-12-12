--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: connections; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE connections (
    id integer NOT NULL,
    user_id integer,
    contact_id integer,
    is_pending boolean DEFAULT true,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    is_rejected boolean DEFAULT false,
    nickname character varying(255),
    is_removed boolean DEFAULT false
);


--
-- Name: connections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE connections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: connections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE connections_id_seq OWNED BY connections.id;


--
-- Name: devices; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE devices (
    id integer NOT NULL,
    token character varying(255),
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: devices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE devices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: devices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE devices_id_seq OWNED BY devices.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE locations (
    id integer NOT NULL,
    session_id integer,
    lat double precision,
    lon double precision,
    bearing integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE locations_id_seq OWNED BY locations.id;


--
-- Name: rapns_apps; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rapns_apps (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    environment character varying(255),
    certificate text,
    password character varying(255),
    connections integer DEFAULT 1 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    type character varying(255) NOT NULL,
    auth_key character varying(255)
);


--
-- Name: rapns_apps_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rapns_apps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rapns_apps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rapns_apps_id_seq OWNED BY rapns_apps.id;


--
-- Name: rapns_feedback; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rapns_feedback (
    id integer NOT NULL,
    device_token character varying(64) NOT NULL,
    failed_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    app character varying(255)
);


--
-- Name: rapns_feedback_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rapns_feedback_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rapns_feedback_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rapns_feedback_id_seq OWNED BY rapns_feedback.id;


--
-- Name: rapns_notifications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rapns_notifications (
    id integer NOT NULL,
    badge integer,
    device_token character varying(64),
    sound character varying(255) DEFAULT 'default'::character varying,
    alert character varying(255),
    data text,
    expiry integer DEFAULT 86400,
    delivered boolean DEFAULT false NOT NULL,
    delivered_at timestamp without time zone,
    failed boolean DEFAULT false NOT NULL,
    failed_at timestamp without time zone,
    error_code integer,
    error_description text,
    deliver_after timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    alert_is_json boolean DEFAULT false,
    type character varying(255) NOT NULL,
    collapse_key character varying(255),
    delay_while_idle boolean DEFAULT false NOT NULL,
    registration_ids text,
    app_id integer NOT NULL,
    retries integer DEFAULT 0
);


--
-- Name: rapns_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rapns_notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rapns_notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rapns_notifications_id_seq OWNED BY rapns_notifications.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: settings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE settings (
    id integer NOT NULL,
    token_expiration_period integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE settings_id_seq OWNED BY settings.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    name character varying(255),
    phone character varying(255),
    email character varying(255),
    role integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    authentication_token character varying(255),
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    last_token character varying(255),
    token_updated_at timestamp without time zone
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY connections ALTER COLUMN id SET DEFAULT nextval('connections_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY devices ALTER COLUMN id SET DEFAULT nextval('devices_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY locations ALTER COLUMN id SET DEFAULT nextval('locations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY rapns_apps ALTER COLUMN id SET DEFAULT nextval('rapns_apps_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY rapns_feedback ALTER COLUMN id SET DEFAULT nextval('rapns_feedback_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY rapns_notifications ALTER COLUMN id SET DEFAULT nextval('rapns_notifications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY settings ALTER COLUMN id SET DEFAULT nextval('settings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: connections_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY connections
    ADD CONSTRAINT connections_pkey PRIMARY KEY (id);


--
-- Name: devices_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY devices
    ADD CONSTRAINT devices_pkey PRIMARY KEY (id);


--
-- Name: locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: rapns_apps_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rapns_apps
    ADD CONSTRAINT rapns_apps_pkey PRIMARY KEY (id);


--
-- Name: rapns_feedback_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rapns_feedback
    ADD CONSTRAINT rapns_feedback_pkey PRIMARY KEY (id);


--
-- Name: rapns_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rapns_notifications
    ADD CONSTRAINT rapns_notifications_pkey PRIMARY KEY (id);


--
-- Name: settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_locations_on_session_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_locations_on_session_id ON locations USING btree (session_id);


--
-- Name: index_rapns_feedback_on_device_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_rapns_feedback_on_device_token ON rapns_feedback USING btree (device_token);


--
-- Name: index_rapns_notifications_multi; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_rapns_notifications_multi ON rapns_notifications USING btree (app_id, delivered, failed, deliver_after);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20130820165845');

INSERT INTO schema_migrations (version) VALUES ('20130820184249');

INSERT INTO schema_migrations (version) VALUES ('20130825131442');

INSERT INTO schema_migrations (version) VALUES ('20130910123149');

INSERT INTO schema_migrations (version) VALUES ('20130920205148');

INSERT INTO schema_migrations (version) VALUES ('20130926112229');

INSERT INTO schema_migrations (version) VALUES ('20130927210520');

INSERT INTO schema_migrations (version) VALUES ('20130928214126');

INSERT INTO schema_migrations (version) VALUES ('20130930201453');

INSERT INTO schema_migrations (version) VALUES ('20131003234939');

INSERT INTO schema_migrations (version) VALUES ('20131005151906');

INSERT INTO schema_migrations (version) VALUES ('20131016085952');

INSERT INTO schema_migrations (version) VALUES ('20131017064443');

INSERT INTO schema_migrations (version) VALUES ('20131101144521');

INSERT INTO schema_migrations (version) VALUES ('20131101144522');

INSERT INTO schema_migrations (version) VALUES ('20131101144523');

INSERT INTO schema_migrations (version) VALUES ('20131101144524');

INSERT INTO schema_migrations (version) VALUES ('20131101144525');

INSERT INTO schema_migrations (version) VALUES ('20131101144526');

INSERT INTO schema_migrations (version) VALUES ('20131101144816');

INSERT INTO schema_migrations (version) VALUES ('20131102223522');
