--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
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
-- Name: games; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE games (
    id integer NOT NULL,
    "time" timestamp without time zone,
    away_id integer,
    home_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    home_score integer,
    away_score integer,
    season_id integer NOT NULL
);


--
-- Name: games_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE games_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: games_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE games_id_seq OWNED BY games.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: seasons; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE seasons (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: seasons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE seasons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: seasons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE seasons_id_seq OWNED BY seasons.id;


--
-- Name: seed_migration_data_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE seed_migration_data_migrations (
    id integer NOT NULL,
    version character varying,
    runtime integer,
    migrated_on timestamp without time zone
);


--
-- Name: seed_migration_data_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE seed_migration_data_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: seed_migration_data_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE seed_migration_data_migrations_id_seq OWNED BY seed_migration_data_migrations.id;


--
-- Name: teams; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE teams (
    id integer NOT NULL,
    name character varying,
    abbr character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    season_id integer NOT NULL
);


--
-- Name: teams_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE teams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE teams_id_seq OWNED BY teams.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY games ALTER COLUMN id SET DEFAULT nextval('games_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY seasons ALTER COLUMN id SET DEFAULT nextval('seasons_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY seed_migration_data_migrations ALTER COLUMN id SET DEFAULT nextval('seed_migration_data_migrations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY teams ALTER COLUMN id SET DEFAULT nextval('teams_id_seq'::regclass);


--
-- Name: games_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY games
    ADD CONSTRAINT games_pkey PRIMARY KEY (id);


--
-- Name: seasons_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY seasons
    ADD CONSTRAINT seasons_pkey PRIMARY KEY (id);


--
-- Name: seed_migration_data_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY seed_migration_data_migrations
    ADD CONSTRAINT seed_migration_data_migrations_pkey PRIMARY KEY (id);


--
-- Name: teams_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- Name: index_games_on_away_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_games_on_away_id ON games USING btree (away_id);


--
-- Name: index_games_on_home_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_games_on_home_id ON games USING btree (home_id);


--
-- Name: index_teams_on_abbr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_teams_on_abbr ON teams USING btree (abbr);


--
-- Name: index_teams_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_teams_on_name ON teams USING btree (name);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_rails_3d11ee4f94; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY games
    ADD CONSTRAINT fk_rails_3d11ee4f94 FOREIGN KEY (home_id) REFERENCES teams(id);


--
-- Name: fk_rails_5fef1fc74c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY teams
    ADD CONSTRAINT fk_rails_5fef1fc74c FOREIGN KEY (season_id) REFERENCES seasons(id);


--
-- Name: fk_rails_9703f316d0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY games
    ADD CONSTRAINT fk_rails_9703f316d0 FOREIGN KEY (away_id) REFERENCES teams(id);


--
-- Name: fk_rails_af8980af68; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY games
    ADD CONSTRAINT fk_rails_af8980af68 FOREIGN KEY (season_id) REFERENCES seasons(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20150829184204');

INSERT INTO schema_migrations (version) VALUES ('20150830005722');

INSERT INTO schema_migrations (version) VALUES ('20150830005729');

INSERT INTO schema_migrations (version) VALUES ('20150914032434');

INSERT INTO schema_migrations (version) VALUES ('20151021032406');

INSERT INTO schema_migrations (version) VALUES ('20151024024241');

