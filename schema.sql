--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE ONLY evoting.surveys_questions DROP CONSTRAINT surveys_questions_survey_fkey;
ALTER TABLE ONLY evoting.surveys_questions DROP CONSTRAINT surveys_questions_question_fkey;
ALTER TABLE ONLY evoting.surveys DROP CONSTRAINT survey_owner_fkey;
ALTER TABLE ONLY evoting.sessions_results DROP CONSTRAINT sessions_results_voter_fkey;
ALTER TABLE ONLY evoting.sessions_results DROP CONSTRAINT sessions_results_session_fkey;
ALTER TABLE ONLY evoting.sessions_results DROP CONSTRAINT sessions_results_question_fkey;
ALTER TABLE ONLY evoting.sessions_results DROP CONSTRAINT sessions_results_answer_fkey;
ALTER TABLE ONLY evoting.questions_answers DROP CONSTRAINT questions_answers_question_fkey;
ALTER TABLE ONLY evoting.questions_answers DROP CONSTRAINT questions_answers_answer_fkey;
ALTER TABLE ONLY evoting.users DROP CONSTRAINT users_pkey;
ALTER TABLE ONLY evoting.surveys_questions DROP CONSTRAINT surveys_questions_pkey;
ALTER TABLE ONLY evoting.surveys DROP CONSTRAINT survey_pkey;
ALTER TABLE ONLY evoting.sessions_results DROP CONSTRAINT sessions_results_pkey;
ALTER TABLE ONLY evoting.sessions DROP CONSTRAINT sessions_pkey;
ALTER TABLE ONLY evoting.questions DROP CONSTRAINT questions_pkey;
ALTER TABLE ONLY evoting.questions_answers DROP CONSTRAINT questions_answers_pkey;
ALTER TABLE ONLY evoting.answers DROP CONSTRAINT answers_pkey;
ALTER TABLE evoting.users ALTER COLUMN id DROP DEFAULT;
ALTER TABLE evoting.surveys ALTER COLUMN id DROP DEFAULT;
ALTER TABLE evoting.sessions ALTER COLUMN id DROP DEFAULT;
ALTER TABLE evoting.questions ALTER COLUMN id DROP DEFAULT;
ALTER TABLE evoting.answers ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE evoting.users_id_seq;
DROP TABLE evoting.users;
DROP TABLE evoting.surveys_questions;
DROP SEQUENCE evoting.survey_id_seq;
DROP TABLE evoting.surveys;
DROP VIEW evoting.sessions_statistics;
DROP TABLE evoting.sessions_results;
DROP SEQUENCE evoting.sessions_id_seq;
DROP TABLE evoting.sessions;
DROP SEQUENCE evoting.questions_id_seq;
DROP TABLE evoting.questions_answers;
DROP TABLE evoting.questions;
DROP SEQUENCE evoting.answers_id_seq;
DROP TABLE evoting.answers;
DROP FUNCTION evoting.random_text(length integer);
DROP SCHEMA evoting;
--
-- Name: evoting; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA evoting;


--
-- Name: random_text(integer); Type: FUNCTION; Schema: evoting; Owner: -
--

CREATE FUNCTION evoting.random_text(length integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$ 
DECLARE 
  possible_chars TEXT := '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'; 
  output TEXT := '';
  i INT4;
  chars_size INTEGER; 
BEGIN
  chars_size := length(possible_chars);
  FOR i IN 1..length LOOP 
    output := output || substr(
      possible_chars, 
      (1 + FLOOR((chars_size - $1 + 1) * random() ))::INTEGER, 1);
  END LOOP;
  RETURN output;
END; $_$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: answers; Type: TABLE; Schema: evoting; Owner: -
--

CREATE TABLE evoting.answers (
    id integer NOT NULL,
    answer text
);


--
-- Name: answers_id_seq; Type: SEQUENCE; Schema: evoting; Owner: -
--

CREATE SEQUENCE evoting.answers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: answers_id_seq; Type: SEQUENCE OWNED BY; Schema: evoting; Owner: -
--

ALTER SEQUENCE evoting.answers_id_seq OWNED BY evoting.answers.id;


--
-- Name: questions; Type: TABLE; Schema: evoting; Owner: -
--

CREATE TABLE evoting.questions (
    id integer NOT NULL,
    question text
);


--
-- Name: questions_answers; Type: TABLE; Schema: evoting; Owner: -
--

CREATE TABLE evoting.questions_answers (
    question integer NOT NULL,
    answer integer NOT NULL
);


--
-- Name: questions_id_seq; Type: SEQUENCE; Schema: evoting; Owner: -
--

CREATE SEQUENCE evoting.questions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: questions_id_seq; Type: SEQUENCE OWNED BY; Schema: evoting; Owner: -
--

ALTER SEQUENCE evoting.questions_id_seq OWNED BY evoting.questions.id;


--
-- Name: sessions; Type: TABLE; Schema: evoting; Owner: -
--

CREATE TABLE evoting.sessions (
    id integer NOT NULL,
    sessiondate date DEFAULT CURRENT_DATE NOT NULL
);


--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: evoting; Owner: -
--

CREATE SEQUENCE evoting.sessions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: evoting; Owner: -
--

ALTER SEQUENCE evoting.sessions_id_seq OWNED BY evoting.sessions.id;


--
-- Name: sessions_results; Type: TABLE; Schema: evoting; Owner: -
--

CREATE TABLE evoting.sessions_results (
    session integer NOT NULL,
    voter integer NOT NULL,
    question integer NOT NULL,
    answer integer NOT NULL
);


--
-- Name: sessions_statistics; Type: VIEW; Schema: evoting; Owner: -
--

CREATE VIEW evoting.sessions_statistics AS
 SELECT session,
    question,
    answer,
    count(voter) AS count
   FROM evoting.sessions_results
  GROUP BY session, question, answer;


--
-- Name: surveys; Type: TABLE; Schema: evoting; Owner: -
--

CREATE TABLE evoting.surveys (
    id integer NOT NULL,
    owner integer,
    title text
);


--
-- Name: survey_id_seq; Type: SEQUENCE; Schema: evoting; Owner: -
--

CREATE SEQUENCE evoting.survey_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: survey_id_seq; Type: SEQUENCE OWNED BY; Schema: evoting; Owner: -
--

ALTER SEQUENCE evoting.survey_id_seq OWNED BY evoting.surveys.id;


--
-- Name: surveys_questions; Type: TABLE; Schema: evoting; Owner: -
--

CREATE TABLE evoting.surveys_questions (
    survey integer NOT NULL,
    question integer NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: evoting; Owner: -
--

CREATE TABLE evoting.users (
    id integer NOT NULL,
    login text NOT NULL,
    password text,
    fullname text,
    email text,
    admin boolean DEFAULT false,
    token text DEFAULT evoting.random_text(15)
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: evoting; Owner: -
--

CREATE SEQUENCE evoting.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: evoting; Owner: -
--

ALTER SEQUENCE evoting.users_id_seq OWNED BY evoting.users.id;


--
-- Name: answers id; Type: DEFAULT; Schema: evoting; Owner: -
--

ALTER TABLE ONLY evoting.answers ALTER COLUMN id SET DEFAULT nextval('evoting.answers_id_seq'::regclass);


--
-- Name: questions id; Type: DEFAULT; Schema: evoting; Owner: -
--

ALTER TABLE ONLY evoting.questions ALTER COLUMN id SET DEFAULT nextval('evoting.questions_id_seq'::regclass);


--
-- Name: sessions id; Type: DEFAULT; Schema: evoting; Owner: -
--

ALTER TABLE ONLY evoting.sessions ALTER COLUMN id SET DEFAULT nextval('evoting.sessions_id_seq'::regclass);


--
-- Name: surveys id; Type: DEFAULT; Schema: evoting; Owner: -
--

ALTER TABLE ONLY evoting.surveys ALTER COLUMN id SET DEFAULT nextval('evoting.survey_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: evoting; Owner: -
--

ALTER TABLE ONLY evoting.users ALTER COLUMN id SET DEFAULT nextval('evoting.users_id_seq'::regclass);


--
-- Name: answers answers_pkey; Type: CONSTRAINT; Schema: evoting; Owner: -
--

ALTER TABLE ONLY evoting.answers
    ADD CONSTRAINT answers_pkey PRIMARY KEY (id);


--
-- Name: questions_answers questions_answers_pkey; Type: CONSTRAINT; Schema: evoting; Owner: -
--

ALTER TABLE ONLY evoting.questions_answers
    ADD CONSTRAINT questions_answers_pkey PRIMARY KEY (question, answer);


--
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: evoting; Owner: -
--

ALTER TABLE ONLY evoting.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: evoting; Owner: -
--

ALTER TABLE ONLY evoting.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sessions_results sessions_results_pkey; Type: CONSTRAINT; Schema: evoting; Owner: -
--

ALTER TABLE ONLY evoting.sessions_results
    ADD CONSTRAINT sessions_results_pkey PRIMARY KEY (session, voter, question, answer);


--
-- Name: surveys survey_pkey; Type: CONSTRAINT; Schema: evoting; Owner: -
--

ALTER TABLE ONLY evoting.surveys
    ADD CONSTRAINT survey_pkey PRIMARY KEY (id);


--
-- Name: surveys_questions surveys_questions_pkey; Type: CONSTRAINT; Schema: evoting; Owner: -
--

ALTER TABLE ONLY evoting.surveys_questions
    ADD CONSTRAINT surveys_questions_pkey PRIMARY KEY (survey, question);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: evoting; Owner: -
--

ALTER TABLE ONLY evoting.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: questions_answers questions_answers_answer_fkey; Type: FK CONSTRAINT; Schema: evoting; Owner: -
--

ALTER TABLE ONLY evoting.questions_answers
    ADD CONSTRAINT questions_answers_answer_fkey FOREIGN KEY (answer) REFERENCES evoting.answers(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: questions_answers questions_answers_question_fkey; Type: FK CONSTRAINT; Schema: evoting; Owner: -
--

ALTER TABLE ONLY evoting.questions_answers
    ADD CONSTRAINT questions_answers_question_fkey FOREIGN KEY (question) REFERENCES evoting.questions(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: sessions_results sessions_results_answer_fkey; Type: FK CONSTRAINT; Schema: evoting; Owner: -
--

ALTER TABLE ONLY evoting.sessions_results
    ADD CONSTRAINT sessions_results_answer_fkey FOREIGN KEY (answer) REFERENCES evoting.answers(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: sessions_results sessions_results_question_fkey; Type: FK CONSTRAINT; Schema: evoting; Owner: -
--

ALTER TABLE ONLY evoting.sessions_results
    ADD CONSTRAINT sessions_results_question_fkey FOREIGN KEY (question) REFERENCES evoting.questions(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: sessions_results sessions_results_session_fkey; Type: FK CONSTRAINT; Schema: evoting; Owner: -
--

ALTER TABLE ONLY evoting.sessions_results
    ADD CONSTRAINT sessions_results_session_fkey FOREIGN KEY (session) REFERENCES evoting.sessions(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: sessions_results sessions_results_voter_fkey; Type: FK CONSTRAINT; Schema: evoting; Owner: -
--

ALTER TABLE ONLY evoting.sessions_results
    ADD CONSTRAINT sessions_results_voter_fkey FOREIGN KEY (voter) REFERENCES evoting.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: surveys survey_owner_fkey; Type: FK CONSTRAINT; Schema: evoting; Owner: -
--

ALTER TABLE ONLY evoting.surveys
    ADD CONSTRAINT survey_owner_fkey FOREIGN KEY (owner) REFERENCES evoting.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: surveys_questions surveys_questions_question_fkey; Type: FK CONSTRAINT; Schema: evoting; Owner: -
--

ALTER TABLE ONLY evoting.surveys_questions
    ADD CONSTRAINT surveys_questions_question_fkey FOREIGN KEY (question) REFERENCES evoting.questions(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: surveys_questions surveys_questions_survey_fkey; Type: FK CONSTRAINT; Schema: evoting; Owner: -
--

ALTER TABLE ONLY evoting.surveys_questions
    ADD CONSTRAINT surveys_questions_survey_fkey FOREIGN KEY (survey) REFERENCES evoting.surveys(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

