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

--
-- Data for Name: answers; Type: TABLE DATA; Schema: evoting; Owner: -
--

COPY evoting.answers (id, answer) FROM stdin;
1	Bleu
2	Rouge
3	Jaune
4	Chien
5	Chat
6	Poisson rouge
\.


--
-- Data for Name: questions; Type: TABLE DATA; Schema: evoting; Owner: -
--

COPY evoting.questions (id, question) FROM stdin;
1	Quelle est votre couleur préférée ?
2	Quelle est votre animal préféré ?
\.


--
-- Data for Name: questions_answers; Type: TABLE DATA; Schema: evoting; Owner: -
--

COPY evoting.questions_answers (question, answer) FROM stdin;
1	1
1	2
1	3
2	4
2	5
2	6
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: evoting; Owner: -
--

COPY evoting.sessions (id, sessiondate) FROM stdin;
1	2025-04-06
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: evoting; Owner: -
--

COPY evoting.users (id, login, password, fullname, email, admin, token) FROM stdin;
2	admin	abc	\N	\N	t	v1uqBwqmkd0j9A9
1	francois	password	FH	anne.onyme@le.fr	f	HCr8orqJqa9Kku8
\.


--
-- Data for Name: sessions_results; Type: TABLE DATA; Schema: evoting; Owner: -
--

COPY evoting.sessions_results (session, voter, question, answer) FROM stdin;
\.


--
-- Data for Name: surveys; Type: TABLE DATA; Schema: evoting; Owner: -
--

COPY evoting.surveys (id, owner, title) FROM stdin;
1	1	Mon assemblée générale
\.


--
-- Data for Name: surveys_questions; Type: TABLE DATA; Schema: evoting; Owner: -
--

COPY evoting.surveys_questions (survey, question) FROM stdin;
1	1
1	2
\.


--
-- Name: answers_id_seq; Type: SEQUENCE SET; Schema: evoting; Owner: -
--

SELECT pg_catalog.setval('evoting.answers_id_seq', 6, true);


--
-- Name: questions_id_seq; Type: SEQUENCE SET; Schema: evoting; Owner: -
--

SELECT pg_catalog.setval('evoting.questions_id_seq', 2, true);


--
-- Name: sessions_id_seq; Type: SEQUENCE SET; Schema: evoting; Owner: -
--

SELECT pg_catalog.setval('evoting.sessions_id_seq', 1, true);


--
-- Name: survey_id_seq; Type: SEQUENCE SET; Schema: evoting; Owner: -
--

SELECT pg_catalog.setval('evoting.survey_id_seq', 1, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: evoting; Owner: -
--

SELECT pg_catalog.setval('evoting.users_id_seq', 2, true);


--
-- PostgreSQL database dump complete
--

