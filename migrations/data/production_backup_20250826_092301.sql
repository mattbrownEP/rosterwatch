--
-- PostgreSQL database dump
--

-- Dumped from database version 16.9 (84ade85)
-- Dumped by pg_dump version 17.5

-- Started on 2025-08-26 09:23:01 UTC

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

DROP DATABASE neondb;
--
-- TOC entry 3360 (class 1262 OID 16389)
-- Name: neondb; Type: DATABASE; Schema: -; Owner: neondb_owner
--

CREATE DATABASE neondb WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C.UTF-8';


ALTER DATABASE neondb OWNER TO neondb_owner;

\connect neondb

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 16475)
-- Name: monitored_url; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.monitored_url (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    url character varying(500) NOT NULL,
    email character varying(120) NOT NULL,
    last_checked timestamp without time zone,
    last_content_hash character varying(64),
    is_active boolean,
    created_at timestamp without time zone,
    state character varying(2),
    institution_type character varying(20) DEFAULT 'public'::character varying,
    conference character varying(100),
    open_records_contact character varying(200),
    open_records_email character varying(120),
    response_time_days integer DEFAULT 10
);


ALTER TABLE public.monitored_url OWNER TO neondb_owner;

--
-- TOC entry 216 (class 1259 OID 16482)
-- Name: monitored_url_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.monitored_url_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.monitored_url_id_seq OWNER TO neondb_owner;

--
-- TOC entry 3362 (class 0 OID 0)
-- Dependencies: 216
-- Name: monitored_url_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.monitored_url_id_seq OWNED BY public.monitored_url.id;


--
-- TOC entry 217 (class 1259 OID 16483)
-- Name: scraping_log; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.scraping_log (
    id integer NOT NULL,
    monitored_url_id integer NOT NULL,
    status character varying(50) NOT NULL,
    message text,
    scraped_at timestamp without time zone
);


ALTER TABLE public.scraping_log OWNER TO neondb_owner;

--
-- TOC entry 218 (class 1259 OID 16488)
-- Name: scraping_log_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.scraping_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.scraping_log_id_seq OWNER TO neondb_owner;

--
-- TOC entry 3363 (class 0 OID 0)
-- Dependencies: 218
-- Name: scraping_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.scraping_log_id_seq OWNED BY public.scraping_log.id;


--
-- TOC entry 219 (class 1259 OID 16489)
-- Name: staff_change; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.staff_change (
    id integer NOT NULL,
    monitored_url_id integer NOT NULL,
    change_type character varying(50) NOT NULL,
    staff_name character varying(200),
    staff_title character varying(200),
    change_description text,
    detected_at timestamp without time zone,
    email_sent boolean,
    position_importance character varying(20) DEFAULT 'standard'::character varying,
    likely_contract_value character varying(20),
    open_records_filed boolean DEFAULT false,
    open_records_date timestamp without time zone,
    open_records_status character varying(50) DEFAULT 'not_filed'::character varying
);


ALTER TABLE public.staff_change OWNER TO neondb_owner;

--
-- TOC entry 220 (class 1259 OID 16497)
-- Name: staff_change_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.staff_change_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.staff_change_id_seq OWNER TO neondb_owner;

--
-- TOC entry 3364 (class 0 OID 0)
-- Dependencies: 220
-- Name: staff_change_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.staff_change_id_seq OWNED BY public.staff_change.id;


--
-- TOC entry 3190 (class 2604 OID 16498)
-- Name: monitored_url id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.monitored_url ALTER COLUMN id SET DEFAULT nextval('public.monitored_url_id_seq'::regclass);


--
-- TOC entry 3193 (class 2604 OID 16499)
-- Name: scraping_log id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.scraping_log ALTER COLUMN id SET DEFAULT nextval('public.scraping_log_id_seq'::regclass);


--
-- TOC entry 3194 (class 2604 OID 16500)
-- Name: staff_change id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.staff_change ALTER COLUMN id SET DEFAULT nextval('public.staff_change_id_seq'::regclass);


--
-- TOC entry 3349 (class 0 OID 16475)
-- Dependencies: 215
-- Data for Name: monitored_url; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.monitored_url (id, name, url, email, last_checked, last_content_hash, is_active, created_at, state, institution_type, conference, open_records_contact, open_records_email, response_time_days) FROM stdin;
654	Indiana	https://iuhoosiers.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 16:02:10.593126	580ebbe0223f3906dc0ee9b290e57b4030689234df67141eb060f8870d895dac	f	2025-08-18 01:20:18.745416		public	\N	\N	\N	10
659	James Madison	https://jmusports.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 16:02:18.269166	dcb4273f140f9473bb8849cbc8d92348a513562c11d003deb3719813d8205b87	f	2025-08-18 01:20:19.194347	VA	public	\N	\N	\N	10
666	Long Beach State	https://longbeachstate.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 16:02:22.35114	6c26c0952cb306873dba90835ff1d998d976c0ef360541e9007542348e3043a7	f	2025-08-18 01:20:19.815479		public	\N	\N	\N	10
674	Mississippi State	https://hailstate.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 16:02:30.381738	7820340969bae86aa51c7d19cc3babc568a9bc8f700b8d549471e651324b8135	f	2025-08-18 01:20:20.522615		public	\N	\N	\N	10
680	Murray State	https://goracers.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 16:02:34.072238	7820340969bae86aa51c7d19cc3babc568a9bc8f700b8d549471e651324b8135	f	2025-08-18 01:20:21.052275		public	\N	\N	\N	10
606	Alabama A&M Athletics	https://aamusports.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:18:28.406571	9abfe8a34f0432cb2d1074ce056ad91c12cfb9255b7762c765fdb04c9d1fecda	f	2025-08-18 01:20:14.432817		public	\N	\N	\N	10
607	Alabama State University	https://bamastatesports.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:18:40.106082	cdd1c428a72f36a0c74d8444e2a05da3771cf238d4994e3fbbdb78e2cf355e99	f	2025-08-18 01:20:14.542538		public	\N	\N	\N	10
608	Alcorn State	https://alcornsports.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:18:52.077196	aad1595381e42f36160a5863bbd1cb875654f2162508e566fb4ea64f9e5f1c3d	f	2025-08-18 01:20:14.652292		public	\N	\N	\N	10
609	Appalachian State	https://appstatesports.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:19:02.676521	2328211173e9b41c4b4f8ffb05fcde3d4a0133f25896b839e1febe33977b5530	f	2025-08-18 01:20:14.740649		public	\N	\N	\N	10
610	Arizona	https://arizonawildcats.com/sports/2007/8/1/207969432.aspx	Matt@ExtraPointsMB.com	2025-08-20 15:19:18.320298	e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855	f	2025-08-18 01:20:14.828282		public	\N	\N	\N	10
611	Arizona State	https://thesundevils.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:19:36.538734	e2689d68bda7439ea4f3b8dafcf4eef56538f7c22f861d4a2f40ce54a15f8cd6	f	2025-08-18 01:20:14.916272		public	\N	\N	\N	10
612	Arkansas State University	https://astateredwolves.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:19:51.86149	d2fe5172ced97063864f724f77b41b085f5b6ed4cf19ff20e09f5623ee1077f5	f	2025-08-18 01:20:15.003523		public	\N	\N	\N	10
613	Auburn	https://auburntigers.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:20:11.290603	649d3b22f8506064fbc2c7344cd62ed4918a97039007b78984e5dd583347b55e	f	2025-08-18 01:20:15.091456		public	\N	\N	\N	10
614	Austin Peay	https://letsgopeay.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:20:26.105902	1f4476c7ea974882568f544dd6e2940dcdd48bfcc2e55637e4659bc9d1663a93	f	2025-08-18 01:20:15.179922		public	\N	\N	\N	10
615	Ball State	https://ballstatesports.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:20:54.744251	9066b434cd7661db92b09d384745a53d5708130dea459dd620c71061613974fc	f	2025-08-18 01:20:15.266977		public	\N	\N	\N	10
616	Binghamton	https://binghamtonbearcats.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:21:07.286162	2332975de1641cba7b4ab3bb3d9dd35448192e6d82f6fda0de70d0738f9ff3dd	f	2025-08-18 01:20:15.354718		public	\N	\N	\N	10
617	Boise State	https://broncosports.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:21:25.626371	6b64c6f99617f817e6d2c3b44ed0d6c57d8d10be07bf15256700c9fc8d7e0bb4	f	2025-08-18 01:20:15.442713		public	\N	\N	\N	10
618	Bowling Green	https://bgsufalcons.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:21:43.713895	6f756a972c342843b0819023b2e196a96fde87462492bd7f4fc90845e5255706	f	2025-08-18 01:20:15.531465		public	\N	\N	\N	10
621	Cal State Fullerton	https://fullertontitans.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:22:22.804385	153ac514d36db6585ddb41018a31eaa38108472c530fa80ba2f4b1bd0602b4d6	f	2025-08-18 01:20:15.800769		public	\N	\N	\N	10
622	Cal State Northridge	https://gomatadors.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:22:36.896118	8cb77f2fe51c7be8bc8a7f0e5cb836835b14fc1a5eb86639c7d6a9f59a5be414	f	2025-08-18 01:20:15.887967		public	\N	\N	\N	10
623	Central Connecticut State University	https://ccsubluedevils.com/athletics/directory/index	Matt@ExtraPointsMB.com	2025-08-20 15:22:50.779898	83bd2815731b7b193493eb65fbeabdb0628373738eefdbca5c802c7e6ccb46b9	f	2025-08-18 01:20:15.977581		public	\N	\N	\N	10
624	Central Michigan	https://cmuchippewas.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:23:05.623799	4d7081840e50036d56a47fd4e61a2f5c05f4837b089fe50984e6eba60f067d34	f	2025-08-18 01:20:16.065643		public	\N	\N	\N	10
625	Chicago State	https://www.gocsucougars.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:23:19.191473	c20f1bb4df921c498f1a6f22b50a44b846b1f76d301c2038f6001654008d0f8d	f	2025-08-18 01:20:16.155868		public	\N	\N	\N	10
626	Clemson	https://clemsontigers.com/staff-directory/	Matt@ExtraPointsMB.com	2025-08-20 15:23:28.848605	3ba2959c0275697d3275904fab2beb17bc9330e2fb3682ce0e2161f4627aecd7	f	2025-08-18 01:20:16.244503		public	\N	\N	\N	10
627	Cleveland State	https://csuvikings.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:23:40.546253	329e6f7ab6b19aa0f84092966da5132640718d5e1b9423ee819c12420094c860	f	2025-08-18 01:20:16.339622		public	\N	\N	\N	10
628	Coastal Carolina	https://goccusports.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:23:52.640401	28b1cbfb117dda75acf77d9f26226627e6b46ddb1c6d565c92d2631d5c7916dd	f	2025-08-18 01:20:16.427589		public	\N	\N	\N	10
629	College of Charleston	https://cofcsports.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:24:06.515088	6150050de2db9a7e4ed249c1f22493a8eeef6640db07f6f266b631ab30148dfe	f	2025-08-18 01:20:16.522248		public	\N	\N	\N	10
630	Colorado	https://cubuffs.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:24:24.569206	6b64c6f99617f817e6d2c3b44ed0d6c57d8d10be07bf15256700c9fc8d7e0bb4	f	2025-08-18 01:20:16.611077		public	\N	\N	\N	10
631	Colorado State	https://csurams.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:24:39.716375	f9a452ba29677a00ba0a1ad0a86792ea5c4ddf76445e64968db5956c7a49ea5c	f	2025-08-18 01:20:16.707024		public	\N	\N	\N	10
633	ECU	https://ecupirates.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:25:09.190772	7820340969bae86aa51c7d19cc3babc568a9bc8f700b8d549471e651324b8135	f	2025-08-18 01:20:16.886156		public	\N	\N	\N	10
634	EKU	https://ekusports.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:25:19.405593	c9cc037cacd5792f35f0e10b0f9977637fd98fca1e9c265d69a91216d7592093	f	2025-08-18 01:20:16.980025		public	\N	\N	\N	10
635	ETSU	https://etsubucs.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:25:29.659326	9d2159db063e63618367ec4174c15a04963897b669c1dffe9ae4be43247edb19	f	2025-08-18 01:20:17.06863		public	\N	\N	\N	10
636	East Texas A&M University	https://lionathletics.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:25:40.250636	94cbb519f0b1d1b18bc63129c357e3bf8e60e13b83be71b46768820523c91e91	f	2025-08-18 01:20:17.155838		public	\N	\N	\N	10
637	Eastern Illinois	https://eiupanthers.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:25:54.034906	b59d60ecbbff7b0db538509f0bfba8a12e8964d7c66d13097afb88d8edf1543e	f	2025-08-18 01:20:17.243574		public	\N	\N	\N	10
638	Eastern Michigan	https://emueagles.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:26:09.578162	368caa287b773c129f597c5337d443db2f8b0896e76fd055b1645a961969b1b1	f	2025-08-18 01:20:17.332368		public	\N	\N	\N	10
639	Eastern Washington University	https://goeags.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:26:21.50189	e1c896ee928876fedc70bdd1d75c14cbb98259bcad2e59db56f523fe1ea2951d	f	2025-08-18 01:20:17.421011		public	\N	\N	\N	10
640	FAMU	https://famuathletics.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:26:33.973003	354cc999e1d2836f1e499b9d09c73eb0abe296ca2cddd6550e4f59cc2b1a4bb0	f	2025-08-18 01:20:17.509695		public	\N	\N	\N	10
641	FAU	https://fausports.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:26:53.400282	6f756a972c342843b0819023b2e196a96fde87462492bd7f4fc90845e5255706	f	2025-08-18 01:20:17.597292		public	\N	\N	\N	10
642	Florida Gulf Coast	https://fgcuathletics.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:27:07.147129	a5f855649a161ef1e033bc43cb1972cc16b0d40fb97a3154bb591a38b38db91b	f	2025-08-18 01:20:17.686532		public	\N	\N	\N	10
643	Florida International	https://fiusports.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:27:19.395471	23e4e394631655775920f067560f624424c1d3f55cc7209dae5883ad496ceddd	f	2025-08-18 01:20:17.774626		public	\N	\N	\N	10
644	Fresno State	https://gobulldogs.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:27:40.971529	494074f84c729d3a0894a6ddeb6af263e0adbda9b3f077f32e6daf6219c35d39	f	2025-08-18 01:20:17.862221		public	\N	\N	\N	10
645	George Mason	https://gomason.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:27:54.878971	637da7996ff0d6768090ba34c35da0515c5554ed33fb4f36d5a0f29b3b60f3e3	f	2025-08-18 01:20:17.949526		public	\N	\N	\N	10
646	Georgia	https://georgiadogs.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:28:17.807517	2ebc4e714e0003594aa8aa6acf0abc4a8667c294f63829bfcaec17113bb81b25	f	2025-08-18 01:20:18.038174	GA	public	\N	\N	\N	10
647	Georgia Southern	https://gseagles.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:28:29.312617	6d64be18c5b3ebfe3bc9d1534f79fba141fab97926e9939e006cb9aee895da09	f	2025-08-18 01:20:18.126759		public	\N	\N	\N	10
648	Georgia State	https://georgiastatesports.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:28:41.720785	5cdd7bae1550bd641e2ef5614da42c7a0ecf104d840f0ab785a68a16839791a8	f	2025-08-18 01:20:18.215638	GA	public	\N	\N	\N	10
649	Georgia Tech	https://ramblinwreck.com/staff-directory/	Matt@ExtraPointsMB.com	2025-08-20 15:29:16.529397	9129ab7e6ee633ae9e40f339e3e8b1fdc3709630ff8cc9a3131fe88b47bbf20d	f	2025-08-18 01:20:18.302953		public	\N	\N	\N	10
650	Grambling	https://gsutigers.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:29:31.56658	cfdc8fc44785a7fc335a1c6561cc9a7f176873179c26587d9a89e6a66595d27b	f	2025-08-18 01:20:18.390595	TX	public	\N	\N	\N	10
651	IU Indy	https://iuindyjags.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:29:46.986452	6f552a4444cd956b620a1d6c9f5cde330b6edae2b74cd1b2e4bc4ff70394b3fa	f	2025-08-18 01:20:18.478884		public	\N	\N	\N	10
652	Idaho State	https://isubengals.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:30:04.187355	7f4fe38433565c78ad41ebf07bf4aa299dc2321bb94657a8aa2f344f2efe6ced	f	2025-08-18 01:20:18.56755		public	\N	\N	\N	10
653	Illinois State	https://goredbirds.com/staff-directory?path=general	Matt@ExtraPointsMB.com	2025-08-20 16:02:35.534672	90a9e5c29cea97af80a954ae7c2da1e031bf20ac4ffb6661757b13f4b2246c0e	f	2025-08-18 01:20:18.657758		public	\N	\N	\N	10
620	Cal State Bakersfield	https://gorunners.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:22:10.212824	4a679ab02c1597a747d8efb71ddf88d89fec8d3537908fc093b71f7202e4ab29	f	2025-08-18 01:20:15.71286		public	\N	\N	\N	10
656	Iowa State	https://cyclones.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 16:02:43.833745	22c8acf185f09c228f8806cdae40d6e7a9669cdb70016b7d8f59a2654af58257	f	2025-08-18 01:20:18.921992		public	\N	\N	\N	10
657	Jackson State	https://gojsutigers.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 16:02:47.483907	72b3684a47bd9a856caf45df6805cc2bbed7136a0cfb730d9ed9524fea200656	f	2025-08-18 01:20:19.016061	TX	public	\N	\N	\N	10
658	Jacksonville State	https://jaxstatesports.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 16:02:48.502785	2df675b6bf292025c83a680f8b5cfa28f5742eb482e814561df3789568dce3b7	f	2025-08-18 01:20:19.10637		public	\N	\N	\N	10
660	Kansas	https://kuathletics.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 16:02:56.986629	4602cd1cc81d071bb7e79c59cc8d5fadc2c1eacad6dfa074294d9ac332ce4b77	f	2025-08-18 01:20:19.283931		public	\N	\N	\N	10
619	Cal Poly	https://gopoly.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:21:56.015086	35d70bbf44388cd3508e8751e6bbb7df6107f116ca3510c722466d3c130503b6	f	2025-08-18 01:20:15.61931		public	\N	\N	\N	10
632	Coppin State	https://coppinstatesports.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 15:24:51.716555	287d259c921c5d84801476f7aabbc05c341be4dd9e8c9df9b4551e0cde734bc5	f	2025-08-18 01:20:16.796604		public	\N	\N	\N	10
655	Indiana State	https://gosycamores.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 16:02:36.640984	b7bca2de9b988357520e33f51855758f1e91578c28204d0e114e95c4d931882e	f	2025-08-18 01:20:18.834521		public	\N	\N	\N	10
661	Kansas State	https://www.kstatesports.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 16:03:04.554721	1395254e4a57fa94c52232dcad1405883186bc2f730e012142fbd67340e00738	f	2025-08-18 01:20:19.371916		public	\N	\N	\N	10
662	Kennesaw State Athletics	https://ksuowls.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 16:03:07.467291	76c0ec13c53786e31219d61ececbe90e21be833ad6cc26d7a8b870d3f793a2bc	f	2025-08-18 01:20:19.459285		public	\N	\N	\N	10
663	Kent State	https://kentstatesports.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 16:03:09.237537	82eeefdfb3cf6c80ca373f933fba4c55be4c1561c122a5bb9cb72bac129af0bf	f	2025-08-18 01:20:19.546729		public	\N	\N	\N	10
664	LSU	https://lsusports.net/staff-directory/	Matt@ExtraPointsMB.com	2025-08-20 16:03:12.87629	e921217b11857542d43d4c1a991f2ee2ced655e6a011f1cba25f9df6f47469cb	f	2025-08-18 01:20:19.63757	LA	public	\N	\N	\N	10
665	Lamar	https://lamarcardinals.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 16:03:13.804572	e33ffbdc94336b3d7896ada987e907181d902113573d7362d044cadfc65d0768	f	2025-08-18 01:20:19.725508		public	\N	\N	\N	10
667	Longwood	https://longwoodlancers.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 16:03:14.906327	77692d82e952f35b5d5c741a04b3fe8e6b022ce479c6ef294d86c8249a3e14f0	f	2025-08-18 01:20:19.903393		public	\N	\N	\N	10
668	Louisiana Tech	https://latechsports.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 16:03:15.9746	084c773674db08758bb000fc83970563f701681c85f9df7e9b7e17d5c2c83959	f	2025-08-18 01:20:19.9921		public	\N	\N	\N	10
669	MTSU	https://goblueraiders.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 16:03:21.685094	4a54c9d5a6d9fd7ee0810a50a6b6edd25488c3d20414a768fc95fdb7c3ef0cf1	f	2025-08-18 01:20:20.079506		public	\N	\N	\N	10
670	Marshall	https://herdzone.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 16:03:25.051693	6b64c6f99617f817e6d2c3b44ed0d6c57d8d10be07bf15256700c9fc8d7e0bb4	f	2025-08-18 01:20:20.166802		public	\N	\N	\N	10
671	McNeese State	https://mcneesesports.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 16:03:26.519478	848596d82ca52659cc916373518a6baec17864ab26ee91a979f5550810c496c7	f	2025-08-18 01:20:20.255435		public	\N	\N	\N	10
672	Miami OH	https://miamiredhawks.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 16:03:28.059402	7ead5d380a8f73e6b885ae9fa6f2a5ec2e456b3b61c3da50c51aef9f61185c86	f	2025-08-18 01:20:20.346319	FL	public	\N	\N	\N	10
673	Michigan State	https://msuspartans.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 16:03:39.886375	83605c6655bb13f730a4ee2b9cab772020221e99b0e773e58ff283ef9a2d159b	f	2025-08-18 01:20:20.435016		public	\N	\N	\N	10
675	Mississippi State Valley State	https://mvsusports.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 16:03:41.414664	b3f32c227e3887dbd24d58f2b338a14b7f011aba198f1468d3b60a096163a40f	f	2025-08-18 01:20:20.614374		public	\N	\N	\N	10
676	Missouri State	https://missouristatebears.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 16:03:44.703831	54f4188647bc4ae6127fd98f6795879b5e5fdae12071f6501b6f500d263d7bc7	f	2025-08-18 01:20:20.702222		public	\N	\N	\N	10
677	Montana State University	https://msubobcats.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 16:03:56.467183	4602cd1cc81d071bb7e79c59cc8d5fadc2c1eacad6dfa074294d9ac332ce4b77	f	2025-08-18 01:20:20.79047		public	\N	\N	\N	10
678	Morehead State University	https://msueagles.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 16:03:57.84723	fa283413a2b8678240cb0fc13983924d31bd0da4c77c4e5a6755b0a7378c60c7	f	2025-08-18 01:20:20.877912		public	\N	\N	\N	10
679	Morgan State	https://morganstatebears.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 16:04:00.164105	886560c6325011fed1bed65b2438731a67efd474e21be4b1bac614279ee58d30	f	2025-08-18 01:20:20.96503		public	\N	\N	\N	10
681	NJIT	https://njithighlanders.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 16:04:02.894258	0b6d9689b43a1a42ede7b05763fa11f0bdae0e4b32e9acc2b57d59815682fad4	f	2025-08-18 01:20:21.140394		public	\N	\N	\N	10
682	New Mexico State	https://nmstatesports.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 16:04:05.650644	d19c70bc3a442999bf7ce891fd33cbf8fda57f1458282042fa52a766b263ba7f	f	2025-08-18 01:20:21.23079		public	\N	\N	\N	10
683	Nicholls State	https://geauxcolonels.com/staff-directory?path=gen	Matt@ExtraPointsMB.com	2025-08-20 16:04:07.017895	913b5d6f2a0584886f61b820f57901d10960f27bb4a14da7c84c02bc9f9bc35f	f	2025-08-18 01:20:21.318285		public	\N	\N	\N	10
684	Norfolk State	https://nsuspartans.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 16:04:09.261737	e53f561549f97385abb64f1e41134613fcd62d6832a419ea4a23a53129de7140	f	2025-08-18 01:20:21.406303		public	\N	\N	\N	10
685	Sacramento State	https://hornetsports.com/staff-directory	Matt@ExtraPointsMB.com	2025-08-20 16:04:12.278056	d12c7284f4e37ab75ea30236dc7c0318a48ccf650c340d3ca2b954c7685f3fd0	f	2025-08-18 01:20:21.493051		public	\N	\N	\N	10
\.


--
-- TOC entry 3351 (class 0 OID 16483)
-- Dependencies: 217
-- Data for Name: scraping_log; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.scraping_log (id, monitored_url_id, status, message, scraped_at) FROM stdin;
87	606	success	Successfully scraped 141 staff members	2025-08-19 10:33:36.954922
88	607	success	Successfully scraped 126 staff members	2025-08-19 10:33:36.954928
89	608	success	Successfully scraped 66 staff members	2025-08-19 10:33:36.954929
90	609	success	Successfully scraped 140 staff members	2025-08-19 10:33:36.95493
91	610	success	Successfully scraped 0 staff members	2025-08-19 10:33:36.954934
92	611	success	Successfully scraped 91 staff members	2025-08-19 10:33:36.954936
93	612	success	Successfully scraped 146 staff members	2025-08-19 10:33:36.954937
94	613	success	Successfully scraped 86 staff members	2025-08-19 10:33:36.954938
95	614	success	Successfully scraped 139 staff members	2025-08-19 10:33:36.954939
96	615	success	Successfully scraped 3 staff members	2025-08-19 10:33:36.954939
97	616	success	Successfully scraped 141 staff members	2025-08-19 10:33:36.95494
98	617	success	Successfully scraped 2 staff members	2025-08-19 10:33:36.954941
99	618	success	Successfully scraped 3 staff members	2025-08-19 10:33:36.954941
100	619	success	Successfully scraped 147 staff members	2025-08-19 10:33:36.954942
101	620	success	Successfully scraped 113 staff members	2025-08-19 10:33:36.954942
102	621	success	Successfully scraped 129 staff members	2025-08-19 10:33:36.954943
103	622	success	Successfully scraped 139 staff members	2025-08-19 10:33:36.954944
104	623	success	Successfully scraped 25 staff members	2025-08-19 10:33:36.954944
105	624	success	Successfully scraped 3 staff members	2025-08-19 10:33:36.954945
106	625	success	Successfully scraped 63 staff members	2025-08-19 10:33:36.954945
107	626	success	Successfully scraped 41 staff members	2025-08-19 10:33:36.954946
108	627	success	Successfully scraped 110 staff members	2025-08-19 10:33:36.954947
109	628	success	Successfully scraped 144 staff members	2025-08-19 10:33:36.954947
110	629	success	Successfully scraped 125 staff members	2025-08-19 10:33:36.954948
111	630	success	Successfully scraped 2 staff members	2025-08-19 10:33:36.954948
112	631	success	Successfully scraped 3 staff members	2025-08-19 10:33:36.954949
113	632	success	Successfully scraped 71 staff members	2025-08-19 10:33:36.95495
114	633	success	Successfully scraped 2 staff members	2025-08-19 10:33:36.95495
115	634	success	Successfully scraped 139 staff members	2025-08-19 10:33:36.954951
116	635	success	Successfully scraped 133 staff members	2025-08-19 10:33:36.954951
117	636	success	Successfully scraped 104 staff members	2025-08-19 10:33:36.954952
118	637	success	Successfully scraped 123 staff members	2025-08-19 10:33:36.954953
119	638	success	Successfully scraped 3 staff members	2025-08-19 10:33:36.954953
120	639	success	Successfully scraped 119 staff members	2025-08-19 10:33:36.954954
121	640	success	Successfully scraped 133 staff members	2025-08-19 10:33:36.954954
122	641	success	Successfully scraped 3 staff members	2025-08-19 10:33:36.954955
123	642	success	Successfully scraped 143 staff members	2025-08-19 10:33:36.954956
124	643	success	Successfully scraped 142 staff members	2025-08-19 10:33:36.954956
125	644	success	Successfully scraped 2 staff members	2025-08-19 10:33:36.954957
126	645	success	Successfully scraped 143 staff members	2025-08-19 10:33:36.954958
127	646	success	Successfully scraped 2 staff members	2025-08-19 10:33:36.954958
128	647	success	Successfully scraped 144 staff members	2025-08-19 10:33:36.954959
129	648	success	Successfully scraped 141 staff members	2025-08-19 10:33:36.954959
130	649	success	Successfully scraped 35 staff members	2025-08-19 10:33:36.95496
131	650	success	Successfully scraped 88 staff members	2025-08-19 10:33:36.95496
132	651	success	Successfully scraped 95 staff members	2025-08-19 10:33:36.954961
133	652	success	Successfully scraped 135 staff members	2025-08-19 10:33:36.954961
134	653	success	Successfully scraped 143 staff members	2025-08-19 10:33:36.954962
135	654	error	Failed to fetch URL after 3 attempts: 500 Server Error: Server Error for url: https://iuhoosiers.com/staff-directory	2025-08-19 10:33:36.954962
136	655	success	Successfully scraped 124 staff members	2025-08-19 10:33:36.954963
137	656	success	Successfully scraped 2 staff members	2025-08-19 10:33:36.954964
138	657	success	Successfully scraped 109 staff members	2025-08-19 10:33:36.954964
139	658	success	Successfully scraped 135 staff members	2025-08-19 10:33:36.954965
140	659	error	Failed to fetch URL after 3 attempts: 500 Server Error: Server Error for url: https://jmusports.com/staff-directory	2025-08-19 10:33:36.954965
141	660	success	Successfully scraped 2 staff members	2025-08-19 10:33:36.954966
142	661	success	Successfully scraped 2 staff members	2025-08-19 10:33:36.954966
143	662	success	Successfully scraped 141 staff members	2025-08-19 10:33:36.954967
144	663	success	Successfully scraped 146 staff members	2025-08-19 10:33:36.954967
145	664	success	Successfully scraped 83 staff members	2025-08-19 10:33:36.954968
146	665	success	Successfully scraped 134 staff members	2025-08-19 10:33:36.954969
147	666	error	Failed to fetch URL after 3 attempts: 404 Client Error: Not Found for url: https://longbeachstate.com/staff-directory	2025-08-19 10:33:36.95497
148	667	success	Successfully scraped 106 staff members	2025-08-19 10:33:36.95497
149	668	success	Successfully scraped 144 staff members	2025-08-19 10:33:36.954971
150	669	success	Successfully scraped 3 staff members	2025-08-19 10:33:36.954971
151	670	success	Successfully scraped 2 staff members	2025-08-19 10:33:36.954972
152	671	success	Successfully scraped 124 staff members	2025-08-19 10:33:36.954972
153	672	success	Successfully scraped 141 staff members	2025-08-19 10:33:36.954973
154	673	success	Successfully scraped 2 staff members	2025-08-19 10:33:36.954974
155	674	error	Failed to fetch URL after 3 attempts: 500 Server Error: Server Error for url: https://hailstate.com/staff-directory	2025-08-19 10:33:36.954974
156	675	success	Successfully scraped 62 staff members	2025-08-19 10:33:36.954975
157	676	success	Successfully scraped 145 staff members	2025-08-19 10:33:36.954975
158	677	success	Successfully scraped 2 staff members	2025-08-19 10:33:36.954982
159	678	success	Successfully scraped 92 staff members	2025-08-19 10:33:36.954983
160	679	success	Successfully scraped 121 staff members	2025-08-19 10:33:36.954983
161	680	error	Failed to fetch URL after 3 attempts: 404 Client Error: Not Found for url: https://goracers.com/staff-directory	2025-08-19 10:33:36.954984
162	681	success	Successfully scraped 115 staff members	2025-08-19 10:33:36.954985
163	682	success	Successfully scraped 147 staff members	2025-08-19 10:33:36.954985
164	683	success	Successfully scraped 98 staff members	2025-08-19 10:33:36.954986
165	684	success	Successfully scraped 91 staff members	2025-08-19 10:33:36.954986
166	685	success	Successfully scraped 139 staff members	2025-08-19 10:33:36.954987
167	606	success	Successfully scraped 141 staff members	2025-08-20 15:18:28.477714
168	607	success	Successfully scraped 124 staff members	2025-08-20 15:18:40.167356
169	608	success	Successfully scraped 66 staff members	2025-08-20 15:18:52.138557
170	609	success	Successfully scraped 140 staff members	2025-08-20 15:19:02.737661
171	610	success	Successfully scraped 0 staff members	2025-08-20 15:19:18.381532
172	611	success	Successfully scraped 91 staff members	2025-08-20 15:19:36.601956
173	612	success	Successfully scraped 146 staff members	2025-08-20 15:19:51.922642
174	613	success	Successfully scraped 86 staff members	2025-08-20 15:20:11.354085
175	614	success	Successfully scraped 139 staff members	2025-08-20 15:20:26.167326
176	615	success	Successfully scraped 3 staff members	2025-08-20 15:20:54.80559
177	616	success	Successfully scraped 143 staff members	2025-08-20 15:21:07.347639
178	617	success	Successfully scraped 2 staff members	2025-08-20 15:21:25.691444
179	618	success	Successfully scraped 3 staff members	2025-08-20 15:21:43.775202
180	619	success	Successfully scraped 147 staff members	2025-08-20 15:21:56.097648
181	620	success	Successfully scraped 113 staff members	2025-08-20 15:22:10.273911
182	621	success	Successfully scraped 129 staff members	2025-08-20 15:22:22.86523
183	622	success	Successfully scraped 139 staff members	2025-08-20 15:22:36.957679
184	623	success	Successfully scraped 25 staff members	2025-08-20 15:22:50.840761
185	624	success	Successfully scraped 3 staff members	2025-08-20 15:23:05.686486
186	625	success	Successfully scraped 63 staff members	2025-08-20 15:23:19.253586
187	626	success	Successfully scraped 41 staff members	2025-08-20 15:23:28.91077
188	627	success	Successfully scraped 110 staff members	2025-08-20 15:23:40.608501
189	628	success	Successfully scraped 144 staff members	2025-08-20 15:23:52.70314
190	629	success	Successfully scraped 125 staff members	2025-08-20 15:24:06.57731
191	630	success	Successfully scraped 2 staff members	2025-08-20 15:24:24.631242
192	631	success	Successfully scraped 3 staff members	2025-08-20 15:24:39.778958
193	632	success	Successfully scraped 71 staff members	2025-08-20 15:24:51.779654
194	633	success	Successfully scraped 3 staff members	2025-08-20 15:25:09.25308
195	634	success	Successfully scraped 139 staff members	2025-08-20 15:25:19.467773
196	635	success	Successfully scraped 134 staff members	2025-08-20 15:25:29.721484
197	636	success	Successfully scraped 107 staff members	2025-08-20 15:25:40.313515
198	637	success	Successfully scraped 123 staff members	2025-08-20 15:25:54.096893
199	638	success	Successfully scraped 3 staff members	2025-08-20 15:26:09.640396
200	639	success	Successfully scraped 118 staff members	2025-08-20 15:26:21.564096
201	640	success	Successfully scraped 133 staff members	2025-08-20 15:26:34.035005
202	641	success	Successfully scraped 3 staff members	2025-08-20 15:26:53.462502
203	642	success	Successfully scraped 143 staff members	2025-08-20 15:27:07.209529
204	643	success	Successfully scraped 142 staff members	2025-08-20 15:27:19.457934
205	644	success	Successfully scraped 3 staff members	2025-08-20 15:27:41.033702
206	645	success	Successfully scraped 143 staff members	2025-08-20 15:27:54.940957
207	646	success	Successfully scraped 3 staff members	2025-08-20 15:28:17.871151
208	647	success	Successfully scraped 144 staff members	2025-08-20 15:28:29.373859
209	648	success	Successfully scraped 141 staff members	2025-08-20 15:28:41.781992
210	649	success	Successfully scraped 35 staff members	2025-08-20 15:29:16.597214
211	650	success	Successfully scraped 89 staff members	2025-08-20 15:29:31.6338
212	651	success	Successfully scraped 95 staff members	2025-08-20 15:29:47.053846
213	652	success	Successfully scraped 135 staff members	2025-08-20 15:30:04.249605
214	653	success	Successfully scraped 143 staff members	2025-08-20 15:30:16.161942
215	654	success	Successfully scraped 3 staff members	2025-08-20 15:30:42.841523
216	655	success	Successfully scraped 124 staff members	2025-08-20 15:31:01.386749
217	657	success	Successfully scraped 109 staff members	2025-08-20 15:32:02.897564
218	658	success	Successfully scraped 135 staff members	2025-08-20 15:32:14.535477
219	659	success	Successfully scraped 3 staff members	2025-08-20 15:32:33.719973
220	660	success	Successfully scraped 3 staff members	2025-08-20 15:32:52.969352
221	661	success	Successfully scraped 3 staff members	2025-08-20 15:33:11.728017
222	662	success	Successfully scraped 141 staff members	2025-08-20 15:33:26.454731
223	663	success	Successfully scraped 146 staff members	2025-08-20 15:33:41.382783
224	664	success	Successfully scraped 83 staff members	2025-08-20 15:33:54.05546
225	665	success	Successfully scraped 134 staff members	2025-08-20 15:34:07.472422
226	666	success	Successfully scraped 3 staff members	2025-08-20 15:34:21.91292
227	667	success	Successfully scraped 108 staff members	2025-08-20 15:34:32.633891
228	668	success	Successfully scraped 144 staff members	2025-08-20 15:34:46.103008
229	669	success	Successfully scraped 3 staff members	2025-08-20 15:35:10.117875
230	670	success	Successfully scraped 2 staff members	2025-08-20 15:35:28.170473
231	671	success	Successfully scraped 124 staff members	2025-08-20 15:35:40.244965
232	672	success	Successfully scraped 141 staff members	2025-08-20 15:36:00.835066
233	673	success	Successfully scraped 3 staff members	2025-08-20 15:36:22.956711
234	674	success	Successfully scraped 3 staff members	2025-08-20 15:36:41.370496
235	675	success	Successfully scraped 62 staff members	2025-08-20 15:36:57.075121
236	676	success	Successfully scraped 145 staff members	2025-08-20 15:37:12.755324
237	677	success	Successfully scraped 3 staff members	2025-08-20 15:37:28.767421
238	678	success	Successfully scraped 92 staff members	2025-08-20 15:37:44.867886
239	679	success	Successfully scraped 121 staff members	2025-08-20 15:37:56.417872
240	680	success	Successfully scraped 3 staff members	2025-08-20 15:38:12.207467
241	681	success	Successfully scraped 114 staff members	2025-08-20 15:38:23.042284
242	682	success	Successfully scraped 147 staff members	2025-08-20 15:38:45.277049
243	683	success	Successfully scraped 98 staff members	2025-08-20 15:39:01.687859
244	684	success	Successfully scraped 91 staff members	2025-08-20 15:39:14.445121
245	685	success	Successfully scraped 139 staff members	2025-08-20 15:39:28.755121
246	654	success	Successfully scraped 3 staff members	2025-08-20 16:04:14.223323
247	659	success	Successfully scraped 3 staff members	2025-08-20 16:04:14.223327
248	666	success	Successfully scraped 3 staff members	2025-08-20 16:04:14.223328
249	674	success	Successfully scraped 3 staff members	2025-08-20 16:04:14.223329
250	680	success	Successfully scraped 3 staff members	2025-08-20 16:04:14.22333
251	653	success	Successfully scraped 143 staff members	2025-08-20 16:04:14.22333
252	655	success	Successfully scraped 124 staff members	2025-08-20 16:04:14.223331
253	656	success	Successfully scraped 2 staff members	2025-08-20 16:04:14.223332
254	657	success	Successfully scraped 109 staff members	2025-08-20 16:04:14.223332
255	658	success	Successfully scraped 135 staff members	2025-08-20 16:04:14.223333
256	660	success	Successfully scraped 3 staff members	2025-08-20 16:04:14.223334
257	661	success	Successfully scraped 3 staff members	2025-08-20 16:04:14.223335
258	662	success	Successfully scraped 141 staff members	2025-08-20 16:04:14.223335
259	663	success	Successfully scraped 146 staff members	2025-08-20 16:04:14.223336
260	664	success	Successfully scraped 83 staff members	2025-08-20 16:04:14.223337
261	665	success	Successfully scraped 134 staff members	2025-08-20 16:04:14.223337
262	667	success	Successfully scraped 108 staff members	2025-08-20 16:04:14.223338
263	668	success	Successfully scraped 144 staff members	2025-08-20 16:04:14.223339
264	669	success	Successfully scraped 3 staff members	2025-08-20 16:04:14.223339
265	670	success	Successfully scraped 2 staff members	2025-08-20 16:04:14.22334
266	671	success	Successfully scraped 124 staff members	2025-08-20 16:04:14.223341
267	672	success	Successfully scraped 141 staff members	2025-08-20 16:04:14.223341
268	673	success	Successfully scraped 3 staff members	2025-08-20 16:04:14.223342
269	675	success	Successfully scraped 62 staff members	2025-08-20 16:04:14.223343
270	676	success	Successfully scraped 145 staff members	2025-08-20 16:04:14.223343
271	677	success	Successfully scraped 3 staff members	2025-08-20 16:04:14.223344
272	678	success	Successfully scraped 92 staff members	2025-08-20 16:04:14.223345
273	679	success	Successfully scraped 121 staff members	2025-08-20 16:04:14.223345
274	681	success	Successfully scraped 114 staff members	2025-08-20 16:04:14.223346
275	682	success	Successfully scraped 147 staff members	2025-08-20 16:04:14.223347
276	683	success	Successfully scraped 98 staff members	2025-08-20 16:04:14.223347
277	684	success	Successfully scraped 91 staff members	2025-08-20 16:04:14.223348
278	685	success	Successfully scraped 139 staff members	2025-08-20 16:04:14.223349
\.


--
-- TOC entry 3353 (class 0 OID 16489)
-- Dependencies: 219
-- Data for Name: staff_change; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.staff_change (id, monitored_url_id, change_type, staff_name, staff_title, change_description, detected_at, email_sent, position_importance, likely_contract_value, open_records_filed, open_records_date, open_records_status) FROM stdin;
\.


--
-- TOC entry 3365 (class 0 OID 0)
-- Dependencies: 216
-- Name: monitored_url_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.monitored_url_id_seq', 685, true);


--
-- TOC entry 3366 (class 0 OID 0)
-- Dependencies: 218
-- Name: scraping_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.scraping_log_id_seq', 278, true);


--
-- TOC entry 3367 (class 0 OID 0)
-- Dependencies: 220
-- Name: staff_change_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.staff_change_id_seq', 1, false);


--
-- TOC entry 3199 (class 2606 OID 16502)
-- Name: monitored_url monitored_url_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.monitored_url
    ADD CONSTRAINT monitored_url_pkey PRIMARY KEY (id);


--
-- TOC entry 3201 (class 2606 OID 16504)
-- Name: scraping_log scraping_log_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.scraping_log
    ADD CONSTRAINT scraping_log_pkey PRIMARY KEY (id);


--
-- TOC entry 3203 (class 2606 OID 16506)
-- Name: staff_change staff_change_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.staff_change
    ADD CONSTRAINT staff_change_pkey PRIMARY KEY (id);


--
-- TOC entry 3204 (class 2606 OID 16507)
-- Name: scraping_log scraping_log_monitored_url_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.scraping_log
    ADD CONSTRAINT scraping_log_monitored_url_id_fkey FOREIGN KEY (monitored_url_id) REFERENCES public.monitored_url(id);


--
-- TOC entry 3205 (class 2606 OID 16512)
-- Name: staff_change staff_change_monitored_url_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.staff_change
    ADD CONSTRAINT staff_change_monitored_url_id_fkey FOREIGN KEY (monitored_url_id) REFERENCES public.monitored_url(id);


--
-- TOC entry 3361 (class 0 OID 0)
-- Dependencies: 3360
-- Name: DATABASE neondb; Type: ACL; Schema: -; Owner: neondb_owner
--

GRANT ALL ON DATABASE neondb TO neon_superuser;


--
-- TOC entry 2049 (class 826 OID 16392)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: cloud_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE cloud_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO neon_superuser WITH GRANT OPTION;


--
-- TOC entry 2048 (class 826 OID 16391)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: cloud_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE cloud_admin IN SCHEMA public GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO neon_superuser WITH GRANT OPTION;


-- Completed on 2025-08-26 09:23:02 UTC

--
-- PostgreSQL database dump complete
--

