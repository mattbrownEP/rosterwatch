--
-- PostgreSQL database dump
--

-- Dumped from database version 16.9 (84ade85)
-- Dumped by pg_dump version 17.5

-- Started on 2025-08-26 09:01:21 UTC

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
-- TOC entry 216 (class 1259 OID 24577)
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
-- TOC entry 215 (class 1259 OID 24576)
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
-- Dependencies: 215
-- Name: monitored_url_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.monitored_url_id_seq OWNED BY public.monitored_url.id;


--
-- TOC entry 220 (class 1259 OID 24600)
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
-- TOC entry 219 (class 1259 OID 24599)
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
-- Dependencies: 219
-- Name: scraping_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.scraping_log_id_seq OWNED BY public.scraping_log.id;


--
-- TOC entry 218 (class 1259 OID 24586)
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
-- TOC entry 217 (class 1259 OID 24585)
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
-- Dependencies: 217
-- Name: staff_change_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.staff_change_id_seq OWNED BY public.staff_change.id;


--
-- TOC entry 3190 (class 2604 OID 24580)
-- Name: monitored_url id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.monitored_url ALTER COLUMN id SET DEFAULT nextval('public.monitored_url_id_seq'::regclass);


--
-- TOC entry 3197 (class 2604 OID 24603)
-- Name: scraping_log id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.scraping_log ALTER COLUMN id SET DEFAULT nextval('public.scraping_log_id_seq'::regclass);


--
-- TOC entry 3193 (class 2604 OID 24589)
-- Name: staff_change id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.staff_change ALTER COLUMN id SET DEFAULT nextval('public.staff_change_id_seq'::regclass);


--
-- TOC entry 3350 (class 0 OID 24577)
-- Dependencies: 216
-- Data for Name: monitored_url; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.monitored_url (id, name, url, email, last_checked, last_content_hash, is_active, created_at, state, institution_type, conference, open_records_contact, open_records_email, response_time_days) FROM stdin;
246	Central Michigan	https://cmuchippewas.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
247	Chicago State	https://www.gocsucougars.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
248	Clemson	https://clemsontigers.com/staff-directory/	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
249	Cleveland State	https://csuvikings.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
250	Coastal Carolina	https://goccusports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
251	College of Charleston	https://cofcsports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
252	Colorado State	https://csurams.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
253	Coppin State	https://coppinstatesports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
254	Colorado	https://cubuffs.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
255	ECU	https://ecupirates.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
256	ETSU	https://etsubucs.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
257	East Texas A&M University	https://lionathletics.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
258	Eastern Illinois	https://eiupanthers.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
259	EKU	https://ekusports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
260	Eastern Michigan	https://emueagles.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
261	Eastern Washington University	https://goeags.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
262	FAMU	https://famuathletics.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
263	FAU	https://fausports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
264	Florida Gulf Coast	https://fgcuathletics.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
265	Florida International	https://fiusports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
266	George Mason	https://gomason.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
267	Georgia Tech	https://ramblinwreck.com/staff-directory/	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
268	Georgia Southern	https://gseagles.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
269	Georgia State	https://georgiastatesports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	GA	public	\N	\N	\N	10
270	Georgia	https://georgiadogs.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	GA	public	\N	\N	\N	10
271	Grambling	https://gsutigers.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	TX	public	\N	\N	\N	10
272	Idaho State	https://isubengals.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
273	Illinois State	https://goredbirds.com/staff-directory?path=general	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
274	Indiana State	https://gosycamores.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
275	Indiana	https://iuhoosiers.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
276	Iowa State	https://cyclones.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
277	IU Indy	https://iuindyjags.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
278	Jackson State	https://gojsutigers.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	TX	public	\N	\N	\N	10
279	Jacksonville State	https://jaxstatesports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
280	James Madison	https://jmusports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	VA	public	\N	\N	\N	10
281	Kansas State	https://www.kstatesports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
282	Kansas	https://kuathletics.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
283	Kennesaw State Athletics	https://ksuowls.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
284	Kent State	https://kentstatesports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
285	Lamar	https://lamarcardinals.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
286	Long Beach State	https://longbeachstate.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
287	Longwood	https://longwoodlancers.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
288	LSU	https://lsusports.net/staff-directory/	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	LA	public	\N	\N	\N	10
289	Louisiana Tech	https://latechsports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
290	Marshall	https://herdzone.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
291	McNeese State	https://mcneesesports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
292	Miami OH	https://miamiredhawks.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	FL	public	\N	\N	\N	10
293	Michigan State	https://msuspartans.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
294	MTSU	https://goblueraiders.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
295	Mississippi State	https://hailstate.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
296	Mississippi State Valley State	https://mvsusports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
297	Missouri State	https://missouristatebears.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
298	Montana State University	https://msubobcats.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
299	Morehead State University	https://msueagles.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
300	Morgan State	https://morganstatebears.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
301	Murray State	https://goracers.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
302	NJIT	https://njithighlanders.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
226	Alabama State University	https://bamastatesports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
227	Alcorn State	https://alcornsports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
228	Appalachian State	https://appstatesports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
229	Arizona State	https://thesundevils.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
230	Arkansas State University	https://astateredwolves.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
231	Auburn	https://auburntigers.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
232	Austin Peay	https://letsgopeay.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
233	Arizona	https://arizonawildcats.com/sports/2007/8/1/207969432.aspx	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
234	Ball State	https://ballstatesports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
235	Binghamton	https://binghamtonbearcats.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
236	Boise State	https://broncosports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
237	Bowling Green	https://bgsufalcons.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
238	Alabama A&M Athletics	https://aamusports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
239	Cal Poly	https://gopoly.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
240	Cal State Bakersfield	https://gorunners.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
241	Fresno State	https://gobulldogs.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
242	Cal State Fullerton	https://fullertontitans.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
243	Cal State Northridge	https://gomatadors.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
244	Sacramento State	https://hornetsports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
245	Central Connecticut State University	https://ccsubluedevils.com/athletics/directory/index	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
303	New Mexico State	https://nmstatesports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
304	Nicholls State	https://geauxcolonels.com/staff-directory?path=gen	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
305	Norfolk State	https://nsuspartans.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
306	NC A&T	https://ncataggies.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
307	NC Central	https://nccueaglepride.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
308	NC State	https://gopack.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
309	North Dakota State	https://gobison.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
310	Northern Arizona	https://nauathletics.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	AZ	public	\N	\N	\N	10
311	Northern Illinois	https://niuhuskies.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
312	Northern Kentucky	https://nkunorse.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
313	Northwestern State	https://nsudemons.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
314	Oakland	https://goldengrizzlies.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
315	Ohio University	https://ohiobobcats.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	OH	public	\N	\N	\N	10
316	Ohio State	https://ohiostatebuckeyes.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	OH	public	\N	\N	\N	10
317	Oklahoma State	https://okstate.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
318	Old Dominion	https://odusports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
319	Oregon State	https://osubeavers.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
320	Portland State	https://goviks.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
321	Prairie View A&M	https://pvpanthers.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
322	Purdue	https://purduesports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	IN	public	\N	\N	\N	10
323	Purdue Ft. Wayne	https://gomastodons.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
324	Radford	https://radfordathletics.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
325	Rutgers	https://scarletknights.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
326	Sam Houston State	https://gobearkats.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
327	San Diego State	https://goaztecs.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
328	San Jose State	https://sjsuspartans.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
329	South Carolina State	https://www.scsuathletics.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
330	South Dakota State	https://gojacks.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
331	Southeast Missouri State	https://semoredhawks.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
332	Southeast Louisiana	https://lionsports.net/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
333	Southern Illinois	https://siusalukis.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
334	Southern Illinois - Edwardsville	https://siuecougars.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
335	Southern	https://gojagsports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
336	Southern Utah	https://suutbirds.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	TX	public	\N	\N	\N	10
337	Stephen F. Austin State University	https://sfajacks.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
338	Stony Brook	https://stonybrookathletics.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
339	Tarleton State	https://tarletonsports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
340	Tennessee State	https://tsutigers.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	TX	public	\N	\N	\N	10
341	Tennessee Tech	https://www.ttusports.com/information/directory/index	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
342	Texas A&M	https://12thman.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
343	Texas A&M CC	https://goislanders.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
344	Texas Southern	https://tsusports.com/staff-directory	matt@extrapointsmb.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
345	Texas State	https://txst.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
346	Texas Tech	https://texastech.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	TX	public	\N	\N	\N	10
347	The Citadel	https://citadelsports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
348	Charlotte	https://charlotte49ers.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
349	UNC Greensboro	https://uncgspartans.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
350	Southern Miss	https://southernmiss.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	MS	public	\N	\N	\N	10
351	UTRGV	https://goutrgv.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	TX	public	\N	\N	\N	10
352	Towson	https://towsontigers.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
353	Troy	https://troytrojans.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	AL	public	\N	\N	\N	10
354	Albany	https://ualbanysports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
355	Buffalo	https://ubbulls.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	LA	public	\N	\N	\N	10
356	Akron	https://gozips.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
357	Alabama	https://rolltide.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
358	UAB	https://uabsports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	AL	public	\N	\N	\N	10
359	Arkansas Little Rock	https://lrtrojans.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
360	Arkansas Pine Bluff	https://uapblionsroar.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
361	Cal	https://calbears.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
362	UC Davis	https://ucdavisaggies.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
363	UC Irvine	https://ucirvinesports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
364	UCLA	https://uclabruins.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	CA	public	\N	\N	\N	10
365	UC Riverside	https://gohighlanders.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
366	UC San Diego	https://ucsdtritons.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
367	UC Santa Barbara	https://ucsbgauchos.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
368	Central Arkansas	https://ucasports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
369	Cincinnati	https://gobearcats.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
370	UConn	https://uconnhuskies.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
371	Hawaii	https://hawaiiathletics.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
372	Houston	https://uhcougars.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
373	Idaho	https://govandals.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
374	Illinois	https://fightingillini.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
375	UIC	https://uicflames.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
376	Iowa	https://hawkeyesports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
377	Kentucky	https://ukathletics.com/staff-directory/	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
378	Louisiana Lafayette	https://ragincajuns.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
379	Louisiana Monroe	https://ulmwarhawks.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
380	Louisville	https://gocards.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
381	Maine	https://goblackbears.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
382	Maryland Eastern Shore	https://umeshawksports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
383	UMBC	https://umbcretrievers.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
384	UMass Lowell	https://goriverhawks.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
385	UMass	https://umassathletics.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
386	Memphis	https://gotigersgo.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
387	Michigan	https://mgoblue.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
388	Minnesota	https://gophersports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
389	Ole Miss	https://olemisssports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	MS	public	\N	\N	\N	10
390	UMKC	https://kcroos.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
391	Missouri	https://mutigers.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	TX	public	\N	\N	\N	10
392	Montana	https://gogriz.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
393	Nebraska-Omaha	https://omavs.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
394	Nebraska	https://huskers.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
395	UNLV	https://unlvrebels.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
396	Nevada	https://nevadawolfpack.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
397	New Hampshire	https://unhwildcats.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
398	New Mexico	https://golobos.com/staff-directory/	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
399	New Orleans	https://unoprivateers.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
400	North Alabama	https://roarlions.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
401	UNC Asheville	https://uncabulldogs.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	LA	public	\N	\N	\N	10
402	UNC Wilmington	https://uncwsports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
403	UNC	https://goheels.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
404	North Dakota	https://fightinghawks.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
405	North Florida	https://unfospreys.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
406	North Texas	https://meangreensports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
407	Northern Colorado	https://uncbears.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
408	Northern Iowa	https://unipanthers.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
409	Oklahoma	https://soonersports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
410	Oregon	https://goducks.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
411	Rhode Island	https://gorhody.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
412	South Alabama	https://usajaguars.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
413	South Carolina Upstate	https://upstatespartans.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
414	South Carolina	https://gamecocksonline.com/staff-directory/	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
415	South Dakota	https://goyotes.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
416	South Florida	https://gousfbulls.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	FL	public	\N	\N	\N	10
417	Tennessee Chattanooga	https://gomocs.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
418	Tennessee Martin	https://utmsports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	TX	public	\N	\N	\N	10
419	Tennessee	https://utsports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	TX	public	\N	\N	\N	10
420	UT Arlington	https://utamavs.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	TX	public	\N	\N	\N	10
421	Texas	https://texaslonghorns.com/staff-directory?path=general	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	TX	public	\N	\N	\N	10
422	UTEP	https://utepminers.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	TX	public	\N	\N	\N	10
423	UTSA	https://goutsa.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	TX	public	\N	\N	\N	10
424	Toledo	https://utrockets.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	TX	public	\N	\N	\N	10
425	Utah	https://utahutes.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	TX	public	\N	\N	\N	10
426	Vermont	https://uvmathletics.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
427	Virginia	https://virginiasports.com/staff-directory/	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	VA	public	\N	\N	\N	10
428	Washington	https://gohuskies.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
429	West Georgia	https://uwgathletics.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
430	UW Green Bay	https://greenbayphoenix.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
431	Wisconsin	https://uwbadgers.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
432	UW Milwaukee	https://mkepanthers.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
433	Wyoming	https://gowyo.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
434	Utah State	https://utahstateaggies.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	TX	public	\N	\N	\N	10
435	Utah Tech	https://utahtechtrailblazers.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	TX	public	\N	\N	\N	10
436	Utah Valley	https://gouvu.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
437	VCU	https://vcuathletics.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	VA	public	\N	\N	\N	10
438	VMI	https://vmikeydets.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
439	Virginia Tech	https://hokiesports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
440	Weber State	https://weberstatesports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
441	West Virginia	https://wvusports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
442	Western Carolina	https://catamountsports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
443	Western Illinois	https://goleathernecks.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
444	Western Kentucky	https://wkusports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
445	Western Michigan	https://wmubroncos.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
446	Wichita State	https://goshockers.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
447	William & Mary	https://tribeathletics.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
448	Winthrop	https://winthropeagles.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
449	Wright State	https://wsuraiders.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
450	Youngstown State	https://ysusports.com/staff-directory	Matt@ExtraPointsMB.com	\N	\N	t	2025-08-18 00:48:54.18581	\N	public	\N	\N	\N	10
\.


--
-- TOC entry 3354 (class 0 OID 24600)
-- Dependencies: 220
-- Data for Name: scraping_log; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.scraping_log (id, monitored_url_id, status, message, scraped_at) FROM stdin;
\.


--
-- TOC entry 3352 (class 0 OID 24586)
-- Dependencies: 218
-- Data for Name: staff_change; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.staff_change (id, monitored_url_id, change_type, staff_name, staff_title, change_description, detected_at, email_sent, position_importance, likely_contract_value, open_records_filed, open_records_date, open_records_status) FROM stdin;
\.


--
-- TOC entry 3365 (class 0 OID 0)
-- Dependencies: 215
-- Name: monitored_url_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.monitored_url_id_seq', 450, true);


--
-- TOC entry 3366 (class 0 OID 0)
-- Dependencies: 219
-- Name: scraping_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.scraping_log_id_seq', 333, true);


--
-- TOC entry 3367 (class 0 OID 0)
-- Dependencies: 217
-- Name: staff_change_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.staff_change_id_seq', 1, false);


--
-- TOC entry 3199 (class 2606 OID 24584)
-- Name: monitored_url monitored_url_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.monitored_url
    ADD CONSTRAINT monitored_url_pkey PRIMARY KEY (id);


--
-- TOC entry 3203 (class 2606 OID 24607)
-- Name: scraping_log scraping_log_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.scraping_log
    ADD CONSTRAINT scraping_log_pkey PRIMARY KEY (id);


--
-- TOC entry 3201 (class 2606 OID 24593)
-- Name: staff_change staff_change_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.staff_change
    ADD CONSTRAINT staff_change_pkey PRIMARY KEY (id);


--
-- TOC entry 3205 (class 2606 OID 24608)
-- Name: scraping_log scraping_log_monitored_url_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.scraping_log
    ADD CONSTRAINT scraping_log_monitored_url_id_fkey FOREIGN KEY (monitored_url_id) REFERENCES public.monitored_url(id);


--
-- TOC entry 3204 (class 2606 OID 24594)
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


-- Completed on 2025-08-26 09:01:23 UTC

--
-- PostgreSQL database dump complete
--

