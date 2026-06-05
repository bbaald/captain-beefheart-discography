--
-- PostgreSQL database dump
--

\restrict Ageuh1SGnw0uYt5IbeJA5xFGMOsqF8EjZnJ27KrkKWRwDg3VTFUvp0O5Ep08lCW

-- Dumped from database version 17.6
-- Dumped by pg_dump version 18.4 (Postgres.app)

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
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: _migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public._migrations (
    name text NOT NULL,
    run_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: albums; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.albums (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    artist_id uuid NOT NULL,
    credited_as text,
    title text NOT NULL,
    album_type text,
    release_date date,
    release_year smallint,
    record_label text,
    catalog_number text,
    cover_art_url text,
    liner_notes text,
    source_list text[] DEFAULT '{}'::text[] NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT albums_album_type_check CHECK ((album_type = ANY (ARRAY['LP'::text, 'EP'::text, 'Single'::text, 'Compilation'::text, 'Live'::text])))
);


--
-- Name: api_keys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.api_keys (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    label text NOT NULL,
    key_hash text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    last_used_at timestamp with time zone,
    revoked_at timestamp with time zone
);


--
-- Name: artists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.artists (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    sort_name text,
    aliases text[] DEFAULT '{}'::text[] NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: personnel; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.personnel (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    sort_name text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: song_albums; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.song_albums (
    song_id uuid NOT NULL,
    album_id uuid NOT NULL,
    sequence_number smallint NOT NULL
);


--
-- Name: song_personnel; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.song_personnel (
    song_id uuid NOT NULL,
    personnel_id uuid NOT NULL,
    role text NOT NULL,
    instrument text,
    CONSTRAINT song_personnel_role_check CHECK ((role = ANY (ARRAY['musician'::text, 'songwriter'::text, 'producer'::text, 'engineer'::text])))
);


--
-- Name: songs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.songs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title text NOT NULL,
    artist_id uuid NOT NULL,
    credited_as text,
    media_type text NOT NULL,
    recording_type text,
    running_time_seconds integer,
    release_date date,
    release_year smallint,
    recording_date date,
    recording_year smallint,
    lyrics text,
    cover_art_url text,
    recording_url text,
    record_label text,
    catalog_number text,
    liner_notes text,
    source_list text[] DEFAULT '{}'::text[] NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT songs_media_type_check CHECK ((media_type = ANY (ARRAY['audio'::text, 'video'::text]))),
    CONSTRAINT songs_recording_type_check CHECK ((recording_type = ANY (ARRAY['studio'::text, 'live'::text])))
);


--
-- Data for Name: _migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public._migrations (name, run_at) FROM stdin;
001_create_artists.sql	2026-05-26 00:11:55.104586+00
002_create_albums.sql	2026-05-26 00:11:55.110108+00
003_create_songs.sql	2026-05-26 00:11:55.113629+00
004_create_song_albums.sql	2026-05-26 00:11:55.11656+00
005_create_personnel.sql	2026-05-26 00:11:55.120525+00
006_create_api_keys.sql	2026-05-26 00:11:55.122737+00
\.


--
-- Data for Name: albums; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.albums (id, artist_id, credited_as, title, album_type, release_date, release_year, record_label, catalog_number, cover_art_url, liner_notes, source_list, created_at, updated_at) FROM stdin;
f8e57c2e-03d4-4406-93a2-306ac95e7e73	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	Amsterdam ’80	Live	\N	2006	\N	\N	https://is1-ssl.mzstatic.com/image/thumb/Music124/v4/b1/e2/b0/b1e2b0a2-1b31-e7cc-f567-0de3a9068f1b/cover.jpg/600x600bb.jpg	\N	{}	2026-05-26 18:39:42.491628+00	2026-05-26 18:39:42.491628+00
bf883f7b-883d-42bc-bf96-ecf9c9c1b93d	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	Bat Chain Puller	LP	\N	2012	\N	\N	https://is1-ssl.mzstatic.com/image/thumb/Music/70/be/6d/mzi.gvbdsbho.jpg/600x600bb.jpg	\N	{}	2026-05-26 18:39:42.404421+00	2026-05-26 18:39:42.404421+00
65f9285c-1f54-479b-8bbc-a8f83fba8731	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	Bluejeans & Moonbeams	LP	\N	1974	\N	\N	https://is1-ssl.mzstatic.com/image/thumb/Music112/v4/b5/d3/67/b5d36738-80e2-9fd7-5911-bb20b73b26de/5012981202323_cover.jpg/600x600bb.jpg	\N	{}	2026-05-26 18:39:42.382537+00	2026-05-26 18:39:42.382537+00
da79f6d3-81d9-4770-bc82-f5801de2fb73	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	Clear Spot	LP	\N	1972	\N	\N	https://is1-ssl.mzstatic.com/image/thumb/Music221/v4/38/34/2f/38342f31-bf26-8b91-2240-43dc7f50fa9a/603497810109.jpg/600x600bb.jpg	\N	{}	2026-05-26 18:39:42.336494+00	2026-05-26 18:39:42.336494+00
f416ba36-a04b-41de-9f58-68befa9f8be2	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	Doc At the Radar Station	LP	\N	1980	\N	\N	https://is1-ssl.mzstatic.com/image/thumb/Music6/v4/1d/f2/6f/1df26f7a-95e9-e20b-7ba9-67b15c9f3139/00094636551357.jpg/600x600bb.jpg	\N	{}	2026-05-26 18:39:42.435403+00	2026-05-26 18:39:42.435403+00
a5533028-7204-4616-b4c5-8208a1cccb4e	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	I’m Going To Do What I Wanna Do: Live At My Father’s Place 1978	Live	\N	2000	\N	\N	https://is1-ssl.mzstatic.com/image/thumb/Music/d3/cb/11/mzi.jgoxbpwk.jpg/600x600bb.jpg	\N	{}	2026-05-26 18:39:42.480081+00	2026-05-26 18:39:42.480081+00
6cdf2052-ade2-42eb-a8a9-ea366c169fa0	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	Ice Cream For Crow	LP	\N	1982	\N	\N	https://is1-ssl.mzstatic.com/image/thumb/Music6/v4/bb/38/fe/bb38fe98-2aa9-2268-3b1b-73a7a4c44c2a/00094636551456.jpg/600x600bb.jpg	\N	{}	2026-05-26 18:39:42.458671+00	2026-05-26 18:39:42.458671+00
70efa772-3276-471d-89e1-78c2fa0b5f2e	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	Lick My Decals Off, Baby	LP	\N	1970	\N	\N	https://is1-ssl.mzstatic.com/image/thumb/Music/19/c7/f9/mzi.vrtmheir.jpg/600x600bb.jpg	\N	{}	2026-05-26 18:39:42.296614+00	2026-05-26 18:39:42.296614+00
3261733a-bea7-45dc-875f-90e751180428	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	Magnetic Hands – Live in the UK 72-80	Live	\N	2002	\N	\N	https://is1-ssl.mzstatic.com/image/thumb/Music/b5/a2/d8/mzi.gyextvtb.tif/600x600bb.jpg	\N	{}	2026-05-26 18:39:42.506235+00	2026-05-26 18:39:42.506235+00
c3e36469-6fda-4fa3-9cfa-94a3872d267b	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	Mirror Man	LP	\N	1971	\N	\N	https://is1-ssl.mzstatic.com/image/thumb/Music/13/da/c8/mzi.ceqfrmvd.jpg/600x600bb.jpg	\N	{}	2026-05-26 18:39:42.206372+00	2026-05-26 18:39:42.206372+00
e5fa2803-4a41-43c7-afbd-f27b44bef66d	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	Railroadism – Live in the US 72-81	Live	\N	2003	\N	\N	https://is1-ssl.mzstatic.com/image/thumb/Music118/v4/47/2c/97/472c975d-ee16-eb65-249d-ce6e85bfe665/0666017059723_cover.jpg/600x600bb.jpg	\N	{}	2026-05-26 18:39:42.499575+00	2026-05-26 18:39:42.499575+00
39d43e79-4f46-422a-9a37-957d0cc88f95	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	Safe As Milk	LP	\N	1967	\N	\N	https://is1-ssl.mzstatic.com/image/thumb/Features125/v4/3e/aa/59/3eaa5989-cc54-abed-b6b3-56956353834a/dj.eypesrwn.jpg/600x600bb.jpg	\N	{}	2026-05-26 18:39:42.150669+00	2026-05-26 18:39:42.150669+00
21ed747d-e758-4db7-9cbc-53f985e763b7	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	Shiny Beast (Bat Chain Puller)	LP	\N	1978	\N	\N	https://is1-ssl.mzstatic.com/image/thumb/Music221/v4/ae/50/13/ae5013ff-42f9-8850-a92b-dd6915d33142/603497810055.jpg/600x600bb.jpg	\N	{}	2026-05-26 18:39:42.410408+00	2026-05-26 18:39:42.410408+00
ae1e5f58-282e-430c-8c7b-9b6681846c9c	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	The Legendary A&M Sessions	LP	\N	1984	\N	\N	https://is1-ssl.mzstatic.com/image/thumb/Music113/v4/60/54/5d/60545d26-39fd-c060-ad2f-b090bb2dcc72/19UMGIM74326.rgb.jpg/600x600bb.jpg	\N	{}	2026-05-26 18:39:42.130722+00	2026-05-26 18:39:42.130722+00
8d2b3fa9-6cd6-4c63-9877-52475ff32317	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	The Spotlight Kid	LP	\N	1972	\N	\N	https://is1-ssl.mzstatic.com/image/thumb/Music/7e/51/25/mzi.gakajezn.jpg/600x600bb.jpg	\N	{}	2026-05-26 18:39:42.317949+00	2026-05-26 18:39:42.317949+00
71ef3cbd-d4ab-4493-878c-34efc83e49f6	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	Strictly Personal	LP	\N	1968	\N	\N	https://upload.wikimedia.org/wikipedia/en/b/bd/Strictly_Personal.jpg	\N	{}	2026-05-26 18:39:42.21847+00	2026-05-26 18:39:42.21847+00
7911d8c7-67e7-4797-8ff9-e2d78b687eb2	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	Unconditionally Guaranteed	LP	\N	1974	\N	\N	https://upload.wikimedia.org/wikipedia/en/2/21/Unconditionally_Guaranteed_cover.jpg	\N	{}	2026-05-26 18:39:42.360379+00	2026-05-26 18:39:42.360379+00
fbf3f180-6c5b-4b8c-8396-15cb33a232af	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	Trout Mask Replica	LP	\N	1969	\N	\N	https://upload.wikimedia.org/wikipedia/en/3/30/Trout_Mask_Replica.png	\N	{}	2026-05-26 18:39:42.235504+00	2026-05-26 18:39:42.235504+00
28f7805c-927a-4b68-be85-bc6bf91fe362	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	Live London ’74	Live	\N	2006	\N	\N	https://m.media-amazon.com/images/I/61grHrhArfL._SX522_.jpg	\N	{}	2026-05-26 18:39:42.486686+00	2026-05-26 18:39:42.486686+00
\.


--
-- Data for Name: artists; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.artists (id, name, sort_name, aliases, created_at, updated_at) FROM stdin;
9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart	\N	{"Don Van Vliet"}	2026-05-26 18:37:15.769746+00	2026-05-26 18:37:15.769746+00
\.


--
-- Data for Name: personnel; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.personnel (id, name, sort_name, created_at) FROM stdin;
175b3e5c-7748-4371-a35f-7cbb51af971c	Don Van Vliet	Vliet, Don Van	2026-05-26 18:39:42.151778+00
c08796b2-ca8b-4608-987c-71f8e87d19d4	Ry Cooder	Cooder, Ry	2026-05-26 18:39:42.152429+00
31c7cc31-0970-4783-8b00-094b4c05b347	Alex St Clair Snouffer	Snouffer, Alex St Clair	2026-05-26 18:39:42.15283+00
e42b4fc2-8a09-4a12-9423-f9e916b9deb9	Jerry Handley	Handley, Jerry	2026-05-26 18:39:42.15359+00
3d8dbde7-ee83-4f72-ba75-25b84428335b	John French	French, John	2026-05-26 18:39:42.154087+00
bc667db6-68be-4725-9b65-cb03b0708c58	Doug Moon	Moon, Doug	2026-05-26 18:39:42.154456+00
9bc9004a-4384-459a-a437-c5a76758704d	Milt Holland	Holland, Milt	2026-05-26 18:39:42.154726+00
9fba26b0-6fca-45d2-8933-954cd22c9e15	Russ Titelman	Titelman, Russ	2026-05-26 18:39:42.155044+00
0cd1d3f8-bf16-495c-9a40-08a817edcabc	Taj Mahal	Mahal, Taj	2026-05-26 18:39:42.155313+00
a4ca337a-c0e7-4d8b-bd84-01df9ba1e841	Sam Hoffman	Hoffman, Sam	2026-05-26 18:39:42.155598+00
b6a9b075-cb97-4b6e-a9de-a0f1961ba590	Don Van Vliet – vocals, harmonica, oboe	oboe, Don Van Vliet – vocals, harmonica,	2026-05-26 18:39:42.206854+00
e6a33d6e-9bc9-479f-980b-80a160fab790	Alex St. Clair – guitar	guitar, Alex St. Clair –	2026-05-26 18:39:42.207139+00
1053f839-2480-4b9e-b333-56d915889d68	Jeff Cotton – guitar	guitar, Jeff Cotton –	2026-05-26 18:39:42.207404+00
3a4e3b7b-4d0b-46a7-ac96-b1ef70ac34d6	Mark Marcellino – keyboards	keyboards, Mark Marcellino –	2026-05-26 18:39:42.207681+00
dbf4ed8c-12b5-434f-a65a-41fcdbb871e2	John French – drums	drums, John French –	2026-05-26 18:39:42.207948+00
46b74a4a-0596-4ae5-9798-092541ff1792	Jeff Cotton	Cotton, Jeff	2026-05-26 18:39:42.219078+00
49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	Bill Harkleroad	Harkleroad, Bill	2026-05-26 18:39:42.236+00
f817c384-6c4f-446e-8aa9-cb451fb25d5f	Mark Boston	Boston, Mark	2026-05-26 18:39:42.236594+00
ecbf062c-7532-4568-b020-ab843d7889a4	Victor Hayden	Hayden, Victor	2026-05-26 18:39:42.236877+00
2e7faa49-83d8-45ec-84a7-c8a1e94024df	Gary Marker	Marker, Gary	2026-05-26 18:39:42.237429+00
ab2566da-78ad-4277-8cc4-19793fbf285a	Don van Vliet	Vliet, Don van	2026-05-26 18:39:42.296927+00
b2caac43-13f5-4fd7-b662-93710c54eb0e	Art Tripp	Tripp, Art	2026-05-26 18:39:42.297233+00
b05cbf1d-9540-4814-9e68-eea286331b30	Elliot Ingber	Ingber, Elliot	2026-05-26 18:39:42.318453+00
c156a868-2456-49ca-9865-b037b0804f9c	Rhys Clark	Clark, Rhys	2026-05-26 18:39:42.318795+00
e1a106b8-8c8c-4fee-bb90-4b0f46b049e9	Roy Estrada	Estrada, Roy	2026-05-26 18:39:42.337036+00
f063b7e2-06eb-41dc-9cda-5714a4fd97da	The Blackberries	Blackberries, The	2026-05-26 18:39:42.337356+00
fc960ba4-1d9e-4d21-b80b-4c08778fd2c8	Mark Marcellino	Marcellino, Mark	2026-05-26 18:39:42.361013+00
83638843-8a89-4911-805c-1b74233c5cf5	Andy DiMartino	DiMartino, Andy	2026-05-26 18:39:42.361207+00
146c4d2e-8439-49a2-86a8-a4f2d1a240a4	Del Simmons	Simmons, Del	2026-05-26 18:39:42.3616+00
dcbe59a3-af12-4d97-a570-63ad7bfe078c	Dean Smith	Smith, Dean	2026-05-26 18:39:42.382848+00
aaacd880-8a8b-4f4f-bfb6-9f624d83d4a5	Ira Ingber	Ingber, Ira	2026-05-26 18:39:42.383021+00
c0b33917-530a-4565-8f72-51f937a2adcc	Bob West	West, Bob	2026-05-26 18:39:42.383197+00
fb6792ec-79b3-48fe-9e4f-8f8ed45fa697	Michael Smotherman	Smotherman, Michael	2026-05-26 18:39:42.383365+00
14e57665-4f3d-44c7-aa5e-ee9ebebe40ce	Mark Gibbons	Gibbons, Mark	2026-05-26 18:39:42.383525+00
cd8c2eac-c5bb-49c6-9948-4c3d3f4cba96	Gene Pello	Pello, Gene	2026-05-26 18:39:42.383691+00
5c0d6118-8ae8-49ed-b6e3-4ebcade708bb	Jimmy Caravan	Caravan, Jimmy	2026-05-26 18:39:42.383856+00
669f8f3f-ea44-4710-a386-dc16d41110cc	Ty Grimes	Grimes, Ty	2026-05-26 18:39:42.384016+00
5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	Jeff Moris Tepper	Tepper, Jeff Moris	2026-05-26 18:39:42.410733+00
d1c51e36-dcad-4aff-a9d9-10ffdfb0118d	Richard Redus	Redus, Richard	2026-05-26 18:39:42.410916+00
cb450c14-8087-47ce-8298-673a78487072	Eric Drew Feldman	Feldman, Eric Drew	2026-05-26 18:39:42.411082+00
9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	Bruce Fowler	Fowler, Bruce	2026-05-26 18:39:42.411236+00
2e5887d2-31dc-4951-aa79-6a12d6b18bbf	Robert Arthur Williams	Williams, Robert Arthur	2026-05-26 18:39:42.411395+00
d7d77953-0537-41b8-9f4c-212c1d2b8908	Gary Lucas	Lucas, Gary	2026-05-26 18:39:42.436127+00
af53f5a4-7a76-4114-a899-ca66de74ce5e	Richard Snyder	Snyder, Richard	2026-05-26 18:39:42.459155+00
4246f981-1d59-4657-a89a-2cb4b967acf5	Cliff Martinez	Martinez, Cliff	2026-05-26 18:39:42.459402+00
7ae077fe-1e75-44a9-87cb-950839b4a0a1	Richard Hepner	Hepner, Richard	2026-05-26 18:44:16.414952+00
a1f23ff0-09c3-43f8-8bbd-2195b64452d4	PG Blakely	Blakely, PG	2026-05-26 18:44:16.422773+00
f0d16f0b-1b9c-44ca-907f-b63aa8df4d1a	Denny Walley	Walley, Denny	2026-05-26 18:44:16.433566+00
11813a6f-3f0c-440b-b348-0c55d2da73a1	John Thomas	Thomas, John	2026-05-26 18:44:16.440224+00
\.


--
-- Data for Name: song_albums; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.song_albums (song_id, album_id, sequence_number) FROM stdin;
060881c0-9f52-46a2-b2d1-f3309890039d	ae1e5f58-282e-430c-8c7b-9b6681846c9c	1
b5c963dc-80be-468a-af48-c79cec9d996d	ae1e5f58-282e-430c-8c7b-9b6681846c9c	2
95084f73-6b60-40b8-8c4d-e01f62eda5b3	ae1e5f58-282e-430c-8c7b-9b6681846c9c	3
af20e028-e923-46cd-8885-23e58c84c39d	ae1e5f58-282e-430c-8c7b-9b6681846c9c	4
9edd194b-da00-4687-9018-b5e8470ffa69	ae1e5f58-282e-430c-8c7b-9b6681846c9c	5
a256a5c8-9eeb-4fae-aaf4-b49fdf80c21b	39d43e79-4f46-422a-9a37-957d0cc88f95	1
a095556f-6027-447c-9df0-31fc0bf804d9	39d43e79-4f46-422a-9a37-957d0cc88f95	2
a04a04c6-9443-4b5e-b313-2a6c634f67fa	39d43e79-4f46-422a-9a37-957d0cc88f95	3
94446116-059e-4b7b-85c1-58944ed0dc41	39d43e79-4f46-422a-9a37-957d0cc88f95	4
5b3d3d90-b994-4daf-bdc0-6be573b1db19	39d43e79-4f46-422a-9a37-957d0cc88f95	5
e62eedca-8668-4df5-8716-e599d629f3db	39d43e79-4f46-422a-9a37-957d0cc88f95	6
5b27b2ef-2c08-4e36-b13c-9226d1c8ca26	39d43e79-4f46-422a-9a37-957d0cc88f95	7
a849df0d-cd1d-4474-b6a1-7c4235b0efa0	39d43e79-4f46-422a-9a37-957d0cc88f95	8
3a657d57-cb2a-4697-a9fe-abe556a30f81	39d43e79-4f46-422a-9a37-957d0cc88f95	9
a277926e-a922-46e2-b539-5b724f1840d2	39d43e79-4f46-422a-9a37-957d0cc88f95	10
ccf8d742-c9ab-4b93-bf18-03e04a9ecd3c	39d43e79-4f46-422a-9a37-957d0cc88f95	11
40b6303d-04f7-4780-8f48-4a4566bc4524	39d43e79-4f46-422a-9a37-957d0cc88f95	12
fc8a1095-8526-40b6-811a-37c9d51d232d	c3e36469-6fda-4fa3-9cfa-94a3872d267b	1
13037f41-f94f-4f54-b0e0-595be3f2bbb8	c3e36469-6fda-4fa3-9cfa-94a3872d267b	2
dd76048e-fb51-4cf9-9c70-7878d3cb9420	c3e36469-6fda-4fa3-9cfa-94a3872d267b	3
29228018-46e7-4ca2-9e23-4f31f7f96008	c3e36469-6fda-4fa3-9cfa-94a3872d267b	4
32ff6187-3e57-443e-8e1c-a4db99eb7ddd	71ef3cbd-d4ab-4493-878c-34efc83e49f6	1
a53420a4-a0a9-45ff-ae0e-82238a1b412b	71ef3cbd-d4ab-4493-878c-34efc83e49f6	2
8144ea5f-7c54-4481-a8dd-47bdf4b8c279	71ef3cbd-d4ab-4493-878c-34efc83e49f6	3
174becd0-21bb-435c-92dd-43c9cb3520f0	71ef3cbd-d4ab-4493-878c-34efc83e49f6	4
85f767a3-9ca9-4436-9da1-a0e1c3ff8e9d	71ef3cbd-d4ab-4493-878c-34efc83e49f6	5
bde8c5e9-5644-4fab-b3d4-5b22b1f279e9	71ef3cbd-d4ab-4493-878c-34efc83e49f6	6
e5c8d84f-4240-4df8-8a7d-2f18ad191576	71ef3cbd-d4ab-4493-878c-34efc83e49f6	7
13037f41-f94f-4f54-b0e0-595be3f2bbb8	71ef3cbd-d4ab-4493-878c-34efc83e49f6	8
d7f96915-362a-4bbe-96b9-75deb2246330	fbf3f180-6c5b-4b8c-8396-15cb33a232af	1
012d3877-7d1a-4906-822c-48a001aade0f	fbf3f180-6c5b-4b8c-8396-15cb33a232af	2
c8564903-702d-42cf-b5a4-849a62be3ceb	fbf3f180-6c5b-4b8c-8396-15cb33a232af	3
afba7949-efb0-4d86-ae30-687f1b789e65	fbf3f180-6c5b-4b8c-8396-15cb33a232af	4
89864f61-5706-4239-82ca-00700eb9c566	fbf3f180-6c5b-4b8c-8396-15cb33a232af	5
45f0b486-6191-48ee-bd24-92f2b0fe8b64	fbf3f180-6c5b-4b8c-8396-15cb33a232af	6
37bd0dc6-9408-43c1-9613-29378a88c7f7	fbf3f180-6c5b-4b8c-8396-15cb33a232af	7
789e99b8-d4b5-4b46-8d92-22ff93716bff	fbf3f180-6c5b-4b8c-8396-15cb33a232af	8
2fc21ed3-1d96-4977-bfd4-ae6e92e372e2	fbf3f180-6c5b-4b8c-8396-15cb33a232af	9
3157fbd3-9691-4e93-bb87-ea4b2f77ac79	fbf3f180-6c5b-4b8c-8396-15cb33a232af	10
6bfc1ffd-a34b-4e4b-9464-367b55366818	fbf3f180-6c5b-4b8c-8396-15cb33a232af	11
60febd73-2ff4-487d-865b-ca3901fd625b	fbf3f180-6c5b-4b8c-8396-15cb33a232af	12
36c456fc-f0a2-4720-81af-430a5af2cc36	fbf3f180-6c5b-4b8c-8396-15cb33a232af	13
437fe539-901d-4597-8988-0b6f70415461	fbf3f180-6c5b-4b8c-8396-15cb33a232af	14
e0f00358-61dd-42b9-ac58-f26bd7dda8d8	fbf3f180-6c5b-4b8c-8396-15cb33a232af	15
c272a857-ee14-4004-a561-b31e15d13173	fbf3f180-6c5b-4b8c-8396-15cb33a232af	16
4a9c1bce-79f8-48ba-8512-f985e2b0a941	fbf3f180-6c5b-4b8c-8396-15cb33a232af	17
cf2b7173-1bc8-4b37-b4d7-a29f35e9e10a	fbf3f180-6c5b-4b8c-8396-15cb33a232af	18
e414815c-1859-4fe4-bb5d-4d1c7a89fed5	fbf3f180-6c5b-4b8c-8396-15cb33a232af	19
16cc493a-c8ef-431b-9700-71ef8049bc65	fbf3f180-6c5b-4b8c-8396-15cb33a232af	20
5977d702-9493-4821-8a72-6856e074f2c5	fbf3f180-6c5b-4b8c-8396-15cb33a232af	21
cee9b984-01a8-4736-a963-d516a180d7de	fbf3f180-6c5b-4b8c-8396-15cb33a232af	22
f6f5e23a-e3b7-463c-9eef-5f142bc75d2d	fbf3f180-6c5b-4b8c-8396-15cb33a232af	23
3d5cb9a2-7f15-4bfb-8f26-ca80ac766e79	fbf3f180-6c5b-4b8c-8396-15cb33a232af	24
26e96601-d56b-47fa-81de-727988b23718	fbf3f180-6c5b-4b8c-8396-15cb33a232af	25
e8a867c9-355f-4c9b-a446-655cef3b7519	fbf3f180-6c5b-4b8c-8396-15cb33a232af	26
65db0285-f781-4dc3-90b0-9d59d557c517	fbf3f180-6c5b-4b8c-8396-15cb33a232af	27
c11ad5e0-3684-4e72-af5e-2c8e8279ab73	fbf3f180-6c5b-4b8c-8396-15cb33a232af	28
d5d2d0a1-32ea-4e58-9456-779f9499a5c4	70efa772-3276-471d-89e1-78c2fa0b5f2e	1
4b0f6edd-10b9-490f-a646-f9249068952f	70efa772-3276-471d-89e1-78c2fa0b5f2e	2
09e9b2f1-a24d-4ee1-998c-715dd1036244	70efa772-3276-471d-89e1-78c2fa0b5f2e	3
2c6e5dd5-7643-4285-a0d7-78c580ddb23e	70efa772-3276-471d-89e1-78c2fa0b5f2e	4
9a45812f-cd8f-4ad1-afd0-80218cebb79c	70efa772-3276-471d-89e1-78c2fa0b5f2e	5
22fd10ab-8ea5-4f68-9fa4-8aa6352b21bb	70efa772-3276-471d-89e1-78c2fa0b5f2e	6
73e87677-d92e-4d40-81e7-08ed1050d963	70efa772-3276-471d-89e1-78c2fa0b5f2e	7
00828216-8d76-4738-8603-c8d31fc0ee7c	70efa772-3276-471d-89e1-78c2fa0b5f2e	8
d799c2ab-07bd-407f-9947-dd6953581aa3	70efa772-3276-471d-89e1-78c2fa0b5f2e	9
6b10dd87-fdd9-4e7b-9f7d-5306bc6336fe	70efa772-3276-471d-89e1-78c2fa0b5f2e	10
fe0bd689-1d11-4874-9aa1-ea05d65e5112	70efa772-3276-471d-89e1-78c2fa0b5f2e	11
3c6cfcd5-8b8f-42aa-9179-b108417b2bda	70efa772-3276-471d-89e1-78c2fa0b5f2e	12
d6ce060e-510a-4fa5-bbac-ea26737707b3	70efa772-3276-471d-89e1-78c2fa0b5f2e	13
e8b23e54-4e6b-4cb2-a627-e1b5f9e6f9b0	70efa772-3276-471d-89e1-78c2fa0b5f2e	14
fc5ea0b4-fea8-41e9-8b87-a9268cec8cca	70efa772-3276-471d-89e1-78c2fa0b5f2e	15
2bea8d49-607c-45ca-ada6-08ab5a323e74	8d2b3fa9-6cd6-4c63-9877-52475ff32317	1
690f4280-281d-4f49-848f-950ca30b075d	8d2b3fa9-6cd6-4c63-9877-52475ff32317	2
02c9e510-9272-4a7a-ba2f-f3d284992c02	8d2b3fa9-6cd6-4c63-9877-52475ff32317	3
3cfda4a5-777b-409f-9940-9595c5587858	8d2b3fa9-6cd6-4c63-9877-52475ff32317	4
56012461-6ea0-4392-8411-540fc7c5a831	8d2b3fa9-6cd6-4c63-9877-52475ff32317	5
c81f435a-9015-4cc4-b4c0-deff1aea32ef	8d2b3fa9-6cd6-4c63-9877-52475ff32317	6
4ca9d9c0-f4e6-4c7f-914a-98cec3a13c43	8d2b3fa9-6cd6-4c63-9877-52475ff32317	7
f20f5432-ee59-40cb-a59f-4815184ec559	8d2b3fa9-6cd6-4c63-9877-52475ff32317	8
71242661-57f3-41dc-8d68-ae489713ef80	8d2b3fa9-6cd6-4c63-9877-52475ff32317	9
2d34d2c6-3079-4d4b-836f-9914beb94610	8d2b3fa9-6cd6-4c63-9877-52475ff32317	10
d3340079-0e73-403c-8218-f01cf279a17a	da79f6d3-81d9-4770-bc82-f5801de2fb73	1
87218e59-1b9e-4b7f-9087-aee04ac7cb7b	da79f6d3-81d9-4770-bc82-f5801de2fb73	2
30d24070-e97e-47df-9845-948127100112	da79f6d3-81d9-4770-bc82-f5801de2fb73	3
e124717f-bb89-473c-98cd-61a51a67ecbf	da79f6d3-81d9-4770-bc82-f5801de2fb73	4
cd70f106-7de8-4c45-a890-80b2032518a4	da79f6d3-81d9-4770-bc82-f5801de2fb73	5
1fec70d0-4494-4cef-9788-2044a712d059	da79f6d3-81d9-4770-bc82-f5801de2fb73	6
d9ae1b80-6628-4d01-947b-0d03c81f1f11	da79f6d3-81d9-4770-bc82-f5801de2fb73	7
e696c9df-3a8a-411e-959a-c1b93890032f	da79f6d3-81d9-4770-bc82-f5801de2fb73	8
966b1f44-b1b9-478a-a185-6375c9ed0808	da79f6d3-81d9-4770-bc82-f5801de2fb73	9
bf53173c-a420-45e3-be70-3d03e23b4551	da79f6d3-81d9-4770-bc82-f5801de2fb73	10
1f891548-c46e-4b80-91c6-b928bd9076cf	da79f6d3-81d9-4770-bc82-f5801de2fb73	11
3ef35113-4602-484c-9329-e4b1a0293797	da79f6d3-81d9-4770-bc82-f5801de2fb73	12
41fdb870-64fb-44a7-b863-6fa37ade63ed	7911d8c7-67e7-4797-8ff9-e2d78b687eb2	1
aee73938-e08f-443c-9eb6-4939b24e5b18	7911d8c7-67e7-4797-8ff9-e2d78b687eb2	2
9dc7a707-d71d-41c0-8541-5361907828fa	7911d8c7-67e7-4797-8ff9-e2d78b687eb2	3
ee5736b4-5078-4d35-b143-a34fcb5b44d2	7911d8c7-67e7-4797-8ff9-e2d78b687eb2	4
de53a002-6644-40cb-81cc-d9c5b780cae9	7911d8c7-67e7-4797-8ff9-e2d78b687eb2	5
4edc21e4-42d4-4b16-86d8-d70bb97b4499	7911d8c7-67e7-4797-8ff9-e2d78b687eb2	6
22c6fec0-32e5-4b89-b3f7-faabe7290bcc	7911d8c7-67e7-4797-8ff9-e2d78b687eb2	7
35735121-6583-4df8-9526-fc7cc8edd5fc	7911d8c7-67e7-4797-8ff9-e2d78b687eb2	8
298267eb-a490-4408-9ada-cb5b5864c2cb	7911d8c7-67e7-4797-8ff9-e2d78b687eb2	9
557ad703-cb16-4046-a3af-35a32e0a4b4d	7911d8c7-67e7-4797-8ff9-e2d78b687eb2	10
507a5c5c-d828-4181-9516-950d2b837b1a	65f9285c-1f54-479b-8bbc-a8f83fba8731	1
8208c1aa-a51c-4ff4-920f-3983a3bb9561	65f9285c-1f54-479b-8bbc-a8f83fba8731	2
7399581c-7454-4c60-95a9-fe391580e363	65f9285c-1f54-479b-8bbc-a8f83fba8731	3
3b7a41bc-10ca-4af0-ae8e-f5046b1db3e5	65f9285c-1f54-479b-8bbc-a8f83fba8731	4
90f5754b-ebe1-40dd-9ef4-28d5aa58c4c9	65f9285c-1f54-479b-8bbc-a8f83fba8731	5
c2a0a42b-fa6d-4ac5-b968-631343c94321	65f9285c-1f54-479b-8bbc-a8f83fba8731	6
7c0315c7-1d0f-45dd-8152-9c3b747ae647	65f9285c-1f54-479b-8bbc-a8f83fba8731	7
a10f73f8-7777-4a72-9997-91db9be6b929	65f9285c-1f54-479b-8bbc-a8f83fba8731	8
be447424-a6d2-45ed-b813-17d88d03c35d	65f9285c-1f54-479b-8bbc-a8f83fba8731	9
0ad4a4fa-f8de-4047-8bda-d07313d51f1c	bf883f7b-883d-42bc-bf96-ecf9c9c1b93d	1
69ab3866-bbad-4449-ab24-73ea7ef1df00	bf883f7b-883d-42bc-bf96-ecf9c9c1b93d	2
557ea8f6-9f56-4be3-8897-d38b366e5464	bf883f7b-883d-42bc-bf96-ecf9c9c1b93d	3
de3bfb88-7783-450a-a5d0-b31068e39bd3	bf883f7b-883d-42bc-bf96-ecf9c9c1b93d	4
c6bfdbc5-00ad-4aae-b306-cdd3cf2c3d56	bf883f7b-883d-42bc-bf96-ecf9c9c1b93d	5
3336feea-1b60-4713-b7be-1224a3c3ecf9	bf883f7b-883d-42bc-bf96-ecf9c9c1b93d	6
3e200d0b-0bcc-464f-b439-4a8aa8a7e760	bf883f7b-883d-42bc-bf96-ecf9c9c1b93d	7
7c3a4ceb-db90-4097-9051-305d1bdd3248	bf883f7b-883d-42bc-bf96-ecf9c9c1b93d	8
31a22da7-3bb0-4e9c-a072-a6efafdff6f9	bf883f7b-883d-42bc-bf96-ecf9c9c1b93d	9
786d3951-e845-4478-97de-e5dde9af8209	bf883f7b-883d-42bc-bf96-ecf9c9c1b93d	10
bbee75ca-5fc0-44ec-ab25-0a2801ab05b2	bf883f7b-883d-42bc-bf96-ecf9c9c1b93d	11
914a6870-0842-4712-9ad9-2820f9ac825c	bf883f7b-883d-42bc-bf96-ecf9c9c1b93d	12
28cbee10-7def-4f0a-ad0f-41800ef94380	21ed747d-e758-4db7-9cbc-53f985e763b7	1
4996b88a-f8c4-4943-8026-2439ffa339f3	21ed747d-e758-4db7-9cbc-53f985e763b7	2
f7e94fde-4a03-4c9b-91cf-9525d2575afd	21ed747d-e758-4db7-9cbc-53f985e763b7	3
557ea8f6-9f56-4be3-8897-d38b366e5464	21ed747d-e758-4db7-9cbc-53f985e763b7	4
ada4c57d-e0e9-4c95-bf4c-d7fe53953d3e	21ed747d-e758-4db7-9cbc-53f985e763b7	5
0ad4a4fa-f8de-4047-8bda-d07313d51f1c	21ed747d-e758-4db7-9cbc-53f985e763b7	6
5cf50d37-f372-4b62-a130-0928def5ffe3	21ed747d-e758-4db7-9cbc-53f985e763b7	7
5d122ecb-4f53-4f55-9702-0c63b4c32f9e	21ed747d-e758-4db7-9cbc-53f985e763b7	8
5fe34c92-f026-41a9-bf4d-00264881c630	21ed747d-e758-4db7-9cbc-53f985e763b7	9
a93622d5-019a-4924-b458-b34353ce5dce	21ed747d-e758-4db7-9cbc-53f985e763b7	10
42c18384-6104-4e7e-b669-67cc9feffab5	21ed747d-e758-4db7-9cbc-53f985e763b7	11
636e9138-2ee1-4197-afea-100c85a8ec9b	21ed747d-e758-4db7-9cbc-53f985e763b7	12
f8918d61-e93a-4064-ab52-e7acc677d2c3	f416ba36-a04b-41de-9f58-68befa9f8be2	1
0f909c77-c53f-4dfb-8d0f-49420a57b392	f416ba36-a04b-41de-9f58-68befa9f8be2	2
6dd89d9d-87e2-4f5f-8295-71f2859e2f00	f416ba36-a04b-41de-9f58-68befa9f8be2	3
0de06350-8914-4517-ab5a-0ca414aa3e44	f416ba36-a04b-41de-9f58-68befa9f8be2	4
eec6c1c2-0d42-4e01-9e9e-f9b9e93ab9e7	f416ba36-a04b-41de-9f58-68befa9f8be2	5
b52e321b-e30c-4f26-bbfb-095ceee16253	f416ba36-a04b-41de-9f58-68befa9f8be2	6
ce90f3aa-d79f-4a2d-a2ac-460f5e31b5e8	f416ba36-a04b-41de-9f58-68befa9f8be2	7
2d142f2b-13a0-44c1-9a7e-23d8bd8bf039	f416ba36-a04b-41de-9f58-68befa9f8be2	8
14d48b5b-fc92-46d5-b11c-13c3216f0a04	f416ba36-a04b-41de-9f58-68befa9f8be2	9
c6bfdbc5-00ad-4aae-b306-cdd3cf2c3d56	f416ba36-a04b-41de-9f58-68befa9f8be2	10
9afd11ab-7f47-4a90-bb98-f396e11f9401	f416ba36-a04b-41de-9f58-68befa9f8be2	11
10ca92eb-4bc5-4591-8060-562bebcc6616	f416ba36-a04b-41de-9f58-68befa9f8be2	12
910d9763-2d67-4e08-a0d7-0e1e5e6c45ef	6cdf2052-ade2-42eb-a8a9-ea366c169fa0	1
c57ea0df-159b-4af4-bfc9-3dd6f69dad13	6cdf2052-ade2-42eb-a8a9-ea366c169fa0	2
c431c364-3ee2-4654-8e89-05491f5479ad	6cdf2052-ade2-42eb-a8a9-ea366c169fa0	3
2842fda3-eb10-4aae-b4fb-8004ff89a2bd	6cdf2052-ade2-42eb-a8a9-ea366c169fa0	4
9df73ca6-e32d-4172-94f5-57e59b3a3c0b	6cdf2052-ade2-42eb-a8a9-ea366c169fa0	5
24712e22-99ee-4da8-87e5-29b29f74dfa6	6cdf2052-ade2-42eb-a8a9-ea366c169fa0	6
6853edf0-6fb0-45d3-a64d-9c1e2d1c28d9	6cdf2052-ade2-42eb-a8a9-ea366c169fa0	7
2f68cbc3-6171-42c9-8e3b-91bcf5b2fa71	6cdf2052-ade2-42eb-a8a9-ea366c169fa0	8
6d0ddf93-0b53-44d7-bc81-9e8f5655820d	6cdf2052-ade2-42eb-a8a9-ea366c169fa0	9
de3bfb88-7783-450a-a5d0-b31068e39bd3	6cdf2052-ade2-42eb-a8a9-ea366c169fa0	10
e056d1c0-9ef6-43d4-aa9b-8ee3af1b44b9	6cdf2052-ade2-42eb-a8a9-ea366c169fa0	11
2d141317-7d3e-43ad-a4a4-55a51a6a121e	6cdf2052-ade2-42eb-a8a9-ea366c169fa0	12
6e26a80b-5347-4d56-9e29-5214e63f838a	a5533028-7204-4616-b4c5-8208a1cccb4e	1
56b58cd8-cf8f-4051-ad91-c16a9435752c	a5533028-7204-4616-b4c5-8208a1cccb4e	2
0e67f4d8-2b35-4592-9295-10a293f759fe	a5533028-7204-4616-b4c5-8208a1cccb4e	3
4ebd20d5-33ce-48a6-b26c-c98c31fd94e1	a5533028-7204-4616-b4c5-8208a1cccb4e	4
7d08f6fe-4d63-43d5-94c0-94b7af3f1277	a5533028-7204-4616-b4c5-8208a1cccb4e	5
99c498ac-2f95-4dde-bbe3-7646e05fb76c	a5533028-7204-4616-b4c5-8208a1cccb4e	6
77fe0ec5-3dec-4960-aa45-6fa3534e3ec2	a5533028-7204-4616-b4c5-8208a1cccb4e	7
312877de-7cab-4fc0-9178-2fb5376cb132	a5533028-7204-4616-b4c5-8208a1cccb4e	8
6ea8d8e5-4093-448e-a3fa-25d6a90b25d1	a5533028-7204-4616-b4c5-8208a1cccb4e	9
b9b31485-718e-44f6-9e54-f9fb8b0a7ccd	a5533028-7204-4616-b4c5-8208a1cccb4e	10
4d727491-2011-45ad-b77e-af4af22480f6	a5533028-7204-4616-b4c5-8208a1cccb4e	11
2994a441-6986-4bf8-ae2b-8da2af04f498	a5533028-7204-4616-b4c5-8208a1cccb4e	12
8c4c8524-0123-45a8-a6ec-b0c1793b09cf	a5533028-7204-4616-b4c5-8208a1cccb4e	13
875f446a-9b61-4eab-829e-b3733a7f752e	a5533028-7204-4616-b4c5-8208a1cccb4e	14
f4cf9a24-ef2c-4893-8b15-2181238927f6	a5533028-7204-4616-b4c5-8208a1cccb4e	15
63f43c30-6c11-4c0f-9c60-d18251104601	a5533028-7204-4616-b4c5-8208a1cccb4e	16
73d50d6f-f9bc-4d3b-9bf5-13ff7f6cd2d5	a5533028-7204-4616-b4c5-8208a1cccb4e	17
db8d7479-5b7d-4da2-9230-0fd3808636ec	28f7805c-927a-4b68-be85-bc6bf91fe362	1
a1c6f207-66ef-402e-b3a5-e6e7ae4eec3f	28f7805c-927a-4b68-be85-bc6bf91fe362	2
97fccb64-97f5-4d89-902a-f268f2409968	28f7805c-927a-4b68-be85-bc6bf91fe362	3
72110ecf-5d56-4bf8-a616-81994292edfc	28f7805c-927a-4b68-be85-bc6bf91fe362	4
2a53107c-97b7-43e7-b720-c82cdac1736c	28f7805c-927a-4b68-be85-bc6bf91fe362	5
3bca071e-f0cf-464c-a793-fa43a5cbe6d2	28f7805c-927a-4b68-be85-bc6bf91fe362	6
db88c659-3edb-4ded-ae58-d532b93dce48	28f7805c-927a-4b68-be85-bc6bf91fe362	7
fbfe7991-1879-4f10-b103-34fe28048195	28f7805c-927a-4b68-be85-bc6bf91fe362	8
d51f9aa8-06d0-404c-bb02-ec0d40e6f5d0	28f7805c-927a-4b68-be85-bc6bf91fe362	9
f0e324ec-bf9b-4059-a522-c01caf4f2b16	28f7805c-927a-4b68-be85-bc6bf91fe362	10
6c92d437-ac4a-4327-b8df-a580d5c4ebf5	28f7805c-927a-4b68-be85-bc6bf91fe362	11
aff07b4c-46cb-47b7-9f8a-cfa2a72143ee	28f7805c-927a-4b68-be85-bc6bf91fe362	12
562a6458-4e9b-41da-b95f-e12b88491ebf	f8e57c2e-03d4-4406-93a2-306ac95e7e73	1
fb8a5d6d-8fed-4f6a-96d0-60ea8c7c1db3	f8e57c2e-03d4-4406-93a2-306ac95e7e73	2
cb7b1a5b-a8b3-4085-9b77-21aa2979aeca	f8e57c2e-03d4-4406-93a2-306ac95e7e73	3
ca30e995-7800-47b3-9b89-e79448e1c7a7	f8e57c2e-03d4-4406-93a2-306ac95e7e73	4
55ca45cf-83a5-4094-b2d7-a89c9b981a79	f8e57c2e-03d4-4406-93a2-306ac95e7e73	5
4972abd1-91c5-4c2e-843d-79ab09a9efef	f8e57c2e-03d4-4406-93a2-306ac95e7e73	6
7cc29d44-0d5f-455c-b598-af70cffbf702	f8e57c2e-03d4-4406-93a2-306ac95e7e73	7
25d2f57a-fab0-418b-abed-ed28f57e5d2a	f8e57c2e-03d4-4406-93a2-306ac95e7e73	8
388aa8dd-be2e-464b-8554-d690eed634db	f8e57c2e-03d4-4406-93a2-306ac95e7e73	9
cc452b4b-83ff-465e-ab6a-eb9f223b3fca	f8e57c2e-03d4-4406-93a2-306ac95e7e73	10
c6de96b3-8498-41c8-9f3c-9e04a1e4eab1	f8e57c2e-03d4-4406-93a2-306ac95e7e73	11
5ec21fc2-a319-4ef2-8d57-8581b7ba7eb6	f8e57c2e-03d4-4406-93a2-306ac95e7e73	12
ee730331-0d09-494d-bccb-30464d976e61	f8e57c2e-03d4-4406-93a2-306ac95e7e73	13
455f2a73-4a63-40ef-836f-72ef78985aa0	f8e57c2e-03d4-4406-93a2-306ac95e7e73	14
23798bf7-78f3-43f2-a619-a49c8d0b56d6	f8e57c2e-03d4-4406-93a2-306ac95e7e73	15
ff4f2b27-5b1e-4bce-b9f1-1c1d97a3a5ad	f8e57c2e-03d4-4406-93a2-306ac95e7e73	16
fcd63314-f880-443c-b2d0-d975de18ed63	f8e57c2e-03d4-4406-93a2-306ac95e7e73	17
8ef87f45-e8d7-4d0c-9536-d3530d8da330	f8e57c2e-03d4-4406-93a2-306ac95e7e73	18
038ee92d-e7e7-4efb-bf6f-6feca8ff3d0d	e5fa2803-4a41-43c7-afbd-f27b44bef66d	1
8259fb35-0f37-4538-8818-b5142c883543	e5fa2803-4a41-43c7-afbd-f27b44bef66d	2
ac1847e8-caad-4a59-9a80-128ee90d3811	e5fa2803-4a41-43c7-afbd-f27b44bef66d	3
2614c6bf-ce1d-4d46-847b-1efe0d606407	e5fa2803-4a41-43c7-afbd-f27b44bef66d	4
61f3e568-4e6a-4f22-bcbe-3fd9056821e4	e5fa2803-4a41-43c7-afbd-f27b44bef66d	5
a05b3650-0f3a-484a-8d5d-b6442b80fd8c	e5fa2803-4a41-43c7-afbd-f27b44bef66d	6
360e5022-5c5e-433b-91fa-51c205314eb1	e5fa2803-4a41-43c7-afbd-f27b44bef66d	7
6140d2b5-ed0f-45ad-ab12-9cb5df6677c4	e5fa2803-4a41-43c7-afbd-f27b44bef66d	8
36758089-5d1c-4f70-8611-bc929c15bc05	e5fa2803-4a41-43c7-afbd-f27b44bef66d	9
5f3a98c2-1e6a-4e01-a38c-7daa46f265e6	e5fa2803-4a41-43c7-afbd-f27b44bef66d	10
1bdb4f76-42c2-47b6-9397-a42c7ca148c2	e5fa2803-4a41-43c7-afbd-f27b44bef66d	11
cb7b1a5b-a8b3-4085-9b77-21aa2979aeca	e5fa2803-4a41-43c7-afbd-f27b44bef66d	12
ca30e995-7800-47b3-9b89-e79448e1c7a7	e5fa2803-4a41-43c7-afbd-f27b44bef66d	13
3d5fc892-cce3-4d7a-9d47-e2156e76c07f	e5fa2803-4a41-43c7-afbd-f27b44bef66d	14
25d2f57a-fab0-418b-abed-ed28f57e5d2a	e5fa2803-4a41-43c7-afbd-f27b44bef66d	15
ee730331-0d09-494d-bccb-30464d976e61	e5fa2803-4a41-43c7-afbd-f27b44bef66d	16
8ef87f45-e8d7-4d0c-9536-d3530d8da330	e5fa2803-4a41-43c7-afbd-f27b44bef66d	17
fd16e995-a741-4f26-8cb4-e25c7c869eb6	e5fa2803-4a41-43c7-afbd-f27b44bef66d	18
96759f44-9b16-4ab7-b7c4-eb9ae5266008	3261733a-bea7-45dc-875f-90e751180428	1
038ee92d-e7e7-4efb-bf6f-6feca8ff3d0d	3261733a-bea7-45dc-875f-90e751180428	2
6140d2b5-ed0f-45ad-ab12-9cb5df6677c4	3261733a-bea7-45dc-875f-90e751180428	3
8cdd08ac-f608-4998-9fad-a4856e76964e	3261733a-bea7-45dc-875f-90e751180428	4
cf4419b4-b5e7-400f-bfb9-50f0fcdf446a	3261733a-bea7-45dc-875f-90e751180428	5
600abda1-8885-427c-a1fb-855f02994ef4	3261733a-bea7-45dc-875f-90e751180428	6
6e046453-8f68-415d-9e5a-e3e617f5030a	3261733a-bea7-45dc-875f-90e751180428	7
f51d2e00-f60b-456f-8718-d8c9435a0ac7	3261733a-bea7-45dc-875f-90e751180428	8
bf9acbc9-afe2-44f9-80d9-6f47048781d4	3261733a-bea7-45dc-875f-90e751180428	9
e0fc5ceb-ffd9-4574-96c5-96e9bea4767e	3261733a-bea7-45dc-875f-90e751180428	10
c0c3bf94-8723-4b18-b772-8a65e8dc7cab	3261733a-bea7-45dc-875f-90e751180428	11
4a474223-0216-45ca-acdd-393f21e2a34c	3261733a-bea7-45dc-875f-90e751180428	12
1aa76b7e-2f67-46cb-bf9a-9f9a94d9af3f	3261733a-bea7-45dc-875f-90e751180428	13
562a6458-4e9b-41da-b95f-e12b88491ebf	3261733a-bea7-45dc-875f-90e751180428	14
6e96d606-5c9d-4682-bbbd-6cfbe2fbdf73	3261733a-bea7-45dc-875f-90e751180428	15
4972abd1-91c5-4c2e-843d-79ab09a9efef	3261733a-bea7-45dc-875f-90e751180428	16
455f2a73-4a63-40ef-836f-72ef78985aa0	3261733a-bea7-45dc-875f-90e751180428	17
ff4f2b27-5b1e-4bce-b9f1-1c1d97a3a5ad	3261733a-bea7-45dc-875f-90e751180428	18
\.


--
-- Data for Name: song_personnel; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.song_personnel (song_id, personnel_id, role, instrument) FROM stdin;
a256a5c8-9eeb-4fae-aaf4-b49fdf80c21b	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
a256a5c8-9eeb-4fae-aaf4-b49fdf80c21b	c08796b2-ca8b-4608-987c-71f8e87d19d4	musician	\N
a256a5c8-9eeb-4fae-aaf4-b49fdf80c21b	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
a256a5c8-9eeb-4fae-aaf4-b49fdf80c21b	e42b4fc2-8a09-4a12-9423-f9e916b9deb9	musician	\N
a256a5c8-9eeb-4fae-aaf4-b49fdf80c21b	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
a256a5c8-9eeb-4fae-aaf4-b49fdf80c21b	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
a256a5c8-9eeb-4fae-aaf4-b49fdf80c21b	9bc9004a-4384-459a-a437-c5a76758704d	musician	\N
a256a5c8-9eeb-4fae-aaf4-b49fdf80c21b	9fba26b0-6fca-45d2-8933-954cd22c9e15	musician	\N
a256a5c8-9eeb-4fae-aaf4-b49fdf80c21b	0cd1d3f8-bf16-495c-9a40-08a817edcabc	musician	\N
a256a5c8-9eeb-4fae-aaf4-b49fdf80c21b	a4ca337a-c0e7-4d8b-bd84-01df9ba1e841	musician	\N
a095556f-6027-447c-9df0-31fc0bf804d9	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
a095556f-6027-447c-9df0-31fc0bf804d9	c08796b2-ca8b-4608-987c-71f8e87d19d4	musician	\N
a095556f-6027-447c-9df0-31fc0bf804d9	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
a095556f-6027-447c-9df0-31fc0bf804d9	e42b4fc2-8a09-4a12-9423-f9e916b9deb9	musician	\N
a095556f-6027-447c-9df0-31fc0bf804d9	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
a095556f-6027-447c-9df0-31fc0bf804d9	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
a095556f-6027-447c-9df0-31fc0bf804d9	9bc9004a-4384-459a-a437-c5a76758704d	musician	\N
a095556f-6027-447c-9df0-31fc0bf804d9	9fba26b0-6fca-45d2-8933-954cd22c9e15	musician	\N
a095556f-6027-447c-9df0-31fc0bf804d9	0cd1d3f8-bf16-495c-9a40-08a817edcabc	musician	\N
a095556f-6027-447c-9df0-31fc0bf804d9	a4ca337a-c0e7-4d8b-bd84-01df9ba1e841	musician	\N
a04a04c6-9443-4b5e-b313-2a6c634f67fa	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
a04a04c6-9443-4b5e-b313-2a6c634f67fa	c08796b2-ca8b-4608-987c-71f8e87d19d4	musician	\N
a04a04c6-9443-4b5e-b313-2a6c634f67fa	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
a04a04c6-9443-4b5e-b313-2a6c634f67fa	e42b4fc2-8a09-4a12-9423-f9e916b9deb9	musician	\N
a04a04c6-9443-4b5e-b313-2a6c634f67fa	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
a04a04c6-9443-4b5e-b313-2a6c634f67fa	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
a04a04c6-9443-4b5e-b313-2a6c634f67fa	9bc9004a-4384-459a-a437-c5a76758704d	musician	\N
a04a04c6-9443-4b5e-b313-2a6c634f67fa	9fba26b0-6fca-45d2-8933-954cd22c9e15	musician	\N
a04a04c6-9443-4b5e-b313-2a6c634f67fa	0cd1d3f8-bf16-495c-9a40-08a817edcabc	musician	\N
a04a04c6-9443-4b5e-b313-2a6c634f67fa	a4ca337a-c0e7-4d8b-bd84-01df9ba1e841	musician	\N
94446116-059e-4b7b-85c1-58944ed0dc41	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
94446116-059e-4b7b-85c1-58944ed0dc41	c08796b2-ca8b-4608-987c-71f8e87d19d4	musician	\N
94446116-059e-4b7b-85c1-58944ed0dc41	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
94446116-059e-4b7b-85c1-58944ed0dc41	e42b4fc2-8a09-4a12-9423-f9e916b9deb9	musician	\N
94446116-059e-4b7b-85c1-58944ed0dc41	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
94446116-059e-4b7b-85c1-58944ed0dc41	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
94446116-059e-4b7b-85c1-58944ed0dc41	9bc9004a-4384-459a-a437-c5a76758704d	musician	\N
94446116-059e-4b7b-85c1-58944ed0dc41	9fba26b0-6fca-45d2-8933-954cd22c9e15	musician	\N
94446116-059e-4b7b-85c1-58944ed0dc41	0cd1d3f8-bf16-495c-9a40-08a817edcabc	musician	\N
94446116-059e-4b7b-85c1-58944ed0dc41	a4ca337a-c0e7-4d8b-bd84-01df9ba1e841	musician	\N
5b3d3d90-b994-4daf-bdc0-6be573b1db19	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
5b3d3d90-b994-4daf-bdc0-6be573b1db19	c08796b2-ca8b-4608-987c-71f8e87d19d4	musician	\N
5b3d3d90-b994-4daf-bdc0-6be573b1db19	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
5b3d3d90-b994-4daf-bdc0-6be573b1db19	e42b4fc2-8a09-4a12-9423-f9e916b9deb9	musician	\N
5b3d3d90-b994-4daf-bdc0-6be573b1db19	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
5b3d3d90-b994-4daf-bdc0-6be573b1db19	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
5b3d3d90-b994-4daf-bdc0-6be573b1db19	9bc9004a-4384-459a-a437-c5a76758704d	musician	\N
5b3d3d90-b994-4daf-bdc0-6be573b1db19	9fba26b0-6fca-45d2-8933-954cd22c9e15	musician	\N
5b3d3d90-b994-4daf-bdc0-6be573b1db19	0cd1d3f8-bf16-495c-9a40-08a817edcabc	musician	\N
5b3d3d90-b994-4daf-bdc0-6be573b1db19	a4ca337a-c0e7-4d8b-bd84-01df9ba1e841	musician	\N
e62eedca-8668-4df5-8716-e599d629f3db	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
e62eedca-8668-4df5-8716-e599d629f3db	c08796b2-ca8b-4608-987c-71f8e87d19d4	musician	\N
e62eedca-8668-4df5-8716-e599d629f3db	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
e62eedca-8668-4df5-8716-e599d629f3db	e42b4fc2-8a09-4a12-9423-f9e916b9deb9	musician	\N
e62eedca-8668-4df5-8716-e599d629f3db	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
e62eedca-8668-4df5-8716-e599d629f3db	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
e62eedca-8668-4df5-8716-e599d629f3db	9bc9004a-4384-459a-a437-c5a76758704d	musician	\N
e62eedca-8668-4df5-8716-e599d629f3db	9fba26b0-6fca-45d2-8933-954cd22c9e15	musician	\N
e62eedca-8668-4df5-8716-e599d629f3db	0cd1d3f8-bf16-495c-9a40-08a817edcabc	musician	\N
e62eedca-8668-4df5-8716-e599d629f3db	a4ca337a-c0e7-4d8b-bd84-01df9ba1e841	musician	\N
5b27b2ef-2c08-4e36-b13c-9226d1c8ca26	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
5b27b2ef-2c08-4e36-b13c-9226d1c8ca26	c08796b2-ca8b-4608-987c-71f8e87d19d4	musician	\N
5b27b2ef-2c08-4e36-b13c-9226d1c8ca26	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
5b27b2ef-2c08-4e36-b13c-9226d1c8ca26	e42b4fc2-8a09-4a12-9423-f9e916b9deb9	musician	\N
5b27b2ef-2c08-4e36-b13c-9226d1c8ca26	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
5b27b2ef-2c08-4e36-b13c-9226d1c8ca26	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
5b27b2ef-2c08-4e36-b13c-9226d1c8ca26	9bc9004a-4384-459a-a437-c5a76758704d	musician	\N
5b27b2ef-2c08-4e36-b13c-9226d1c8ca26	9fba26b0-6fca-45d2-8933-954cd22c9e15	musician	\N
5b27b2ef-2c08-4e36-b13c-9226d1c8ca26	0cd1d3f8-bf16-495c-9a40-08a817edcabc	musician	\N
5b27b2ef-2c08-4e36-b13c-9226d1c8ca26	a4ca337a-c0e7-4d8b-bd84-01df9ba1e841	musician	\N
a849df0d-cd1d-4474-b6a1-7c4235b0efa0	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
a849df0d-cd1d-4474-b6a1-7c4235b0efa0	c08796b2-ca8b-4608-987c-71f8e87d19d4	musician	\N
a849df0d-cd1d-4474-b6a1-7c4235b0efa0	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
a849df0d-cd1d-4474-b6a1-7c4235b0efa0	e42b4fc2-8a09-4a12-9423-f9e916b9deb9	musician	\N
a849df0d-cd1d-4474-b6a1-7c4235b0efa0	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
a849df0d-cd1d-4474-b6a1-7c4235b0efa0	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
a849df0d-cd1d-4474-b6a1-7c4235b0efa0	9bc9004a-4384-459a-a437-c5a76758704d	musician	\N
a849df0d-cd1d-4474-b6a1-7c4235b0efa0	9fba26b0-6fca-45d2-8933-954cd22c9e15	musician	\N
a849df0d-cd1d-4474-b6a1-7c4235b0efa0	0cd1d3f8-bf16-495c-9a40-08a817edcabc	musician	\N
a849df0d-cd1d-4474-b6a1-7c4235b0efa0	a4ca337a-c0e7-4d8b-bd84-01df9ba1e841	musician	\N
3a657d57-cb2a-4697-a9fe-abe556a30f81	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
3a657d57-cb2a-4697-a9fe-abe556a30f81	c08796b2-ca8b-4608-987c-71f8e87d19d4	musician	\N
3a657d57-cb2a-4697-a9fe-abe556a30f81	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
3a657d57-cb2a-4697-a9fe-abe556a30f81	e42b4fc2-8a09-4a12-9423-f9e916b9deb9	musician	\N
3a657d57-cb2a-4697-a9fe-abe556a30f81	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
3a657d57-cb2a-4697-a9fe-abe556a30f81	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
3a657d57-cb2a-4697-a9fe-abe556a30f81	9bc9004a-4384-459a-a437-c5a76758704d	musician	\N
3a657d57-cb2a-4697-a9fe-abe556a30f81	9fba26b0-6fca-45d2-8933-954cd22c9e15	musician	\N
3a657d57-cb2a-4697-a9fe-abe556a30f81	0cd1d3f8-bf16-495c-9a40-08a817edcabc	musician	\N
3a657d57-cb2a-4697-a9fe-abe556a30f81	a4ca337a-c0e7-4d8b-bd84-01df9ba1e841	musician	\N
a277926e-a922-46e2-b539-5b724f1840d2	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
a277926e-a922-46e2-b539-5b724f1840d2	c08796b2-ca8b-4608-987c-71f8e87d19d4	musician	\N
a277926e-a922-46e2-b539-5b724f1840d2	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
a277926e-a922-46e2-b539-5b724f1840d2	e42b4fc2-8a09-4a12-9423-f9e916b9deb9	musician	\N
a277926e-a922-46e2-b539-5b724f1840d2	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
a277926e-a922-46e2-b539-5b724f1840d2	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
a277926e-a922-46e2-b539-5b724f1840d2	9bc9004a-4384-459a-a437-c5a76758704d	musician	\N
a277926e-a922-46e2-b539-5b724f1840d2	9fba26b0-6fca-45d2-8933-954cd22c9e15	musician	\N
a277926e-a922-46e2-b539-5b724f1840d2	0cd1d3f8-bf16-495c-9a40-08a817edcabc	musician	\N
a277926e-a922-46e2-b539-5b724f1840d2	a4ca337a-c0e7-4d8b-bd84-01df9ba1e841	musician	\N
ccf8d742-c9ab-4b93-bf18-03e04a9ecd3c	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
ccf8d742-c9ab-4b93-bf18-03e04a9ecd3c	c08796b2-ca8b-4608-987c-71f8e87d19d4	musician	\N
ccf8d742-c9ab-4b93-bf18-03e04a9ecd3c	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
ccf8d742-c9ab-4b93-bf18-03e04a9ecd3c	e42b4fc2-8a09-4a12-9423-f9e916b9deb9	musician	\N
ccf8d742-c9ab-4b93-bf18-03e04a9ecd3c	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
ccf8d742-c9ab-4b93-bf18-03e04a9ecd3c	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
ccf8d742-c9ab-4b93-bf18-03e04a9ecd3c	9bc9004a-4384-459a-a437-c5a76758704d	musician	\N
ccf8d742-c9ab-4b93-bf18-03e04a9ecd3c	9fba26b0-6fca-45d2-8933-954cd22c9e15	musician	\N
ccf8d742-c9ab-4b93-bf18-03e04a9ecd3c	0cd1d3f8-bf16-495c-9a40-08a817edcabc	musician	\N
ccf8d742-c9ab-4b93-bf18-03e04a9ecd3c	a4ca337a-c0e7-4d8b-bd84-01df9ba1e841	musician	\N
40b6303d-04f7-4780-8f48-4a4566bc4524	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
40b6303d-04f7-4780-8f48-4a4566bc4524	c08796b2-ca8b-4608-987c-71f8e87d19d4	musician	\N
40b6303d-04f7-4780-8f48-4a4566bc4524	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
40b6303d-04f7-4780-8f48-4a4566bc4524	e42b4fc2-8a09-4a12-9423-f9e916b9deb9	musician	\N
40b6303d-04f7-4780-8f48-4a4566bc4524	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
40b6303d-04f7-4780-8f48-4a4566bc4524	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
40b6303d-04f7-4780-8f48-4a4566bc4524	9bc9004a-4384-459a-a437-c5a76758704d	musician	\N
40b6303d-04f7-4780-8f48-4a4566bc4524	9fba26b0-6fca-45d2-8933-954cd22c9e15	musician	\N
40b6303d-04f7-4780-8f48-4a4566bc4524	0cd1d3f8-bf16-495c-9a40-08a817edcabc	musician	\N
40b6303d-04f7-4780-8f48-4a4566bc4524	a4ca337a-c0e7-4d8b-bd84-01df9ba1e841	musician	\N
fc8a1095-8526-40b6-811a-37c9d51d232d	b6a9b075-cb97-4b6e-a9de-a0f1961ba590	musician	\N
fc8a1095-8526-40b6-811a-37c9d51d232d	e6a33d6e-9bc9-479f-980b-80a160fab790	musician	\N
fc8a1095-8526-40b6-811a-37c9d51d232d	1053f839-2480-4b9e-b333-56d915889d68	musician	\N
fc8a1095-8526-40b6-811a-37c9d51d232d	3a4e3b7b-4d0b-46a7-ac96-b1ef70ac34d6	musician	\N
fc8a1095-8526-40b6-811a-37c9d51d232d	dbf4ed8c-12b5-434f-a65a-41fcdbb871e2	musician	\N
fc8a1095-8526-40b6-811a-37c9d51d232d	e42b4fc2-8a09-4a12-9423-f9e916b9deb9	musician	\N
13037f41-f94f-4f54-b0e0-595be3f2bbb8	b6a9b075-cb97-4b6e-a9de-a0f1961ba590	musician	\N
13037f41-f94f-4f54-b0e0-595be3f2bbb8	e6a33d6e-9bc9-479f-980b-80a160fab790	musician	\N
13037f41-f94f-4f54-b0e0-595be3f2bbb8	1053f839-2480-4b9e-b333-56d915889d68	musician	\N
13037f41-f94f-4f54-b0e0-595be3f2bbb8	3a4e3b7b-4d0b-46a7-ac96-b1ef70ac34d6	musician	\N
13037f41-f94f-4f54-b0e0-595be3f2bbb8	dbf4ed8c-12b5-434f-a65a-41fcdbb871e2	musician	\N
13037f41-f94f-4f54-b0e0-595be3f2bbb8	e42b4fc2-8a09-4a12-9423-f9e916b9deb9	musician	\N
dd76048e-fb51-4cf9-9c70-7878d3cb9420	b6a9b075-cb97-4b6e-a9de-a0f1961ba590	musician	\N
dd76048e-fb51-4cf9-9c70-7878d3cb9420	e6a33d6e-9bc9-479f-980b-80a160fab790	musician	\N
dd76048e-fb51-4cf9-9c70-7878d3cb9420	1053f839-2480-4b9e-b333-56d915889d68	musician	\N
dd76048e-fb51-4cf9-9c70-7878d3cb9420	3a4e3b7b-4d0b-46a7-ac96-b1ef70ac34d6	musician	\N
dd76048e-fb51-4cf9-9c70-7878d3cb9420	dbf4ed8c-12b5-434f-a65a-41fcdbb871e2	musician	\N
dd76048e-fb51-4cf9-9c70-7878d3cb9420	e42b4fc2-8a09-4a12-9423-f9e916b9deb9	musician	\N
29228018-46e7-4ca2-9e23-4f31f7f96008	b6a9b075-cb97-4b6e-a9de-a0f1961ba590	musician	\N
29228018-46e7-4ca2-9e23-4f31f7f96008	e6a33d6e-9bc9-479f-980b-80a160fab790	musician	\N
29228018-46e7-4ca2-9e23-4f31f7f96008	1053f839-2480-4b9e-b333-56d915889d68	musician	\N
29228018-46e7-4ca2-9e23-4f31f7f96008	3a4e3b7b-4d0b-46a7-ac96-b1ef70ac34d6	musician	\N
29228018-46e7-4ca2-9e23-4f31f7f96008	dbf4ed8c-12b5-434f-a65a-41fcdbb871e2	musician	\N
29228018-46e7-4ca2-9e23-4f31f7f96008	e42b4fc2-8a09-4a12-9423-f9e916b9deb9	musician	\N
32ff6187-3e57-443e-8e1c-a4db99eb7ddd	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
32ff6187-3e57-443e-8e1c-a4db99eb7ddd	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
32ff6187-3e57-443e-8e1c-a4db99eb7ddd	46b74a4a-0596-4ae5-9798-092541ff1792	musician	\N
32ff6187-3e57-443e-8e1c-a4db99eb7ddd	e42b4fc2-8a09-4a12-9423-f9e916b9deb9	musician	\N
32ff6187-3e57-443e-8e1c-a4db99eb7ddd	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
a53420a4-a0a9-45ff-ae0e-82238a1b412b	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
a53420a4-a0a9-45ff-ae0e-82238a1b412b	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
a53420a4-a0a9-45ff-ae0e-82238a1b412b	46b74a4a-0596-4ae5-9798-092541ff1792	musician	\N
a53420a4-a0a9-45ff-ae0e-82238a1b412b	e42b4fc2-8a09-4a12-9423-f9e916b9deb9	musician	\N
a53420a4-a0a9-45ff-ae0e-82238a1b412b	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
8144ea5f-7c54-4481-a8dd-47bdf4b8c279	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
8144ea5f-7c54-4481-a8dd-47bdf4b8c279	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
8144ea5f-7c54-4481-a8dd-47bdf4b8c279	46b74a4a-0596-4ae5-9798-092541ff1792	musician	\N
8144ea5f-7c54-4481-a8dd-47bdf4b8c279	e42b4fc2-8a09-4a12-9423-f9e916b9deb9	musician	\N
8144ea5f-7c54-4481-a8dd-47bdf4b8c279	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
174becd0-21bb-435c-92dd-43c9cb3520f0	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
174becd0-21bb-435c-92dd-43c9cb3520f0	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
174becd0-21bb-435c-92dd-43c9cb3520f0	46b74a4a-0596-4ae5-9798-092541ff1792	musician	\N
174becd0-21bb-435c-92dd-43c9cb3520f0	e42b4fc2-8a09-4a12-9423-f9e916b9deb9	musician	\N
174becd0-21bb-435c-92dd-43c9cb3520f0	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
85f767a3-9ca9-4436-9da1-a0e1c3ff8e9d	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
85f767a3-9ca9-4436-9da1-a0e1c3ff8e9d	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
85f767a3-9ca9-4436-9da1-a0e1c3ff8e9d	46b74a4a-0596-4ae5-9798-092541ff1792	musician	\N
85f767a3-9ca9-4436-9da1-a0e1c3ff8e9d	e42b4fc2-8a09-4a12-9423-f9e916b9deb9	musician	\N
85f767a3-9ca9-4436-9da1-a0e1c3ff8e9d	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
bde8c5e9-5644-4fab-b3d4-5b22b1f279e9	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
bde8c5e9-5644-4fab-b3d4-5b22b1f279e9	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
bde8c5e9-5644-4fab-b3d4-5b22b1f279e9	46b74a4a-0596-4ae5-9798-092541ff1792	musician	\N
bde8c5e9-5644-4fab-b3d4-5b22b1f279e9	e42b4fc2-8a09-4a12-9423-f9e916b9deb9	musician	\N
bde8c5e9-5644-4fab-b3d4-5b22b1f279e9	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
e5c8d84f-4240-4df8-8a7d-2f18ad191576	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
e5c8d84f-4240-4df8-8a7d-2f18ad191576	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
e5c8d84f-4240-4df8-8a7d-2f18ad191576	46b74a4a-0596-4ae5-9798-092541ff1792	musician	\N
e5c8d84f-4240-4df8-8a7d-2f18ad191576	e42b4fc2-8a09-4a12-9423-f9e916b9deb9	musician	\N
e5c8d84f-4240-4df8-8a7d-2f18ad191576	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
13037f41-f94f-4f54-b0e0-595be3f2bbb8	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
13037f41-f94f-4f54-b0e0-595be3f2bbb8	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
13037f41-f94f-4f54-b0e0-595be3f2bbb8	46b74a4a-0596-4ae5-9798-092541ff1792	musician	\N
13037f41-f94f-4f54-b0e0-595be3f2bbb8	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
d7f96915-362a-4bbe-96b9-75deb2246330	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
d7f96915-362a-4bbe-96b9-75deb2246330	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
d7f96915-362a-4bbe-96b9-75deb2246330	46b74a4a-0596-4ae5-9798-092541ff1792	musician	\N
d7f96915-362a-4bbe-96b9-75deb2246330	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
d7f96915-362a-4bbe-96b9-75deb2246330	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
d7f96915-362a-4bbe-96b9-75deb2246330	ecbf062c-7532-4568-b020-ab843d7889a4	musician	\N
d7f96915-362a-4bbe-96b9-75deb2246330	2e7faa49-83d8-45ec-84a7-c8a1e94024df	musician	\N
d7f96915-362a-4bbe-96b9-75deb2246330	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
012d3877-7d1a-4906-822c-48a001aade0f	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
012d3877-7d1a-4906-822c-48a001aade0f	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
012d3877-7d1a-4906-822c-48a001aade0f	46b74a4a-0596-4ae5-9798-092541ff1792	musician	\N
012d3877-7d1a-4906-822c-48a001aade0f	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
012d3877-7d1a-4906-822c-48a001aade0f	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
012d3877-7d1a-4906-822c-48a001aade0f	ecbf062c-7532-4568-b020-ab843d7889a4	musician	\N
012d3877-7d1a-4906-822c-48a001aade0f	2e7faa49-83d8-45ec-84a7-c8a1e94024df	musician	\N
012d3877-7d1a-4906-822c-48a001aade0f	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
c8564903-702d-42cf-b5a4-849a62be3ceb	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
c8564903-702d-42cf-b5a4-849a62be3ceb	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
c8564903-702d-42cf-b5a4-849a62be3ceb	46b74a4a-0596-4ae5-9798-092541ff1792	musician	\N
c8564903-702d-42cf-b5a4-849a62be3ceb	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
c8564903-702d-42cf-b5a4-849a62be3ceb	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
c8564903-702d-42cf-b5a4-849a62be3ceb	ecbf062c-7532-4568-b020-ab843d7889a4	musician	\N
c8564903-702d-42cf-b5a4-849a62be3ceb	2e7faa49-83d8-45ec-84a7-c8a1e94024df	musician	\N
c8564903-702d-42cf-b5a4-849a62be3ceb	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
afba7949-efb0-4d86-ae30-687f1b789e65	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
afba7949-efb0-4d86-ae30-687f1b789e65	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
afba7949-efb0-4d86-ae30-687f1b789e65	46b74a4a-0596-4ae5-9798-092541ff1792	musician	\N
afba7949-efb0-4d86-ae30-687f1b789e65	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
afba7949-efb0-4d86-ae30-687f1b789e65	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
afba7949-efb0-4d86-ae30-687f1b789e65	ecbf062c-7532-4568-b020-ab843d7889a4	musician	\N
afba7949-efb0-4d86-ae30-687f1b789e65	2e7faa49-83d8-45ec-84a7-c8a1e94024df	musician	\N
afba7949-efb0-4d86-ae30-687f1b789e65	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
89864f61-5706-4239-82ca-00700eb9c566	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
89864f61-5706-4239-82ca-00700eb9c566	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
89864f61-5706-4239-82ca-00700eb9c566	46b74a4a-0596-4ae5-9798-092541ff1792	musician	\N
89864f61-5706-4239-82ca-00700eb9c566	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
89864f61-5706-4239-82ca-00700eb9c566	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
89864f61-5706-4239-82ca-00700eb9c566	ecbf062c-7532-4568-b020-ab843d7889a4	musician	\N
89864f61-5706-4239-82ca-00700eb9c566	2e7faa49-83d8-45ec-84a7-c8a1e94024df	musician	\N
89864f61-5706-4239-82ca-00700eb9c566	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
45f0b486-6191-48ee-bd24-92f2b0fe8b64	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
45f0b486-6191-48ee-bd24-92f2b0fe8b64	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
45f0b486-6191-48ee-bd24-92f2b0fe8b64	46b74a4a-0596-4ae5-9798-092541ff1792	musician	\N
45f0b486-6191-48ee-bd24-92f2b0fe8b64	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
45f0b486-6191-48ee-bd24-92f2b0fe8b64	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
45f0b486-6191-48ee-bd24-92f2b0fe8b64	ecbf062c-7532-4568-b020-ab843d7889a4	musician	\N
45f0b486-6191-48ee-bd24-92f2b0fe8b64	2e7faa49-83d8-45ec-84a7-c8a1e94024df	musician	\N
45f0b486-6191-48ee-bd24-92f2b0fe8b64	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
37bd0dc6-9408-43c1-9613-29378a88c7f7	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
37bd0dc6-9408-43c1-9613-29378a88c7f7	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
37bd0dc6-9408-43c1-9613-29378a88c7f7	46b74a4a-0596-4ae5-9798-092541ff1792	musician	\N
37bd0dc6-9408-43c1-9613-29378a88c7f7	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
37bd0dc6-9408-43c1-9613-29378a88c7f7	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
37bd0dc6-9408-43c1-9613-29378a88c7f7	ecbf062c-7532-4568-b020-ab843d7889a4	musician	\N
37bd0dc6-9408-43c1-9613-29378a88c7f7	2e7faa49-83d8-45ec-84a7-c8a1e94024df	musician	\N
37bd0dc6-9408-43c1-9613-29378a88c7f7	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
789e99b8-d4b5-4b46-8d92-22ff93716bff	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
789e99b8-d4b5-4b46-8d92-22ff93716bff	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
789e99b8-d4b5-4b46-8d92-22ff93716bff	46b74a4a-0596-4ae5-9798-092541ff1792	musician	\N
789e99b8-d4b5-4b46-8d92-22ff93716bff	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
789e99b8-d4b5-4b46-8d92-22ff93716bff	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
789e99b8-d4b5-4b46-8d92-22ff93716bff	ecbf062c-7532-4568-b020-ab843d7889a4	musician	\N
789e99b8-d4b5-4b46-8d92-22ff93716bff	2e7faa49-83d8-45ec-84a7-c8a1e94024df	musician	\N
789e99b8-d4b5-4b46-8d92-22ff93716bff	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
2fc21ed3-1d96-4977-bfd4-ae6e92e372e2	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
2fc21ed3-1d96-4977-bfd4-ae6e92e372e2	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
2fc21ed3-1d96-4977-bfd4-ae6e92e372e2	46b74a4a-0596-4ae5-9798-092541ff1792	musician	\N
2fc21ed3-1d96-4977-bfd4-ae6e92e372e2	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
2fc21ed3-1d96-4977-bfd4-ae6e92e372e2	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
2fc21ed3-1d96-4977-bfd4-ae6e92e372e2	ecbf062c-7532-4568-b020-ab843d7889a4	musician	\N
2fc21ed3-1d96-4977-bfd4-ae6e92e372e2	2e7faa49-83d8-45ec-84a7-c8a1e94024df	musician	\N
2fc21ed3-1d96-4977-bfd4-ae6e92e372e2	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
3157fbd3-9691-4e93-bb87-ea4b2f77ac79	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
3157fbd3-9691-4e93-bb87-ea4b2f77ac79	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
3157fbd3-9691-4e93-bb87-ea4b2f77ac79	46b74a4a-0596-4ae5-9798-092541ff1792	musician	\N
3157fbd3-9691-4e93-bb87-ea4b2f77ac79	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
3157fbd3-9691-4e93-bb87-ea4b2f77ac79	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
3157fbd3-9691-4e93-bb87-ea4b2f77ac79	ecbf062c-7532-4568-b020-ab843d7889a4	musician	\N
3157fbd3-9691-4e93-bb87-ea4b2f77ac79	2e7faa49-83d8-45ec-84a7-c8a1e94024df	musician	\N
3157fbd3-9691-4e93-bb87-ea4b2f77ac79	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
6bfc1ffd-a34b-4e4b-9464-367b55366818	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
6bfc1ffd-a34b-4e4b-9464-367b55366818	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
6bfc1ffd-a34b-4e4b-9464-367b55366818	46b74a4a-0596-4ae5-9798-092541ff1792	musician	\N
6bfc1ffd-a34b-4e4b-9464-367b55366818	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
6bfc1ffd-a34b-4e4b-9464-367b55366818	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
6bfc1ffd-a34b-4e4b-9464-367b55366818	ecbf062c-7532-4568-b020-ab843d7889a4	musician	\N
6bfc1ffd-a34b-4e4b-9464-367b55366818	2e7faa49-83d8-45ec-84a7-c8a1e94024df	musician	\N
6bfc1ffd-a34b-4e4b-9464-367b55366818	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
60febd73-2ff4-487d-865b-ca3901fd625b	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
60febd73-2ff4-487d-865b-ca3901fd625b	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
60febd73-2ff4-487d-865b-ca3901fd625b	46b74a4a-0596-4ae5-9798-092541ff1792	musician	\N
60febd73-2ff4-487d-865b-ca3901fd625b	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
60febd73-2ff4-487d-865b-ca3901fd625b	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
60febd73-2ff4-487d-865b-ca3901fd625b	ecbf062c-7532-4568-b020-ab843d7889a4	musician	\N
60febd73-2ff4-487d-865b-ca3901fd625b	2e7faa49-83d8-45ec-84a7-c8a1e94024df	musician	\N
60febd73-2ff4-487d-865b-ca3901fd625b	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
36c456fc-f0a2-4720-81af-430a5af2cc36	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
36c456fc-f0a2-4720-81af-430a5af2cc36	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
36c456fc-f0a2-4720-81af-430a5af2cc36	46b74a4a-0596-4ae5-9798-092541ff1792	musician	\N
36c456fc-f0a2-4720-81af-430a5af2cc36	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
36c456fc-f0a2-4720-81af-430a5af2cc36	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
36c456fc-f0a2-4720-81af-430a5af2cc36	ecbf062c-7532-4568-b020-ab843d7889a4	musician	\N
36c456fc-f0a2-4720-81af-430a5af2cc36	2e7faa49-83d8-45ec-84a7-c8a1e94024df	musician	\N
36c456fc-f0a2-4720-81af-430a5af2cc36	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
437fe539-901d-4597-8988-0b6f70415461	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
437fe539-901d-4597-8988-0b6f70415461	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
437fe539-901d-4597-8988-0b6f70415461	46b74a4a-0596-4ae5-9798-092541ff1792	musician	\N
437fe539-901d-4597-8988-0b6f70415461	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
437fe539-901d-4597-8988-0b6f70415461	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
437fe539-901d-4597-8988-0b6f70415461	ecbf062c-7532-4568-b020-ab843d7889a4	musician	\N
437fe539-901d-4597-8988-0b6f70415461	2e7faa49-83d8-45ec-84a7-c8a1e94024df	musician	\N
437fe539-901d-4597-8988-0b6f70415461	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
e0f00358-61dd-42b9-ac58-f26bd7dda8d8	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
e0f00358-61dd-42b9-ac58-f26bd7dda8d8	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
e0f00358-61dd-42b9-ac58-f26bd7dda8d8	46b74a4a-0596-4ae5-9798-092541ff1792	musician	\N
e0f00358-61dd-42b9-ac58-f26bd7dda8d8	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
e0f00358-61dd-42b9-ac58-f26bd7dda8d8	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
e0f00358-61dd-42b9-ac58-f26bd7dda8d8	ecbf062c-7532-4568-b020-ab843d7889a4	musician	\N
e0f00358-61dd-42b9-ac58-f26bd7dda8d8	2e7faa49-83d8-45ec-84a7-c8a1e94024df	musician	\N
e0f00358-61dd-42b9-ac58-f26bd7dda8d8	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
c272a857-ee14-4004-a561-b31e15d13173	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
c272a857-ee14-4004-a561-b31e15d13173	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
c272a857-ee14-4004-a561-b31e15d13173	46b74a4a-0596-4ae5-9798-092541ff1792	musician	\N
c272a857-ee14-4004-a561-b31e15d13173	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
c272a857-ee14-4004-a561-b31e15d13173	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
c272a857-ee14-4004-a561-b31e15d13173	ecbf062c-7532-4568-b020-ab843d7889a4	musician	\N
c272a857-ee14-4004-a561-b31e15d13173	2e7faa49-83d8-45ec-84a7-c8a1e94024df	musician	\N
c272a857-ee14-4004-a561-b31e15d13173	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
4a9c1bce-79f8-48ba-8512-f985e2b0a941	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
4a9c1bce-79f8-48ba-8512-f985e2b0a941	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
4a9c1bce-79f8-48ba-8512-f985e2b0a941	46b74a4a-0596-4ae5-9798-092541ff1792	musician	\N
4a9c1bce-79f8-48ba-8512-f985e2b0a941	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
4a9c1bce-79f8-48ba-8512-f985e2b0a941	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
4a9c1bce-79f8-48ba-8512-f985e2b0a941	ecbf062c-7532-4568-b020-ab843d7889a4	musician	\N
4a9c1bce-79f8-48ba-8512-f985e2b0a941	2e7faa49-83d8-45ec-84a7-c8a1e94024df	musician	\N
4a9c1bce-79f8-48ba-8512-f985e2b0a941	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
cf2b7173-1bc8-4b37-b4d7-a29f35e9e10a	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
cf2b7173-1bc8-4b37-b4d7-a29f35e9e10a	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
cf2b7173-1bc8-4b37-b4d7-a29f35e9e10a	46b74a4a-0596-4ae5-9798-092541ff1792	musician	\N
cf2b7173-1bc8-4b37-b4d7-a29f35e9e10a	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
cf2b7173-1bc8-4b37-b4d7-a29f35e9e10a	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
cf2b7173-1bc8-4b37-b4d7-a29f35e9e10a	ecbf062c-7532-4568-b020-ab843d7889a4	musician	\N
cf2b7173-1bc8-4b37-b4d7-a29f35e9e10a	2e7faa49-83d8-45ec-84a7-c8a1e94024df	musician	\N
cf2b7173-1bc8-4b37-b4d7-a29f35e9e10a	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
e414815c-1859-4fe4-bb5d-4d1c7a89fed5	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
e414815c-1859-4fe4-bb5d-4d1c7a89fed5	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
e414815c-1859-4fe4-bb5d-4d1c7a89fed5	46b74a4a-0596-4ae5-9798-092541ff1792	musician	\N
e414815c-1859-4fe4-bb5d-4d1c7a89fed5	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
e414815c-1859-4fe4-bb5d-4d1c7a89fed5	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
e414815c-1859-4fe4-bb5d-4d1c7a89fed5	ecbf062c-7532-4568-b020-ab843d7889a4	musician	\N
e414815c-1859-4fe4-bb5d-4d1c7a89fed5	2e7faa49-83d8-45ec-84a7-c8a1e94024df	musician	\N
e414815c-1859-4fe4-bb5d-4d1c7a89fed5	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
16cc493a-c8ef-431b-9700-71ef8049bc65	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
16cc493a-c8ef-431b-9700-71ef8049bc65	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
16cc493a-c8ef-431b-9700-71ef8049bc65	46b74a4a-0596-4ae5-9798-092541ff1792	musician	\N
16cc493a-c8ef-431b-9700-71ef8049bc65	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
16cc493a-c8ef-431b-9700-71ef8049bc65	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
16cc493a-c8ef-431b-9700-71ef8049bc65	ecbf062c-7532-4568-b020-ab843d7889a4	musician	\N
16cc493a-c8ef-431b-9700-71ef8049bc65	2e7faa49-83d8-45ec-84a7-c8a1e94024df	musician	\N
16cc493a-c8ef-431b-9700-71ef8049bc65	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
5977d702-9493-4821-8a72-6856e074f2c5	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
5977d702-9493-4821-8a72-6856e074f2c5	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
5977d702-9493-4821-8a72-6856e074f2c5	46b74a4a-0596-4ae5-9798-092541ff1792	musician	\N
5977d702-9493-4821-8a72-6856e074f2c5	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
5977d702-9493-4821-8a72-6856e074f2c5	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
5977d702-9493-4821-8a72-6856e074f2c5	ecbf062c-7532-4568-b020-ab843d7889a4	musician	\N
5977d702-9493-4821-8a72-6856e074f2c5	2e7faa49-83d8-45ec-84a7-c8a1e94024df	musician	\N
5977d702-9493-4821-8a72-6856e074f2c5	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
cee9b984-01a8-4736-a963-d516a180d7de	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
cee9b984-01a8-4736-a963-d516a180d7de	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
cee9b984-01a8-4736-a963-d516a180d7de	46b74a4a-0596-4ae5-9798-092541ff1792	musician	\N
cee9b984-01a8-4736-a963-d516a180d7de	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
cee9b984-01a8-4736-a963-d516a180d7de	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
cee9b984-01a8-4736-a963-d516a180d7de	ecbf062c-7532-4568-b020-ab843d7889a4	musician	\N
cee9b984-01a8-4736-a963-d516a180d7de	2e7faa49-83d8-45ec-84a7-c8a1e94024df	musician	\N
cee9b984-01a8-4736-a963-d516a180d7de	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
f6f5e23a-e3b7-463c-9eef-5f142bc75d2d	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
f6f5e23a-e3b7-463c-9eef-5f142bc75d2d	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
f6f5e23a-e3b7-463c-9eef-5f142bc75d2d	46b74a4a-0596-4ae5-9798-092541ff1792	musician	\N
f6f5e23a-e3b7-463c-9eef-5f142bc75d2d	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
f6f5e23a-e3b7-463c-9eef-5f142bc75d2d	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
f6f5e23a-e3b7-463c-9eef-5f142bc75d2d	ecbf062c-7532-4568-b020-ab843d7889a4	musician	\N
f6f5e23a-e3b7-463c-9eef-5f142bc75d2d	2e7faa49-83d8-45ec-84a7-c8a1e94024df	musician	\N
f6f5e23a-e3b7-463c-9eef-5f142bc75d2d	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
3d5cb9a2-7f15-4bfb-8f26-ca80ac766e79	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
3d5cb9a2-7f15-4bfb-8f26-ca80ac766e79	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
3d5cb9a2-7f15-4bfb-8f26-ca80ac766e79	46b74a4a-0596-4ae5-9798-092541ff1792	musician	\N
3d5cb9a2-7f15-4bfb-8f26-ca80ac766e79	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
3d5cb9a2-7f15-4bfb-8f26-ca80ac766e79	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
3d5cb9a2-7f15-4bfb-8f26-ca80ac766e79	ecbf062c-7532-4568-b020-ab843d7889a4	musician	\N
3d5cb9a2-7f15-4bfb-8f26-ca80ac766e79	2e7faa49-83d8-45ec-84a7-c8a1e94024df	musician	\N
3d5cb9a2-7f15-4bfb-8f26-ca80ac766e79	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
26e96601-d56b-47fa-81de-727988b23718	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
26e96601-d56b-47fa-81de-727988b23718	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
26e96601-d56b-47fa-81de-727988b23718	46b74a4a-0596-4ae5-9798-092541ff1792	musician	\N
26e96601-d56b-47fa-81de-727988b23718	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
26e96601-d56b-47fa-81de-727988b23718	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
26e96601-d56b-47fa-81de-727988b23718	ecbf062c-7532-4568-b020-ab843d7889a4	musician	\N
26e96601-d56b-47fa-81de-727988b23718	2e7faa49-83d8-45ec-84a7-c8a1e94024df	musician	\N
26e96601-d56b-47fa-81de-727988b23718	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
e8a867c9-355f-4c9b-a446-655cef3b7519	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
e8a867c9-355f-4c9b-a446-655cef3b7519	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
e8a867c9-355f-4c9b-a446-655cef3b7519	46b74a4a-0596-4ae5-9798-092541ff1792	musician	\N
e8a867c9-355f-4c9b-a446-655cef3b7519	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
e8a867c9-355f-4c9b-a446-655cef3b7519	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
e8a867c9-355f-4c9b-a446-655cef3b7519	ecbf062c-7532-4568-b020-ab843d7889a4	musician	\N
e8a867c9-355f-4c9b-a446-655cef3b7519	2e7faa49-83d8-45ec-84a7-c8a1e94024df	musician	\N
e8a867c9-355f-4c9b-a446-655cef3b7519	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
65db0285-f781-4dc3-90b0-9d59d557c517	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
65db0285-f781-4dc3-90b0-9d59d557c517	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
65db0285-f781-4dc3-90b0-9d59d557c517	46b74a4a-0596-4ae5-9798-092541ff1792	musician	\N
65db0285-f781-4dc3-90b0-9d59d557c517	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
65db0285-f781-4dc3-90b0-9d59d557c517	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
65db0285-f781-4dc3-90b0-9d59d557c517	ecbf062c-7532-4568-b020-ab843d7889a4	musician	\N
65db0285-f781-4dc3-90b0-9d59d557c517	2e7faa49-83d8-45ec-84a7-c8a1e94024df	musician	\N
65db0285-f781-4dc3-90b0-9d59d557c517	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
c11ad5e0-3684-4e72-af5e-2c8e8279ab73	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
c11ad5e0-3684-4e72-af5e-2c8e8279ab73	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
c11ad5e0-3684-4e72-af5e-2c8e8279ab73	46b74a4a-0596-4ae5-9798-092541ff1792	musician	\N
c11ad5e0-3684-4e72-af5e-2c8e8279ab73	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
c11ad5e0-3684-4e72-af5e-2c8e8279ab73	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
c11ad5e0-3684-4e72-af5e-2c8e8279ab73	ecbf062c-7532-4568-b020-ab843d7889a4	musician	\N
c11ad5e0-3684-4e72-af5e-2c8e8279ab73	2e7faa49-83d8-45ec-84a7-c8a1e94024df	musician	\N
c11ad5e0-3684-4e72-af5e-2c8e8279ab73	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
d5d2d0a1-32ea-4e58-9456-779f9499a5c4	ab2566da-78ad-4277-8cc4-19793fbf285a	musician	\N
d5d2d0a1-32ea-4e58-9456-779f9499a5c4	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
d5d2d0a1-32ea-4e58-9456-779f9499a5c4	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
d5d2d0a1-32ea-4e58-9456-779f9499a5c4	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
d5d2d0a1-32ea-4e58-9456-779f9499a5c4	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
4b0f6edd-10b9-490f-a646-f9249068952f	ab2566da-78ad-4277-8cc4-19793fbf285a	musician	\N
4b0f6edd-10b9-490f-a646-f9249068952f	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
4b0f6edd-10b9-490f-a646-f9249068952f	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
4b0f6edd-10b9-490f-a646-f9249068952f	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
4b0f6edd-10b9-490f-a646-f9249068952f	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
09e9b2f1-a24d-4ee1-998c-715dd1036244	ab2566da-78ad-4277-8cc4-19793fbf285a	musician	\N
09e9b2f1-a24d-4ee1-998c-715dd1036244	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
09e9b2f1-a24d-4ee1-998c-715dd1036244	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
09e9b2f1-a24d-4ee1-998c-715dd1036244	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
09e9b2f1-a24d-4ee1-998c-715dd1036244	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
2c6e5dd5-7643-4285-a0d7-78c580ddb23e	ab2566da-78ad-4277-8cc4-19793fbf285a	musician	\N
2c6e5dd5-7643-4285-a0d7-78c580ddb23e	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
2c6e5dd5-7643-4285-a0d7-78c580ddb23e	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
2c6e5dd5-7643-4285-a0d7-78c580ddb23e	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
2c6e5dd5-7643-4285-a0d7-78c580ddb23e	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
9a45812f-cd8f-4ad1-afd0-80218cebb79c	ab2566da-78ad-4277-8cc4-19793fbf285a	musician	\N
9a45812f-cd8f-4ad1-afd0-80218cebb79c	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
9a45812f-cd8f-4ad1-afd0-80218cebb79c	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
9a45812f-cd8f-4ad1-afd0-80218cebb79c	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
9a45812f-cd8f-4ad1-afd0-80218cebb79c	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
22fd10ab-8ea5-4f68-9fa4-8aa6352b21bb	ab2566da-78ad-4277-8cc4-19793fbf285a	musician	\N
22fd10ab-8ea5-4f68-9fa4-8aa6352b21bb	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
22fd10ab-8ea5-4f68-9fa4-8aa6352b21bb	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
22fd10ab-8ea5-4f68-9fa4-8aa6352b21bb	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
22fd10ab-8ea5-4f68-9fa4-8aa6352b21bb	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
73e87677-d92e-4d40-81e7-08ed1050d963	ab2566da-78ad-4277-8cc4-19793fbf285a	musician	\N
73e87677-d92e-4d40-81e7-08ed1050d963	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
73e87677-d92e-4d40-81e7-08ed1050d963	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
73e87677-d92e-4d40-81e7-08ed1050d963	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
73e87677-d92e-4d40-81e7-08ed1050d963	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
00828216-8d76-4738-8603-c8d31fc0ee7c	ab2566da-78ad-4277-8cc4-19793fbf285a	musician	\N
00828216-8d76-4738-8603-c8d31fc0ee7c	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
00828216-8d76-4738-8603-c8d31fc0ee7c	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
00828216-8d76-4738-8603-c8d31fc0ee7c	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
00828216-8d76-4738-8603-c8d31fc0ee7c	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
d799c2ab-07bd-407f-9947-dd6953581aa3	ab2566da-78ad-4277-8cc4-19793fbf285a	musician	\N
d799c2ab-07bd-407f-9947-dd6953581aa3	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
d799c2ab-07bd-407f-9947-dd6953581aa3	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
d799c2ab-07bd-407f-9947-dd6953581aa3	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
d799c2ab-07bd-407f-9947-dd6953581aa3	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
6b10dd87-fdd9-4e7b-9f7d-5306bc6336fe	ab2566da-78ad-4277-8cc4-19793fbf285a	musician	\N
6b10dd87-fdd9-4e7b-9f7d-5306bc6336fe	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
6b10dd87-fdd9-4e7b-9f7d-5306bc6336fe	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
6b10dd87-fdd9-4e7b-9f7d-5306bc6336fe	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
6b10dd87-fdd9-4e7b-9f7d-5306bc6336fe	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
fe0bd689-1d11-4874-9aa1-ea05d65e5112	ab2566da-78ad-4277-8cc4-19793fbf285a	musician	\N
fe0bd689-1d11-4874-9aa1-ea05d65e5112	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
fe0bd689-1d11-4874-9aa1-ea05d65e5112	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
fe0bd689-1d11-4874-9aa1-ea05d65e5112	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
fe0bd689-1d11-4874-9aa1-ea05d65e5112	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
3c6cfcd5-8b8f-42aa-9179-b108417b2bda	ab2566da-78ad-4277-8cc4-19793fbf285a	musician	\N
3c6cfcd5-8b8f-42aa-9179-b108417b2bda	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
3c6cfcd5-8b8f-42aa-9179-b108417b2bda	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
3c6cfcd5-8b8f-42aa-9179-b108417b2bda	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
3c6cfcd5-8b8f-42aa-9179-b108417b2bda	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
d6ce060e-510a-4fa5-bbac-ea26737707b3	ab2566da-78ad-4277-8cc4-19793fbf285a	musician	\N
d6ce060e-510a-4fa5-bbac-ea26737707b3	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
d6ce060e-510a-4fa5-bbac-ea26737707b3	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
d6ce060e-510a-4fa5-bbac-ea26737707b3	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
d6ce060e-510a-4fa5-bbac-ea26737707b3	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
e8b23e54-4e6b-4cb2-a627-e1b5f9e6f9b0	ab2566da-78ad-4277-8cc4-19793fbf285a	musician	\N
e8b23e54-4e6b-4cb2-a627-e1b5f9e6f9b0	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
e8b23e54-4e6b-4cb2-a627-e1b5f9e6f9b0	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
e8b23e54-4e6b-4cb2-a627-e1b5f9e6f9b0	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
e8b23e54-4e6b-4cb2-a627-e1b5f9e6f9b0	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
fc5ea0b4-fea8-41e9-8b87-a9268cec8cca	ab2566da-78ad-4277-8cc4-19793fbf285a	musician	\N
fc5ea0b4-fea8-41e9-8b87-a9268cec8cca	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
fc5ea0b4-fea8-41e9-8b87-a9268cec8cca	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
fc5ea0b4-fea8-41e9-8b87-a9268cec8cca	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
fc5ea0b4-fea8-41e9-8b87-a9268cec8cca	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
2bea8d49-607c-45ca-ada6-08ab5a323e74	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
2bea8d49-607c-45ca-ada6-08ab5a323e74	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
2bea8d49-607c-45ca-ada6-08ab5a323e74	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
2bea8d49-607c-45ca-ada6-08ab5a323e74	b05cbf1d-9540-4814-9e68-eea286331b30	musician	\N
2bea8d49-607c-45ca-ada6-08ab5a323e74	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
2bea8d49-607c-45ca-ada6-08ab5a323e74	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
2bea8d49-607c-45ca-ada6-08ab5a323e74	c156a868-2456-49ca-9865-b037b0804f9c	musician	\N
690f4280-281d-4f49-848f-950ca30b075d	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
690f4280-281d-4f49-848f-950ca30b075d	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
690f4280-281d-4f49-848f-950ca30b075d	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
690f4280-281d-4f49-848f-950ca30b075d	b05cbf1d-9540-4814-9e68-eea286331b30	musician	\N
690f4280-281d-4f49-848f-950ca30b075d	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
690f4280-281d-4f49-848f-950ca30b075d	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
690f4280-281d-4f49-848f-950ca30b075d	c156a868-2456-49ca-9865-b037b0804f9c	musician	\N
02c9e510-9272-4a7a-ba2f-f3d284992c02	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
02c9e510-9272-4a7a-ba2f-f3d284992c02	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
02c9e510-9272-4a7a-ba2f-f3d284992c02	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
02c9e510-9272-4a7a-ba2f-f3d284992c02	b05cbf1d-9540-4814-9e68-eea286331b30	musician	\N
02c9e510-9272-4a7a-ba2f-f3d284992c02	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
02c9e510-9272-4a7a-ba2f-f3d284992c02	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
02c9e510-9272-4a7a-ba2f-f3d284992c02	c156a868-2456-49ca-9865-b037b0804f9c	musician	\N
3cfda4a5-777b-409f-9940-9595c5587858	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
3cfda4a5-777b-409f-9940-9595c5587858	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
3cfda4a5-777b-409f-9940-9595c5587858	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
3cfda4a5-777b-409f-9940-9595c5587858	b05cbf1d-9540-4814-9e68-eea286331b30	musician	\N
3cfda4a5-777b-409f-9940-9595c5587858	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
3cfda4a5-777b-409f-9940-9595c5587858	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
3cfda4a5-777b-409f-9940-9595c5587858	c156a868-2456-49ca-9865-b037b0804f9c	musician	\N
56012461-6ea0-4392-8411-540fc7c5a831	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
56012461-6ea0-4392-8411-540fc7c5a831	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
56012461-6ea0-4392-8411-540fc7c5a831	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
56012461-6ea0-4392-8411-540fc7c5a831	b05cbf1d-9540-4814-9e68-eea286331b30	musician	\N
56012461-6ea0-4392-8411-540fc7c5a831	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
56012461-6ea0-4392-8411-540fc7c5a831	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
56012461-6ea0-4392-8411-540fc7c5a831	c156a868-2456-49ca-9865-b037b0804f9c	musician	\N
c81f435a-9015-4cc4-b4c0-deff1aea32ef	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
c81f435a-9015-4cc4-b4c0-deff1aea32ef	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
c81f435a-9015-4cc4-b4c0-deff1aea32ef	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
c81f435a-9015-4cc4-b4c0-deff1aea32ef	b05cbf1d-9540-4814-9e68-eea286331b30	musician	\N
c81f435a-9015-4cc4-b4c0-deff1aea32ef	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
c81f435a-9015-4cc4-b4c0-deff1aea32ef	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
c81f435a-9015-4cc4-b4c0-deff1aea32ef	c156a868-2456-49ca-9865-b037b0804f9c	musician	\N
4ca9d9c0-f4e6-4c7f-914a-98cec3a13c43	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
4ca9d9c0-f4e6-4c7f-914a-98cec3a13c43	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
4ca9d9c0-f4e6-4c7f-914a-98cec3a13c43	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
4ca9d9c0-f4e6-4c7f-914a-98cec3a13c43	b05cbf1d-9540-4814-9e68-eea286331b30	musician	\N
4ca9d9c0-f4e6-4c7f-914a-98cec3a13c43	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
4ca9d9c0-f4e6-4c7f-914a-98cec3a13c43	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
4ca9d9c0-f4e6-4c7f-914a-98cec3a13c43	c156a868-2456-49ca-9865-b037b0804f9c	musician	\N
f20f5432-ee59-40cb-a59f-4815184ec559	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
f20f5432-ee59-40cb-a59f-4815184ec559	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
f20f5432-ee59-40cb-a59f-4815184ec559	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
f20f5432-ee59-40cb-a59f-4815184ec559	b05cbf1d-9540-4814-9e68-eea286331b30	musician	\N
f20f5432-ee59-40cb-a59f-4815184ec559	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
f20f5432-ee59-40cb-a59f-4815184ec559	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
f20f5432-ee59-40cb-a59f-4815184ec559	c156a868-2456-49ca-9865-b037b0804f9c	musician	\N
71242661-57f3-41dc-8d68-ae489713ef80	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
71242661-57f3-41dc-8d68-ae489713ef80	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
71242661-57f3-41dc-8d68-ae489713ef80	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
71242661-57f3-41dc-8d68-ae489713ef80	b05cbf1d-9540-4814-9e68-eea286331b30	musician	\N
71242661-57f3-41dc-8d68-ae489713ef80	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
71242661-57f3-41dc-8d68-ae489713ef80	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
71242661-57f3-41dc-8d68-ae489713ef80	c156a868-2456-49ca-9865-b037b0804f9c	musician	\N
2d34d2c6-3079-4d4b-836f-9914beb94610	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
2d34d2c6-3079-4d4b-836f-9914beb94610	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
2d34d2c6-3079-4d4b-836f-9914beb94610	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
2d34d2c6-3079-4d4b-836f-9914beb94610	b05cbf1d-9540-4814-9e68-eea286331b30	musician	\N
2d34d2c6-3079-4d4b-836f-9914beb94610	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
2d34d2c6-3079-4d4b-836f-9914beb94610	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
2d34d2c6-3079-4d4b-836f-9914beb94610	c156a868-2456-49ca-9865-b037b0804f9c	musician	\N
d3340079-0e73-403c-8218-f01cf279a17a	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
d3340079-0e73-403c-8218-f01cf279a17a	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
d3340079-0e73-403c-8218-f01cf279a17a	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
d3340079-0e73-403c-8218-f01cf279a17a	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
d3340079-0e73-403c-8218-f01cf279a17a	e1a106b8-8c8c-4fee-bb90-4b0f46b049e9	musician	\N
d3340079-0e73-403c-8218-f01cf279a17a	9bc9004a-4384-459a-a437-c5a76758704d	musician	\N
d3340079-0e73-403c-8218-f01cf279a17a	9fba26b0-6fca-45d2-8933-954cd22c9e15	musician	\N
d3340079-0e73-403c-8218-f01cf279a17a	f063b7e2-06eb-41dc-9cda-5714a4fd97da	musician	\N
87218e59-1b9e-4b7f-9087-aee04ac7cb7b	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
87218e59-1b9e-4b7f-9087-aee04ac7cb7b	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
87218e59-1b9e-4b7f-9087-aee04ac7cb7b	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
87218e59-1b9e-4b7f-9087-aee04ac7cb7b	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
87218e59-1b9e-4b7f-9087-aee04ac7cb7b	e1a106b8-8c8c-4fee-bb90-4b0f46b049e9	musician	\N
87218e59-1b9e-4b7f-9087-aee04ac7cb7b	9bc9004a-4384-459a-a437-c5a76758704d	musician	\N
87218e59-1b9e-4b7f-9087-aee04ac7cb7b	9fba26b0-6fca-45d2-8933-954cd22c9e15	musician	\N
87218e59-1b9e-4b7f-9087-aee04ac7cb7b	f063b7e2-06eb-41dc-9cda-5714a4fd97da	musician	\N
30d24070-e97e-47df-9845-948127100112	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
30d24070-e97e-47df-9845-948127100112	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
30d24070-e97e-47df-9845-948127100112	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
30d24070-e97e-47df-9845-948127100112	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
30d24070-e97e-47df-9845-948127100112	e1a106b8-8c8c-4fee-bb90-4b0f46b049e9	musician	\N
30d24070-e97e-47df-9845-948127100112	9bc9004a-4384-459a-a437-c5a76758704d	musician	\N
30d24070-e97e-47df-9845-948127100112	9fba26b0-6fca-45d2-8933-954cd22c9e15	musician	\N
30d24070-e97e-47df-9845-948127100112	f063b7e2-06eb-41dc-9cda-5714a4fd97da	musician	\N
e124717f-bb89-473c-98cd-61a51a67ecbf	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
e124717f-bb89-473c-98cd-61a51a67ecbf	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
e124717f-bb89-473c-98cd-61a51a67ecbf	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
e124717f-bb89-473c-98cd-61a51a67ecbf	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
e124717f-bb89-473c-98cd-61a51a67ecbf	e1a106b8-8c8c-4fee-bb90-4b0f46b049e9	musician	\N
e124717f-bb89-473c-98cd-61a51a67ecbf	9bc9004a-4384-459a-a437-c5a76758704d	musician	\N
e124717f-bb89-473c-98cd-61a51a67ecbf	9fba26b0-6fca-45d2-8933-954cd22c9e15	musician	\N
e124717f-bb89-473c-98cd-61a51a67ecbf	f063b7e2-06eb-41dc-9cda-5714a4fd97da	musician	\N
cd70f106-7de8-4c45-a890-80b2032518a4	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
cd70f106-7de8-4c45-a890-80b2032518a4	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
cd70f106-7de8-4c45-a890-80b2032518a4	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
cd70f106-7de8-4c45-a890-80b2032518a4	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
cd70f106-7de8-4c45-a890-80b2032518a4	e1a106b8-8c8c-4fee-bb90-4b0f46b049e9	musician	\N
cd70f106-7de8-4c45-a890-80b2032518a4	9bc9004a-4384-459a-a437-c5a76758704d	musician	\N
cd70f106-7de8-4c45-a890-80b2032518a4	9fba26b0-6fca-45d2-8933-954cd22c9e15	musician	\N
cd70f106-7de8-4c45-a890-80b2032518a4	f063b7e2-06eb-41dc-9cda-5714a4fd97da	musician	\N
1fec70d0-4494-4cef-9788-2044a712d059	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
1fec70d0-4494-4cef-9788-2044a712d059	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
1fec70d0-4494-4cef-9788-2044a712d059	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
1fec70d0-4494-4cef-9788-2044a712d059	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
1fec70d0-4494-4cef-9788-2044a712d059	e1a106b8-8c8c-4fee-bb90-4b0f46b049e9	musician	\N
1fec70d0-4494-4cef-9788-2044a712d059	9bc9004a-4384-459a-a437-c5a76758704d	musician	\N
1fec70d0-4494-4cef-9788-2044a712d059	9fba26b0-6fca-45d2-8933-954cd22c9e15	musician	\N
1fec70d0-4494-4cef-9788-2044a712d059	f063b7e2-06eb-41dc-9cda-5714a4fd97da	musician	\N
d9ae1b80-6628-4d01-947b-0d03c81f1f11	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
d9ae1b80-6628-4d01-947b-0d03c81f1f11	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
d9ae1b80-6628-4d01-947b-0d03c81f1f11	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
d9ae1b80-6628-4d01-947b-0d03c81f1f11	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
d9ae1b80-6628-4d01-947b-0d03c81f1f11	e1a106b8-8c8c-4fee-bb90-4b0f46b049e9	musician	\N
d9ae1b80-6628-4d01-947b-0d03c81f1f11	9bc9004a-4384-459a-a437-c5a76758704d	musician	\N
d9ae1b80-6628-4d01-947b-0d03c81f1f11	9fba26b0-6fca-45d2-8933-954cd22c9e15	musician	\N
d9ae1b80-6628-4d01-947b-0d03c81f1f11	f063b7e2-06eb-41dc-9cda-5714a4fd97da	musician	\N
e696c9df-3a8a-411e-959a-c1b93890032f	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
e696c9df-3a8a-411e-959a-c1b93890032f	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
e696c9df-3a8a-411e-959a-c1b93890032f	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
e696c9df-3a8a-411e-959a-c1b93890032f	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
e696c9df-3a8a-411e-959a-c1b93890032f	e1a106b8-8c8c-4fee-bb90-4b0f46b049e9	musician	\N
e696c9df-3a8a-411e-959a-c1b93890032f	9bc9004a-4384-459a-a437-c5a76758704d	musician	\N
e696c9df-3a8a-411e-959a-c1b93890032f	9fba26b0-6fca-45d2-8933-954cd22c9e15	musician	\N
e696c9df-3a8a-411e-959a-c1b93890032f	f063b7e2-06eb-41dc-9cda-5714a4fd97da	musician	\N
966b1f44-b1b9-478a-a185-6375c9ed0808	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
966b1f44-b1b9-478a-a185-6375c9ed0808	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
966b1f44-b1b9-478a-a185-6375c9ed0808	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
966b1f44-b1b9-478a-a185-6375c9ed0808	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
966b1f44-b1b9-478a-a185-6375c9ed0808	e1a106b8-8c8c-4fee-bb90-4b0f46b049e9	musician	\N
966b1f44-b1b9-478a-a185-6375c9ed0808	9bc9004a-4384-459a-a437-c5a76758704d	musician	\N
966b1f44-b1b9-478a-a185-6375c9ed0808	9fba26b0-6fca-45d2-8933-954cd22c9e15	musician	\N
966b1f44-b1b9-478a-a185-6375c9ed0808	f063b7e2-06eb-41dc-9cda-5714a4fd97da	musician	\N
bf53173c-a420-45e3-be70-3d03e23b4551	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
bf53173c-a420-45e3-be70-3d03e23b4551	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
bf53173c-a420-45e3-be70-3d03e23b4551	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
bf53173c-a420-45e3-be70-3d03e23b4551	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
bf53173c-a420-45e3-be70-3d03e23b4551	e1a106b8-8c8c-4fee-bb90-4b0f46b049e9	musician	\N
bf53173c-a420-45e3-be70-3d03e23b4551	9bc9004a-4384-459a-a437-c5a76758704d	musician	\N
bf53173c-a420-45e3-be70-3d03e23b4551	9fba26b0-6fca-45d2-8933-954cd22c9e15	musician	\N
bf53173c-a420-45e3-be70-3d03e23b4551	f063b7e2-06eb-41dc-9cda-5714a4fd97da	musician	\N
1f891548-c46e-4b80-91c6-b928bd9076cf	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
1f891548-c46e-4b80-91c6-b928bd9076cf	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
1f891548-c46e-4b80-91c6-b928bd9076cf	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
1f891548-c46e-4b80-91c6-b928bd9076cf	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
1f891548-c46e-4b80-91c6-b928bd9076cf	e1a106b8-8c8c-4fee-bb90-4b0f46b049e9	musician	\N
1f891548-c46e-4b80-91c6-b928bd9076cf	9bc9004a-4384-459a-a437-c5a76758704d	musician	\N
1f891548-c46e-4b80-91c6-b928bd9076cf	9fba26b0-6fca-45d2-8933-954cd22c9e15	musician	\N
1f891548-c46e-4b80-91c6-b928bd9076cf	f063b7e2-06eb-41dc-9cda-5714a4fd97da	musician	\N
3ef35113-4602-484c-9329-e4b1a0293797	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
3ef35113-4602-484c-9329-e4b1a0293797	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
3ef35113-4602-484c-9329-e4b1a0293797	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
3ef35113-4602-484c-9329-e4b1a0293797	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
3ef35113-4602-484c-9329-e4b1a0293797	e1a106b8-8c8c-4fee-bb90-4b0f46b049e9	musician	\N
3ef35113-4602-484c-9329-e4b1a0293797	9bc9004a-4384-459a-a437-c5a76758704d	musician	\N
3ef35113-4602-484c-9329-e4b1a0293797	9fba26b0-6fca-45d2-8933-954cd22c9e15	musician	\N
3ef35113-4602-484c-9329-e4b1a0293797	f063b7e2-06eb-41dc-9cda-5714a4fd97da	musician	\N
41fdb870-64fb-44a7-b863-6fa37ade63ed	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
41fdb870-64fb-44a7-b863-6fa37ade63ed	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
41fdb870-64fb-44a7-b863-6fa37ade63ed	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
41fdb870-64fb-44a7-b863-6fa37ade63ed	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
41fdb870-64fb-44a7-b863-6fa37ade63ed	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
41fdb870-64fb-44a7-b863-6fa37ade63ed	fc960ba4-1d9e-4d21-b80b-4c08778fd2c8	musician	\N
41fdb870-64fb-44a7-b863-6fa37ade63ed	83638843-8a89-4911-805c-1b74233c5cf5	musician	\N
41fdb870-64fb-44a7-b863-6fa37ade63ed	146c4d2e-8439-49a2-86a8-a4f2d1a240a4	musician	\N
aee73938-e08f-443c-9eb6-4939b24e5b18	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
aee73938-e08f-443c-9eb6-4939b24e5b18	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
aee73938-e08f-443c-9eb6-4939b24e5b18	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
aee73938-e08f-443c-9eb6-4939b24e5b18	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
aee73938-e08f-443c-9eb6-4939b24e5b18	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
aee73938-e08f-443c-9eb6-4939b24e5b18	fc960ba4-1d9e-4d21-b80b-4c08778fd2c8	musician	\N
aee73938-e08f-443c-9eb6-4939b24e5b18	83638843-8a89-4911-805c-1b74233c5cf5	musician	\N
aee73938-e08f-443c-9eb6-4939b24e5b18	146c4d2e-8439-49a2-86a8-a4f2d1a240a4	musician	\N
9dc7a707-d71d-41c0-8541-5361907828fa	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
9dc7a707-d71d-41c0-8541-5361907828fa	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
9dc7a707-d71d-41c0-8541-5361907828fa	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
9dc7a707-d71d-41c0-8541-5361907828fa	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
9dc7a707-d71d-41c0-8541-5361907828fa	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
9dc7a707-d71d-41c0-8541-5361907828fa	fc960ba4-1d9e-4d21-b80b-4c08778fd2c8	musician	\N
9dc7a707-d71d-41c0-8541-5361907828fa	83638843-8a89-4911-805c-1b74233c5cf5	musician	\N
9dc7a707-d71d-41c0-8541-5361907828fa	146c4d2e-8439-49a2-86a8-a4f2d1a240a4	musician	\N
ee5736b4-5078-4d35-b143-a34fcb5b44d2	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
ee5736b4-5078-4d35-b143-a34fcb5b44d2	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
ee5736b4-5078-4d35-b143-a34fcb5b44d2	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
ee5736b4-5078-4d35-b143-a34fcb5b44d2	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
ee5736b4-5078-4d35-b143-a34fcb5b44d2	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
ee5736b4-5078-4d35-b143-a34fcb5b44d2	fc960ba4-1d9e-4d21-b80b-4c08778fd2c8	musician	\N
ee5736b4-5078-4d35-b143-a34fcb5b44d2	83638843-8a89-4911-805c-1b74233c5cf5	musician	\N
ee5736b4-5078-4d35-b143-a34fcb5b44d2	146c4d2e-8439-49a2-86a8-a4f2d1a240a4	musician	\N
de53a002-6644-40cb-81cc-d9c5b780cae9	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
de53a002-6644-40cb-81cc-d9c5b780cae9	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
de53a002-6644-40cb-81cc-d9c5b780cae9	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
de53a002-6644-40cb-81cc-d9c5b780cae9	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
de53a002-6644-40cb-81cc-d9c5b780cae9	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
de53a002-6644-40cb-81cc-d9c5b780cae9	fc960ba4-1d9e-4d21-b80b-4c08778fd2c8	musician	\N
de53a002-6644-40cb-81cc-d9c5b780cae9	83638843-8a89-4911-805c-1b74233c5cf5	musician	\N
de53a002-6644-40cb-81cc-d9c5b780cae9	146c4d2e-8439-49a2-86a8-a4f2d1a240a4	musician	\N
4edc21e4-42d4-4b16-86d8-d70bb97b4499	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
4edc21e4-42d4-4b16-86d8-d70bb97b4499	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
4edc21e4-42d4-4b16-86d8-d70bb97b4499	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
4edc21e4-42d4-4b16-86d8-d70bb97b4499	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
4edc21e4-42d4-4b16-86d8-d70bb97b4499	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
4edc21e4-42d4-4b16-86d8-d70bb97b4499	fc960ba4-1d9e-4d21-b80b-4c08778fd2c8	musician	\N
4edc21e4-42d4-4b16-86d8-d70bb97b4499	83638843-8a89-4911-805c-1b74233c5cf5	musician	\N
4edc21e4-42d4-4b16-86d8-d70bb97b4499	146c4d2e-8439-49a2-86a8-a4f2d1a240a4	musician	\N
22c6fec0-32e5-4b89-b3f7-faabe7290bcc	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
22c6fec0-32e5-4b89-b3f7-faabe7290bcc	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
22c6fec0-32e5-4b89-b3f7-faabe7290bcc	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
22c6fec0-32e5-4b89-b3f7-faabe7290bcc	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
22c6fec0-32e5-4b89-b3f7-faabe7290bcc	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
22c6fec0-32e5-4b89-b3f7-faabe7290bcc	fc960ba4-1d9e-4d21-b80b-4c08778fd2c8	musician	\N
22c6fec0-32e5-4b89-b3f7-faabe7290bcc	83638843-8a89-4911-805c-1b74233c5cf5	musician	\N
22c6fec0-32e5-4b89-b3f7-faabe7290bcc	146c4d2e-8439-49a2-86a8-a4f2d1a240a4	musician	\N
35735121-6583-4df8-9526-fc7cc8edd5fc	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
35735121-6583-4df8-9526-fc7cc8edd5fc	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
35735121-6583-4df8-9526-fc7cc8edd5fc	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
35735121-6583-4df8-9526-fc7cc8edd5fc	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
35735121-6583-4df8-9526-fc7cc8edd5fc	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
35735121-6583-4df8-9526-fc7cc8edd5fc	fc960ba4-1d9e-4d21-b80b-4c08778fd2c8	musician	\N
35735121-6583-4df8-9526-fc7cc8edd5fc	83638843-8a89-4911-805c-1b74233c5cf5	musician	\N
35735121-6583-4df8-9526-fc7cc8edd5fc	146c4d2e-8439-49a2-86a8-a4f2d1a240a4	musician	\N
298267eb-a490-4408-9ada-cb5b5864c2cb	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
298267eb-a490-4408-9ada-cb5b5864c2cb	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
298267eb-a490-4408-9ada-cb5b5864c2cb	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
298267eb-a490-4408-9ada-cb5b5864c2cb	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
298267eb-a490-4408-9ada-cb5b5864c2cb	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
298267eb-a490-4408-9ada-cb5b5864c2cb	fc960ba4-1d9e-4d21-b80b-4c08778fd2c8	musician	\N
298267eb-a490-4408-9ada-cb5b5864c2cb	83638843-8a89-4911-805c-1b74233c5cf5	musician	\N
298267eb-a490-4408-9ada-cb5b5864c2cb	146c4d2e-8439-49a2-86a8-a4f2d1a240a4	musician	\N
557ad703-cb16-4046-a3af-35a32e0a4b4d	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
557ad703-cb16-4046-a3af-35a32e0a4b4d	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
557ad703-cb16-4046-a3af-35a32e0a4b4d	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
557ad703-cb16-4046-a3af-35a32e0a4b4d	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
557ad703-cb16-4046-a3af-35a32e0a4b4d	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
557ad703-cb16-4046-a3af-35a32e0a4b4d	fc960ba4-1d9e-4d21-b80b-4c08778fd2c8	musician	\N
557ad703-cb16-4046-a3af-35a32e0a4b4d	83638843-8a89-4911-805c-1b74233c5cf5	musician	\N
557ad703-cb16-4046-a3af-35a32e0a4b4d	146c4d2e-8439-49a2-86a8-a4f2d1a240a4	musician	\N
507a5c5c-d828-4181-9516-950d2b837b1a	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
507a5c5c-d828-4181-9516-950d2b837b1a	dcbe59a3-af12-4d97-a570-63ad7bfe078c	musician	\N
507a5c5c-d828-4181-9516-950d2b837b1a	aaacd880-8a8b-4f4f-bfb6-9f624d83d4a5	musician	\N
507a5c5c-d828-4181-9516-950d2b837b1a	c0b33917-530a-4565-8f72-51f937a2adcc	musician	\N
507a5c5c-d828-4181-9516-950d2b837b1a	fb6792ec-79b3-48fe-9e4f-8f8ed45fa697	musician	\N
507a5c5c-d828-4181-9516-950d2b837b1a	14e57665-4f3d-44c7-aa5e-ee9ebebe40ce	musician	\N
507a5c5c-d828-4181-9516-950d2b837b1a	cd8c2eac-c5bb-49c6-9948-4c3d3f4cba96	musician	\N
507a5c5c-d828-4181-9516-950d2b837b1a	5c0d6118-8ae8-49ed-b6e3-4ebcade708bb	musician	\N
507a5c5c-d828-4181-9516-950d2b837b1a	669f8f3f-ea44-4710-a386-dc16d41110cc	musician	\N
8208c1aa-a51c-4ff4-920f-3983a3bb9561	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
8208c1aa-a51c-4ff4-920f-3983a3bb9561	dcbe59a3-af12-4d97-a570-63ad7bfe078c	musician	\N
8208c1aa-a51c-4ff4-920f-3983a3bb9561	aaacd880-8a8b-4f4f-bfb6-9f624d83d4a5	musician	\N
8208c1aa-a51c-4ff4-920f-3983a3bb9561	c0b33917-530a-4565-8f72-51f937a2adcc	musician	\N
8208c1aa-a51c-4ff4-920f-3983a3bb9561	fb6792ec-79b3-48fe-9e4f-8f8ed45fa697	musician	\N
8208c1aa-a51c-4ff4-920f-3983a3bb9561	14e57665-4f3d-44c7-aa5e-ee9ebebe40ce	musician	\N
8208c1aa-a51c-4ff4-920f-3983a3bb9561	cd8c2eac-c5bb-49c6-9948-4c3d3f4cba96	musician	\N
8208c1aa-a51c-4ff4-920f-3983a3bb9561	5c0d6118-8ae8-49ed-b6e3-4ebcade708bb	musician	\N
8208c1aa-a51c-4ff4-920f-3983a3bb9561	669f8f3f-ea44-4710-a386-dc16d41110cc	musician	\N
7399581c-7454-4c60-95a9-fe391580e363	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
7399581c-7454-4c60-95a9-fe391580e363	dcbe59a3-af12-4d97-a570-63ad7bfe078c	musician	\N
7399581c-7454-4c60-95a9-fe391580e363	aaacd880-8a8b-4f4f-bfb6-9f624d83d4a5	musician	\N
7399581c-7454-4c60-95a9-fe391580e363	c0b33917-530a-4565-8f72-51f937a2adcc	musician	\N
7399581c-7454-4c60-95a9-fe391580e363	fb6792ec-79b3-48fe-9e4f-8f8ed45fa697	musician	\N
7399581c-7454-4c60-95a9-fe391580e363	14e57665-4f3d-44c7-aa5e-ee9ebebe40ce	musician	\N
7399581c-7454-4c60-95a9-fe391580e363	cd8c2eac-c5bb-49c6-9948-4c3d3f4cba96	musician	\N
7399581c-7454-4c60-95a9-fe391580e363	5c0d6118-8ae8-49ed-b6e3-4ebcade708bb	musician	\N
7399581c-7454-4c60-95a9-fe391580e363	669f8f3f-ea44-4710-a386-dc16d41110cc	musician	\N
3b7a41bc-10ca-4af0-ae8e-f5046b1db3e5	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
3b7a41bc-10ca-4af0-ae8e-f5046b1db3e5	dcbe59a3-af12-4d97-a570-63ad7bfe078c	musician	\N
3b7a41bc-10ca-4af0-ae8e-f5046b1db3e5	aaacd880-8a8b-4f4f-bfb6-9f624d83d4a5	musician	\N
3b7a41bc-10ca-4af0-ae8e-f5046b1db3e5	c0b33917-530a-4565-8f72-51f937a2adcc	musician	\N
3b7a41bc-10ca-4af0-ae8e-f5046b1db3e5	fb6792ec-79b3-48fe-9e4f-8f8ed45fa697	musician	\N
3b7a41bc-10ca-4af0-ae8e-f5046b1db3e5	14e57665-4f3d-44c7-aa5e-ee9ebebe40ce	musician	\N
3b7a41bc-10ca-4af0-ae8e-f5046b1db3e5	cd8c2eac-c5bb-49c6-9948-4c3d3f4cba96	musician	\N
3b7a41bc-10ca-4af0-ae8e-f5046b1db3e5	5c0d6118-8ae8-49ed-b6e3-4ebcade708bb	musician	\N
3b7a41bc-10ca-4af0-ae8e-f5046b1db3e5	669f8f3f-ea44-4710-a386-dc16d41110cc	musician	\N
90f5754b-ebe1-40dd-9ef4-28d5aa58c4c9	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
90f5754b-ebe1-40dd-9ef4-28d5aa58c4c9	dcbe59a3-af12-4d97-a570-63ad7bfe078c	musician	\N
90f5754b-ebe1-40dd-9ef4-28d5aa58c4c9	aaacd880-8a8b-4f4f-bfb6-9f624d83d4a5	musician	\N
90f5754b-ebe1-40dd-9ef4-28d5aa58c4c9	c0b33917-530a-4565-8f72-51f937a2adcc	musician	\N
90f5754b-ebe1-40dd-9ef4-28d5aa58c4c9	fb6792ec-79b3-48fe-9e4f-8f8ed45fa697	musician	\N
90f5754b-ebe1-40dd-9ef4-28d5aa58c4c9	14e57665-4f3d-44c7-aa5e-ee9ebebe40ce	musician	\N
90f5754b-ebe1-40dd-9ef4-28d5aa58c4c9	cd8c2eac-c5bb-49c6-9948-4c3d3f4cba96	musician	\N
90f5754b-ebe1-40dd-9ef4-28d5aa58c4c9	5c0d6118-8ae8-49ed-b6e3-4ebcade708bb	musician	\N
90f5754b-ebe1-40dd-9ef4-28d5aa58c4c9	669f8f3f-ea44-4710-a386-dc16d41110cc	musician	\N
c2a0a42b-fa6d-4ac5-b968-631343c94321	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
c2a0a42b-fa6d-4ac5-b968-631343c94321	dcbe59a3-af12-4d97-a570-63ad7bfe078c	musician	\N
c2a0a42b-fa6d-4ac5-b968-631343c94321	aaacd880-8a8b-4f4f-bfb6-9f624d83d4a5	musician	\N
c2a0a42b-fa6d-4ac5-b968-631343c94321	c0b33917-530a-4565-8f72-51f937a2adcc	musician	\N
c2a0a42b-fa6d-4ac5-b968-631343c94321	fb6792ec-79b3-48fe-9e4f-8f8ed45fa697	musician	\N
c2a0a42b-fa6d-4ac5-b968-631343c94321	14e57665-4f3d-44c7-aa5e-ee9ebebe40ce	musician	\N
c2a0a42b-fa6d-4ac5-b968-631343c94321	cd8c2eac-c5bb-49c6-9948-4c3d3f4cba96	musician	\N
c2a0a42b-fa6d-4ac5-b968-631343c94321	5c0d6118-8ae8-49ed-b6e3-4ebcade708bb	musician	\N
c2a0a42b-fa6d-4ac5-b968-631343c94321	669f8f3f-ea44-4710-a386-dc16d41110cc	musician	\N
7c0315c7-1d0f-45dd-8152-9c3b747ae647	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
7c0315c7-1d0f-45dd-8152-9c3b747ae647	dcbe59a3-af12-4d97-a570-63ad7bfe078c	musician	\N
7c0315c7-1d0f-45dd-8152-9c3b747ae647	aaacd880-8a8b-4f4f-bfb6-9f624d83d4a5	musician	\N
7c0315c7-1d0f-45dd-8152-9c3b747ae647	c0b33917-530a-4565-8f72-51f937a2adcc	musician	\N
7c0315c7-1d0f-45dd-8152-9c3b747ae647	fb6792ec-79b3-48fe-9e4f-8f8ed45fa697	musician	\N
7c0315c7-1d0f-45dd-8152-9c3b747ae647	14e57665-4f3d-44c7-aa5e-ee9ebebe40ce	musician	\N
7c0315c7-1d0f-45dd-8152-9c3b747ae647	cd8c2eac-c5bb-49c6-9948-4c3d3f4cba96	musician	\N
7c0315c7-1d0f-45dd-8152-9c3b747ae647	5c0d6118-8ae8-49ed-b6e3-4ebcade708bb	musician	\N
7c0315c7-1d0f-45dd-8152-9c3b747ae647	669f8f3f-ea44-4710-a386-dc16d41110cc	musician	\N
a10f73f8-7777-4a72-9997-91db9be6b929	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
a10f73f8-7777-4a72-9997-91db9be6b929	dcbe59a3-af12-4d97-a570-63ad7bfe078c	musician	\N
a10f73f8-7777-4a72-9997-91db9be6b929	aaacd880-8a8b-4f4f-bfb6-9f624d83d4a5	musician	\N
a10f73f8-7777-4a72-9997-91db9be6b929	c0b33917-530a-4565-8f72-51f937a2adcc	musician	\N
a10f73f8-7777-4a72-9997-91db9be6b929	fb6792ec-79b3-48fe-9e4f-8f8ed45fa697	musician	\N
a10f73f8-7777-4a72-9997-91db9be6b929	14e57665-4f3d-44c7-aa5e-ee9ebebe40ce	musician	\N
a10f73f8-7777-4a72-9997-91db9be6b929	cd8c2eac-c5bb-49c6-9948-4c3d3f4cba96	musician	\N
a10f73f8-7777-4a72-9997-91db9be6b929	5c0d6118-8ae8-49ed-b6e3-4ebcade708bb	musician	\N
a10f73f8-7777-4a72-9997-91db9be6b929	669f8f3f-ea44-4710-a386-dc16d41110cc	musician	\N
be447424-a6d2-45ed-b813-17d88d03c35d	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
be447424-a6d2-45ed-b813-17d88d03c35d	dcbe59a3-af12-4d97-a570-63ad7bfe078c	musician	\N
be447424-a6d2-45ed-b813-17d88d03c35d	aaacd880-8a8b-4f4f-bfb6-9f624d83d4a5	musician	\N
be447424-a6d2-45ed-b813-17d88d03c35d	c0b33917-530a-4565-8f72-51f937a2adcc	musician	\N
be447424-a6d2-45ed-b813-17d88d03c35d	fb6792ec-79b3-48fe-9e4f-8f8ed45fa697	musician	\N
be447424-a6d2-45ed-b813-17d88d03c35d	14e57665-4f3d-44c7-aa5e-ee9ebebe40ce	musician	\N
be447424-a6d2-45ed-b813-17d88d03c35d	cd8c2eac-c5bb-49c6-9948-4c3d3f4cba96	musician	\N
be447424-a6d2-45ed-b813-17d88d03c35d	5c0d6118-8ae8-49ed-b6e3-4ebcade708bb	musician	\N
be447424-a6d2-45ed-b813-17d88d03c35d	669f8f3f-ea44-4710-a386-dc16d41110cc	musician	\N
28cbee10-7def-4f0a-ad0f-41800ef94380	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
28cbee10-7def-4f0a-ad0f-41800ef94380	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
28cbee10-7def-4f0a-ad0f-41800ef94380	d1c51e36-dcad-4aff-a9d9-10ffdfb0118d	musician	\N
28cbee10-7def-4f0a-ad0f-41800ef94380	cb450c14-8087-47ce-8298-673a78487072	musician	\N
28cbee10-7def-4f0a-ad0f-41800ef94380	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
28cbee10-7def-4f0a-ad0f-41800ef94380	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
28cbee10-7def-4f0a-ad0f-41800ef94380	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
4996b88a-f8c4-4943-8026-2439ffa339f3	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
4996b88a-f8c4-4943-8026-2439ffa339f3	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
4996b88a-f8c4-4943-8026-2439ffa339f3	d1c51e36-dcad-4aff-a9d9-10ffdfb0118d	musician	\N
4996b88a-f8c4-4943-8026-2439ffa339f3	cb450c14-8087-47ce-8298-673a78487072	musician	\N
4996b88a-f8c4-4943-8026-2439ffa339f3	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
4996b88a-f8c4-4943-8026-2439ffa339f3	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
4996b88a-f8c4-4943-8026-2439ffa339f3	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
f7e94fde-4a03-4c9b-91cf-9525d2575afd	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
f7e94fde-4a03-4c9b-91cf-9525d2575afd	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
f7e94fde-4a03-4c9b-91cf-9525d2575afd	d1c51e36-dcad-4aff-a9d9-10ffdfb0118d	musician	\N
f7e94fde-4a03-4c9b-91cf-9525d2575afd	cb450c14-8087-47ce-8298-673a78487072	musician	\N
f7e94fde-4a03-4c9b-91cf-9525d2575afd	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
f7e94fde-4a03-4c9b-91cf-9525d2575afd	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
f7e94fde-4a03-4c9b-91cf-9525d2575afd	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
557ea8f6-9f56-4be3-8897-d38b366e5464	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
557ea8f6-9f56-4be3-8897-d38b366e5464	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
557ea8f6-9f56-4be3-8897-d38b366e5464	d1c51e36-dcad-4aff-a9d9-10ffdfb0118d	musician	\N
557ea8f6-9f56-4be3-8897-d38b366e5464	cb450c14-8087-47ce-8298-673a78487072	musician	\N
557ea8f6-9f56-4be3-8897-d38b366e5464	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
557ea8f6-9f56-4be3-8897-d38b366e5464	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
557ea8f6-9f56-4be3-8897-d38b366e5464	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
ada4c57d-e0e9-4c95-bf4c-d7fe53953d3e	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
ada4c57d-e0e9-4c95-bf4c-d7fe53953d3e	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
ada4c57d-e0e9-4c95-bf4c-d7fe53953d3e	d1c51e36-dcad-4aff-a9d9-10ffdfb0118d	musician	\N
ada4c57d-e0e9-4c95-bf4c-d7fe53953d3e	cb450c14-8087-47ce-8298-673a78487072	musician	\N
ada4c57d-e0e9-4c95-bf4c-d7fe53953d3e	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
ada4c57d-e0e9-4c95-bf4c-d7fe53953d3e	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
ada4c57d-e0e9-4c95-bf4c-d7fe53953d3e	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
0ad4a4fa-f8de-4047-8bda-d07313d51f1c	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
0ad4a4fa-f8de-4047-8bda-d07313d51f1c	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
0ad4a4fa-f8de-4047-8bda-d07313d51f1c	d1c51e36-dcad-4aff-a9d9-10ffdfb0118d	musician	\N
0ad4a4fa-f8de-4047-8bda-d07313d51f1c	cb450c14-8087-47ce-8298-673a78487072	musician	\N
0ad4a4fa-f8de-4047-8bda-d07313d51f1c	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
0ad4a4fa-f8de-4047-8bda-d07313d51f1c	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
0ad4a4fa-f8de-4047-8bda-d07313d51f1c	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
5cf50d37-f372-4b62-a130-0928def5ffe3	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
5cf50d37-f372-4b62-a130-0928def5ffe3	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
5cf50d37-f372-4b62-a130-0928def5ffe3	d1c51e36-dcad-4aff-a9d9-10ffdfb0118d	musician	\N
5cf50d37-f372-4b62-a130-0928def5ffe3	cb450c14-8087-47ce-8298-673a78487072	musician	\N
5cf50d37-f372-4b62-a130-0928def5ffe3	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
5cf50d37-f372-4b62-a130-0928def5ffe3	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
5cf50d37-f372-4b62-a130-0928def5ffe3	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
5d122ecb-4f53-4f55-9702-0c63b4c32f9e	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
5d122ecb-4f53-4f55-9702-0c63b4c32f9e	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
5d122ecb-4f53-4f55-9702-0c63b4c32f9e	d1c51e36-dcad-4aff-a9d9-10ffdfb0118d	musician	\N
5d122ecb-4f53-4f55-9702-0c63b4c32f9e	cb450c14-8087-47ce-8298-673a78487072	musician	\N
5d122ecb-4f53-4f55-9702-0c63b4c32f9e	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
5d122ecb-4f53-4f55-9702-0c63b4c32f9e	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
5d122ecb-4f53-4f55-9702-0c63b4c32f9e	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
5fe34c92-f026-41a9-bf4d-00264881c630	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
5fe34c92-f026-41a9-bf4d-00264881c630	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
5fe34c92-f026-41a9-bf4d-00264881c630	d1c51e36-dcad-4aff-a9d9-10ffdfb0118d	musician	\N
5fe34c92-f026-41a9-bf4d-00264881c630	cb450c14-8087-47ce-8298-673a78487072	musician	\N
5fe34c92-f026-41a9-bf4d-00264881c630	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
5fe34c92-f026-41a9-bf4d-00264881c630	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
5fe34c92-f026-41a9-bf4d-00264881c630	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
a93622d5-019a-4924-b458-b34353ce5dce	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
a93622d5-019a-4924-b458-b34353ce5dce	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
a93622d5-019a-4924-b458-b34353ce5dce	d1c51e36-dcad-4aff-a9d9-10ffdfb0118d	musician	\N
a93622d5-019a-4924-b458-b34353ce5dce	cb450c14-8087-47ce-8298-673a78487072	musician	\N
a93622d5-019a-4924-b458-b34353ce5dce	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
a93622d5-019a-4924-b458-b34353ce5dce	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
a93622d5-019a-4924-b458-b34353ce5dce	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
42c18384-6104-4e7e-b669-67cc9feffab5	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
42c18384-6104-4e7e-b669-67cc9feffab5	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
42c18384-6104-4e7e-b669-67cc9feffab5	d1c51e36-dcad-4aff-a9d9-10ffdfb0118d	musician	\N
42c18384-6104-4e7e-b669-67cc9feffab5	cb450c14-8087-47ce-8298-673a78487072	musician	\N
42c18384-6104-4e7e-b669-67cc9feffab5	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
42c18384-6104-4e7e-b669-67cc9feffab5	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
42c18384-6104-4e7e-b669-67cc9feffab5	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
636e9138-2ee1-4197-afea-100c85a8ec9b	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
636e9138-2ee1-4197-afea-100c85a8ec9b	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
636e9138-2ee1-4197-afea-100c85a8ec9b	d1c51e36-dcad-4aff-a9d9-10ffdfb0118d	musician	\N
636e9138-2ee1-4197-afea-100c85a8ec9b	cb450c14-8087-47ce-8298-673a78487072	musician	\N
636e9138-2ee1-4197-afea-100c85a8ec9b	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
636e9138-2ee1-4197-afea-100c85a8ec9b	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
636e9138-2ee1-4197-afea-100c85a8ec9b	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
f8918d61-e93a-4064-ab52-e7acc677d2c3	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
f8918d61-e93a-4064-ab52-e7acc677d2c3	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
f8918d61-e93a-4064-ab52-e7acc677d2c3	cb450c14-8087-47ce-8298-673a78487072	musician	\N
f8918d61-e93a-4064-ab52-e7acc677d2c3	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
f8918d61-e93a-4064-ab52-e7acc677d2c3	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
f8918d61-e93a-4064-ab52-e7acc677d2c3	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
f8918d61-e93a-4064-ab52-e7acc677d2c3	d7d77953-0537-41b8-9f4c-212c1d2b8908	musician	\N
0f909c77-c53f-4dfb-8d0f-49420a57b392	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
0f909c77-c53f-4dfb-8d0f-49420a57b392	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
0f909c77-c53f-4dfb-8d0f-49420a57b392	cb450c14-8087-47ce-8298-673a78487072	musician	\N
0f909c77-c53f-4dfb-8d0f-49420a57b392	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
0f909c77-c53f-4dfb-8d0f-49420a57b392	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
0f909c77-c53f-4dfb-8d0f-49420a57b392	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
0f909c77-c53f-4dfb-8d0f-49420a57b392	d7d77953-0537-41b8-9f4c-212c1d2b8908	musician	\N
6dd89d9d-87e2-4f5f-8295-71f2859e2f00	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
6dd89d9d-87e2-4f5f-8295-71f2859e2f00	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
6dd89d9d-87e2-4f5f-8295-71f2859e2f00	cb450c14-8087-47ce-8298-673a78487072	musician	\N
6dd89d9d-87e2-4f5f-8295-71f2859e2f00	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
6dd89d9d-87e2-4f5f-8295-71f2859e2f00	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
6dd89d9d-87e2-4f5f-8295-71f2859e2f00	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
6dd89d9d-87e2-4f5f-8295-71f2859e2f00	d7d77953-0537-41b8-9f4c-212c1d2b8908	musician	\N
0de06350-8914-4517-ab5a-0ca414aa3e44	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
0de06350-8914-4517-ab5a-0ca414aa3e44	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
0de06350-8914-4517-ab5a-0ca414aa3e44	cb450c14-8087-47ce-8298-673a78487072	musician	\N
0de06350-8914-4517-ab5a-0ca414aa3e44	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
0de06350-8914-4517-ab5a-0ca414aa3e44	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
0de06350-8914-4517-ab5a-0ca414aa3e44	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
0de06350-8914-4517-ab5a-0ca414aa3e44	d7d77953-0537-41b8-9f4c-212c1d2b8908	musician	\N
eec6c1c2-0d42-4e01-9e9e-f9b9e93ab9e7	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
eec6c1c2-0d42-4e01-9e9e-f9b9e93ab9e7	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
eec6c1c2-0d42-4e01-9e9e-f9b9e93ab9e7	cb450c14-8087-47ce-8298-673a78487072	musician	\N
eec6c1c2-0d42-4e01-9e9e-f9b9e93ab9e7	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
eec6c1c2-0d42-4e01-9e9e-f9b9e93ab9e7	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
eec6c1c2-0d42-4e01-9e9e-f9b9e93ab9e7	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
eec6c1c2-0d42-4e01-9e9e-f9b9e93ab9e7	d7d77953-0537-41b8-9f4c-212c1d2b8908	musician	\N
b52e321b-e30c-4f26-bbfb-095ceee16253	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
b52e321b-e30c-4f26-bbfb-095ceee16253	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
b52e321b-e30c-4f26-bbfb-095ceee16253	cb450c14-8087-47ce-8298-673a78487072	musician	\N
b52e321b-e30c-4f26-bbfb-095ceee16253	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
b52e321b-e30c-4f26-bbfb-095ceee16253	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
b52e321b-e30c-4f26-bbfb-095ceee16253	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
b52e321b-e30c-4f26-bbfb-095ceee16253	d7d77953-0537-41b8-9f4c-212c1d2b8908	musician	\N
ce90f3aa-d79f-4a2d-a2ac-460f5e31b5e8	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
ce90f3aa-d79f-4a2d-a2ac-460f5e31b5e8	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
ce90f3aa-d79f-4a2d-a2ac-460f5e31b5e8	cb450c14-8087-47ce-8298-673a78487072	musician	\N
ce90f3aa-d79f-4a2d-a2ac-460f5e31b5e8	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
ce90f3aa-d79f-4a2d-a2ac-460f5e31b5e8	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
ce90f3aa-d79f-4a2d-a2ac-460f5e31b5e8	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
ce90f3aa-d79f-4a2d-a2ac-460f5e31b5e8	d7d77953-0537-41b8-9f4c-212c1d2b8908	musician	\N
2d142f2b-13a0-44c1-9a7e-23d8bd8bf039	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
2d142f2b-13a0-44c1-9a7e-23d8bd8bf039	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
2d142f2b-13a0-44c1-9a7e-23d8bd8bf039	cb450c14-8087-47ce-8298-673a78487072	musician	\N
2d142f2b-13a0-44c1-9a7e-23d8bd8bf039	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
2d142f2b-13a0-44c1-9a7e-23d8bd8bf039	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
2d142f2b-13a0-44c1-9a7e-23d8bd8bf039	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
2d142f2b-13a0-44c1-9a7e-23d8bd8bf039	d7d77953-0537-41b8-9f4c-212c1d2b8908	musician	\N
14d48b5b-fc92-46d5-b11c-13c3216f0a04	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
14d48b5b-fc92-46d5-b11c-13c3216f0a04	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
14d48b5b-fc92-46d5-b11c-13c3216f0a04	cb450c14-8087-47ce-8298-673a78487072	musician	\N
14d48b5b-fc92-46d5-b11c-13c3216f0a04	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
14d48b5b-fc92-46d5-b11c-13c3216f0a04	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
14d48b5b-fc92-46d5-b11c-13c3216f0a04	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
14d48b5b-fc92-46d5-b11c-13c3216f0a04	d7d77953-0537-41b8-9f4c-212c1d2b8908	musician	\N
c6bfdbc5-00ad-4aae-b306-cdd3cf2c3d56	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
c6bfdbc5-00ad-4aae-b306-cdd3cf2c3d56	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
c6bfdbc5-00ad-4aae-b306-cdd3cf2c3d56	cb450c14-8087-47ce-8298-673a78487072	musician	\N
c6bfdbc5-00ad-4aae-b306-cdd3cf2c3d56	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
c6bfdbc5-00ad-4aae-b306-cdd3cf2c3d56	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
c6bfdbc5-00ad-4aae-b306-cdd3cf2c3d56	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
c6bfdbc5-00ad-4aae-b306-cdd3cf2c3d56	d7d77953-0537-41b8-9f4c-212c1d2b8908	musician	\N
9afd11ab-7f47-4a90-bb98-f396e11f9401	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
9afd11ab-7f47-4a90-bb98-f396e11f9401	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
9afd11ab-7f47-4a90-bb98-f396e11f9401	cb450c14-8087-47ce-8298-673a78487072	musician	\N
9afd11ab-7f47-4a90-bb98-f396e11f9401	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
9afd11ab-7f47-4a90-bb98-f396e11f9401	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
9afd11ab-7f47-4a90-bb98-f396e11f9401	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
9afd11ab-7f47-4a90-bb98-f396e11f9401	d7d77953-0537-41b8-9f4c-212c1d2b8908	musician	\N
10ca92eb-4bc5-4591-8060-562bebcc6616	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
10ca92eb-4bc5-4591-8060-562bebcc6616	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
10ca92eb-4bc5-4591-8060-562bebcc6616	cb450c14-8087-47ce-8298-673a78487072	musician	\N
10ca92eb-4bc5-4591-8060-562bebcc6616	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
10ca92eb-4bc5-4591-8060-562bebcc6616	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
10ca92eb-4bc5-4591-8060-562bebcc6616	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
10ca92eb-4bc5-4591-8060-562bebcc6616	d7d77953-0537-41b8-9f4c-212c1d2b8908	musician	\N
910d9763-2d67-4e08-a0d7-0e1e5e6c45ef	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
910d9763-2d67-4e08-a0d7-0e1e5e6c45ef	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
910d9763-2d67-4e08-a0d7-0e1e5e6c45ef	d7d77953-0537-41b8-9f4c-212c1d2b8908	musician	\N
910d9763-2d67-4e08-a0d7-0e1e5e6c45ef	af53f5a4-7a76-4114-a899-ca66de74ce5e	musician	\N
910d9763-2d67-4e08-a0d7-0e1e5e6c45ef	cb450c14-8087-47ce-8298-673a78487072	musician	\N
910d9763-2d67-4e08-a0d7-0e1e5e6c45ef	4246f981-1d59-4657-a89a-2cb4b967acf5	musician	\N
c57ea0df-159b-4af4-bfc9-3dd6f69dad13	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
c57ea0df-159b-4af4-bfc9-3dd6f69dad13	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
c57ea0df-159b-4af4-bfc9-3dd6f69dad13	d7d77953-0537-41b8-9f4c-212c1d2b8908	musician	\N
c57ea0df-159b-4af4-bfc9-3dd6f69dad13	af53f5a4-7a76-4114-a899-ca66de74ce5e	musician	\N
c57ea0df-159b-4af4-bfc9-3dd6f69dad13	cb450c14-8087-47ce-8298-673a78487072	musician	\N
c57ea0df-159b-4af4-bfc9-3dd6f69dad13	4246f981-1d59-4657-a89a-2cb4b967acf5	musician	\N
c431c364-3ee2-4654-8e89-05491f5479ad	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
c431c364-3ee2-4654-8e89-05491f5479ad	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
c431c364-3ee2-4654-8e89-05491f5479ad	d7d77953-0537-41b8-9f4c-212c1d2b8908	musician	\N
c431c364-3ee2-4654-8e89-05491f5479ad	af53f5a4-7a76-4114-a899-ca66de74ce5e	musician	\N
c431c364-3ee2-4654-8e89-05491f5479ad	cb450c14-8087-47ce-8298-673a78487072	musician	\N
c431c364-3ee2-4654-8e89-05491f5479ad	4246f981-1d59-4657-a89a-2cb4b967acf5	musician	\N
2842fda3-eb10-4aae-b4fb-8004ff89a2bd	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
2842fda3-eb10-4aae-b4fb-8004ff89a2bd	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
2842fda3-eb10-4aae-b4fb-8004ff89a2bd	d7d77953-0537-41b8-9f4c-212c1d2b8908	musician	\N
2842fda3-eb10-4aae-b4fb-8004ff89a2bd	af53f5a4-7a76-4114-a899-ca66de74ce5e	musician	\N
2842fda3-eb10-4aae-b4fb-8004ff89a2bd	cb450c14-8087-47ce-8298-673a78487072	musician	\N
2842fda3-eb10-4aae-b4fb-8004ff89a2bd	4246f981-1d59-4657-a89a-2cb4b967acf5	musician	\N
9df73ca6-e32d-4172-94f5-57e59b3a3c0b	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
9df73ca6-e32d-4172-94f5-57e59b3a3c0b	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
9df73ca6-e32d-4172-94f5-57e59b3a3c0b	d7d77953-0537-41b8-9f4c-212c1d2b8908	musician	\N
9df73ca6-e32d-4172-94f5-57e59b3a3c0b	af53f5a4-7a76-4114-a899-ca66de74ce5e	musician	\N
9df73ca6-e32d-4172-94f5-57e59b3a3c0b	cb450c14-8087-47ce-8298-673a78487072	musician	\N
9df73ca6-e32d-4172-94f5-57e59b3a3c0b	4246f981-1d59-4657-a89a-2cb4b967acf5	musician	\N
24712e22-99ee-4da8-87e5-29b29f74dfa6	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
24712e22-99ee-4da8-87e5-29b29f74dfa6	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
24712e22-99ee-4da8-87e5-29b29f74dfa6	d7d77953-0537-41b8-9f4c-212c1d2b8908	musician	\N
24712e22-99ee-4da8-87e5-29b29f74dfa6	af53f5a4-7a76-4114-a899-ca66de74ce5e	musician	\N
24712e22-99ee-4da8-87e5-29b29f74dfa6	cb450c14-8087-47ce-8298-673a78487072	musician	\N
24712e22-99ee-4da8-87e5-29b29f74dfa6	4246f981-1d59-4657-a89a-2cb4b967acf5	musician	\N
6853edf0-6fb0-45d3-a64d-9c1e2d1c28d9	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
6853edf0-6fb0-45d3-a64d-9c1e2d1c28d9	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
6853edf0-6fb0-45d3-a64d-9c1e2d1c28d9	d7d77953-0537-41b8-9f4c-212c1d2b8908	musician	\N
6853edf0-6fb0-45d3-a64d-9c1e2d1c28d9	af53f5a4-7a76-4114-a899-ca66de74ce5e	musician	\N
6853edf0-6fb0-45d3-a64d-9c1e2d1c28d9	cb450c14-8087-47ce-8298-673a78487072	musician	\N
6853edf0-6fb0-45d3-a64d-9c1e2d1c28d9	4246f981-1d59-4657-a89a-2cb4b967acf5	musician	\N
2f68cbc3-6171-42c9-8e3b-91bcf5b2fa71	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
2f68cbc3-6171-42c9-8e3b-91bcf5b2fa71	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
2f68cbc3-6171-42c9-8e3b-91bcf5b2fa71	d7d77953-0537-41b8-9f4c-212c1d2b8908	musician	\N
2f68cbc3-6171-42c9-8e3b-91bcf5b2fa71	af53f5a4-7a76-4114-a899-ca66de74ce5e	musician	\N
2f68cbc3-6171-42c9-8e3b-91bcf5b2fa71	cb450c14-8087-47ce-8298-673a78487072	musician	\N
2f68cbc3-6171-42c9-8e3b-91bcf5b2fa71	4246f981-1d59-4657-a89a-2cb4b967acf5	musician	\N
6d0ddf93-0b53-44d7-bc81-9e8f5655820d	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
6d0ddf93-0b53-44d7-bc81-9e8f5655820d	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
6d0ddf93-0b53-44d7-bc81-9e8f5655820d	d7d77953-0537-41b8-9f4c-212c1d2b8908	musician	\N
6d0ddf93-0b53-44d7-bc81-9e8f5655820d	af53f5a4-7a76-4114-a899-ca66de74ce5e	musician	\N
6d0ddf93-0b53-44d7-bc81-9e8f5655820d	cb450c14-8087-47ce-8298-673a78487072	musician	\N
6d0ddf93-0b53-44d7-bc81-9e8f5655820d	4246f981-1d59-4657-a89a-2cb4b967acf5	musician	\N
de3bfb88-7783-450a-a5d0-b31068e39bd3	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
de3bfb88-7783-450a-a5d0-b31068e39bd3	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
de3bfb88-7783-450a-a5d0-b31068e39bd3	d7d77953-0537-41b8-9f4c-212c1d2b8908	musician	\N
de3bfb88-7783-450a-a5d0-b31068e39bd3	af53f5a4-7a76-4114-a899-ca66de74ce5e	musician	\N
de3bfb88-7783-450a-a5d0-b31068e39bd3	cb450c14-8087-47ce-8298-673a78487072	musician	\N
de3bfb88-7783-450a-a5d0-b31068e39bd3	4246f981-1d59-4657-a89a-2cb4b967acf5	musician	\N
e056d1c0-9ef6-43d4-aa9b-8ee3af1b44b9	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
e056d1c0-9ef6-43d4-aa9b-8ee3af1b44b9	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
e056d1c0-9ef6-43d4-aa9b-8ee3af1b44b9	d7d77953-0537-41b8-9f4c-212c1d2b8908	musician	\N
e056d1c0-9ef6-43d4-aa9b-8ee3af1b44b9	af53f5a4-7a76-4114-a899-ca66de74ce5e	musician	\N
e056d1c0-9ef6-43d4-aa9b-8ee3af1b44b9	cb450c14-8087-47ce-8298-673a78487072	musician	\N
e056d1c0-9ef6-43d4-aa9b-8ee3af1b44b9	4246f981-1d59-4657-a89a-2cb4b967acf5	musician	\N
2d141317-7d3e-43ad-a4a4-55a51a6a121e	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
2d141317-7d3e-43ad-a4a4-55a51a6a121e	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
2d141317-7d3e-43ad-a4a4-55a51a6a121e	d7d77953-0537-41b8-9f4c-212c1d2b8908	musician	\N
2d141317-7d3e-43ad-a4a4-55a51a6a121e	af53f5a4-7a76-4114-a899-ca66de74ce5e	musician	\N
2d141317-7d3e-43ad-a4a4-55a51a6a121e	cb450c14-8087-47ce-8298-673a78487072	musician	\N
2d141317-7d3e-43ad-a4a4-55a51a6a121e	4246f981-1d59-4657-a89a-2cb4b967acf5	musician	\N
060881c0-9f52-46a2-b2d1-f3309890039d	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
b5c963dc-80be-468a-af48-c79cec9d996d	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
95084f73-6b60-40b8-8c4d-e01f62eda5b3	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
af20e028-e923-46cd-8885-23e58c84c39d	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
9edd194b-da00-4687-9018-b5e8470ffa69	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
060881c0-9f52-46a2-b2d1-f3309890039d	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
b5c963dc-80be-468a-af48-c79cec9d996d	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
95084f73-6b60-40b8-8c4d-e01f62eda5b3	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
af20e028-e923-46cd-8885-23e58c84c39d	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
9edd194b-da00-4687-9018-b5e8470ffa69	bc667db6-68be-4725-9b65-cb03b0708c58	musician	\N
060881c0-9f52-46a2-b2d1-f3309890039d	7ae077fe-1e75-44a9-87cb-950839b4a0a1	musician	\N
b5c963dc-80be-468a-af48-c79cec9d996d	7ae077fe-1e75-44a9-87cb-950839b4a0a1	musician	\N
95084f73-6b60-40b8-8c4d-e01f62eda5b3	7ae077fe-1e75-44a9-87cb-950839b4a0a1	musician	\N
af20e028-e923-46cd-8885-23e58c84c39d	7ae077fe-1e75-44a9-87cb-950839b4a0a1	musician	\N
9edd194b-da00-4687-9018-b5e8470ffa69	7ae077fe-1e75-44a9-87cb-950839b4a0a1	musician	\N
060881c0-9f52-46a2-b2d1-f3309890039d	e42b4fc2-8a09-4a12-9423-f9e916b9deb9	musician	\N
b5c963dc-80be-468a-af48-c79cec9d996d	e42b4fc2-8a09-4a12-9423-f9e916b9deb9	musician	\N
95084f73-6b60-40b8-8c4d-e01f62eda5b3	e42b4fc2-8a09-4a12-9423-f9e916b9deb9	musician	\N
af20e028-e923-46cd-8885-23e58c84c39d	e42b4fc2-8a09-4a12-9423-f9e916b9deb9	musician	\N
9edd194b-da00-4687-9018-b5e8470ffa69	e42b4fc2-8a09-4a12-9423-f9e916b9deb9	musician	\N
060881c0-9f52-46a2-b2d1-f3309890039d	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
b5c963dc-80be-468a-af48-c79cec9d996d	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
95084f73-6b60-40b8-8c4d-e01f62eda5b3	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
af20e028-e923-46cd-8885-23e58c84c39d	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
9edd194b-da00-4687-9018-b5e8470ffa69	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
060881c0-9f52-46a2-b2d1-f3309890039d	a1f23ff0-09c3-43f8-8bbd-2195b64452d4	musician	\N
b5c963dc-80be-468a-af48-c79cec9d996d	a1f23ff0-09c3-43f8-8bbd-2195b64452d4	musician	\N
95084f73-6b60-40b8-8c4d-e01f62eda5b3	a1f23ff0-09c3-43f8-8bbd-2195b64452d4	musician	\N
af20e028-e923-46cd-8885-23e58c84c39d	a1f23ff0-09c3-43f8-8bbd-2195b64452d4	musician	\N
9edd194b-da00-4687-9018-b5e8470ffa69	a1f23ff0-09c3-43f8-8bbd-2195b64452d4	musician	\N
69ab3866-bbad-4449-ab24-73ea7ef1df00	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
3336feea-1b60-4713-b7be-1224a3c3ecf9	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
3e200d0b-0bcc-464f-b439-4a8aa8a7e760	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
7c3a4ceb-db90-4097-9051-305d1bdd3248	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
31a22da7-3bb0-4e9c-a072-a6efafdff6f9	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
786d3951-e845-4478-97de-e5dde9af8209	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
bbee75ca-5fc0-44ec-ab25-0a2801ab05b2	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
914a6870-0842-4712-9ad9-2820f9ac825c	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
0ad4a4fa-f8de-4047-8bda-d07313d51f1c	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
69ab3866-bbad-4449-ab24-73ea7ef1df00	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
557ea8f6-9f56-4be3-8897-d38b366e5464	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
de3bfb88-7783-450a-a5d0-b31068e39bd3	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
3336feea-1b60-4713-b7be-1224a3c3ecf9	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
3e200d0b-0bcc-464f-b439-4a8aa8a7e760	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
7c3a4ceb-db90-4097-9051-305d1bdd3248	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
31a22da7-3bb0-4e9c-a072-a6efafdff6f9	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
786d3951-e845-4478-97de-e5dde9af8209	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
bbee75ca-5fc0-44ec-ab25-0a2801ab05b2	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
914a6870-0842-4712-9ad9-2820f9ac825c	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
0ad4a4fa-f8de-4047-8bda-d07313d51f1c	f0d16f0b-1b9c-44ca-907f-b63aa8df4d1a	musician	\N
69ab3866-bbad-4449-ab24-73ea7ef1df00	f0d16f0b-1b9c-44ca-907f-b63aa8df4d1a	musician	\N
557ea8f6-9f56-4be3-8897-d38b366e5464	f0d16f0b-1b9c-44ca-907f-b63aa8df4d1a	musician	\N
de3bfb88-7783-450a-a5d0-b31068e39bd3	f0d16f0b-1b9c-44ca-907f-b63aa8df4d1a	musician	\N
c6bfdbc5-00ad-4aae-b306-cdd3cf2c3d56	f0d16f0b-1b9c-44ca-907f-b63aa8df4d1a	musician	\N
3336feea-1b60-4713-b7be-1224a3c3ecf9	f0d16f0b-1b9c-44ca-907f-b63aa8df4d1a	musician	\N
3e200d0b-0bcc-464f-b439-4a8aa8a7e760	f0d16f0b-1b9c-44ca-907f-b63aa8df4d1a	musician	\N
7c3a4ceb-db90-4097-9051-305d1bdd3248	f0d16f0b-1b9c-44ca-907f-b63aa8df4d1a	musician	\N
31a22da7-3bb0-4e9c-a072-a6efafdff6f9	f0d16f0b-1b9c-44ca-907f-b63aa8df4d1a	musician	\N
786d3951-e845-4478-97de-e5dde9af8209	f0d16f0b-1b9c-44ca-907f-b63aa8df4d1a	musician	\N
bbee75ca-5fc0-44ec-ab25-0a2801ab05b2	f0d16f0b-1b9c-44ca-907f-b63aa8df4d1a	musician	\N
914a6870-0842-4712-9ad9-2820f9ac825c	f0d16f0b-1b9c-44ca-907f-b63aa8df4d1a	musician	\N
69ab3866-bbad-4449-ab24-73ea7ef1df00	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
3336feea-1b60-4713-b7be-1224a3c3ecf9	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
3e200d0b-0bcc-464f-b439-4a8aa8a7e760	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
7c3a4ceb-db90-4097-9051-305d1bdd3248	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
31a22da7-3bb0-4e9c-a072-a6efafdff6f9	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
786d3951-e845-4478-97de-e5dde9af8209	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
bbee75ca-5fc0-44ec-ab25-0a2801ab05b2	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
914a6870-0842-4712-9ad9-2820f9ac825c	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
0ad4a4fa-f8de-4047-8bda-d07313d51f1c	11813a6f-3f0c-440b-b348-0c55d2da73a1	musician	\N
69ab3866-bbad-4449-ab24-73ea7ef1df00	11813a6f-3f0c-440b-b348-0c55d2da73a1	musician	\N
557ea8f6-9f56-4be3-8897-d38b366e5464	11813a6f-3f0c-440b-b348-0c55d2da73a1	musician	\N
de3bfb88-7783-450a-a5d0-b31068e39bd3	11813a6f-3f0c-440b-b348-0c55d2da73a1	musician	\N
c6bfdbc5-00ad-4aae-b306-cdd3cf2c3d56	11813a6f-3f0c-440b-b348-0c55d2da73a1	musician	\N
3336feea-1b60-4713-b7be-1224a3c3ecf9	11813a6f-3f0c-440b-b348-0c55d2da73a1	musician	\N
3e200d0b-0bcc-464f-b439-4a8aa8a7e760	11813a6f-3f0c-440b-b348-0c55d2da73a1	musician	\N
7c3a4ceb-db90-4097-9051-305d1bdd3248	11813a6f-3f0c-440b-b348-0c55d2da73a1	musician	\N
31a22da7-3bb0-4e9c-a072-a6efafdff6f9	11813a6f-3f0c-440b-b348-0c55d2da73a1	musician	\N
786d3951-e845-4478-97de-e5dde9af8209	11813a6f-3f0c-440b-b348-0c55d2da73a1	musician	\N
bbee75ca-5fc0-44ec-ab25-0a2801ab05b2	11813a6f-3f0c-440b-b348-0c55d2da73a1	musician	\N
914a6870-0842-4712-9ad9-2820f9ac825c	11813a6f-3f0c-440b-b348-0c55d2da73a1	musician	\N
db8d7479-5b7d-4da2-9230-0fd3808636ec	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
a1c6f207-66ef-402e-b3a5-e6e7ae4eec3f	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
97fccb64-97f5-4d89-902a-f268f2409968	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
72110ecf-5d56-4bf8-a616-81994292edfc	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
2a53107c-97b7-43e7-b720-c82cdac1736c	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
3bca071e-f0cf-464c-a793-fa43a5cbe6d2	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
db88c659-3edb-4ded-ae58-d532b93dce48	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
fbfe7991-1879-4f10-b103-34fe28048195	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
d51f9aa8-06d0-404c-bb02-ec0d40e6f5d0	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
f0e324ec-bf9b-4059-a522-c01caf4f2b16	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
6c92d437-ac4a-4327-b8df-a580d5c4ebf5	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
aff07b4c-46cb-47b7-9f8a-cfa2a72143ee	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
db8d7479-5b7d-4da2-9230-0fd3808636ec	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
a1c6f207-66ef-402e-b3a5-e6e7ae4eec3f	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
97fccb64-97f5-4d89-902a-f268f2409968	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
72110ecf-5d56-4bf8-a616-81994292edfc	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
2a53107c-97b7-43e7-b720-c82cdac1736c	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
3bca071e-f0cf-464c-a793-fa43a5cbe6d2	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
db88c659-3edb-4ded-ae58-d532b93dce48	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
fbfe7991-1879-4f10-b103-34fe28048195	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
d51f9aa8-06d0-404c-bb02-ec0d40e6f5d0	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
f0e324ec-bf9b-4059-a522-c01caf4f2b16	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
6c92d437-ac4a-4327-b8df-a580d5c4ebf5	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
aff07b4c-46cb-47b7-9f8a-cfa2a72143ee	31c7cc31-0970-4783-8b00-094b4c05b347	musician	\N
db8d7479-5b7d-4da2-9230-0fd3808636ec	83638843-8a89-4911-805c-1b74233c5cf5	musician	\N
a1c6f207-66ef-402e-b3a5-e6e7ae4eec3f	83638843-8a89-4911-805c-1b74233c5cf5	musician	\N
97fccb64-97f5-4d89-902a-f268f2409968	83638843-8a89-4911-805c-1b74233c5cf5	musician	\N
72110ecf-5d56-4bf8-a616-81994292edfc	83638843-8a89-4911-805c-1b74233c5cf5	musician	\N
2a53107c-97b7-43e7-b720-c82cdac1736c	83638843-8a89-4911-805c-1b74233c5cf5	musician	\N
3bca071e-f0cf-464c-a793-fa43a5cbe6d2	83638843-8a89-4911-805c-1b74233c5cf5	musician	\N
db88c659-3edb-4ded-ae58-d532b93dce48	83638843-8a89-4911-805c-1b74233c5cf5	musician	\N
fbfe7991-1879-4f10-b103-34fe28048195	83638843-8a89-4911-805c-1b74233c5cf5	musician	\N
d51f9aa8-06d0-404c-bb02-ec0d40e6f5d0	83638843-8a89-4911-805c-1b74233c5cf5	musician	\N
f0e324ec-bf9b-4059-a522-c01caf4f2b16	83638843-8a89-4911-805c-1b74233c5cf5	musician	\N
6c92d437-ac4a-4327-b8df-a580d5c4ebf5	83638843-8a89-4911-805c-1b74233c5cf5	musician	\N
aff07b4c-46cb-47b7-9f8a-cfa2a72143ee	83638843-8a89-4911-805c-1b74233c5cf5	musician	\N
db8d7479-5b7d-4da2-9230-0fd3808636ec	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
a1c6f207-66ef-402e-b3a5-e6e7ae4eec3f	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
97fccb64-97f5-4d89-902a-f268f2409968	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
72110ecf-5d56-4bf8-a616-81994292edfc	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
2a53107c-97b7-43e7-b720-c82cdac1736c	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
3bca071e-f0cf-464c-a793-fa43a5cbe6d2	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
db88c659-3edb-4ded-ae58-d532b93dce48	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
fbfe7991-1879-4f10-b103-34fe28048195	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
d51f9aa8-06d0-404c-bb02-ec0d40e6f5d0	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
f0e324ec-bf9b-4059-a522-c01caf4f2b16	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
6c92d437-ac4a-4327-b8df-a580d5c4ebf5	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
aff07b4c-46cb-47b7-9f8a-cfa2a72143ee	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
db8d7479-5b7d-4da2-9230-0fd3808636ec	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
a1c6f207-66ef-402e-b3a5-e6e7ae4eec3f	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
97fccb64-97f5-4d89-902a-f268f2409968	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
72110ecf-5d56-4bf8-a616-81994292edfc	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
2a53107c-97b7-43e7-b720-c82cdac1736c	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
3bca071e-f0cf-464c-a793-fa43a5cbe6d2	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
db88c659-3edb-4ded-ae58-d532b93dce48	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
fbfe7991-1879-4f10-b103-34fe28048195	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
d51f9aa8-06d0-404c-bb02-ec0d40e6f5d0	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
f0e324ec-bf9b-4059-a522-c01caf4f2b16	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
6c92d437-ac4a-4327-b8df-a580d5c4ebf5	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
aff07b4c-46cb-47b7-9f8a-cfa2a72143ee	49dd81e5-8a5e-4b0f-a2e3-0611de830e9d	musician	\N
db8d7479-5b7d-4da2-9230-0fd3808636ec	146c4d2e-8439-49a2-86a8-a4f2d1a240a4	musician	\N
a1c6f207-66ef-402e-b3a5-e6e7ae4eec3f	146c4d2e-8439-49a2-86a8-a4f2d1a240a4	musician	\N
97fccb64-97f5-4d89-902a-f268f2409968	146c4d2e-8439-49a2-86a8-a4f2d1a240a4	musician	\N
72110ecf-5d56-4bf8-a616-81994292edfc	146c4d2e-8439-49a2-86a8-a4f2d1a240a4	musician	\N
2a53107c-97b7-43e7-b720-c82cdac1736c	146c4d2e-8439-49a2-86a8-a4f2d1a240a4	musician	\N
3bca071e-f0cf-464c-a793-fa43a5cbe6d2	146c4d2e-8439-49a2-86a8-a4f2d1a240a4	musician	\N
db88c659-3edb-4ded-ae58-d532b93dce48	146c4d2e-8439-49a2-86a8-a4f2d1a240a4	musician	\N
fbfe7991-1879-4f10-b103-34fe28048195	146c4d2e-8439-49a2-86a8-a4f2d1a240a4	musician	\N
d51f9aa8-06d0-404c-bb02-ec0d40e6f5d0	146c4d2e-8439-49a2-86a8-a4f2d1a240a4	musician	\N
f0e324ec-bf9b-4059-a522-c01caf4f2b16	146c4d2e-8439-49a2-86a8-a4f2d1a240a4	musician	\N
6c92d437-ac4a-4327-b8df-a580d5c4ebf5	146c4d2e-8439-49a2-86a8-a4f2d1a240a4	musician	\N
aff07b4c-46cb-47b7-9f8a-cfa2a72143ee	146c4d2e-8439-49a2-86a8-a4f2d1a240a4	musician	\N
db8d7479-5b7d-4da2-9230-0fd3808636ec	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
a1c6f207-66ef-402e-b3a5-e6e7ae4eec3f	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
97fccb64-97f5-4d89-902a-f268f2409968	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
72110ecf-5d56-4bf8-a616-81994292edfc	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
2a53107c-97b7-43e7-b720-c82cdac1736c	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
3bca071e-f0cf-464c-a793-fa43a5cbe6d2	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
db88c659-3edb-4ded-ae58-d532b93dce48	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
fbfe7991-1879-4f10-b103-34fe28048195	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
d51f9aa8-06d0-404c-bb02-ec0d40e6f5d0	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
f0e324ec-bf9b-4059-a522-c01caf4f2b16	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
6c92d437-ac4a-4327-b8df-a580d5c4ebf5	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
aff07b4c-46cb-47b7-9f8a-cfa2a72143ee	f817c384-6c4f-446e-8aa9-cb451fb25d5f	musician	\N
db8d7479-5b7d-4da2-9230-0fd3808636ec	fc960ba4-1d9e-4d21-b80b-4c08778fd2c8	musician	\N
a1c6f207-66ef-402e-b3a5-e6e7ae4eec3f	fc960ba4-1d9e-4d21-b80b-4c08778fd2c8	musician	\N
97fccb64-97f5-4d89-902a-f268f2409968	fc960ba4-1d9e-4d21-b80b-4c08778fd2c8	musician	\N
72110ecf-5d56-4bf8-a616-81994292edfc	fc960ba4-1d9e-4d21-b80b-4c08778fd2c8	musician	\N
2a53107c-97b7-43e7-b720-c82cdac1736c	fc960ba4-1d9e-4d21-b80b-4c08778fd2c8	musician	\N
3bca071e-f0cf-464c-a793-fa43a5cbe6d2	fc960ba4-1d9e-4d21-b80b-4c08778fd2c8	musician	\N
db88c659-3edb-4ded-ae58-d532b93dce48	fc960ba4-1d9e-4d21-b80b-4c08778fd2c8	musician	\N
fbfe7991-1879-4f10-b103-34fe28048195	fc960ba4-1d9e-4d21-b80b-4c08778fd2c8	musician	\N
d51f9aa8-06d0-404c-bb02-ec0d40e6f5d0	fc960ba4-1d9e-4d21-b80b-4c08778fd2c8	musician	\N
f0e324ec-bf9b-4059-a522-c01caf4f2b16	fc960ba4-1d9e-4d21-b80b-4c08778fd2c8	musician	\N
6c92d437-ac4a-4327-b8df-a580d5c4ebf5	fc960ba4-1d9e-4d21-b80b-4c08778fd2c8	musician	\N
aff07b4c-46cb-47b7-9f8a-cfa2a72143ee	fc960ba4-1d9e-4d21-b80b-4c08778fd2c8	musician	\N
562a6458-4e9b-41da-b95f-e12b88491ebf	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
fb8a5d6d-8fed-4f6a-96d0-60ea8c7c1db3	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
cb7b1a5b-a8b3-4085-9b77-21aa2979aeca	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
ca30e995-7800-47b3-9b89-e79448e1c7a7	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
55ca45cf-83a5-4094-b2d7-a89c9b981a79	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
4972abd1-91c5-4c2e-843d-79ab09a9efef	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
7cc29d44-0d5f-455c-b598-af70cffbf702	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
25d2f57a-fab0-418b-abed-ed28f57e5d2a	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
388aa8dd-be2e-464b-8554-d690eed634db	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
cc452b4b-83ff-465e-ab6a-eb9f223b3fca	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
c6de96b3-8498-41c8-9f3c-9e04a1e4eab1	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
5ec21fc2-a319-4ef2-8d57-8581b7ba7eb6	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
ee730331-0d09-494d-bccb-30464d976e61	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
455f2a73-4a63-40ef-836f-72ef78985aa0	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
23798bf7-78f3-43f2-a619-a49c8d0b56d6	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
ff4f2b27-5b1e-4bce-b9f1-1c1d97a3a5ad	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
fcd63314-f880-443c-b2d0-d975de18ed63	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
8ef87f45-e8d7-4d0c-9536-d3530d8da330	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
562a6458-4e9b-41da-b95f-e12b88491ebf	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
fb8a5d6d-8fed-4f6a-96d0-60ea8c7c1db3	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
cb7b1a5b-a8b3-4085-9b77-21aa2979aeca	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
ca30e995-7800-47b3-9b89-e79448e1c7a7	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
55ca45cf-83a5-4094-b2d7-a89c9b981a79	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
4972abd1-91c5-4c2e-843d-79ab09a9efef	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
7cc29d44-0d5f-455c-b598-af70cffbf702	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
25d2f57a-fab0-418b-abed-ed28f57e5d2a	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
388aa8dd-be2e-464b-8554-d690eed634db	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
cc452b4b-83ff-465e-ab6a-eb9f223b3fca	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
c6de96b3-8498-41c8-9f3c-9e04a1e4eab1	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
5ec21fc2-a319-4ef2-8d57-8581b7ba7eb6	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
ee730331-0d09-494d-bccb-30464d976e61	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
455f2a73-4a63-40ef-836f-72ef78985aa0	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
23798bf7-78f3-43f2-a619-a49c8d0b56d6	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
ff4f2b27-5b1e-4bce-b9f1-1c1d97a3a5ad	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
fcd63314-f880-443c-b2d0-d975de18ed63	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
8ef87f45-e8d7-4d0c-9536-d3530d8da330	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
562a6458-4e9b-41da-b95f-e12b88491ebf	cb450c14-8087-47ce-8298-673a78487072	musician	\N
fb8a5d6d-8fed-4f6a-96d0-60ea8c7c1db3	cb450c14-8087-47ce-8298-673a78487072	musician	\N
cb7b1a5b-a8b3-4085-9b77-21aa2979aeca	cb450c14-8087-47ce-8298-673a78487072	musician	\N
ca30e995-7800-47b3-9b89-e79448e1c7a7	cb450c14-8087-47ce-8298-673a78487072	musician	\N
55ca45cf-83a5-4094-b2d7-a89c9b981a79	cb450c14-8087-47ce-8298-673a78487072	musician	\N
4972abd1-91c5-4c2e-843d-79ab09a9efef	cb450c14-8087-47ce-8298-673a78487072	musician	\N
7cc29d44-0d5f-455c-b598-af70cffbf702	cb450c14-8087-47ce-8298-673a78487072	musician	\N
25d2f57a-fab0-418b-abed-ed28f57e5d2a	cb450c14-8087-47ce-8298-673a78487072	musician	\N
388aa8dd-be2e-464b-8554-d690eed634db	cb450c14-8087-47ce-8298-673a78487072	musician	\N
cc452b4b-83ff-465e-ab6a-eb9f223b3fca	cb450c14-8087-47ce-8298-673a78487072	musician	\N
c6de96b3-8498-41c8-9f3c-9e04a1e4eab1	cb450c14-8087-47ce-8298-673a78487072	musician	\N
5ec21fc2-a319-4ef2-8d57-8581b7ba7eb6	cb450c14-8087-47ce-8298-673a78487072	musician	\N
ee730331-0d09-494d-bccb-30464d976e61	cb450c14-8087-47ce-8298-673a78487072	musician	\N
455f2a73-4a63-40ef-836f-72ef78985aa0	cb450c14-8087-47ce-8298-673a78487072	musician	\N
23798bf7-78f3-43f2-a619-a49c8d0b56d6	cb450c14-8087-47ce-8298-673a78487072	musician	\N
ff4f2b27-5b1e-4bce-b9f1-1c1d97a3a5ad	cb450c14-8087-47ce-8298-673a78487072	musician	\N
fcd63314-f880-443c-b2d0-d975de18ed63	cb450c14-8087-47ce-8298-673a78487072	musician	\N
8ef87f45-e8d7-4d0c-9536-d3530d8da330	cb450c14-8087-47ce-8298-673a78487072	musician	\N
562a6458-4e9b-41da-b95f-e12b88491ebf	d7d77953-0537-41b8-9f4c-212c1d2b8908	musician	\N
fb8a5d6d-8fed-4f6a-96d0-60ea8c7c1db3	d7d77953-0537-41b8-9f4c-212c1d2b8908	musician	\N
cb7b1a5b-a8b3-4085-9b77-21aa2979aeca	d7d77953-0537-41b8-9f4c-212c1d2b8908	musician	\N
ca30e995-7800-47b3-9b89-e79448e1c7a7	d7d77953-0537-41b8-9f4c-212c1d2b8908	musician	\N
55ca45cf-83a5-4094-b2d7-a89c9b981a79	d7d77953-0537-41b8-9f4c-212c1d2b8908	musician	\N
4972abd1-91c5-4c2e-843d-79ab09a9efef	d7d77953-0537-41b8-9f4c-212c1d2b8908	musician	\N
7cc29d44-0d5f-455c-b598-af70cffbf702	d7d77953-0537-41b8-9f4c-212c1d2b8908	musician	\N
25d2f57a-fab0-418b-abed-ed28f57e5d2a	d7d77953-0537-41b8-9f4c-212c1d2b8908	musician	\N
388aa8dd-be2e-464b-8554-d690eed634db	d7d77953-0537-41b8-9f4c-212c1d2b8908	musician	\N
cc452b4b-83ff-465e-ab6a-eb9f223b3fca	d7d77953-0537-41b8-9f4c-212c1d2b8908	musician	\N
c6de96b3-8498-41c8-9f3c-9e04a1e4eab1	d7d77953-0537-41b8-9f4c-212c1d2b8908	musician	\N
5ec21fc2-a319-4ef2-8d57-8581b7ba7eb6	d7d77953-0537-41b8-9f4c-212c1d2b8908	musician	\N
ee730331-0d09-494d-bccb-30464d976e61	d7d77953-0537-41b8-9f4c-212c1d2b8908	musician	\N
455f2a73-4a63-40ef-836f-72ef78985aa0	d7d77953-0537-41b8-9f4c-212c1d2b8908	musician	\N
23798bf7-78f3-43f2-a619-a49c8d0b56d6	d7d77953-0537-41b8-9f4c-212c1d2b8908	musician	\N
ff4f2b27-5b1e-4bce-b9f1-1c1d97a3a5ad	d7d77953-0537-41b8-9f4c-212c1d2b8908	musician	\N
fcd63314-f880-443c-b2d0-d975de18ed63	d7d77953-0537-41b8-9f4c-212c1d2b8908	musician	\N
8ef87f45-e8d7-4d0c-9536-d3530d8da330	d7d77953-0537-41b8-9f4c-212c1d2b8908	musician	\N
562a6458-4e9b-41da-b95f-e12b88491ebf	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
fb8a5d6d-8fed-4f6a-96d0-60ea8c7c1db3	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
cb7b1a5b-a8b3-4085-9b77-21aa2979aeca	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
ca30e995-7800-47b3-9b89-e79448e1c7a7	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
55ca45cf-83a5-4094-b2d7-a89c9b981a79	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
4972abd1-91c5-4c2e-843d-79ab09a9efef	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
7cc29d44-0d5f-455c-b598-af70cffbf702	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
25d2f57a-fab0-418b-abed-ed28f57e5d2a	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
388aa8dd-be2e-464b-8554-d690eed634db	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
cc452b4b-83ff-465e-ab6a-eb9f223b3fca	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
c6de96b3-8498-41c8-9f3c-9e04a1e4eab1	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
5ec21fc2-a319-4ef2-8d57-8581b7ba7eb6	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
ee730331-0d09-494d-bccb-30464d976e61	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
455f2a73-4a63-40ef-836f-72ef78985aa0	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
23798bf7-78f3-43f2-a619-a49c8d0b56d6	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
ff4f2b27-5b1e-4bce-b9f1-1c1d97a3a5ad	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
fcd63314-f880-443c-b2d0-d975de18ed63	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
8ef87f45-e8d7-4d0c-9536-d3530d8da330	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
562a6458-4e9b-41da-b95f-e12b88491ebf	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
fb8a5d6d-8fed-4f6a-96d0-60ea8c7c1db3	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
cb7b1a5b-a8b3-4085-9b77-21aa2979aeca	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
ca30e995-7800-47b3-9b89-e79448e1c7a7	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
55ca45cf-83a5-4094-b2d7-a89c9b981a79	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
4972abd1-91c5-4c2e-843d-79ab09a9efef	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
7cc29d44-0d5f-455c-b598-af70cffbf702	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
25d2f57a-fab0-418b-abed-ed28f57e5d2a	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
388aa8dd-be2e-464b-8554-d690eed634db	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
cc452b4b-83ff-465e-ab6a-eb9f223b3fca	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
c6de96b3-8498-41c8-9f3c-9e04a1e4eab1	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
5ec21fc2-a319-4ef2-8d57-8581b7ba7eb6	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
ee730331-0d09-494d-bccb-30464d976e61	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
455f2a73-4a63-40ef-836f-72ef78985aa0	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
23798bf7-78f3-43f2-a619-a49c8d0b56d6	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
ff4f2b27-5b1e-4bce-b9f1-1c1d97a3a5ad	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
fcd63314-f880-443c-b2d0-d975de18ed63	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
8ef87f45-e8d7-4d0c-9536-d3530d8da330	3d8dbde7-ee83-4f72-ba75-25b84428335b	musician	\N
562a6458-4e9b-41da-b95f-e12b88491ebf	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
fb8a5d6d-8fed-4f6a-96d0-60ea8c7c1db3	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
cb7b1a5b-a8b3-4085-9b77-21aa2979aeca	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
ca30e995-7800-47b3-9b89-e79448e1c7a7	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
55ca45cf-83a5-4094-b2d7-a89c9b981a79	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
4972abd1-91c5-4c2e-843d-79ab09a9efef	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
7cc29d44-0d5f-455c-b598-af70cffbf702	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
25d2f57a-fab0-418b-abed-ed28f57e5d2a	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
388aa8dd-be2e-464b-8554-d690eed634db	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
cc452b4b-83ff-465e-ab6a-eb9f223b3fca	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
c6de96b3-8498-41c8-9f3c-9e04a1e4eab1	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
5ec21fc2-a319-4ef2-8d57-8581b7ba7eb6	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
ee730331-0d09-494d-bccb-30464d976e61	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
455f2a73-4a63-40ef-836f-72ef78985aa0	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
23798bf7-78f3-43f2-a619-a49c8d0b56d6	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
ff4f2b27-5b1e-4bce-b9f1-1c1d97a3a5ad	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
fcd63314-f880-443c-b2d0-d975de18ed63	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
8ef87f45-e8d7-4d0c-9536-d3530d8da330	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
6e26a80b-5347-4d56-9e29-5214e63f838a	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
56b58cd8-cf8f-4051-ad91-c16a9435752c	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
0e67f4d8-2b35-4592-9295-10a293f759fe	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
4ebd20d5-33ce-48a6-b26c-c98c31fd94e1	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
7d08f6fe-4d63-43d5-94c0-94b7af3f1277	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
99c498ac-2f95-4dde-bbe3-7646e05fb76c	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
77fe0ec5-3dec-4960-aa45-6fa3534e3ec2	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
312877de-7cab-4fc0-9178-2fb5376cb132	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
6ea8d8e5-4093-448e-a3fa-25d6a90b25d1	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
b9b31485-718e-44f6-9e54-f9fb8b0a7ccd	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
4d727491-2011-45ad-b77e-af4af22480f6	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
2994a441-6986-4bf8-ae2b-8da2af04f498	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
8c4c8524-0123-45a8-a6ec-b0c1793b09cf	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
875f446a-9b61-4eab-829e-b3733a7f752e	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
f4cf9a24-ef2c-4893-8b15-2181238927f6	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
63f43c30-6c11-4c0f-9c60-d18251104601	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
73d50d6f-f9bc-4d3b-9bf5-13ff7f6cd2d5	175b3e5c-7748-4371-a35f-7cbb51af971c	musician	\N
6e26a80b-5347-4d56-9e29-5214e63f838a	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
56b58cd8-cf8f-4051-ad91-c16a9435752c	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
0e67f4d8-2b35-4592-9295-10a293f759fe	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
4ebd20d5-33ce-48a6-b26c-c98c31fd94e1	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
7d08f6fe-4d63-43d5-94c0-94b7af3f1277	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
99c498ac-2f95-4dde-bbe3-7646e05fb76c	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
77fe0ec5-3dec-4960-aa45-6fa3534e3ec2	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
312877de-7cab-4fc0-9178-2fb5376cb132	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
6ea8d8e5-4093-448e-a3fa-25d6a90b25d1	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
b9b31485-718e-44f6-9e54-f9fb8b0a7ccd	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
4d727491-2011-45ad-b77e-af4af22480f6	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
2994a441-6986-4bf8-ae2b-8da2af04f498	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
8c4c8524-0123-45a8-a6ec-b0c1793b09cf	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
875f446a-9b61-4eab-829e-b3733a7f752e	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
f4cf9a24-ef2c-4893-8b15-2181238927f6	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
63f43c30-6c11-4c0f-9c60-d18251104601	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
73d50d6f-f9bc-4d3b-9bf5-13ff7f6cd2d5	b2caac43-13f5-4fd7-b662-93710c54eb0e	musician	\N
6e26a80b-5347-4d56-9e29-5214e63f838a	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
56b58cd8-cf8f-4051-ad91-c16a9435752c	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
0e67f4d8-2b35-4592-9295-10a293f759fe	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
4ebd20d5-33ce-48a6-b26c-c98c31fd94e1	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
7d08f6fe-4d63-43d5-94c0-94b7af3f1277	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
99c498ac-2f95-4dde-bbe3-7646e05fb76c	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
77fe0ec5-3dec-4960-aa45-6fa3534e3ec2	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
312877de-7cab-4fc0-9178-2fb5376cb132	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
6ea8d8e5-4093-448e-a3fa-25d6a90b25d1	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
b9b31485-718e-44f6-9e54-f9fb8b0a7ccd	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
4d727491-2011-45ad-b77e-af4af22480f6	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
2994a441-6986-4bf8-ae2b-8da2af04f498	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
8c4c8524-0123-45a8-a6ec-b0c1793b09cf	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
875f446a-9b61-4eab-829e-b3733a7f752e	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
f4cf9a24-ef2c-4893-8b15-2181238927f6	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
63f43c30-6c11-4c0f-9c60-d18251104601	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
73d50d6f-f9bc-4d3b-9bf5-13ff7f6cd2d5	9f0283b4-4c63-4f4a-8c22-ee9e55c6cb54	musician	\N
6e26a80b-5347-4d56-9e29-5214e63f838a	cb450c14-8087-47ce-8298-673a78487072	musician	\N
56b58cd8-cf8f-4051-ad91-c16a9435752c	cb450c14-8087-47ce-8298-673a78487072	musician	\N
0e67f4d8-2b35-4592-9295-10a293f759fe	cb450c14-8087-47ce-8298-673a78487072	musician	\N
4ebd20d5-33ce-48a6-b26c-c98c31fd94e1	cb450c14-8087-47ce-8298-673a78487072	musician	\N
7d08f6fe-4d63-43d5-94c0-94b7af3f1277	cb450c14-8087-47ce-8298-673a78487072	musician	\N
99c498ac-2f95-4dde-bbe3-7646e05fb76c	cb450c14-8087-47ce-8298-673a78487072	musician	\N
77fe0ec5-3dec-4960-aa45-6fa3534e3ec2	cb450c14-8087-47ce-8298-673a78487072	musician	\N
312877de-7cab-4fc0-9178-2fb5376cb132	cb450c14-8087-47ce-8298-673a78487072	musician	\N
6ea8d8e5-4093-448e-a3fa-25d6a90b25d1	cb450c14-8087-47ce-8298-673a78487072	musician	\N
b9b31485-718e-44f6-9e54-f9fb8b0a7ccd	cb450c14-8087-47ce-8298-673a78487072	musician	\N
4d727491-2011-45ad-b77e-af4af22480f6	cb450c14-8087-47ce-8298-673a78487072	musician	\N
2994a441-6986-4bf8-ae2b-8da2af04f498	cb450c14-8087-47ce-8298-673a78487072	musician	\N
8c4c8524-0123-45a8-a6ec-b0c1793b09cf	cb450c14-8087-47ce-8298-673a78487072	musician	\N
875f446a-9b61-4eab-829e-b3733a7f752e	cb450c14-8087-47ce-8298-673a78487072	musician	\N
f4cf9a24-ef2c-4893-8b15-2181238927f6	cb450c14-8087-47ce-8298-673a78487072	musician	\N
63f43c30-6c11-4c0f-9c60-d18251104601	cb450c14-8087-47ce-8298-673a78487072	musician	\N
73d50d6f-f9bc-4d3b-9bf5-13ff7f6cd2d5	cb450c14-8087-47ce-8298-673a78487072	musician	\N
6e26a80b-5347-4d56-9e29-5214e63f838a	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
56b58cd8-cf8f-4051-ad91-c16a9435752c	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
0e67f4d8-2b35-4592-9295-10a293f759fe	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
4ebd20d5-33ce-48a6-b26c-c98c31fd94e1	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
7d08f6fe-4d63-43d5-94c0-94b7af3f1277	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
99c498ac-2f95-4dde-bbe3-7646e05fb76c	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
77fe0ec5-3dec-4960-aa45-6fa3534e3ec2	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
312877de-7cab-4fc0-9178-2fb5376cb132	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
6ea8d8e5-4093-448e-a3fa-25d6a90b25d1	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
b9b31485-718e-44f6-9e54-f9fb8b0a7ccd	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
4d727491-2011-45ad-b77e-af4af22480f6	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
2994a441-6986-4bf8-ae2b-8da2af04f498	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
8c4c8524-0123-45a8-a6ec-b0c1793b09cf	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
875f446a-9b61-4eab-829e-b3733a7f752e	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
f4cf9a24-ef2c-4893-8b15-2181238927f6	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
63f43c30-6c11-4c0f-9c60-d18251104601	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
73d50d6f-f9bc-4d3b-9bf5-13ff7f6cd2d5	5a42cb40-f086-4e3e-b75e-46e2f4b0b78e	musician	\N
6e26a80b-5347-4d56-9e29-5214e63f838a	d1c51e36-dcad-4aff-a9d9-10ffdfb0118d	musician	\N
56b58cd8-cf8f-4051-ad91-c16a9435752c	d1c51e36-dcad-4aff-a9d9-10ffdfb0118d	musician	\N
0e67f4d8-2b35-4592-9295-10a293f759fe	d1c51e36-dcad-4aff-a9d9-10ffdfb0118d	musician	\N
4ebd20d5-33ce-48a6-b26c-c98c31fd94e1	d1c51e36-dcad-4aff-a9d9-10ffdfb0118d	musician	\N
7d08f6fe-4d63-43d5-94c0-94b7af3f1277	d1c51e36-dcad-4aff-a9d9-10ffdfb0118d	musician	\N
99c498ac-2f95-4dde-bbe3-7646e05fb76c	d1c51e36-dcad-4aff-a9d9-10ffdfb0118d	musician	\N
77fe0ec5-3dec-4960-aa45-6fa3534e3ec2	d1c51e36-dcad-4aff-a9d9-10ffdfb0118d	musician	\N
312877de-7cab-4fc0-9178-2fb5376cb132	d1c51e36-dcad-4aff-a9d9-10ffdfb0118d	musician	\N
6ea8d8e5-4093-448e-a3fa-25d6a90b25d1	d1c51e36-dcad-4aff-a9d9-10ffdfb0118d	musician	\N
b9b31485-718e-44f6-9e54-f9fb8b0a7ccd	d1c51e36-dcad-4aff-a9d9-10ffdfb0118d	musician	\N
4d727491-2011-45ad-b77e-af4af22480f6	d1c51e36-dcad-4aff-a9d9-10ffdfb0118d	musician	\N
2994a441-6986-4bf8-ae2b-8da2af04f498	d1c51e36-dcad-4aff-a9d9-10ffdfb0118d	musician	\N
8c4c8524-0123-45a8-a6ec-b0c1793b09cf	d1c51e36-dcad-4aff-a9d9-10ffdfb0118d	musician	\N
875f446a-9b61-4eab-829e-b3733a7f752e	d1c51e36-dcad-4aff-a9d9-10ffdfb0118d	musician	\N
f4cf9a24-ef2c-4893-8b15-2181238927f6	d1c51e36-dcad-4aff-a9d9-10ffdfb0118d	musician	\N
63f43c30-6c11-4c0f-9c60-d18251104601	d1c51e36-dcad-4aff-a9d9-10ffdfb0118d	musician	\N
73d50d6f-f9bc-4d3b-9bf5-13ff7f6cd2d5	d1c51e36-dcad-4aff-a9d9-10ffdfb0118d	musician	\N
6e26a80b-5347-4d56-9e29-5214e63f838a	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
56b58cd8-cf8f-4051-ad91-c16a9435752c	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
0e67f4d8-2b35-4592-9295-10a293f759fe	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
4ebd20d5-33ce-48a6-b26c-c98c31fd94e1	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
7d08f6fe-4d63-43d5-94c0-94b7af3f1277	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
99c498ac-2f95-4dde-bbe3-7646e05fb76c	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
77fe0ec5-3dec-4960-aa45-6fa3534e3ec2	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
312877de-7cab-4fc0-9178-2fb5376cb132	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
6ea8d8e5-4093-448e-a3fa-25d6a90b25d1	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
b9b31485-718e-44f6-9e54-f9fb8b0a7ccd	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
4d727491-2011-45ad-b77e-af4af22480f6	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
2994a441-6986-4bf8-ae2b-8da2af04f498	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
8c4c8524-0123-45a8-a6ec-b0c1793b09cf	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
875f446a-9b61-4eab-829e-b3733a7f752e	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
f4cf9a24-ef2c-4893-8b15-2181238927f6	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
63f43c30-6c11-4c0f-9c60-d18251104601	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
73d50d6f-f9bc-4d3b-9bf5-13ff7f6cd2d5	2e5887d2-31dc-4951-aa79-6a12d6b18bbf	musician	\N
\.


--
-- Data for Name: songs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.songs (id, title, artist_id, credited_as, media_type, recording_type, running_time_seconds, release_date, release_year, recording_date, recording_year, lyrics, cover_art_url, recording_url, record_label, catalog_number, liner_notes, source_list, created_at, updated_at) FROM stdin;
789e99b8-d4b5-4b46-8d92-22ff93716bff	Bills Corpse	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1969	\N	\N	\N	\N	\N	\N	\N	\N	{}	2026-05-26 18:39:42.254102+00	2026-05-26 18:39:42.254102+00
94446116-059e-4b7b-85c1-58944ed0dc41	Dropout Boogie	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1967	\N	\N	You wanna do what (repeat) I told you what (repeat) (repeat both) Go ta school (repeat) just cain't (repeat) dropout (repeat) Ya getta job (repeat) Dunno whattit (repeat) What it's all about (repeat) you told her ya love her so figured her mother ya love her adapt her (repeat) adapt her adapter (repeat) Support her (repeat) she says she's no boarder getta job (repeat) ya gotta support her ya told her you loved her so figured her mother ya love her adapt her (repeat) adapt her adapter (repeat) 'n;' what about after that (repeat)	\N	https://music.apple.com/us/album/dropout-boogie/290334563?i=290334567&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.170021+00	2026-05-26 20:11:35.964514+00
40b6303d-04f7-4780-8f48-4a4566bc4524	Autumn’s Child	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1967	\N	\N	\N	\N	https://music.apple.com/us/album/autumns-child/290334563?i=290334577&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.202528+00	2026-05-26 20:11:35.958286+00
d7f96915-362a-4bbe-96b9-75deb2246330	Frownland	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1969	\N	\N	My smile is stuck I cannot go back t' yer Frownland My spirit's made up of the ocean And the sky 'n the sun 'n the moon 'n all my eye can see I cannot go back to yer land of gloom Where black jagged shadows Remind me of the comin' of yer doom I want my own land Take my hand 'n come with me It's not too late for you It's not too late for me To find my homeland Where uh man can stand by another man Without an ego flyin' With no man lyin' 'n no one dyin' by an earthly hand Let the devil burn 'n the beggar learn 'n the little girls that live in those old worlds Take my kind hand My smile is stuck I cannot go back t' yer Frownland	\N	https://music.apple.com/us/album/frownland/1059242591?i=1059242612&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.237869+00	2026-05-26 20:11:35.966755+00
13037f41-f94f-4f54-b0e0-595be3f2bbb8	Kandy Korn	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1971	\N	\N	Yellow and orange orange and well they taste so good I want to eat 'em And they taste s good I get to need 'em Can-can-can-candy candy Candy corn yellow and orange and candy corn yellow and orange and candy be reborn be reformed stay stay warm	\N	https://music.apple.com/us/album/kandy-korn/284001765?i=284001779&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.210773+00	2026-05-26 20:11:35.973165+00
3157fbd3-9691-4e93-bb87-ea4b2f77ac79	Neon Meate Dream of a Octafish	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1969	\N	\N	Lucid tentacles test 'n sleeved\n'n joined 'n jointed jade pointed\nDiamond back patterns\nNeon meate dream of a octafish\nArtifact on rose petals\n'n flesh petals 'n pots\nFack 'n feast 'n tubes tubs bulbs\nIn jest incest injest injust in feast incest\n'n specks 'n speckled speckled\nSpeckled speculation\nFedlocks waddlin' feast\nArchaic faces frenzy\nCeramic fists artificial deceased\n'n cists rancid buds burst\nDank drum 'n dung dust\nMeate rose 'n hairs\nMeaty meate rose 'n hairs\nMeaty dream wet meate\nLimp damp rows\nPeeled 'n felt fields 'n belts\nImpaled on 'n daeman\nMucus mules\nTwot trot tra la tra la\nTra la tra la tra la\nWhale bone fields 'n belts\nWhale bone farmhouse\nCavorts girdled 'n latters uh lite\nCavorts girdled 'n latters uh lite\nUh dipped amidst\nSquirmin' serum 'n semen 'n syrup 'n semen\n'n serum\nStirrupped in syrup\nNeon meate dream of a octafish	\N	\N	\N	\N	\N	{}	2026-05-26 18:39:42.257457+00	2026-05-26 18:39:42.257457+00
3a657d57-cb2a-4697-a9fe-abe556a30f81	Plastic Factory	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1967	\N	\N	Phos'phrous chimney burnin'\nModern-men's a-learnin'\nTime and space a-turnin' Motor's engine churnin'\nfac'trys no place for me boss man let me be Wind and wave all blowin'\nMountain 'n' sky showin'\nBee 'n;'' flower growin'\nBoy'n'girl are glowin'\nfac'trys no place for me boss man let me be Minds inside are goin'\nMuscle 'n' bone are showin''\nOne thing sure are knowing (sure I'm?) knowin'\nGet a fire goin' fac'trys no place for me boss man let me be boss man let me be boss man leave me be	\N	https://music.apple.com/us/album/plastic-factory/290334563?i=290334573&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.189541+00	2026-05-26 20:11:35.978676+00
a256a5c8-9eeb-4fae-aaf4-b49fdf80c21b	Sure ‘Nuff ‘N Yes I Do	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1967	\N	\N	Well I was born in the desert came on up from New Orleans\nCame up on a tornado sunlight in the sky\nI went around all day with the moon sticking in my eye\nHey hey hey all you young girls wherever you're at\nI got a brand new Cadillac I got a Ferrari too\nSure 'nuff baby sure 'nuff 'n yes I do\nGot the time to teach ya' now, bet you'll learn some too\nGot the time to teach ya' now, bet you'll learn some too\nSure 'nuff baby sure 'nuff 'n yes I do\nHey hey hey all you young girls whatever you do\nHey hey hey all you young girls whatever you do\nWell come on by and see me I'll make it worth it to you\n.....with me and I'll ..with me and you\nSleep with me and I'll sleep with me and you\nStick with me and I'll stick with me and you	\N	https://music.apple.com/us/album/sure-nuff-n-yes-i-do/290334563?i=290334564&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.156038+00	2026-05-26 20:11:35.981306+00
5b27b2ef-2c08-4e36-b13c-9226d1c8ca26	Yellow Brick Road	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1967	\N	\N	Around the corner the wind blew back follow the yellow brick road\nIt ended up in black on black\nI was taught the gift of love\nSmiling children painted joy sunshine bright girl and boy\nbag of trick s and candy sticks peppermint kite for my toy\nYellow brick black on black Keep on walking and don't look back I walked along happy and them came back I follow the yellow brick road\nLost and found I saw you down on the bound off the bound Taught against the love yellow brick road took my load Sunshine girl sunshine girl come to my abode 1-2-3-4-5 miles long Oh I can't ever (so) go wrong\nClouds were gray yesterday down on my shoulder it's time to play\nYellow brick black on black Keep on walking and don't look back (repeat 1st verse)\nI follow the yellow brick road..............	\N	https://music.apple.com/us/album/yellow-brick-road/290334563?i=290334571&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.182123+00	2026-05-26 20:11:35.985824+00
e5c8d84f-4240-4df8-8a7d-2f18ad191576	Gimme Dat Harp Boy	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1968	\N	\N	\N	\N	https://music.apple.com/us/album/gimme-dat-harp-boy/284001765?i=284001786&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.231838+00	2026-05-26 20:11:35.967101+00
437fe539-901d-4597-8988-0b6f70415461	Hair Pie: Bake 2	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1969	\N	\N	\N	\N	https://music.apple.com/us/album/hair-pie-bake-2/137665947?i=137666970&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.266081+00	2026-05-26 20:11:35.968641+00
b5c963dc-80be-468a-af48-c79cec9d996d	Who Do You Think You’re Fooling	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1984	\N	\N	\N	\N	https://music.apple.com/us/album/who-do-you-think-youre-fooling/1477554850?i=1477554860&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.145115+00	2026-05-26 20:11:35.985517+00
bde8c5e9-5644-4fab-b3d4-5b22b1f279e9	Beatle Bones and Smokin’ Stones	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1968	\N	\N	\N	\N	https://music.apple.com/us/album/beatle-bones-n-smokin-stones/284001765?i=284001784&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.22985+00	2026-05-26 20:25:11.46218+00
9a45812f-cd8f-4ad1-afd0-80218cebb79c	Bellerin’ Plain	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1970	\N	\N	\N	\N	https://music.apple.com/us/album/bellerin-plain/935265160?i=935265172&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.302925+00	2026-05-26 20:11:35.959421+00
2d34d2c6-3079-4d4b-836f-9914beb94610	Glider	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1972	\N	\N	Into the sun in my glider There's ah shadow beside her Up 'n down through the blues Clouds give me my silent cues I'm up in my glider With ah shadow beside her It begins t' rain on her window pane Up in my glider There's no shadow beside her Thunderin' 'n lightnin' Gettin' pretty frightenin' I feel like an outsider Then the sun shows through 'n right on cue There's ah shadow beside her Up 'n down through the blues I'm up in my glider 'N I'm tellin' you boys there ain't no noise 'N me 'n my baby ain't never gonna bring my glider down	\N	https://music.apple.com/us/album/glider/415006591?i=415006689&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.33478+00	2026-05-26 20:11:35.967257+00
3d5cb9a2-7f15-4bfb-8f26-ca80ac766e79	Hobo Chang Ba	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1969	\N	\N	Strawwood claw rattlin' m' jaw I can't call it usin' It's just sumptin' soothin' Feather times uh feather Mornin' time t' thaw Hobo chang ba Hobo chang ba Standin' still is losin' Feather times a feather Mornin' time t' thaw Strawwood claw rattlin' m' jaw Hobo chang ba Hobo chang ba Hobo chang ba 'o Hobo chang ba 'o Stand t' gain m' ground Lay t' rest the law The ocean is m' mother 'n the freight train is m' paw Hobo chang ba Hobo chang ba 'o Hobo chang ba The rails I ride 'r rustin' The new sunrise m' trustin' The rails I ride 'r rustin' The new sunrise m' trustin' Strawwood claw rattlin' m' jaw Hobo chang ba ooh Hobo chang ba, Hobo	\N	https://music.apple.com/us/album/hobo-chang-ba/137665947?i=137667080&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.286505+00	2026-05-26 20:11:35.970393+00
e8a867c9-355f-4c9b-a446-655cef3b7519	Steal Softly Thru Snow	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1969	\N	\N	The black paper between a mirror breaks my heart\nThe moon frayed thru dark velvet lightly apart\nSteal softly thru sunshine\nSteal softly thru snow\nThe wild goose flies from winter\nBreaks my heart that I can't go\nEnergy flys thru a field\n'n the sun softly melts a nothing wheel\nSteal softly thru sunshine\nSteal softly thru snow\nThe black paper between a mirror breaks my heart that I can't go\nThe swan their feathers don't grow\nThey're spun\nThey live two hundred years of love\nThey're one\nBreaks my heart to see them cross the sun\nGrain grows rainbows up straw hill\nBreaks my heart to see the highway cross the hill\nMan lived a million years 'n still he kills\nThe black paper between a mirror\nBreaks my heart that I can't go\nSteal softly thru sunshine\nSteal softly thru snow	\N	https://music.apple.com/us/album/steal-softly-thru-snow-instrumental/1059238140?i=1059238255&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.29026+00	2026-05-26 20:25:11.469118+00
30d24070-e97e-47df-9845-948127100112	Too Much Time	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1972	\N	\N	[Chorus:] I got too much time, too much time\nI got too much time to be without love\nIn my life I've got a deep devotion\nWide as the sky and deep as the ocean\nEvery war that's waged makes me cry\nEvery bird that goes by gets me high\n[Spoken: Sometimes when it's late and I'm a little bit hungry I heat\nup some old stale beans, open up a can of sardines, eat crackers and\ndreams of somebody to cook for me.]\n[Repeat chorus, verse and chorus]	\N	https://music.apple.com/us/album/too-much-time/1829049521?i=1829049528&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.341418+00	2026-05-26 20:11:35.984044+00
fc5ea0b4-fea8-41e9-8b87-a9268cec8cca	Flash Gordon’s Ape	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1970	\N	\N	\N	\N	https://music.apple.com/us/album/flash-gordons-ape/415007099?i=415007219&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.316443+00	2026-05-26 20:11:35.965856+00
3cfda4a5-777b-409f-9940-9595c5587858	When It Blows Its Stacks	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1972	\N	\N	When it blows its stacks\nHe ain't nowhere t' be found\nWhen ah wolf's claws wear way down\nBetter watch out there's ah man eater around\nHide all the women in town\nWhen it blows its stacks\nAll you girls make no mistake\nHe's as cold as ah snake sleepin' in the shade\nHe takes um out\nOut on an iceberg\nHand 'em ah Ronson 'n says\nI'll see you around\nWhen he straighten up\nThey all bend down\nHe don't bow t' bad water\nHe don't pussy foot around\nWhen it blows its stacks\nHe ain't nowhere t'be found	\N	https://music.apple.com/us/album/when-it-blows-its-stacks/1829049107?i=1829049119&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.323745+00	2026-05-26 20:11:35.985056+00
09e9b2f1-a24d-4ee1-998c-715dd1036244	I Love You, You Big Dummy	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1970	\N	\N	\N	\N	https://music.apple.com/us/album/i-love-you-you-big-dummy/1530937920?i=1530938506&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.300198+00	2026-05-26 20:11:35.971084+00
2bea8d49-607c-45ca-ada6-08ab5a323e74	I’m Gonna Booglarize You Baby	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1972	\N	\N	\N	\N	https://music.apple.com/us/album/im-gonna-booglarize-you-baby/415006591?i=415006596&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.319039+00	2026-05-26 20:11:35.971869+00
73e87677-d92e-4d40-81e7-08ed1050d963	Japan in a Dishpan	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1970	\N	\N	\N	\N	https://music.apple.com/us/album/japan-in-a-dishpan/415007099?i=415007200&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.30543+00	2026-05-26 20:11:35.972825+00
d5d2d0a1-32ea-4e58-9456-779f9499a5c4	Lick My Decals Off, Baby	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1970	\N	\N	\N	\N	https://music.apple.com/us/album/lick-my-decals-off-baby/415007099?i=415007105&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.297637+00	2026-05-26 20:11:35.973369+00
6b10dd87-fdd9-4e7b-9f7d-5306bc6336fe	One Red Rose That I Mean	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1970	\N	\N	\N	\N	https://music.apple.com/us/album/one-red-rose-that-i-mean/415007099?i=415007212&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.309426+00	2026-05-26 20:11:35.977123+00
2c6e5dd5-7643-4285-a0d7-78c580ddb23e	Peon	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1970	\N	\N	\N	\N	https://music.apple.com/us/album/peon/415007099?i=415007137&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.301436+00	2026-05-26 20:11:35.978261+00
f6f5e23a-e3b7-463c-9eef-5f142bc75d2d	She’s Too Much For My Mirror	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1969	\N	\N	\N	\N	https://music.apple.com/us/album/shes-too-much-for-my-mirror/251186740?i=251186992&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.284445+00	2026-05-26 20:11:35.979327+00
d6ce060e-510a-4fa5-bbac-ea26737707b3	Space-age Couple	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1970	\N	\N	\N	\N	https://music.apple.com/us/album/space-age-couple/415007099?i=415007215&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.314024+00	2026-05-26 20:11:35.979995+00
fe0bd689-1d11-4874-9aa1-ea05d65e5112	The Buggy Boogie Woogie	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1970	\N	\N	\N	\N	https://music.apple.com/us/album/the-buggy-boogie-woogie/415007099?i=415007213&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.310683+00	2026-05-26 20:11:35.981977+00
c11ad5e0-3684-4e72-af5e-2c8e8279ab73	Veteran’s Day Poppy	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1969	\N	\N	\N	\N	https://music.apple.com/us/album/veterans-day-poppy-live/358815897?i=358816727&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.294056+00	2026-05-26 20:25:54.954849+00
ee5736b4-5078-4d35-b143-a34fcb5b44d2	Magic Be	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1974	\N	\N	\N	\N	\N	\N	\N	\N	{}	2026-05-26 18:39:42.367813+00	2026-05-26 18:39:42.367813+00
de53a002-6644-40cb-81cc-d9c5b780cae9	Happy Love Song	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1974	\N	\N	\N	\N	\N	\N	\N	\N	{}	2026-05-26 18:39:42.3696+00	2026-05-26 18:39:42.3696+00
22c6fec0-32e5-4b89-b3f7-faabe7290bcc	I Got Love On My Mind	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1974	\N	\N	\N	\N	\N	\N	\N	\N	{}	2026-05-26 18:39:42.374132+00	2026-05-26 18:39:42.374132+00
298267eb-a490-4408-9ada-cb5b5864c2cb	Lazy Music	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1974	\N	\N	\N	\N	\N	\N	\N	\N	{}	2026-05-26 18:39:42.378202+00	2026-05-26 18:39:42.378202+00
c2a0a42b-fa6d-4ac5-b968-631343c94321	Rock and Roll’s Evil Doll (Don Vliet / Mark Gibbons / Ira Ingber) 3.09	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1974	\N	\N	\N	\N	\N	\N	\N	\N	{}	2026-05-26 18:39:42.395086+00	2026-05-26 18:39:42.395086+00
5fe34c92-f026-41a9-bf4d-00264881c630	Candle Mambo	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1978	\N	\N	Candle shy, candle weep\nFly, hot candle, leap\nCandle roll and fold in ball\nCandle large, candle small\nYour threads of fire burning up,\nYour feathers of fire winning night\nAnd turning light, and turning light\nLight deepest night for me, and steer for me\nSpin and spin\nThen and then\nWhen I?m dancing with my love the shadows flicker up above\nUp above the shadows do the Candle Mambo\nCandle roll and fold in ball\nCandle blur, candle whir\nCandle her, candle her\nWhile your lights are spinning round,\nYour feathers of fire winning night\nAnd turning light, and turning light\nCandle crack, candle break\nCorrect the night?s mistake\nWhen I?m dancing with my love\nThe shadows flicker up above\nUp above, the shadows do the Candle Mambo	\N	https://music.apple.com/us/album/candle-mambo/370925126?i=370925166&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.426631+00	2026-05-26 20:11:35.961265+00
5d122ecb-4f53-4f55-9702-0c63b4c32f9e	Owed T’ Alex	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1978	\N	\N	Stupid heart, cupid heart\nWhere will you go from here?\nMagnetic ring, magnetic draw\nOoh, what you got me into?\nI?m a wolf, chrome craw\nLeavin? you now\n- I?ll write ya, ma\nTakin? a putt up to Carson City\nWell, if you hear me howlin?\nWehell, sittin? pretty\nTasted nitty gritty\nPuttin? on into Carson City\nSparks, tattoos, two tats and a toot\nHelmets, crosses, and a patch to boot\nEngine hot, pipes burn white\nGlad I?m not home tonight\nFive miles back I took a spill\n- Thought I almost paid my bill\nMakin? my putt to Carson City\nParty time with the Jones-by-name\nAh, it?s a shame\nSay, it?s a pity\nGotta put outta Carson City\nHa ha ha ha ha\nHa ha ha ha ha ha	\N	https://music.apple.com/us/album/owed-t-alex/370925126?i=370925160&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.424998+00	2026-05-26 20:11:35.977464+00
c6bfdbc5-00ad-4aae-b306-cdd3cf2c3d56	Flavor Bud Living	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	2012	\N	\N	\N	\N	https://music.apple.com/us/album/flavor-bud-living/714553431?i=714553697&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.406287+00	2026-05-26 20:11:35.966194+00
f8918d61-e93a-4064-ab52-e7acc677d2c3	Hot Head	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1980	\N	\N	\N	\N	https://music.apple.com/us/album/hot-head/714553431?i=714553565&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.4364+00	2026-05-26 20:11:35.970582+00
f7e94fde-4a03-4c9b-91cf-9525d2575afd	Ice Rose	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1978	\N	\N	\N	\N	https://music.apple.com/us/album/ice-rose/370925126?i=370925140&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.416275+00	2026-05-26 20:11:35.972278+00
786d3951-e845-4478-97de-e5dde9af8209	Odd Jobs	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	2012	\N	\N	\N	\N	https://music.apple.com/us/album/odd-jobs/1059241448?i=1059242090&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.409032+00	2026-05-26 20:11:35.976417+00
0de06350-8914-4517-ab5a-0ca414aa3e44	Run Paint Run Run	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1980	\N	\N	\N	\N	https://music.apple.com/us/album/run-paint-run-run/714553431?i=714553616&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.441762+00	2026-05-26 20:11:35.978844+00
5cf50d37-f372-4b62-a130-0928def5ffe3	When I See Mommy I Feel Like a Mummy	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1978	\N	\N	\N	\N	https://music.apple.com/us/album/when-i-see-mommy-i-feel-like-a-mummy/370925126?i=370925157&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.423089+00	2026-05-26 20:11:35.984728+00
ada4c57d-e0e9-4c95-bf4c-d7fe53953d3e	You Know You’re A Man	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1978	\N	\N	\N	\N	https://music.apple.com/us/album/you-know-youre-a-man/370925126?i=370925151&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.41969+00	2026-05-26 20:11:35.985978+00
be447424-a6d2-45ed-b813-17d88d03c35d	Bluejeans And Moonbeams (Don Vliet) 5.09	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1974	\N	\N	\N	\N	https://music.apple.com/us/album/bluejeans-and-moonbeams/1658687742?i=1658687874&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.402225+00	2026-05-26 20:25:11.462696+00
3b7a41bc-10ca-4af0-ae8e-f5046b1db3e5	Pompadour Swamp (Don Vliet) 3.27	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1974	\N	\N	\N	\N	https://music.apple.com/us/album/pompadour-swamp/1658687742?i=1658687869&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.390798+00	2026-05-26 20:25:11.468163+00
4edc21e4-42d4-4b16-86d8-d70bb97b4499	Full Moon Hot Sun	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1974	\N	\N	\N	\N	https://music.apple.com/us/album/full-moon-hot-sun-live/1059244495?i=1059244504&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.371503+00	2026-05-26 20:25:54.948218+00
557ad703-cb16-4046-a3af-35a32e0a4b4d	Peaches	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1974	\N	\N	\N	\N	https://music.apple.com/us/album/peaches-pt-1-live/1059244495?i=1059244507&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.380381+00	2026-05-26 20:25:54.951161+00
35735121-6583-4df8-9526-fc7cc8edd5fc	This is the Day	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1974	\N	\N	\N	\N	https://music.apple.com/us/album/this-is-the-day-live/1059244495?i=1059244506&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.376189+00	2026-05-26 20:25:54.954041+00
41fdb870-64fb-44a7-b863-6fa37ade63ed	Upon The My O My	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1974	\N	\N	\N	\N	https://music.apple.com/us/album/upon-the-my-o-my-live/1059244495?i=1059244498&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.361897+00	2026-05-26 20:25:54.954576+00
7399581c-7454-4c60-95a9-fe391580e363	Observatory Crest (Don Vliet / Elliot Ingber) 3.28	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1974	\N	\N	\N	\N	https://music.apple.com/us/album/observatory-crest-mixed/1586405526?i=1586405527&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.388489+00	2026-05-26 20:26:14.037894+00
507a5c5c-d828-4181-9516-950d2b837b1a	Party Of Special Things To Do (Don Vliet / Elliot Ingber) 3.12	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1974	\N	\N	\N	\N	https://music.apple.com/us/album/party-of-special-things-to-do/1658687742?i=1658687743&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.384247+00	2026-05-26 20:26:14.802575+00
a10f73f8-7777-4a72-9997-91db9be6b929	Twist Ah Luck (Don Vliet / Mark Gibbons / Ira Ingber) 3.17	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1974	\N	\N	\N	\N	https://music.apple.com/us/album/twist-ah-luck/1658687742?i=1658687873&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.400232+00	2026-05-26 20:26:17.300659+00
a1c6f207-66ef-402e-b3a5-e6e7ae4eec3f	Upon The Me Oh My	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2006	\N	\N	\N	\N	\N	\N	\N	\N	{}	2026-05-26 18:39:42.487357+00	2026-05-26 18:39:42.487357+00
3bca071e-f0cf-464c-a793-fa43a5cbe6d2	Keep On Rubbin’ aka Mighty Crazy	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2006	\N	\N	\N	\N	\N	\N	\N	\N	{}	2026-05-26 18:39:42.489013+00	2026-05-26 18:39:42.489013+00
f4cf9a24-ef2c-4893-8b15-2181238927f6	Apes-Ma 0:46	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2000	\N	\N	\N	\N	https://music.apple.com/us/album/apes-ma/370925126?i=370925173&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.485506+00	2026-05-26 20:11:35.957167+00
d51f9aa8-06d0-404c-bb02-ec0d40e6f5d0	New Electric Ride	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2006	\N	\N	Here we go again, baby On the New Electric Ride Twisting and turning Over on our side Here we go around the curve Ya, we really going to swerve Oh, I could barely hold my pride I could barely hold my pride Rappin' so hard I'm holding my side With you right by my side With my baby right by my side When the machine-guitar stars to playing We're watching the shooting stars We're under love's blue sky On the New Electric Ride Think of all the love we've been missing Then we start to kissing and kissing I could barely hold my pride With my baby right by my side Loop-de-loop, Ride and glide Swoop-de-swoop, On the New Electric Ride With my baby right by my side I can barely hold my pride >From coast to coast She loves me the most Twisting and turning, side by side My baby loves to hide On the New Electric Ride Up and down, around and round She loves me the most On the New Electric Ride Up and down, around and round She loves to hide On the New Electric Ride . . .	\N	\N	\N	\N	\N	{}	2026-05-26 18:39:42.490179+00	2026-05-26 18:39:42.490179+00
b52e321b-e30c-4f26-bbfb-095ceee16253	Brickbats	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1980	\N	\N	\N	\N	https://music.apple.com/us/album/brickbats/714553431?i=714553666&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.44602+00	2026-05-26 20:11:35.960909+00
4ebd20d5-33ce-48a6-b26c-c98c31fd94e1	Dropout Boogie 3:13	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2000	\N	\N	\N	\N	https://music.apple.com/us/album/dropout-boogie/290334563?i=290334567&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.481564+00	2026-05-26 20:11:35.964701+00
9df73ca6-e32d-4172-94f5-57e59b3a3c0b	Evening Bell	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1982	\N	\N	\N	\N	https://music.apple.com/us/album/evening-bell/714560239?i=714560429&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.466686+00	2026-05-26 20:11:35.965518+00
77fe0ec5-3dec-4960-aa45-6fa3534e3ec2	Her Eyes Are A Blue Million Miles 4:12	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2000	\N	\N	\N	\N	https://music.apple.com/us/album/her-eyes-are-a-blue-million-miles/1829049521?i=1829049538&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.482741+00	2026-05-26 20:11:35.969772+00
910d9763-2d67-4e08-a0d7-0e1e5e6c45ef	Ice Cream For Crow	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1982	\N	\N	\N	\N	https://music.apple.com/us/album/ice-cream-for-crow/714560239?i=714560314&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.45966+00	2026-05-26 20:11:35.97209+00
b9b31485-718e-44f6-9e54-f9fb8b0a7ccd	Ice Rose 3:56	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2000	\N	\N	\N	\N	https://music.apple.com/us/album/ice-rose/370925126?i=370925140&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.483774+00	2026-05-26 20:11:35.972496+00
2f68cbc3-6171-42c9-8e3b-91bcf5b2fa71	Ink Mathematics	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1982	\N	\N	\N	\N	https://music.apple.com/us/album/ink-mathematics/714560239?i=714560532&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.471317+00	2026-05-26 20:11:35.972661+00
56b58cd8-cf8f-4051-ad91-c16a9435752c	Nowadays A Woman’s Gotta Hit A Man 5:07	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2000	\N	\N	\N	\N	https://music.apple.com/us/album/nowadays-a-womans-gotta-hit-a-man/1829049521?i=1829049527&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.480836+00	2026-05-26 20:11:35.976202+00
0e67f4d8-2b35-4592-9295-10a293f759fe	Owed T’ Alex 5:20	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2000	\N	\N	\N	\N	https://music.apple.com/us/album/owed-t-alex/370925126?i=370925160&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.481231+00	2026-05-26 20:11:35.977621+00
c431c364-3ee2-4654-8e89-05491f5479ad	Semi-Multicoloured Caucasian	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1982	\N	\N	\N	\N	https://music.apple.com/us/album/semi-multicoloured-caucasian/714560239?i=714560367&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.463266+00	2026-05-26 20:11:35.979171+00
2994a441-6986-4bf8-ae2b-8da2af04f498	The Floppy Boot Stomp 4:18	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2000	\N	\N	\N	\N	https://music.apple.com/us/album/the-floppy-boot-stomp/370925126?i=370925128&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.48441+00	2026-05-26 20:11:35.98264+00
c57ea0df-159b-4af4-bfc9-3dd6f69dad13	The Host The Ghost The Most Holy-O	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1982	\N	\N	\N	\N	https://music.apple.com/us/album/the-host-the-ghost-the-most-holy-o/714560239?i=714560322&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.461248+00	2026-05-26 20:11:35.982804+00
6e26a80b-5347-4d56-9e29-5214e63f838a	Tropical Hot Dog Night 4:36	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2000	\N	\N	\N	\N	https://music.apple.com/us/album/tropical-hot-dog-night/1783193106?i=1783193482&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.480408+00	2026-05-26 20:11:35.984382+00
63f43c30-6c11-4c0f-9c60-d18251104601	When I See Mommy I Feel Like A Mummy 6:04	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2000	\N	\N	\N	\N	https://music.apple.com/us/album/when-i-see-mommy-i-feel-like-a-mummy/370925126?i=370925157&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.485876+00	2026-05-26 20:11:35.984893+00
f0e324ec-bf9b-4059-a522-c01caf4f2b16	Abba Zabba	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2006	\N	\N	\N	\N	https://music.apple.com/us/album/abba-zabba-live/415588757?i=415588886&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.490517+00	2026-05-26 20:25:11.451839+00
4d727491-2011-45ad-b77e-af4af22480f6	Moonlight On Vermont 3:52	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2000	\N	\N	\N	\N	https://music.apple.com/us/album/moonlight-on-vermont-live/415588757?i=415588891&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.484098+00	2026-05-26 20:25:11.466433+00
6c92d437-ac4a-4327-b8df-a580d5c4ebf5	Peaches	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2006	\N	\N	\N	\N	https://music.apple.com/us/album/peaches-pt-1-live/1059244495?i=1059244507&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.490857+00	2026-05-26 20:25:11.467855+00
72110ecf-5d56-4bf8-a616-81994292edfc	Sugar Bowl	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2006	\N	\N	\N	\N	https://music.apple.com/us/album/sugar-bowl-live/1059244495?i=1059244509&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.488308+00	2026-05-26 20:25:11.469466+00
fbfe7991-1879-4f10-b103-34fe28048195	This Is The Day	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2006	\N	\N	\N	\N	https://music.apple.com/us/album/this-is-the-day-live/1059244495?i=1059244506&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.489703+00	2026-05-26 20:25:11.471201+00
6ea8d8e5-4093-448e-a3fa-25d6a90b25d1	Well 3:55	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2000	\N	\N	\N	\N	https://music.apple.com/us/album/well-live/415588757?i=415588889&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.483431+00	2026-05-26 20:25:11.472346+00
aff07b4c-46cb-47b7-9f8a-cfa2a72143ee	Capitol Radio Concert Advert	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2006	\N	\N	\N	\N	\N	\N	\N	\N	{}	2026-05-26 18:39:42.491198+00	2026-05-26 18:39:42.491198+00
ac1847e8-caad-4a59-9a80-128ee90d3811	The Blimp/Air Bass-Soft Shoe(Sax Improv)	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2003	\N	\N	\N	\N	\N	\N	\N	\N	{}	2026-05-26 18:39:42.500869+00	2026-05-26 18:39:42.500869+00
96759f44-9b16-4ab7-b7c4-eb9ae5266008	Click Clack	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2002	\N	\N	Two trains Two railroad tracks One goin' 'n the other one comin' back There goes my baby on that ole train I say come back come back baby come back Click clack click clack There's my baby wain' her handkerchief down My cars stand up when I hear that sound This time it sound like it's for keeps Click clack click clack I get down on the ground With the gravel around I pray t' the Lord That the train will stop Turn right around 'N never stop till it drop my baby off Now I had this girl Threatened 'n leave me all the time Maybe you had uh girl like that I-yuh all time cryin' Well I had this girl Threatened 'n leave me all the time Threatenin' t' go down t' N'Orleans-uh 'N get herself lost 'n found Maybe you had uh girl like this She's always threatenin' t' go down t' N'Orleans 'N get herself lost 'n found C'mon I'll play it for yuh Lemme tell yuh 'bout it Lemme tell yuh 'bout it There were two railroad tracks Click clack click clack One ah them leavin'-uh 'N the other one comin' back I was two years from yuh baby You were goin' way up the tracks The train was leavin'-uh I could see yuh wavin' your handkerchief	\N	https://music.apple.com/us/album/click-clack/415006591?i=415006628&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.506543+00	2026-05-26 20:11:35.96228+00
5f3a98c2-1e6a-4e01-a38c-7daa46f265e6	Harry Irene	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2003	\N	\N	Harry Irene were a couple that lived in the green Harry Irene were a couple that ran a canteen Ran a canteen Ran a canteen Two people Harry and Irene like you never seen The floor was made of oak, the door was smokey gray Their tuna sandwiches would turn the dark into day Harry Irene were a couple that ran a canteen Harry Irene were a couple that lived in the green Ran a canteen Ran a canteen took Harry for all of his green and Irene Harry was left holding an empty canteen What does this mean? What does this mean? What's the meaning of this? Poor Harry, I guiss	\N	https://music.apple.com/us/album/harry-irene/370925126?i=370925146&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.503463+00	2026-05-26 20:11:35.968877+00
e0fc5ceb-ffd9-4574-96c5-96e9bea4767e	Beatle Bones ‘n’ Smokin Stones	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2002	\N	\N	\N	\N	https://music.apple.com/us/album/beatle-bones-n-smokin-stones/284001765?i=284001784&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.510112+00	2026-05-26 20:11:35.959197+00
ff4f2b27-5b1e-4bce-b9f1-1c1d97a3a5ad	Kandy Korn	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2006	\N	\N	Yellow and orange orange and well they taste so good I want to eat 'em And they taste s good I get to need 'em Can-can-can-candy candy Candy corn yellow and orange and candy corn yellow and orange and candy be reborn be reformed stay stay warm	\N	https://music.apple.com/us/album/kandy-korn/284001765?i=284001779&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.498451+00	2026-05-26 20:11:35.972989+00
4a474223-0216-45ca-acdd-393f21e2a34c	Flavor Bud Living	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2002	\N	\N	\N	\N	https://music.apple.com/us/album/flavor-bud-living/714553431?i=714553697&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.510861+00	2026-05-26 20:11:35.966038+00
36758089-5d1c-4f70-8611-bc929c15bc05	Floppy Boot Stomp	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2003	\N	\N	\N	\N	https://music.apple.com/us/album/floppy-boot-stomp/1057675201?i=1057675208&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.50306+00	2026-05-26 20:11:35.966415+00
fb8a5d6d-8fed-4f6a-96d0-60ea8c7c1db3	Hot Head	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2006	\N	\N	\N	\N	https://music.apple.com/us/album/hot-head/714553431?i=714553565&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.492233+00	2026-05-26 20:11:35.970755+00
2614c6bf-ce1d-4d46-847b-1efe0d606407	I’m Gonna Booglarize You Baby	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2003	\N	\N	\N	\N	https://music.apple.com/us/album/im-gonna-booglarize-you-baby/415006591?i=415006596&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.501261+00	2026-05-26 20:11:35.971711+00
25d2f57a-fab0-418b-abed-ed28f57e5d2a	One Red Rose That I Mean	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2006	\N	\N	\N	\N	https://music.apple.com/us/album/one-red-rose-that-i-mean/415007099?i=415007212&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.494772+00	2026-05-26 20:11:35.9773+00
8cdd08ac-f608-4998-9fad-a4856e76964e	Peon	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2002	\N	\N	\N	\N	https://music.apple.com/us/album/peon/415007099?i=415007137&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.507622+00	2026-05-26 20:11:35.978101+00
fd16e995-a741-4f26-8cb4-e25c7c869eb6	Avalon Blues	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2003	\N	\N	\N	\N	https://music.apple.com/us/album/avalon-blues-avalon-ballroom-sf-usa-1966/316493359?i=316493569&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.505839+00	2026-05-26 20:25:11.461562+00
c0c3bf94-8723-4b18-b772-8a65e8dc7cab	Dali’s Car	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2002	\N	\N	\N	\N	https://music.apple.com/us/album/dalis-car-live/285323829?i=285323845&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.510483+00	2026-05-26 20:25:11.463973+00
bf9acbc9-afe2-44f9-80d9-6f47048781d4	Gimme Dat Harp	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2002	\N	\N	\N	\N	https://music.apple.com/us/album/gimme-dat-harp-boy/284001765?i=284001786&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.509728+00	2026-05-26 20:25:11.465608+00
360e5022-5c5e-433b-91fa-51c205314eb1	I Love You You Big Dummy (short quote only)	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2003	\N	\N	\N	\N	https://music.apple.com/us/album/i-love-you-you-big-dummy/935265160?i=935265169&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.502339+00	2026-05-26 20:25:11.466049+00
23798bf7-78f3-43f2-a619-a49c8d0b56d6	Sheriff Off Hong Kong	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2006	\N	\N	\N	\N	https://music.apple.com/us/album/sheriff-of-hong-kong/714553431?i=714553715&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.498+00	2026-05-26 20:25:11.468674+00
3d5fc892-cce3-4d7a-9d47-e2156e76c07f	Smithsonian Institute Blues	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2003	\N	\N	\N	\N	https://music.apple.com/us/album/the-smithsonian-institute-blues-or-the-big-dig/415007099?i=415007214&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.504634+00	2026-05-26 20:25:11.468884+00
1bdb4f76-42c2-47b6-9397-a42c7ca148c2	The Dust Blows Forward ‘n’ The Dust Blows Back	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2003	\N	\N	\N	\N	https://music.apple.com/us/album/the-dust-blows-forward-n-the-dust-blows-back-live/1286409830?i=1286410013&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.503834+00	2026-05-26 20:25:11.470886+00
8259fb35-0f37-4538-8818-b5142c883543	King Bee	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2003	\N	\N	\N	\N	https://music.apple.com/us/album/im-a-king-bee-town-hall-new-york-usa-24-2-1973/316493359?i=316493399&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.500237+00	2026-05-26 20:27:19.659017+00
61f3e568-4e6a-4f22-bcbe-3fd9056821e4	A carrot is as close as a rabbit gets to a diamond	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2003	\N	\N	\N	\N	https://music.apple.com/us/album/a-carrot-is-as-close-as-a-rabbit-gets-to-a-diamond/714553431?i=714553614&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.501629+00	2026-05-26 20:11:35.95356+00
6dd89d9d-87e2-4f5f-8295-71f2859e2f00	A Carrot is as Close as a Rabbit Gets To A Diamond	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1980	\N	\N	\N	\N	https://music.apple.com/us/album/a-carrot-is-as-close-as-a-rabbit-gets-to-a-diamond/714553431?i=714553614&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.439775+00	2026-05-26 20:11:35.954339+00
99c498ac-2f95-4dde-bbe3-7646e05fb76c	Abba Zaba 3:44	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2000	\N	\N	\N	\N	https://music.apple.com/us/album/abba-zaba/290334563?i=290334572&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.482421+00	2026-05-26 20:11:35.955908+00
56012461-6ea0-4392-8411-540fc7c5a831	Alice in Blunderland	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1972	\N	\N	\N	\N	https://music.apple.com/us/album/alice-in-blunderland/415006591?i=415006606&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.325623+00	2026-05-26 20:11:35.956434+00
875f446a-9b61-4eab-829e-b3733a7f752e	Bat Chain Puller 5:55	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2000	\N	\N	\N	\N	https://music.apple.com/us/album/bat-chain-puller/370925126?i=370925154&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.485149+00	2026-05-26 20:11:35.958899+00
3336feea-1b60-4713-b7be-1224a3c3ecf9	Brick Bats	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	2012	\N	\N	\N	\N	https://music.apple.com/us/album/brick-bats/593229246?i=593229441&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.406651+00	2026-05-26 20:11:35.960742+00
060881c0-9f52-46a2-b2d1-f3309890039d	Diddy Wah Diddy	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1984	\N	\N	\N	\N	https://music.apple.com/us/album/diddy-wah-diddy/1477554850?i=1477554851&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.140395+00	2026-05-26 20:11:35.963262+00
3e200d0b-0bcc-464f-b439-4a8aa8a7e760	Floppy Boot Stomp	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	2012	\N	\N	\N	\N	https://music.apple.com/us/album/floppy-boot-stomp/1057675201?i=1057675208&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.407199+00	2026-05-26 20:11:35.966584+00
89864f61-5706-4239-82ca-00700eb9c566	Hair Pie: Bake 1	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1969	\N	\N	\N	\N	https://music.apple.com/us/album/hair-pie-bake-1/137665947?i=137666928&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.248462+00	2026-05-26 20:11:35.968458+00
7d08f6fe-4d63-43d5-94c0-94b7af3f1277	Harry Irene 3:46	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2000	\N	\N	\N	\N	https://music.apple.com/us/album/harry-irene/370925126?i=370925146&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.481903+00	2026-05-26 20:11:35.969293+00
bbee75ca-5fc0-44ec-ab25-0a2801ab05b2	Human Totem Pole (The 1000th And 10th Day Of The Human Totem Pole)	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	2012	\N	\N	\N	\N	https://music.apple.com/us/album/human-totem-pole-the-1000th-and-10th-day-of/593229246?i=593229446&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.409504+00	2026-05-26 20:11:35.970922+00
00828216-8d76-4738-8603-c8d31fc0ee7c	I Wanna Find a Woman That’ll Hold My Big Toe Till I Have To Go	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1970	\N	\N	\N	\N	https://music.apple.com/us/album/i-wanna-find-a-woman-thatll-hold-my-big-toe-till-i-have-to-go/415007099?i=415007210&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.306613+00	2026-05-26 20:11:35.97129+00
5b3d3d90-b994-4daf-bdc0-6be573b1db19	I’m Glad	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1967	\N	\N	\N	\N	https://music.apple.com/us/album/im-glad/290334563?i=290334569&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.173901+00	2026-05-26 20:11:35.971478+00
d9ae1b80-6628-4d01-947b-0d03c81f1f11	Clear Spot	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1972	\N	\N	I have to run so far to find a clear spot\nSun's all hottin' and a rottin' hot\nSwamp's all rotten 'n stinkin' uhh\nVegetation's hot\nSleepin' in a bayou on a old rotten cot Can't find my kind of folks havin' fun\nI have to run run run run\nRun to find a clear spot\nCan't shadow down, the sun big brown Mosquitos 'n moccasins steppin' all around\n'fraid I'm gonna get hit Sun's all hottin' and a rottin' hot Vegetation's hot Sleepin' in a bayou on a old rotten cot Can't find my kind of folks havin' fun Got to run run run run Run to find a clear spot Can't shadow down, the sun big brown\nMosquitos 'n moccasins steppin' all around 'fraid I'm gonna get hit\n'fraid I'm gonna get hit I have to run so far to find a clear spot	\N	https://music.apple.com/us/album/clear-spot/1829049521?i=1829049534&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.349511+00	2026-05-26 20:11:35.962+00
600abda1-8885-427c-a1fb-855f02994ef4	Electricity	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2002	\N	\N	Singin through you to me; thunderbolts caught easily Shouts the truth peacefully Eeeeeee-lec-tri-ci-teeeeeeee High voltage man kisses night to bring the light to those who need to hide their shadow deed Go into bright find the light and know that friends don't mind just how you grow midnight cowboy stains in black reads dark roads without a map To free-seeking electricity (repeat) (Repeat both lines) Lighthouse beacon straight ahead straight ahead across black seas to bring Seeking eeee-lec-tri-ci-teeeee High voltage man kisses night to bring the light to those who need to hide their shadow-deed hide their shadow-deed (repeat) Seek electricity...........	\N	https://music.apple.com/us/album/electricity/290334563?i=290334570&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.508426+00	2026-05-26 20:11:35.964887+00
3ef35113-4602-484c-9329-e4b1a0293797	Golden Birdies	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1972	\N	\N	Those little golden birdies look at them And the mystic Egypt tossle dangling down Old sleeper-man shish, don't wake him Up one hand broom star was an obi-man revered throughout the bone-knob land His magic black purse slit creeped open, Let go flocks of them Shish sookie singabus Snored like a red merry-go-round horse And an acid gold bar swirled up and down, Up and down, in back of the singabus And the panataloon duck white goose neck quacked webcore, webcore	\N	https://music.apple.com/us/album/golden-birdies/1829049521?i=1829049540&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.358407+00	2026-05-26 20:11:35.967598+00
7cc29d44-0d5f-455c-b598-af70cffbf702	Her Eyes Are A Blue Million Miles	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2006	\N	\N	I look at her and she looks at me In her eyes I see the sea I can't see what she sees in a man like me She says she loves me Her eyes Her eyes Her eyes are a blue million miles Far as I can see She loves me Her eyes Her eyes Her eyes are a blue million miles Far as I can see She loves me I look at her and she looks at me In her eyes I see the sea I can't see what she sees in a man like me She says she loves me Her eyes Her eyes Her eyes are a blue million miles	\N	https://music.apple.com/us/album/her-eyes-are-a-blue-million-miles/1829049521?i=1829049538&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.494407+00	2026-05-26 20:11:35.96962+00
2842fda3-eb10-4aae-b4fb-8004ff89a2bd	Hey Garland I Dig Your Tweed Coat	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1982	\N	\N	Hey Garland, I dig your tweed coat. I'll trade you a domino this size, mothball-scented. The woman silk nude tie painting his chest. One celluloid stay exposed through his nibbled collar. Feet speckled the sidewalk. Faces gurgled through windows. Passing cars gum rubber streaks. Neon plants swim like green seaweed to a deep rhythm of blues. Red thyroid sunsets, flame in speckled chemistry. Pipes run off dark tubes. Erase into marks that pour the dye of darkness. Crystal comes together as silent as ink. "I don't think I could let it go. I got it at the religious scene" Teeth let go, tobacco juice, an oiled balloon, brown eye in an egg white, black tar bubbles and stripes. A straw hat squeaked on the brim of a feather. Newsprint thumbed through nicotine fingers, a dark olive was turned on. Its small pulp speaker burst into a scream. One large tomato was immediately peeled skin red. It bled into a red "O" and smacked behind accepted fangs. Quick eyebrows danced cutely above a mole. The bridge held a large gold pair of spectacles. The front was smooth. It slightly gathered and wrinkled at the holes. A dark wooden moustache deposited below above Chinese red varnished lips that dented slightly into the evening. "It's gotten quite cold. I've decided I can't sell you my coat." Honking, the wind puffed into the clumps above the lattice rows. And out looked Panatella, naked and not ashamed, without no clothes. Wiggle Pig went snout-first into a tree. The rubber turkey was gobbled up by the night's dark rubber mouth. A white phosphorous raindrop dropped in the sky. Hot silhouettes in a convertible gave this applause. And several white porcelain trays were rolled in by bumblebees. Their wings arranged with pictures out of the past. And the rainbow baboon gobbled fifteen fish eyes with each spoon. Pockets was caught at window level. Approaching the fractured glass, dripping in light, he spoke: "I've just looked at myself, and from here to here it ain't far enough, but from here to here it's too short." "And circles don't fly, they float," Pena exclaimed and went on to say, "Sun sure did shine this year. Who'd you look like underneath?"	\N	https://music.apple.com/us/album/hey-garland-i-dig-your-tweed-coat/714560239?i=714560372&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.46502+00	2026-05-26 20:11:35.970193+00
87218e59-1b9e-4b7f-9087-aee04ac7cb7b	Nowadays a Woman’s Gotta Hit a Man	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1972	\N	\N	\N	\N	https://music.apple.com/us/album/nowadays-a-womans-gotta-hit-a-man/1829049521?i=1829049527&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.339419+00	2026-05-26 20:11:35.975849+00
1aa76b7e-2f67-46cb-bf9a-9f9a94d9af3f	Nowadays A Woman’s Gotta Hit A Man	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2002	\N	\N	\N	\N	https://music.apple.com/us/album/nowadays-a-womans-gotta-hit-a-man/1829049521?i=1829049527&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.511204+00	2026-05-26 20:11:35.97601+00
312877de-7cab-4fc0-9178-2fb5376cb132	Old Fart At Play 2:26	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2000	\N	\N	\N	\N	https://music.apple.com/us/album/old-fart-at-play/137665947?i=137667281&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.483113+00	2026-05-26 20:11:35.976906+00
d799c2ab-07bd-407f-9947-dd6953581aa3	Petrified Forest	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1970	\N	\N	\N	\N	https://music.apple.com/us/album/petrified-forest/415007099?i=415007211&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.307918+00	2026-05-26 20:11:35.978491+00
174becd0-21bb-435c-92dd-43c9cb3520f0	Son of Mirror Man – Mere Man	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1968	\N	\N	\N	\N	https://music.apple.com/us/album/son-of-mirror-man-mere-man/1442931150?i=1442931352&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.225235+00	2026-05-26 20:11:35.979832+00
42c18384-6104-4e7e-b669-67cc9feffab5	Suction Prints	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1978	\N	\N	\N	\N	https://music.apple.com/us/album/suction-prints/370925126?i=370925172&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.431835+00	2026-05-26 20:11:35.980178+00
fcd63314-f880-443c-b2d0-d975de18ed63	Suction Prints	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2006	\N	\N	\N	\N	https://music.apple.com/us/album/suction-prints/370925126?i=370925172&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.498801+00	2026-05-26 20:11:35.980388+00
e8b23e54-4e6b-4cb2-a627-e1b5f9e6f9b0	The Clouds Are Full of Wine (not Whiskey or Rye)	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1970	\N	\N	\N	\N	https://music.apple.com/us/album/the-clouds-are-full-of-wine-not-whiskey-or-rye/415007099?i=415007217&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.315245+00	2026-05-26 20:11:35.982132+00
71242661-57f3-41dc-8d68-ae489713ef80	There Ain’t No Santa Claus on the Evenin’ Stage	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1972	\N	\N	\N	\N	https://music.apple.com/us/album/there-aint-no-santa-claus-on-the-evenin-stage/415006591?i=415006667&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.333152+00	2026-05-26 20:11:35.983869+00
a277926e-a922-46e2-b539-5b724f1840d2	Where There’s Woman	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1967	\N	\N	\N	\N	https://music.apple.com/us/album/where-theres-woman/290334563?i=290334574&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.193758+00	2026-05-26 20:11:35.98521+00
22fd10ab-8ea5-4f68-9fa4-8aa6352b21bb	Woe-is-uh-Me-Bop	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1970	\N	\N	\N	\N	https://music.apple.com/us/album/woe-is-uh-me-bop/415007099?i=415007199&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.304211+00	2026-05-26 20:11:35.985669+00
8c4c8524-0123-45a8-a6ec-b0c1793b09cf	You Know You’re A Man 3:26	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2000	\N	\N	\N	\N	https://music.apple.com/us/album/you-know-youre-a-man/370925126?i=370925151&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.484784+00	2026-05-26 20:11:35.98615+00
7c3a4ceb-db90-4097-9051-305d1bdd3248	Ah Carrot Is As Close As Ah Rabbit Gets To Ah Diamond	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	2012	\N	\N	\N	\N	https://music.apple.com/us/album/chariot-ah-carrot-is-as-close-as-ah-rabbit-gets-to-ah-diamond/593229246?i=593229443&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.407622+00	2026-05-26 20:25:11.459915+00
a05b3650-0f3a-484a-8d5d-b6442b80fd8c	China Pig / Railroadism	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2003	\N	\N	\N	\N	https://music.apple.com/us/album/china-pig-railroadism-live/285339390?i=285339502&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.501985+00	2026-05-26 20:25:11.463478+00
97fccb64-97f5-4d89-902a-f268f2409968	Full Moon Hot Sun	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2006	\N	\N	\N	\N	https://music.apple.com/us/album/full-moon-hot-sun-live/1059244495?i=1059244504&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.487742+00	2026-05-26 20:25:11.464688+00
7c0315c7-1d0f-45dd-8152-9c3b747ae647	Further Than We’ve Gone (Don Vliet) 5.00	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1974	\N	\N	\N	\N	https://music.apple.com/us/album/further-than-weve-gone/1658687742?i=1658687872&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.397898+00	2026-05-26 20:25:11.465208+00
6e96d606-5c9d-4682-bbbd-6cfbe2fbdf73	Hothead	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2002	\N	\N	\N	\N	https://music.apple.com/us/album/hothead-live/285323829?i=285323851&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.511792+00	2026-05-26 20:25:11.465841+00
038ee92d-e7e7-4efb-bf6f-6feca8ff3d0d	Old Black Snake	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2003	\N	\N	\N	\N	https://music.apple.com/us/album/old-black-snake-live/285323829?i=285323835&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.499825+00	2026-05-26 20:25:11.46714+00
6e046453-8f68-415d-9e5a-e3e617f5030a	Sugar Mama	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2002	\N	\N	\N	\N	https://music.apple.com/us/album/sugar-mama-live/285323829?i=285323842&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.508892+00	2026-05-26 20:25:11.469658+00
1fec70d0-4494-4cef-9788-2044a712d059	Sun Zoom Spark	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1972	\N	\N	Nothing makes it move\nFrom the bottom to the top\nDoes it start at the bottom?\nOr does it start at the top Magnet draw day from dark\nSun zoom spark\nSun zoom spark Now which hand's got it?\nBottom, or the top?\nNeither hand's got it\nIt's just got it\nHope it don't stop Magnet draw day from dark\nSun zoom spark\nSun zoom spark Think you can uh hold it\nOnce it start\nI don't care who ya are or what\nsize ya are\nI'm gonna magnetize ya Magnet draw day from dark\nSun zoom spark\nSun zoom spark	\N	https://music.apple.com/us/album/sun-zoom-spark/1829049521?i=1829049533&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.347437+00	2026-05-26 20:11:35.981108+00
6853edf0-6fb0-45d3-a64d-9c1e2d1c28d9	The Past Sure Is Tense	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1982	\N	\N	The past sure is tense\nthey're heading up for the main event\nall those people seem to be hell-bent\nsee those people up on top of the fence\nand the man down there\nselling knotholes through the fence\nthe little shoe generation man\nI found your print on a dollar bill\nI founf your print on an Indian mound\nI found your print on the statue at the sound\nI found your print on the elephant ground\nI found your print in the beautiful mountains\nthe grass no longer grew around\nI found your print in my mind -\nthe past sure is tense\nthe pastsureistense\nno you got the wrong idea\nno you got the wrong intent\nthe carpenter carpenterized my vent\nthe only peephole\nwhere is my dent\nthe past sure is tense\nthe past sure is tense\nthe past sure is now\nI don't see how\nsee those people that used to\nthrow those tents\nyou can't see them now\nthey're in past tense\nthe past sure is tense	\N	https://music.apple.com/us/album/the-past-sure-is-tense/714560239?i=714560498&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.469705+00	2026-05-26 20:11:35.982964+00
db88c659-3edb-4ded-ae58-d532b93dce48	Sweet Georgia Brown	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2006	\N	\N	\N	\N	https://music.apple.com/us/album/sweet-georgia-brown-live/1059244495?i=1059244505&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.48935+00	2026-05-26 20:25:11.469929+00
ee730331-0d09-494d-bccb-30464d976e61	Veteran’s Day Poppy	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2006	\N	\N	\N	\N	https://music.apple.com/us/album/veterans-day-poppy-live/358815897?i=358816727&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.497219+00	2026-05-26 20:25:11.471691+00
73d50d6f-f9bc-4d3b-9bf5-13ff7f6cd2d5	Veteran’s Day Poppy 9:11	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2000	\N	\N	\N	\N	https://music.apple.com/us/album/veterans-day-poppy-live/358815897?i=358816727&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.486237+00	2026-05-26 20:25:11.472004+00
36c456fc-f0a2-4720-81af-430a5af2cc36	Dali’s Car	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1969	\N	\N	\N	\N	https://music.apple.com/us/album/dalis-car-live/285323829?i=285323845&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.263939+00	2026-05-26 20:25:54.946235+00
aee73938-e08f-443c-9eb6-4939b24e5b18	Sugar Bowl	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1974	\N	\N	\N	\N	https://music.apple.com/us/album/sugar-bowl-live/1059244495?i=1059244509&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.363959+00	2026-05-26 20:25:54.951672+00
012d3877-7d1a-4906-822c-48a001aade0f	The Dust Blows Forward ‘N The Dust Blows Back	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1969	\N	\N	\N	\N	https://music.apple.com/us/album/the-dust-blows-forward-n-the-dust-blows-back-live/1286409830?i=1286410013&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.240446+00	2026-05-26 20:25:54.953376+00
90f5754b-ebe1-40dd-9ef4-28d5aa58c4c9	Captain’s Holiday (R.Feldman / W.Richmond / S.Hickerson / C.Blackwell) 5.42	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1974	\N	\N	\N	\N	https://music.apple.com/us/album/captains-holiday/1658687742?i=1658687870&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.393056+00	2026-05-26 20:26:13.233806+00
8208c1aa-a51c-4ff4-920f-3983a3bb9561	Same Old Blues (J.J.Cale) 4.00	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1974	\N	\N	\N	\N	https://music.apple.com/us/album/same-old-blues/1658687742?i=1658687866&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.386382+00	2026-05-26 20:26:16.318284+00
dd76048e-fb51-4cf9-9c70-7878d3cb9420	25th Century Quaker	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1971	\N	\N	Mayflower child\nmet uh 25th Century Quaker\nShe's uh pickin' poppies 'n'\nbringin' them into her hue\nSun sifting thru and thru and thru\nLetting them all and all\nfill thru\nMe into you me to you me to you\nInto hue\nBlue cheese faces\nlaces blue cheese\nfaces\nfaces 'n' phases 'n' phases 'n' faces\nGoing thru the cottage cottage\nGoing thru the cottage cottage\nGoing thru the cottage cottage\ncome with me baby, come with me\ncome with me baby, come with me\nQuaker child\nQuaker paper child\nFlutterin' ants flutter like\nfireflies\nEyes that flutter like uh\nwide open shutter\neyes that flutter like uh\nwide open shutter\nshutter, shutter, shutter\nlaces laces laces\nblue cheese faces\nMayflower child met uh\n25th century quaker\nshe's uh pickin' poppies\nbringin them into her hue\nSun just, sun just, sun just\nsun just siftin' thru and thru\nand thru....	\N	https://music.apple.com/us/album/25th-century-quaker/284001765?i=284001776&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.213435+00	2026-05-26 20:11:35.944644+00
de3bfb88-7783-450a-a5d0-b31068e39bd3	81 Poop Hatch	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	2012	\N	\N	My eyes are burnt and bleeding and all that looks like a monkey on a silver bar ?\nbig poop hatch with a cotton hatch ? hatch holes that the light shows in and the light shows out ?\nand the little red fence ?\nand the wire and the wood ?\nand the barbs and the berries ?\nand the tires and the bottles and the caruponrims ?\nand the heat swims on its fenders and the dust collects and the rust of autumn surrenders into gold ?\ntrumpet poop on the ground with peanuts its bell was blocking an ant?s vision ?\nand the mice played in its air holes and valves ?\na ladybug crawled off its mouthpiece standing out red and blacked its wings and blew off to a flower ?\nits hum heard just above the ground ?\nblack dots were hung in what turned out to be an olive tree that originally held a tree house full of a building with one small window ?\nbirds and broken glass and tiny bits of newspaper ?\n"My sun is free from the window," said the god the green dabbers ?\nrice wires mouse tins and milk muffins ?\ncereal and stone ?\nmatches and masks and mace and clubs ?\nand splintered shaft light intrigues a cricket on a dust jeweled penlet ?\ncobwebs collect down plaster run into a hole and find collected glass that drinks the reflection of midday afternoon midway between telegraph lines ?\na silver wing ? a cloud ? a rumbling of a cloud ?\na crowd of various violins strum from next door through my wall into my ear obviously artificial ?\nneighbors laugh through sandwiches ?\nHarlem babies ? their stomachs explode into roars ?\ntheir eyes shiny with starvation ?\nspreckled hula dance on my phonograph ?\nmy door rattles windy ?\nsand wears my rug shoe and taps on the unheard finish of an hourglass I cannot hear ?\na typical musician?s nest of thoughts filter through dust speakers ?\n"Why don?t you go home? Oh Blobby, are you great," exclaims two lips in some jumbled rock ?n? roll tune and wears a spot I cannot scratch ?\nthe surface of a friend ?\nthis high book a friend laid on me ?\non the couch relaxing in the corner behind a still life pond with plenty of bugs and lily pads slurred in mud banks and boulders tin cans and raisins warped by thought ?\nstrain on the spoon like a wheat check ? check Bif ? cotton popping out of his sleeve ?\npoop hatch open ? big poop hatch with a cotton hatch ? hatch holes ? got to pick up the horns ?\nbut the head won?t move until it walks	\N	https://music.apple.com/us/album/81-poop-hatch/714560239?i=714560547&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.405912+00	2026-05-26 20:11:35.952956+00
562a6458-4e9b-41da-b95f-e12b88491ebf	Abba Zaba	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2006	\N	\N	Song before song before song blues Babbette baboon (repeat) abba zabba zoom To shatter the noon Babbette baboon (repeat) Comin' over pretty soon Babbette baboon Run run catch her soon doctor dawn sunshine on Babbette baboon Mother say son she say son you can't lose with the stuff you use Abba Zabba zoom Babbette baboon (repeat both) Run run morning soon Indian dream tiger moon Yellow bird fly high go battle sky to shatter the moon Babbette baboon gonna catch her soon Babbette baboon Song before song before song blues Babbette baboon abba zabba zoom (repeat both) To shatter the noon abba zaba zoom Gonna zaba her soon Babbette baboon abba zabba zoom (repeat) Gonna catch her soon (repeat etc.)	\N	https://music.apple.com/us/album/abba-zaba/290334563?i=290334572&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.491876+00	2026-05-26 20:11:35.954953+00
a849df0d-cd1d-4474-b6a1-7c4235b0efa0	Abba Zaba	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1967	\N	\N	Song before song before song blues Babbette baboon (repeat) abba zabba zoom To shatter the noon Babbette baboon (repeat) Comin' over pretty soon Babbette baboon Run run catch her soon doctor dawn sunshine on Babbette baboon Mother say son she say son you can't lose with the stuff you use Abba Zabba zoom Babbette baboon (repeat both) Run run morning soon Indian dream tiger moon Yellow bird fly high go battle sky to shatter the moon Babbette baboon gonna catch her soon Babbette baboon Song before song before song blues Babbette baboon abba zabba zoom (repeat both) To shatter the noon abba zaba zoom Gonna zaba her soon Babbette baboon abba zabba zoom (repeat) Gonna catch her soon (repeat etc.)	\N	https://music.apple.com/us/album/abba-zaba/290334563?i=290334572&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.185469+00	2026-05-26 20:11:35.955547+00
32ff6187-3e57-443e-8e1c-a4db99eb7ddd	Ah Feel Like Ahcid	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1968	\N	\N	Got (a letter) up this morning how do you reckon it read? Red blue and green whoooo all through my head Licked the stamps saw a movie dropped the stamp I ain't got no blues no more I said Put me up thinkin' a postman's groovy I ain't I ain't got the blues no more I said......... Well send me with a letter lord drop me with a telegram I said My baby walked just like she did Walking on hard-boiled eggs with a...she can steal em.... I ain't blue o more I said Lord one jumped up lord the other one quackin' Yeah she got those great big drums sticking out Whoooo Big chicken legs beat when she walks flappin' down the street where I live Well she slippin' along easy like fried chicken Grew sort of greasy easy hmmmmm... Oh I ain't blue no more I ain't blue no more I said Well she walked along crazy like kinda crazy Sorta lazy sleazy cheesy you know what I mean I said............... Here the rest of the album plays until just after "Trust Us", where this segment plays. Ah Feel... (continued) ......freight elevator operating them trashcans Smackin' lips and saying "the food sure is good" I said Around the corner up round the alley half-shelled shoes a tapping golly golly shaking like jelly like heaven heaven I said Well they rolled around the corner turning up seven come eleven My lucky number lord I feel like I'm in heaven I said Well I ...well I blink my eyes and I see that movie Lord it's red blue and green This last small segment comes at the very conclusion of the album. Ah Feel... (concluded) I I ain't blue no more Wooo it's like heaven I said I said ..............	\N	\N	\N	\N	\N	{}	2026-05-26 18:39:42.219596+00	2026-05-26 18:39:42.219596+00
16cc493a-c8ef-431b-9700-71ef8049bc65	Ant Man Bee	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1969	\N	\N	White ants runnin' Black ants crawlin' Yella ants dreamin' Brown ants longin' All those people longin' to be free Uhuru ant man bee uhuru ant man bee All the ants in God's garden they can't get along War still runnin' on It's that one lump uh sugar That they won't leave each other 'lone Why do yuh have t' do this You've got t' let us free Why do yuh have t' do this You've got t' set us free Why do yuh have t' do this You've got t' set us free Why do yuh have t' do this You've got t' set us free Uhuru ant man bee uhuru ant man bee Now the bee takes his honey then he sets the flower free But in God's garden only Man 'n the ants They won't set each other be	\N	\N	\N	\N	\N	{}	2026-05-26 18:39:42.277322+00	2026-05-26 18:39:42.277322+00
914a6870-0842-4712-9ad9-2820f9ac825c	Apes Ma	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	2012	\N	\N	Apes-Ma, Apes-Ma Remember when you were young Apes-Ma? And you used to break out of your cage? Well you know that you're not Strong enough to do that anymore now And Apes-Ma... The little girl that Named you years ago died now And you're older Apes-Ma Remember when she named you And it was in the paper Apes-Ma? Apes-Ma, Apes-Ma You're eating too much And going to the bathroom too much Apes-Ma And Apes-Ma, your cage isn't getting any bigger Apes-Ma	\N	https://music.apple.com/us/album/apes-ma/370925126?i=370925173&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.40996+00	2026-05-26 20:25:11.461006+00
636e9138-2ee1-4197-afea-100c85a8ec9b	Apes-Ma	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1978	\N	\N	Apes-Ma, Apes-Ma Remember when you were young Apes-Ma? And you used to break out of your cage? Well you know that you're not Strong enough to do that anymore now And Apes-Ma... The little girl that Named you years ago died now And you're older Apes-Ma Remember when she named you And it was in the paper Apes-Ma? Apes-Ma, Apes-Ma You're eating too much And going to the bathroom too much Apes-Ma And Apes-Ma, your cage isn't getting any bigger Apes-Ma	\N	https://music.apple.com/us/album/apes-ma/370925126?i=370925173&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.433605+00	2026-05-26 20:11:35.95674+00
0f909c77-c53f-4dfb-8d0f-49420a57b392	Ashtray Heart	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1980	\N	\N	You used me like an ashtray heart\nCase of the punks\nRight from the start\nI feel like a glass shrimp in a pink panty\nWith a saccharine chaperone\nMake invalids out of supermen\nCall in a "shrink"\nAnd pick you up in a girdle\nYou used me like an ashtray heart\nRight from the start\nCase of the punks\nAnother day, another way\nSomebody's had too much to think\nOpen up another case of the punks\nEach pillow is touted like a rock\nThe mother / father figure\nSomebody's had too much to think\nSend your mother home your navel\nCase of the punks\nNew hearts to the dining rooms\nViolet heart cake\nDissolve in new cards, boards, throats, underwear\nAshtray heart\nYou picked me out, brushed me off\nCrushed me while I was burning out\nThen you picked me out\nLike an ashtray heart\nHid behind the curtain\nWaited for me to go out\nA man on a porcupine fence\nUsed me for an ashtray heart\nHit me where the lover hangs out\nStood behind the curtain\nWhile they crushed me out\nYou used me for an ashtray heart\nYou looked in the window when I went out\nYou used me like an ashtray heart.	\N	https://music.apple.com/us/album/ashtray-heart/714553431?i=714553611&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.438136+00	2026-05-26 20:11:35.958032+00
cb7b1a5b-a8b3-4085-9b77-21aa2979aeca	Ashtray Heart	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2006	\N	\N	You used me like an ashtray heart\nCase of the punks\nRight from the start\nI feel like a glass shrimp in a pink panty\nWith a saccharine chaperone\nMake invalids out of supermen\nCall in a "shrink"\nAnd pick you up in a girdle\nYou used me like an ashtray heart\nRight from the start\nCase of the punks\nAnother day, another way\nSomebody's had too much to think\nOpen up another case of the punks\nEach pillow is touted like a rock\nThe mother / father figure\nSomebody's had too much to think\nSend your mother home your navel\nCase of the punks\nNew hearts to the dining rooms\nViolet heart cake\nDissolve in new cards, boards, throats, underwear\nAshtray heart\nYou picked me out, brushed me off\nCrushed me while I was burning out\nThen you picked me out\nLike an ashtray heart\nHid behind the curtain\nWaited for me to go out\nA man on a porcupine fence\nUsed me for an ashtray heart\nHit me where the lover hangs out\nStood behind the curtain\nWhile they crushed me out\nYou used me for an ashtray heart\nYou looked in the window when I went out\nYou used me like an ashtray heart.	\N	https://music.apple.com/us/album/ashtray-heart/714553431?i=714553611&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.492599+00	2026-05-26 20:11:35.957791+00
0ad4a4fa-f8de-4047-8bda-d07313d51f1c	Bat Chain Puller	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	2012	\N	\N	Bat chain\nPuller\nBat chain puller\nPuller, puller\nA chain with yellow lights\nThat glistens like oil beads\nOn its slick smooth trunk\nThat trails behind on tracks, and thumps\nA wing hangs limp and retreats\nBat chain puller\nPuller puller\nBulbs shoot from its snoot\nAnd vanish into darkness\nIt whistles like a root snatched from dry earth\nSodbustin? rakes with grey dust claws\nAnnounces its coming in the morning\nThis train with grey tubes\nThat houses people?s very thoughts and belongings.\nBat chain puller\nPuller puller\nThis train with grey tubes that houses people?s thoughts,\nTheir very remains and belongings.\nA grey cloth patch\nCaught with four threads\nIn the hollow wind of its stacks\nRipples felt fades and grey sparks clacks,\nLunging the cushioned thickets.\nPumpkins span the hills\nWith orange crayola patches.\nGreen inflated trees\nBalloon up into marshmallow soot\nThat walks away in forty circles,\nCaught in grey blisters\nWith twinkling lights and green sashes\nUuh\nPulled by rubber dolphins with gold yawning mouths\nThat blister and break in agony\nIn souls of rust\nThey kill gold sawdust into dust.\nBat chain puller,\nPuller puller.	\N	https://music.apple.com/us/album/bat-chain-puller/370925126?i=370925154&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.404722+00	2026-05-26 20:11:35.958487+00
cc452b4b-83ff-465e-ab6a-eb9f223b3fca	Bat Chain Puller	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2006	\N	\N	Bat chain\nPuller\nBat chain puller\nPuller, puller\nA chain with yellow lights\nThat glistens like oil beads\nOn its slick smooth trunk\nThat trails behind on tracks, and thumps\nA wing hangs limp and retreats\nBat chain puller\nPuller puller\nBulbs shoot from its snoot\nAnd vanish into darkness\nIt whistles like a root snatched from dry earth\nSodbustin? rakes with grey dust claws\nAnnounces its coming in the morning\nThis train with grey tubes\nThat houses people?s very thoughts and belongings.\nBat chain puller\nPuller puller\nThis train with grey tubes that houses people?s thoughts,\nTheir very remains and belongings.\nA grey cloth patch\nCaught with four threads\nIn the hollow wind of its stacks\nRipples felt fades and grey sparks clacks,\nLunging the cushioned thickets.\nPumpkins span the hills\nWith orange crayola patches.\nGreen inflated trees\nBalloon up into marshmallow soot\nThat walks away in forty circles,\nCaught in grey blisters\nWith twinkling lights and green sashes\nUuh\nPulled by rubber dolphins with gold yawning mouths\nThat blister and break in agony\nIn souls of rust\nThey kill gold sawdust into dust.\nBat chain puller,\nPuller puller.	\N	https://music.apple.com/us/album/bat-chain-puller/370925126?i=370925154&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.495913+00	2026-05-26 20:11:35.958686+00
55ca45cf-83a5-4094-b2d7-a89c9b981a79	Best Batch Yet	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2006	\N	\N	We don't have to suffer, we're the best batch yet\nBaked in special\nWhite flesh waves to black\nYou might think this is the finest pearl\nBut it's only cardboard balls\nSeamed in glue\nOverwhelming technique\nDone t' diligence\nIt's all happening from the inside, you say?\nDone from the inside\nWhere it barely shows on the outside\nIt's remarkable\nI think this is the best batch yet\nWe don't have to suffer, we're the best batch yet\nBaked in special, we're the best batch yet\nWhite flesh waves to black\nYou might think this is the finest pearl\nBut it's only cardboard balls\nSeamed in glue\nOverwhelming technique\nDone through diligence\nIt's all happening from the inside, you say?\nDone from the inside\nWhere it barely shows on the outside\nIt's remarkable\nI say?\nI think this is the best batch yet\nWe're baked in special, we're the best batch yet\nWe don't have to suffer, we're the best batch yet.	\N	https://music.apple.com/us/album/best-batch-yet/714553431?i=714553678&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.493437+00	2026-05-26 20:11:35.959863+00
2d142f2b-13a0-44c1-9a7e-23d8bd8bf039	Best Batch Yet	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1980	\N	\N	We don't have to suffer, we're the best batch yet\nBaked in special\nWhite flesh waves to black\nYou might think this is the finest pearl\nBut it's only cardboard balls\nSeamed in glue\nOverwhelming technique\nDone t' diligence\nIt's all happening from the inside, you say?\nDone from the inside\nWhere it barely shows on the outside\nIt's remarkable\nI think this is the best batch yet\nWe don't have to suffer, we're the best batch yet\nBaked in special, we're the best batch yet\nWhite flesh waves to black\nYou might think this is the finest pearl\nBut it's only cardboard balls\nSeamed in glue\nOverwhelming technique\nDone through diligence\nIt's all happening from the inside, you say?\nDone from the inside\nWhere it barely shows on the outside\nIt's remarkable\nI say?\nI think this is the best batch yet\nWe're baked in special, we're the best batch yet\nWe don't have to suffer, we're the best batch yet.	\N	https://music.apple.com/us/album/best-batch-yet/714553431?i=714553678&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.449917+00	2026-05-26 20:11:35.959662+00
8ef87f45-e8d7-4d0c-9536-d3530d8da330	Big Eyed Beans from Venus	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2006	\N	\N	Distant cousins, there's a limited supply.\nAnd we're down to the dozens, and this is why:\nBig Eyed Beans from Venus! Oh my, oh my. Boys and girls, Earth people around the circle,\nMixtures of man alive.\nBig eyed beans from Venus,\nDon't let anything get in between us. Beam in on me baby,\nand we'll beam together\nI know we always been together, but there's more. Mister Zoot Horn Rollo, hit that long lunar note,\nand let it float. Men let your wallets flop out, and women open your purses,\nCause a man or a woman without a big eyed bean from Venus\nIs suffering with the worstest of curses\nYeah, you're suffering, with the worstest of curses. Put 'em out in the sun, and when the night come\nYou don't have to go out and get 'em\nThey'll glow with you\nThey'll go with you\nThey'll show with you\nAin't no losers\nCause they're on the right track\nCause they're on the right track\nYou can be on the right track, woman,\nOf course, of course Ain't no SNAFU, no fol-de-rol Check these out, Big eyed beans from Venus\nOh, let a few out, let 'em pass in between us Distant cousins, there's a limited supply.\nAnd we're down to the dozens, and this is why... Don't let anything get in between us!\nBig eyed beans from Venus\nBig eyed beans from Venus.	\N	https://music.apple.com/us/album/big-eyed-beans-from-venus/1829049521?i=1829049539&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.499158+00	2026-05-26 20:11:35.960045+00
1f891548-c46e-4b80-91c6-b928bd9076cf	Big Eyed Beans from Venus	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1972	\N	\N	Distant cousins, there's a limited supply.\nAnd we're down to the dozens, and this is why:\nBig Eyed Beans from Venus! Oh my, oh my. Boys and girls, Earth people around the circle,\nMixtures of man alive.\nBig eyed beans from Venus,\nDon't let anything get in between us. Beam in on me baby,\nand we'll beam together\nI know we always been together, but there's more. Mister Zoot Horn Rollo, hit that long lunar note,\nand let it float. Men let your wallets flop out, and women open your purses,\nCause a man or a woman without a big eyed bean from Venus\nIs suffering with the worstest of curses\nYeah, you're suffering, with the worstest of curses. Put 'em out in the sun, and when the night come\nYou don't have to go out and get 'em\nThey'll glow with you\nThey'll go with you\nThey'll show with you\nAin't no losers\nCause they're on the right track\nCause they're on the right track\nYou can be on the right track, woman,\nOf course, of course Ain't no SNAFU, no fol-de-rol Check these out, Big eyed beans from Venus\nOh, let a few out, let 'em pass in between us Distant cousins, there's a limited supply.\nAnd we're down to the dozens, and this is why... Don't let anything get in between us!\nBig eyed beans from Venus\nBig eyed beans from Venus.	\N	https://music.apple.com/us/album/big-eyed-beans-from-venus/1829049521?i=1829049539&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.356582+00	2026-05-26 20:11:35.960217+00
02c9e510-9272-4a7a-ba2f-f3d284992c02	Blabber ‘N Smoke	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1972	\N	\N	All you ever do is blabber 'n smoke There's ah big pain in your window 'N all your waters turn t' rope It gonna hang you all Dangle you all Dang you all If you don't hurry there will be no hope Why don't you quit actin' like ah dope All you ever do is blabber 'n smoke It don't matter where you got your start Which side of your head you wear your heart Clean up the air 'N treat the animals fair I can't help but think you treat love like ah joke Time's runnin' out 'N all you ever do is blabber 'n smoke Blabber 'n smoke Blabber 'n smoke	\N	https://music.apple.com/us/album/blabber-n-smoke/1829049107?i=1829049117&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.322169+00	2026-05-26 20:11:35.960558+00
a04a04c6-9443-4b5e-b313-2a6c634f67fa	Call On Me	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1967	\N	\N	Call on me whenever you're lonely and blue In my house whenever you need me to call on you At any time baby that you need love And a little of that understanding too Feel free love to call on me love cause I'm gonna call on you I'll be there most any time of day call on me To see you baby in the same old loving way call on me If in the night you call and I'm away Leave a little note baby and I'll be there when you say call on me I'm so lonely love when you're way call on me And if I should ever call on you I want you to call on me always I hope your love will always be so true You call on me babe and I'm gonna call on you (repeat) Call on me babe call on me girl Don't you know I'm down on my knees baby baby please Call on me oven on baby......	\N	https://music.apple.com/us/album/call-on-me/290334563?i=290334566&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.166042+00	2026-05-26 20:11:35.961072+00
24712e22-99ee-4da8-87e5-29b29f74dfa6	Cardboard Cutout Sundown	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1982	\N	\N	You hardly know a day goes by\nin the cardboard cutout sundown\nthe moon popped up like a gallery duck\nsipped up gold from the sunny cup\nand longhorns sawed the buggy grass\nand a cowboy blew a harp sitting on his chapped ass\nand the prarie flowers didn?t look a bit queer\nand the stars struck the sand cartwheeled\nand poked in the prarie\na cactus juice stand the only place\nthe crows couldn?t land\nthe bluebottle flies were as big\nas a cowboy?s eyes\nand their buzz was as loud as rattlers\na fire engine red whistle blows raspberries\nin a cloud of whipped steam\na tungle weed ran out black patent yarn stinkbug hoops\nfrom above a living mail thriving dot\nin perfect sympathy\nwith the cardboard cutout sundown\nyou hardly know a day goes by\nin the cardboard cutout sundown	\N	https://music.apple.com/us/album/cardboard-cut-out-sundown/714560239?i=714560478&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.46817+00	2026-05-26 20:25:11.46309+00
6bfc1ffd-a34b-4e4b-9464-367b55366818	China Pig	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1969	\N	\N	Dialogue: Don Van Vliet: "Do one of those u-chunk, u-chunk, u-chunk, u-chunk, one of those" Man: "A real slow one" I don't wanna kill my china pig No I don't Uh man's gotta live Uh man's gotta eat Uh man's gotta have shoes t' walk out on the street I don't wanna kill my china pig Ell he was uh baby I want yuh t' see I don't wanna kill my china pig Well I used t' go t' school With uh' little red box 'n I used to have m' pig go with me We walked for blocks I don't wanna kill my china pig His tail curled five times in uh circle round It's glazed He's got uh slot in his back flowers grow My china pig be uh quite uh show I don't wanna kill my china pig Woe no My china pig I got him by the snout 'n I takes him by the cuff 'n I whipped out m' fork 'n I poked at um Three hairs laid out on m' floor I remember my china pig I fed the neighborhood It was uh big neighborhood Uh lot uh people liked my pig One little girl used t' put her fingers in his snout I put uh fork in his back I didn't wanna kill my china pig	\N	https://music.apple.com/us/album/china-pig/137665947?i=137668248&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.259583+00	2026-05-26 20:11:35.961583+00
e124717f-bb89-473c-98cd-61a51a67ecbf	Circumstances	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1972	\N	\N	Once you find out the circumstances\nThen you can uh go out, whoa yeah Once you find out the circumstances\nThen you can uh go out, whoa yeah Little girl don't you know that the stars up above are runnin' on love\nLittle girl don't you know that they're blinkin' at you\nNow the sun can sun burn you but\nNot as bad as those old people do, yeah Ah once you find out the circumstances\nThen you can uh go out, whoa yeah Little girl don't you know that the stars up above are runnin' on love\nLittle girl don't you know that uh they're blinkin' at you\nNow the sun can sun burn you but\nNot as bad as those o-o-o-old people do, yeah ha ha ha Ah once you once you find out the circumstances\nThen you then you then you then yo-u-u-u-u can go out, ah yeah You can go o-o-o-out	\N	https://music.apple.com/us/album/circumstances/1829049521?i=1829049530&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.343274+00	2026-05-26 20:11:35.961805+00
4ca9d9c0-f4e6-4c7f-914a-98cec3a13c43	Click Clack	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1972	\N	\N	Two trains Two railroad tracks One goin' 'n the other one comin' back There goes my baby on that ole train I say come back come back baby come back Click clack click clack There's my baby wain' her handkerchief down My cars stand up when I hear that sound This time it sound like it's for keeps Click clack click clack I get down on the ground With the gravel around I pray t' the Lord That the train will stop Turn right around 'N never stop till it drop my baby off Now I had this girl Threatened 'n leave me all the time Maybe you had uh girl like that I-yuh all time cryin' Well I had this girl Threatened 'n leave me all the time Threatenin' t' go down t' N'Orleans-uh 'N get herself lost 'n found Maybe you had uh girl like this She's always threatenin' t' go down t' N'Orleans 'N get herself lost 'n found C'mon I'll play it for yuh Lemme tell yuh 'bout it Lemme tell yuh 'bout it There were two railroad tracks Click clack click clack One ah them leavin'-uh 'N the other one comin' back I was two years from yuh baby You were goin' way up the tracks The train was leavin'-uh I could see yuh wavin' your handkerchief	\N	https://music.apple.com/us/album/click-clack/415006591?i=415006628&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.329462+00	2026-05-26 20:11:35.962507+00
e696c9df-3a8a-411e-959a-c1b93890032f	Crazy Little Thing	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1972	\N	\N	Crazy Little Thing has just gone crazy\nGirl, how'd ya get a name like Crazy Little Thing\nProbably the name that drove you crazy all along\nHow'd ya get a walk\nHow'd ya get it all to move so smooth and lazy\nHow'd ya learn to talk real low like that\nTo where it makes all the men go crazy\nEvery little thing, every little thing has just gone crazy\nThe way she move, there ain't no maybe\nTalkin' way low like that\nTo where all the men go crazy\nShe brings things down lower than they should be\nShe brings things up higher than they could be\nShe got the answer to the answer\nAnd my only question is how old, how cool, how low can you be?\n(won't find out from me)\nIf you're too young, girl, you know you're gonna be the ruin of me\nThey call her crazy, but I'm hot and she's cold\nCrazy Little Thing, Crazy Little Thing\nHow old, how old, how old\nHow'd ya get built like that?\nYou ain't been here that long\nCrazy Little Thing, Crazy Little Thing\nHow long, how long, how long\nCrazy Little Thing has just gone crazy\nGirl, how'd ya get a name like Crazy Little Thing\nProbably the name that drove you crazy all along\nHow'd ya get a walk\nHow'd ya get it all to move so smooth and lazy\nHow'd ya learn to talk real low like that\nTo where it drives, to where it drives the men all crazy\nCrazy Little Thing has just gone crazy\nGirl, how'd ya get a name like Crazy Little Thing\nProbably the name that drove you crazy all along	\N	https://music.apple.com/us/album/crazy-little-thing/1829049521?i=1829049535&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.35129+00	2026-05-26 20:11:35.962699+00
2a53107c-97b7-43e7-b720-c82cdac1736c	Crazy Little Thing	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2006	\N	\N	Crazy Little Thing has just gone crazy\nGirl, how'd ya get a name like Crazy Little Thing\nProbably the name that drove you crazy all along\nHow'd ya get a walk\nHow'd ya get it all to move so smooth and lazy\nHow'd ya learn to talk real low like that\nTo where it makes all the men go crazy\nEvery little thing, every little thing has just gone crazy\nThe way she move, there ain't no maybe\nTalkin' way low like that\nTo where all the men go crazy\nShe brings things down lower than they should be\nShe brings things up higher than they could be\nShe got the answer to the answer\nAnd my only question is how old, how cool, how low can you be?\n(won't find out from me)\nIf you're too young, girl, you know you're gonna be the ruin of me\nThey call her crazy, but I'm hot and she's cold\nCrazy Little Thing, Crazy Little Thing\nHow old, how old, how old\nHow'd ya get built like that?\nYou ain't been here that long\nCrazy Little Thing, Crazy Little Thing\nHow long, how long, how long\nCrazy Little Thing has just gone crazy\nGirl, how'd ya get a name like Crazy Little Thing\nProbably the name that drove you crazy all along\nHow'd ya get a walk\nHow'd ya get it all to move so smooth and lazy\nHow'd ya learn to talk real low like that\nTo where it drives, to where it drives the men all crazy\nCrazy Little Thing has just gone crazy\nGirl, how'd ya get a name like Crazy Little Thing\nProbably the name that drove you crazy all along	\N	https://music.apple.com/us/album/crazy-little-thing/1829049521?i=1829049535&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.488669+00	2026-05-26 20:11:35.962885+00
c8564903-702d-42cf-b5a4-849a62be3ceb	Dachau Blues	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1969	\N	\N	Dachau blues those poor Jews Dachau blues those poor Jews Dachau blues, Dachau blues those poor Jews Still cryin' 'bout the burnin' back in World War Two's One mad man six million lose Down in Dachau blues, down in Dachau blues The world can't forget that misery 'n the young ones now beggin' the old ones please t' stop bein' madmen 'fore they have t' tell their children 'bout the burnin's back in World War Three's War One was balls 'n powder 'n blood 'n snow War Two rained death 'n showers 'n skeletons Dancin' 'n screamin' 'n dyin' in the ovens Cough 'n smoke 'n dyin' by the dozens Down in Dachau blues Down in Dachau blues Sweet little children with doves on their shoulders Their eyes rolled back in ecstasy cryin' Please old man stop this misery They're countin' out the devil With two fingers on their hands Beggin' the Lord don't let the third one land On World War Three On World War Three Spoken: "and, it attracted a lotta rats, and, uh, they close the doors, and uh, they all got shotguns and rush out on the grass. Nothing happened, they couldn't get the rats to move, see. So, they got one fella down there, he said, er, ah, heeeeeeeeee s-stammered; when he got excited he couldn't talk at all. They got him down there and er, Walt said, "I'll get 'em outta there," and he took a stick, beating them, started hitting them, tryin' to get them outta there. Then he started shooting from all directions. And 'ole Walt thought he was gonna get killed..."	\N	https://music.apple.com/us/album/dachau-blues/137665947?i=137667229&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.243285+00	2026-05-26 20:11:35.963071+00
ca30e995-7800-47b3-9b89-e79448e1c7a7	Dirty Blue Gene	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2006	\N	\N	The shiny beast of thought\nIf you got ears\nYou gotta listen\nOld woman sweat\nYoung girls glisten\nThe extra act [?] you thought\nis the extract [?] you got\nHop in a thought\nEx-extract [?]\nD'you hear me?\nHope disa-heart drops [?]\nBlue she right/wrote [?]\nDrop by drop\nLight by bright\nNight by light\nThere ain't no good\n'n' there ain't no blame\nNot hip\nAin't no aim\nYou make the fault\nYou cause the blame\nDevil the same\nHop in a thought\nEx-extract\nShiny beast of thought\nYou hang up\nNow you' caught\nIf you got ears\nYou gotta listen\nOld woman sweat\nYoung girls glisten\nThere's more than what you thought\nHop in a thought\nThe shiny beast of thought\nStand there bubblin' like an oven coal in the sun\nBack is achin'\nWork is never done\nShe's swinging a sponge on the end of a string\nRight on the brink\nShe spills the ink down the sink\nShe's not bad\nShe's just genetically mean\nShe's not bad\nShe's just genetically mean\nDon't you wish you never met her? [x3]\nDirty Blue Gene\nShe's swinging a sponge on the end of a string\nDon't you wish you never met her? [x4]\nShe's not bad\nShe's just genetically mean\n(fuck)\nDirty Blue Gene\nDirty [x3]\nDirty Blue Gene\nShe's\nNot\nBad	\N	https://music.apple.com/us/album/dirty-blue-gene/714553431?i=714553671&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.493099+00	2026-05-26 20:11:35.963692+00
ce90f3aa-d79f-4a2d-a2ac-460f5e31b5e8	Dirty Blue Gene	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1980	\N	\N	The shiny beast of thought\nIf you got ears\nYou gotta listen\nOld woman sweat\nYoung girls glisten\nThe extra act [?] you thought\nis the extract [?] you got\nHop in a thought\nEx-extract [?]\nD'you hear me?\nHope disa-heart drops [?]\nBlue she right/wrote [?]\nDrop by drop\nLight by bright\nNight by light\nThere ain't no good\n'n' there ain't no blame\nNot hip\nAin't no aim\nYou make the fault\nYou cause the blame\nDevil the same\nHop in a thought\nEx-extract\nShiny beast of thought\nYou hang up\nNow you' caught\nIf you got ears\nYou gotta listen\nOld woman sweat\nYoung girls glisten\nThere's more than what you thought\nHop in a thought\nThe shiny beast of thought\nStand there bubblin' like an oven coal in the sun\nBack is achin'\nWork is never done\nShe's swinging a sponge on the end of a string\nRight on the brink\nShe spills the ink down the sink\nShe's not bad\nShe's just genetically mean\nShe's not bad\nShe's just genetically mean\nDon't you wish you never met her? [x3]\nDirty Blue Gene\nShe's swinging a sponge on the end of a string\nDon't you wish you never met her? [x4]\nShe's not bad\nShe's just genetically mean\n(fuck)\nDirty Blue Gene\nDirty [x3]\nDirty Blue Gene\nShe's\nNot\nBad	\N	https://music.apple.com/us/album/dirty-blue-gene/714553431?i=714553671&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.448256+00	2026-05-26 20:11:35.963498+00
4b0f6edd-10b9-490f-a646-f9249068952f	Doctor Dark	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1970	\N	\N	Mama, mama, here come Doctor Dark Horse clippin', clappin' 'n his ol' hooves makin' sparks Black leather lady Lord carried her bags The hell horn, hell horn, hell horn Horn rim crimped Glasses look out on the pale hell bent Moon milk run O' lady go home Lord they done cookin' done Black lady Black leather lady Done had a white, white, white poor son Mama, mama, here come Doctor Dark Horse clippin', clappin' 'n his ol' hooves makin' sparks Gotta git me who I want to God, Lord knows I've got to oh see that Doctor Dark Mama, mama, here come Doctor Dark Horse clippin', clappin' 'n his ol' hooves makin' sparks Shed a tear on the meadow lark 'n like Tear t' drink T' brush away 'n tear apart 'n black 'n white 'n like Tear t' drink t' brush away 'n tear apart 'n black 'n white 'n like The moon a pail of milk spilled down black in the night Little girl lost a tear 'n her kite T' the night 'n like 'n light God, Lord knows I've got to oh see that Doctor Dark	\N	https://music.apple.com/us/album/doctor-dark/415007099?i=415007123&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.298979+00	2026-05-26 20:11:35.963895+00
388aa8dd-be2e-464b-8554-d690eed634db	Doctor Dark	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2006	\N	\N	Mama, mama, here come Doctor Dark Horse clippin', clappin' 'n his ol' hooves makin' sparks Black leather lady Lord carried her bags The hell horn, hell horn, hell horn Horn rim crimped Glasses look out on the pale hell bent Moon milk run O' lady go home Lord they done cookin' done Black lady Black leather lady Done had a white, white, white poor son Mama, mama, here come Doctor Dark Horse clippin', clappin' 'n his ol' hooves makin' sparks Gotta git me who I want to God, Lord knows I've got to oh see that Doctor Dark Mama, mama, here come Doctor Dark Horse clippin', clappin' 'n his ol' hooves makin' sparks Shed a tear on the meadow lark 'n like Tear t' drink T' brush away 'n tear apart 'n black 'n white 'n like Tear t' drink t' brush away 'n tear apart 'n black 'n white 'n like The moon a pail of milk spilled down black in the night Little girl lost a tear 'n her kite T' the night 'n like 'n light God, Lord knows I've got to oh see that Doctor Dark	\N	https://music.apple.com/us/album/doctor-dark/415007099?i=415007123&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.495343+00	2026-05-26 20:11:35.964105+00
455f2a73-4a63-40ef-836f-72ef78985aa0	Dropout Boogie	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2006	\N	\N	You wanna do what (repeat) I told you what (repeat) (repeat both) Go ta school (repeat) just cain't (repeat) dropout (repeat) Ya getta job (repeat) Dunno whattit (repeat) What it's all about (repeat) you told her ya love her so figured her mother ya love her adapt her (repeat) adapt her adapter (repeat) Support her (repeat) she says she's no boarder getta job (repeat) ya gotta support her ya told her you loved her so figured her mother ya love her adapt her (repeat) adapt her adapter (repeat) 'n;' what about after that (repeat)	\N	https://music.apple.com/us/album/dropout-boogie/290334563?i=290334567&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.497599+00	2026-05-26 20:11:35.964315+00
e62eedca-8668-4df5-8716-e599d629f3db	Electricity	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1967	\N	\N	Singin through you to me; thunderbolts caught easily Shouts the truth peacefully Eeeeeee-lec-tri-ci-teeeeeeee High voltage man kisses night to bring the light to those who need to hide their shadow deed Go into bright find the light and know that friends don't mind just how you grow midnight cowboy stains in black reads dark roads without a map To free-seeking electricity (repeat) (Repeat both lines) Lighthouse beacon straight ahead straight ahead across black seas to bring Seeking eeee-lec-tri-ci-teeeee High voltage man kisses night to bring the light to those who need to hide their shadow-deed hide their shadow-deed (repeat) Seek electricity...........	\N	https://music.apple.com/us/album/electricity/290334563?i=290334570&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.177483+00	2026-05-26 20:11:35.965068+00
afba7949-efb0-4d86-ae30-687f1b789e65	Ella Guru	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1969	\N	\N	Now here she comes walkin' Lookin' like uh zoo Hello Moon Hello Moon Hi Ella high Ella Guru She know all the colors that nature do High Ella high Ella Guru High yella high red high blue she blew High Ella high Ella Guru She do what she mean 'n she do what she do Got sumptin' fo' me sumptin' fo' you She sho' sumptin' She's young too Ella Guru Ella Guru Ella Guru Ella Guru Ha ha right right Just dig it That's right "The Mascara Snake" Fast 'n bulbous Tight also Ella Guru Ella Guru Ella Guru Ella Guru Ella Guru	\N	https://music.apple.com/us/album/ella-guru/1059242591?i=1059242596&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.246177+00	2026-05-26 20:11:35.965286+00
cf2b7173-1bc8-4b37-b4d7-a29f35e9e10a	Fallin’ Ditch	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1969	\N	\N	Dialogue: Don Van Vliet: "Now we won't have to worry about Rockette Morton with any of those girls." Rockette Morton: "Rockette Morton takes off again into the wind." DVV: "Whaddaya run on, Rockette Morton?" DVV: "Say beans" RM: "I run on beans . . . I run on laser beans." When I get lonesome the wind begin t' moan When I trip fallin' ditch Somebody wanna' throw the dirt right down When I feel like dyin' the sun come out 'n stole m' fear 'n gone Who's afraid of the spirit with the bluesferbones Who's afraid of the fallin' ditch Fallin' ditch ain't gonna get my bones How's that for the spirit How's that for the things Ain't my fault the thing's gone wrong 'n when I'm smilin' my face wrinkles up real warm 'n when um frownin' things just turn t' stone Fallin' ditch ain't gonna get my bones 'n when I get lonesome the wind begin t' moan Fallin' ditch ain't gonna get my bones	\N	https://music.apple.com/us/album/fallin-ditch/464978430?i=464978440&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.273254+00	2026-05-26 20:11:35.965681+00
af20e028-e923-46cd-8885-23e58c84c39d	Frying Pan	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1984	\N	\N	Don't think big man I can't think little Won't let that end catch me up in the middle My whole life's been the toss of a dice Done another girl gone out of my life Out of the frying pan into the fire Anything you say they 's gonna call you lair Go downtown I walk around The man comes up says he's gonna put me down You try to succeed to fulfil your need You get hit by a car the people watch you bleed Out of the frying pan into the fire Anything you say they's gonna call you liar Watch what you do now Think what you sayin' If you get crossed up you gonna end up paying Ain't no loose I'm gonna cut it all loose I made a mistake I can't get no break Out of the frying pan into the fire Anything you say they's gonna call you liar	\N	https://music.apple.com/us/album/frying-pan/1477554850?i=1477555106&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.149212+00	2026-05-26 20:11:35.96692+00
cf4419b4-b5e7-400f-bfb9-50f0fcdf446a	Golden Birdies	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2002	\N	\N	Those little golden birdies look at them And the mystic Egypt tossle dangling down Old sleeper-man shish, don't wake him Up one hand broom star was an obi-man revered throughout the bone-knob land His magic black purse slit creeped open, Let go flocks of them Shish sookie singabus Snored like a red merry-go-round horse And an acid gold bar swirled up and down, Up and down, in back of the singabus And the panataloon duck white goose neck quacked webcore, webcore	\N	https://music.apple.com/us/album/golden-birdies/1829049521?i=1829049540&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.508052+00	2026-05-26 20:11:35.967432+00
f20f5432-ee59-40cb-a59f-4815184ec559	Grow Fins	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1972	\N	\N	Now here ya come baby With yer tail draggin' the gravy Y' know yer P's 'n Q's What ya don't know baby Is you givin' me the blues Ya got juice on your chin Eggs on the drain-board Pie on the wall Dirt on the rug I come home late 'N I stumbled 'n swore Ya won't even give me a hug Ya had my things all laid out by the door I'm leavin' I'm gonna take up with ah mermaid 'N leave you land lubbin' women alone 'N leave you land-lubbin' women alone Ya said ya had it together once Now yer head's around the bend I'm tellin' ya woman Ya better get it bach together again I'm gonna grow fins 'N go back in the water again If ya don't leave me alone I'm gonna take up with ah mermaid 'N leave you land-lubbin' women alone 'N leave you land-lubbin' women alone Now here ya come baby With yer tail draggin' the gravy Ya know yer P's 'n Q's What ya don't know woman Is yer givin' me the blues	\N	https://music.apple.com/us/album/grow-fins/415006591?i=415006647&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.331299+00	2026-05-26 20:11:35.968084+00
6140d2b5-ed0f-45ad-ab12-9cb5df6677c4	Grow Fins	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2003	\N	\N	Now here ya come baby With yer tail draggin' the gravy Y' know yer P's 'n Q's What ya don't know baby Is you givin' me the blues Ya got juice on your chin Eggs on the drain-board Pie on the wall Dirt on the rug I come home late 'N I stumbled 'n swore Ya won't even give me a hug Ya had my things all laid out by the door I'm leavin' I'm gonna take up with ah mermaid 'N leave you land lubbin' women alone 'N leave you land-lubbin' women alone Ya said ya had it together once Now yer head's around the bend I'm tellin' ya woman Ya better get it bach together again I'm gonna grow fins 'N go back in the water again If ya don't leave me alone I'm gonna take up with ah mermaid 'N leave you land-lubbin' women alone 'N leave you land-lubbin' women alone Now here ya come baby With yer tail draggin' the gravy Ya know yer P's 'n Q's What ya don't know woman Is yer givin' me the blues	\N	https://music.apple.com/us/album/grow-fins/415006591?i=415006647&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.502696+00	2026-05-26 20:11:35.967922+00
ccf8d742-c9ab-4b93-bf18-03e04a9ecd3c	Grown So Ugly	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1967	\N	\N	I got up this morning And I put on my shoes I tied my shoes Then I washed my face I went to the mirror For to comb my head I made a move Didn't know what to do I tipped way forward Got to break and run Baby, this ain't me Baby, this ain't me Got so ugly I don't even know myself I left Angola 1964 Go walking down my street Knock on my baby's door My baby come out She asks me who I am And I say, honey, Don't you know your man? She said my man's been gone Since 1942 And I'll tell you Mr. Ugly, He didn't look like you [Repeat chorus]	\N	https://music.apple.com/us/album/grown-so-ugly/290334563?i=290334575&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.198508+00	2026-05-26 20:11:35.968247+00
557ea8f6-9f56-4be3-8897-d38b366e5464	Harry Irene	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	2012	\N	\N	Harry Irene were a couple that lived in the green Harry Irene were a couple that ran a canteen Ran a canteen Ran a canteen Two people Harry and Irene like you never seen The floor was made of oak, the door was smokey gray Their tuna sandwiches would turn the dark into day Harry Irene were a couple that ran a canteen Harry Irene were a couple that lived in the green Ran a canteen Ran a canteen took Harry for all of his green and Irene Harry was left holding an empty canteen What does this mean? What does this mean? What's the meaning of this? Poor Harry, I guiss	\N	https://music.apple.com/us/album/harry-irene/370925126?i=370925146&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.405536+00	2026-05-26 20:11:35.969103+00
bf53173c-a420-45e3-be70-3d03e23b4551	Her Eyes Are A Blue Million Miles	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1972	\N	\N	I look at her and she looks at me In her eyes I see the sea I can't see what she sees in a man like me She says she loves me Her eyes Her eyes Her eyes are a blue million miles Far as I can see She loves me Her eyes Her eyes Her eyes are a blue million miles Far as I can see She loves me I look at her and she looks at me In her eyes I see the sea I can't see what she sees in a man like me She says she loves me Her eyes Her eyes Her eyes are a blue million miles	\N	https://music.apple.com/us/album/her-eyes-are-a-blue-million-miles/1829049521?i=1829049538&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.35475+00	2026-05-26 20:11:35.96946+00
9edd194b-da00-4687-9018-b5e8470ffa69	Here I Am I Always Am	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1984	\N	\N	Well you came and now you're gone But our life it will go on I moss you so but only for your return Please come back to me tomorrow To ease this pain and sorrow please try to understand My heart is in your hand baby please don't take our love in vain (repeat) Well here I am I always am And with you my love it will remain please try to understand Yeah my heart is in your hand Please don't take my love in vain Well my nights are filled with sorrow For me there is no tomorrow I'd beg or I'd steal or I'd borrow Will you send this sorrow? baby please don't take our love in vain (repeat) Well here I am I always am And with you my love it will remain please try to understand yeah my heart is in your hand please don't take my love in vain	\N	https://music.apple.com/us/album/here-i-am-i-always-am/1477554850?i=1477555107&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.149903+00	2026-05-26 20:11:35.969992+00
966b1f44-b1b9-478a-a185-6375c9ed0808	Long Neck Bottles	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1972	\N	\N	Woman like long neck bottles And a big head on her beer I don't like to talk about my women But I hold that woman dear Well, one night she go to drinking Got out and shot up the town I'll be damned if she didn't Bring an airplane down I don't like to talk about my woman But this one sure could chug 'em down I don't like to talk about my woman But this one sure could chug 'em down One night she started drinking Down by the river She tied up the river And backed the ocean down I don't like to talk about none of my women But this one sure could hold her long neck bottle beer down When she walked into a bar They set 'em and got right out of town 'Cuz she picked 'em up a'plenty And laid a lot of them down Women like long neck bottles And a big head on their beer Now you got that down You got that down Well, one night she go to drinking Got out and shot up the town I'll be damned if she didn't Bring an airplane down I don't like to talk about my woman But this one sure could chug 'em down I don't like to talk about my woman But this one sure could chug 'em down I don't like to talk about none of my women But I'm going to do it anyway Then I'm going to get Right out of town	\N	https://music.apple.com/us/album/long-neck-bottles/1829049521?i=1829049537&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.353057+00	2026-05-26 20:11:35.973596+00
a93622d5-019a-4924-b458-b34353ce5dce	Love Lies	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1978	\N	\N	Stopped by your house, saw your lamp lit\nNot a sign of you in it\nWhere could you go at this hour?\nHas all our love lost its power?\nI said I?d be here with a flower\nStreetlamps flutter like fireflies\nI wish I hadn?t a told you all of those love lies\nWhere could you go at this hour?\nHas all our love lost its power?\nI miss you more hour by hour\nThe roses seem to smell sour\nStreetlamps flutter like fireflies\nI wished I hadn?t a told you all of those love lies\nStopped by your house, saw your lamp lit\nNot a sign of you in it\nFlutterlamps flutter like fireflies\nI wish I hadn?t a told you all of those love lies\nOh, all of those love lies	\N	https://music.apple.com/us/album/love-lies/370925126?i=370925170&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.429554+00	2026-05-26 20:11:35.97378+00
cd70f106-7de8-4c45-a890-80b2032518a4	My Head Is My Only House Unless It Rains	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1972	\N	\N	I'll let a train be my feet If it's too far to walk to you\nIf a train don't go there I'll get a jet or a bus\nBecause I'm going to find you\nYou're going to see me shadow soon around you\nAnd my head is my only house unless it rains\nI walk the meadow plains\nWater deserts are my eyes until I find you\nI won't sleep until I find you\nI won't eat until I find you\nMy heart won't beat until I wrap my arms around you\nMy arms are just two things in the way\nUntil I can wrap them around you\nYou can make my sad song happy\nMake a bad world good\nI can feel you out there moving\nYou're mine, I know I'll find you\nAnd my head is my only house until I've found you\nI hate to have other people hear me sing this song\nIf this reaches you before I do\nFollow it to "I love you"\nThat's where I'll find you\nAnd my head is my only house until I find you	\N	https://music.apple.com/us/album/my-head-is-my-only-house-unless-it-rains/1829049521?i=1829049532&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.345584+00	2026-05-26 20:11:35.975409+00
d3340079-0e73-403c-8218-f01cf279a17a	Low Yo Yo Stuff	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1972	\N	\N	Fast goes fast Slow goes slow Alright now, do the Low Yo Yo Yo Yo Now do the Low Yo Yo Yo Yo Yo Yo Like that girl standing on the corner Trying to get a ride to the other side When way down underneath All she had to do was move her pretty feet And do the Low Yo Yo Yo Yo Alright baby, do your Low Yo Yo with all your stuff Now, baby, do your Low Yo Yo Stuff Now, baby, it's in your being Whether you're long, tall, short or skinny Sometimes it's rough You mean to tell me it's that Low Yo Yo Stuff? Low Yo Yo Yo Yo Yo Yo Yo Yo Fast goes fast Slow oes slow Low Yo Yo Yo Yo Like that girl standing on the corner Trying to get a ride to the other side When way down underneath All she had to do was move her pretty feet And do the Low Yo Yo Yo Yo What if my girlfriend back home Finds out what my fingers have been doing On my guitar since I been gone? Don't anybody tell her, I been doing the Low Yo Yo Yo Yo Like any other fella Away from home, all alone Been doing that Low Yo Yo Yo Yo Ya, I been really carrying on! Fast goes fast Slow goes slow Rich are rich and the po' are po' Everybody's doing the Low Yo Yo Yo Yo Everybody's doing it Deep down everybody knows they should Do the Low Yo Yo Yo Yo	\N	https://music.apple.com/us/album/low-yo-yo-stuff/1829049521?i=1829049526&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.337583+00	2026-05-26 20:11:35.974012+00
10ca92eb-4bc5-4591-8060-562bebcc6616	Making Love to a Vampire with a Monkey on my Knee	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1980	\N	\N	Making love to a vampire with a monkey on my knee The pond shined dry like a ladies compact Lilies leaped like flat green hearts with white hearts Squirting yellow pollen...cocks... Ferns ran like cool spades.. fossils. ..away from rocks Bees echoed dark carbon hums that dashed in nothing Gnats fucked my ears 'n nostrils Hit my brain like hones 'n numbed t' nothing Wings stuck on liquid bones Making love to a vampire with a monkey on my knee The moon poured hollow down my milky leg Splashed still ?n moved The wind peed down the willows 'n pricked the needle vine The monkey moved a fur shadow... its soot tail curled in twos Its lips smiled needles.. its eyes rolled loose Her throat broke open... glistened in the dew Red berries dangled like a dream of rubies too Snot muscles ran down her ivory chin 'n tooth within A locket... a pin held fast to then, my love, my pocket deep within 'N senses dangled the chain that clasped me to her then The messenger spoke the wind that blows between our time I sensed you then 'n whispers spin 'n flow in silver dust Around the pointed pin Sent to nothing God, please fuck my mind for good Making love to a vampire with a monkey on my knee Oh fuck that thing.. .fuck that poem...eyes crawl out with maggots White cloth bones pile up light thrown blades Rags ?n skull.. scoops soil cracks.. .drain screams.. please Take my hand 'n join me... too soon its clutches gleams Making love to a vampire with a monkey on my knee Death be damned... life	\N	https://music.apple.com/us/album/making-love-to-a-vampire-with-a-monkey-on-my-knee/714553431?i=714553719&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.456786+00	2026-05-26 20:11:35.974314+00
db8d7479-5b7d-4da2-9230-0fd3808636ec	Mirror Man	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2006	\N	\N	Mirror man mirror me\nMirror than mirror me\nMirror man mirror than\nMirror land farther than\nMirror day mirror way\nMirror man mirror way\nMirror man mirror me\nMirror man mirror me\nMirror me..(inaudible)...\nMirror dawn dawnin' on me\nCrack o dawn mirror dawn\nMirror man mirror gone\nMirror fall down mirror gone down\nMirror girl mirror boy\nMirror frog mirror man\nMirror worm mirror worm\nMirror bird mirror germ\ngerm..(inaudible)...\nLittle girl little girl\nLittle girl little girl\nMirror man mirror me\nMirror man mirror me\nMirror man mirroe me\nMirror man further than\nMirror day mirror way\nMirror man mirror me\nMirror dawn dawnin' on me\nDawnin' on me dawnin' on me\nDawnin' on me dawnin' dawnin'\ndrum dromb..(inaudible)...\nLead me to your mirror now\nLead me to your mirror then\nLead me to your mirror now\nLead me to your mirror then\nMirror man mirror man\nMirror man mirror man\nMirror you mirror me\nMirror you you're ya go ga..(inaudible)...\nMirror man uh huh	\N	https://music.apple.com/us/album/mirror-man/284001765?i=284001778&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.486949+00	2026-05-26 20:11:35.974953+00
29228018-46e7-4ca2-9e23-4f31f7f96008	Mirror Man	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1971	\N	\N	Mirror man mirror me\nMirror than mirror me\nMirror man mirror than\nMirror land farther than\nMirror day mirror way\nMirror man mirror way\nMirror man mirror me\nMirror man mirror me\nMirror me..(inaudible)...\nMirror dawn dawnin' on me\nCrack o dawn mirror dawn\nMirror man mirror gone\nMirror fall down mirror gone down\nMirror girl mirror boy\nMirror frog mirror man\nMirror worm mirror worm\nMirror bird mirror germ\ngerm..(inaudible)...\nLittle girl little girl\nLittle girl little girl\nMirror man mirror me\nMirror man mirror me\nMirror man mirroe me\nMirror man further than\nMirror day mirror way\nMirror man mirror me\nMirror dawn dawnin' on me\nDawnin' on me dawnin' on me\nDawnin' on me dawnin' dawnin'\ndrum dromb..(inaudible)...\nLead me to your mirror now\nLead me to your mirror then\nLead me to your mirror now\nLead me to your mirror then\nMirror man mirror man\nMirror man mirror man\nMirror you mirror me\nMirror you you're ya go ga..(inaudible)...\nMirror man uh huh	\N	https://music.apple.com/us/album/mirror-man/284001765?i=284001778&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.216099+00	2026-05-26 20:11:35.974734+00
95084f73-6b60-40b8-8c4d-e01f62eda5b3	Moonchild	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1984	\N	\N	moonchild On the night she born the lightning flashed and the thunder roar But when they heard her cry -the clouds rolled back and the full moon fill the sky Shinin' down in her eye Can you hear her cry Moon child She always look so pale The things she wear and the long white veil She wrapped it up so tight -your mind come loose and you drift on out of sight She's a child of the night Can you hear her cry Moon child ....too high (she always tries to hide?) The way she feel s on the darker side She like to fall in love every time there's a full moon up above Then she's out of this world She's another girl And it makes her cry I love to hear her cry Moon Child (Note: credited to David Gates: an amazing tailoring job)	\N	https://music.apple.com/us/album/moonchild/1477554850?i=1477554863&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.148056+00	2026-05-26 20:11:35.975134+00
45f0b486-6191-48ee-bd24-92f2b0fe8b64	Moonlight on Vermont	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1969	\N	\N	Moonlight on Vermont affected everybody Even Mrs. Wooten well as little Nitty Even lifebuoy floatin' With his lil' pistol showin' 'n his lil' pistol totin' Well that goes t' show you what uh moon can do No more bridge from Tuesday t' Friday Everybody's gone high society Hope lost his head 'n got off on alligators Somebodies leavin' peanuts on the curbins For uh white elephant escaped from the zoo with love Goes t' show you what uh moon can do Moonlight on Vermont Well it did it for Lifebuoy And it did it t' you And it did it t' zoo And it can do it for me And it can do it for you Moonlight on Vermont Gimme dat ole time religion Gimme dat ole time religion Don't gimme no affliction Dat ole time religion is good enough for me Uh it's good enough for you Well come out t' show dem Come out t' show dem Come out t' show dem Come out t' show dem Come out t' show dem Come out t' show dem Come out t' show dem Gimme dat ole time religion Gimme dat ole time religion Gimme dat ole time religion It's good enough for me Without yer new affliction Don't need yer new restrictions Gimme dat ole time religion It's good enough for me Moonlight on Vermont	\N	https://music.apple.com/us/album/moonlight-on-vermont-live/415588757?i=415588891&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.250339+00	2026-05-26 20:25:54.949587+00
c6de96b3-8498-41c8-9f3c-9e04a1e4eab1	My Human Gets Me Blues	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2006	\N	\N	I saw yuh baby dancin' in your x-ray gingham dress I knew you were under duress I knew you were under yer dress Just keep comin' Jesus Your the best dressed You look dandy in the sky but you don't scare me Cause I got you here in my eye In this lifetime you got m'humangetsmeblues With yer jaw hangin' slack n' yer hair's curlin' Like an ole navy fork stickin' in the sunset The way you were dancin' I knew you'd never come back You were strainin' t' keep yer Old black cracked patent shoes In this lifetime you got m'humangetsmeblues Well the way you'd been ole lady I could see the fear in yer windows Under yer furry crawlin' brow Uh silver bow rings up in inches You were afraid you'd be the devils red wife But it's alright God dug yer dance 'n would have you young 'n in his harum Dress you the way he wants cause he never had uh doll Cause everybody made him uh boy 'n God didn't think t' ask his preference You can bring yer dress 'n yer favorite dog 'n yer husbands cane 'n yer old spotted dog Cause in this lifetime You've got m'humangetsmeblues	\N	https://music.apple.com/us/album/my-human-gets-me-blues-manchester-1980/1059240857?i=1059240873&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.496316+00	2026-05-26 20:25:11.466943+00
60febd73-2ff4-487d-865b-ca3901fd625b	My Human Gets Me Blues	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1969	\N	\N	I saw yuh baby dancin' in your x-ray gingham dress I knew you were under duress I knew you were under yer dress Just keep comin' Jesus Your the best dressed You look dandy in the sky but you don't scare me Cause I got you here in my eye In this lifetime you got m'humangetsmeblues With yer jaw hangin' slack n' yer hair's curlin' Like an ole navy fork stickin' in the sunset The way you were dancin' I knew you'd never come back You were strainin' t' keep yer Old black cracked patent shoes In this lifetime you got m'humangetsmeblues Well the way you'd been ole lady I could see the fear in yer windows Under yer furry crawlin' brow Uh silver bow rings up in inches You were afraid you'd be the devils red wife But it's alright God dug yer dance 'n would have you young 'n in his harum Dress you the way he wants cause he never had uh doll Cause everybody made him uh boy 'n God didn't think t' ask his preference You can bring yer dress 'n yer favorite dog 'n yer husbands cane 'n yer old spotted dog Cause in this lifetime You've got m'humangetsmeblues	\N	https://music.apple.com/us/album/my-human-gets-me-blues-manchester-1980/1059240857?i=1059240873&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.261617+00	2026-05-26 20:25:11.466706+00
9dc7a707-d71d-41c0-8541-5361907828fa	New Electric Ride	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1974	\N	\N	Here we go again, baby On the New Electric Ride Twisting and turning Over on our side Here we go around the curve Ya, we really going to swerve Oh, I could barely hold my pride I could barely hold my pride Rappin' so hard I'm holding my side With you right by my side With my baby right by my side When the machine-guitar stars to playing We're watching the shooting stars We're under love's blue sky On the New Electric Ride Think of all the love we've been missing Then we start to kissing and kissing I could barely hold my pride With my baby right by my side Loop-de-loop, Ride and glide Swoop-de-swoop, On the New Electric Ride With my baby right by my side I can barely hold my pride >From coast to coast She loves me the most Twisting and turning, side by side My baby loves to hide On the New Electric Ride Up and down, around and round She loves me the most On the New Electric Ride Up and down, around and round She loves to hide On the New Electric Ride . . .	\N	\N	\N	\N	\N	{}	2026-05-26 18:39:42.365998+00	2026-05-26 18:39:42.365998+00
65db0285-f781-4dc3-90b0-9d59d557c517	Old Fart at Play	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1969	\N	\N	Pappy with the Khaki sweatband Bowed goat potbellied barnyard that only he noticed The old fart was smart The old gold cloth madonna Dancin' t' the fiddle 'n saw He ran down behind the knoll 'n slipped on his wooden fishhead The mouth worked 'n snapped all the bees Back t' the bungalow Momma was flatten'n lard With her red enamel rollin' pin When the fishhead broke the window Rubber eye erect 'n precisely detailed Airholes from which breath should come Is now closely fit With the chatter of the old fart inside An assortment of observations took place Momma licked 'er lips like uh cat Pecked the ground like uh rooster Pivoted like uh duck Her stockings down caught dust 'n doughballs She cracked 'er mouth glaze caught one eyelash Rubbed 'er hands on 'er gorgeous gingham Her hand grasped sticky metal intricate latchwork Open t' the room uh smell cold mixed with bologna Rubber bands crumpled wax paper bonnets Fat goose legs 'n special jellies Ignited by the warmth of the room The old fart smelled this thru his important breather holes Cleverly he dialed from within from the outside we observed That the nose of the wooden mask Where the holes had just been uh moment ago Was now smooth amazingly blended camouflaged in With the very intricate rainbow trout replica The old fart inside was now breathin' freely From his perfume bottle atomizer air bulb invention Dialogue: Don Van Vliet: "His excited eyes from within the dark interior glazed; watered in appreciation of his thoughtful preparation" Man: "Oh man, that's so heavy"	\N	https://music.apple.com/us/album/old-fart-at-play/137665947?i=137667281&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.292137+00	2026-05-26 20:11:35.97664+00
85f767a3-9ca9-4436-9da1-a0e1c3ff8e9d	On Tomorrow	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1968	\N	\N	We're all brothers of tomorrow (we won't have to talk) we won't need to talk We won't need to walk on tomorrow Rush comes the love shapes to share shapes Love love love on tomorrow baby spring son yellow wings red skies showing on Lively ivy growing on tomorrow Wish your way around hair stingin' to the ground Silver streams all our dreams cleansed free of sorrow Love love love love love love Lush skies above shapes to share shapes Peace escapes to play away today tomorrow Mothers graze on grasslands Grazin' woman stands on today's shiftin sands grazin woman stands and baby springs on golden wings flies free of sorrow (flies free of sorrow) on tomorrow woman grazin on grasslands.....on which it stands we're all brothers on tomorrow yeah we're......................	\N	https://music.apple.com/us/album/on-tomorrow-instrumental/290334563?i=290334582&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.22748+00	2026-05-26 20:25:11.46734+00
eec6c1c2-0d42-4e01-9e9e-f9b9e93ab9e7	Sue Egypt	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1980	\N	\N	Chills quick you\nVoices pick you\nCrows hex you\n[You love some?] post-'em avion\nWizard Kiss and all be gone\nScenes\nDreams\nBoats to forever\nBoated ether\nCreep to ether feather\nSue Egypt\nSue Egypt\nBoing pong\nhocus pocus avion\nI think of all those people that ride on my bones\nI think of all of those people that ride on my bones\nThat nobody hears\nThat nobody sees that nobody knows\nSue Egypt\nSue Egypt\nI think of all\nI think of all\nI think of all those people who ride on my bones\nThat nobody sees, that nobody dares\nThat nobody hears, that nobody cares\nI think of the dust that collects on the chairs\nand under her eyes\nand through her eyes\nand out her body\nand in her body\nand in her ha[ir/fa]ce\nBig smoke fingers wave\nCome here Come hear\n"Bring me my scissors"\nand those are waters [?]\nThe moon was a\nwisdomatic\npristocratic\nvagabond\nBad vuggum\na pitcher of red-hot juice\na picture of red garnet juice\nChills quick you\nVoices pick you\nCrows hex you\n[Elects-some postem?] avion\nWizard Kiss and All Be Gone\nScenes\nDreams\nBoats to forever\nBoated ether\nCreep the ether feather\nSue Egypt\nSue Egypt	\N	https://music.apple.com/us/album/sue-egypt/714553431?i=714553641&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.443463+00	2026-05-26 20:11:35.98056+00
5977d702-9493-4821-8a72-6856e074f2c5	Orange Claw Hammer	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1969	\N	\N	Uh thick cloud caught uh piper clubs tail The match struck blue on uh railroad rail The old puff horse was just pullin' thru 'n uh man wore uh peg leg forever I'm on the bum where the hoboes run The air breaks with filthy chatter Oh I don't care there's no place there I don't think it matters My skin's blazin' thru 'n my clothes in tatters 'n the railroad looked Like uh "Y" up the hill of ladders Ohe shoe fell on the gravel One stick poked down Gray of age fell down on uh pair of ears An eagle shined thru my hole watch pocket Uh gingham girl baby girl Passed me by in tears Uh jack rabbit raised his folded ears Uh beautiful sagebrush jack rabbit 'n an oriole sang like an orange His breast full uh worms 'n his tail clawed the evenin' like uh hammer His wings took t' air like uh bomber 'n my rain can caught me uh cup uh water When I got into town Odd jobs mam ah yer horse I'll fodder I'm the round house man I once was yer father Uh little up the road uh wooden Candy stripe barber pole 'n above it read uh sign "painless parker" Lic-licorice twisted around under uh fly 'n uh youngster cocked 'er eye God before me if I'm not crazy Is my daughter Come little one with yer little dimpled fingers Gimme one 'n I'll buy you uh cherry phosphate Take you down t' the foamin' brine 'n water 'n show you the wooden tits On the Goddess with the pole out s'full sail That tempted away yer peg legged father I was shanghied by uh high hat beaver moustache man 'n his pirate friend I woke up in vomit 'n beer in uh banana bin 'n uh soft lass with brown skin Bore me seven babies with snappin' black eyes 'n beautiful ebony skin 'n here it is I'm with you my daughter Thirty years away can make uh seaman's eyes Uh round house man's eyes flow out water Salt water	\N	https://music.apple.com/us/album/orange-claw-hammer-live/1057777742?i=1057777748&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.280415+00	2026-05-26 20:25:54.950569+00
f51d2e00-f60b-456f-8718-d8c9435a0ac7	Orange Claw Hammer	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2002	\N	\N	Uh thick cloud caught uh piper clubs tail The match struck blue on uh railroad rail The old puff horse was just pullin' thru 'n uh man wore uh peg leg forever I'm on the bum where the hoboes run The air breaks with filthy chatter Oh I don't care there's no place there I don't think it matters My skin's blazin' thru 'n my clothes in tatters 'n the railroad looked Like uh "Y" up the hill of ladders Ohe shoe fell on the gravel One stick poked down Gray of age fell down on uh pair of ears An eagle shined thru my hole watch pocket Uh gingham girl baby girl Passed me by in tears Uh jack rabbit raised his folded ears Uh beautiful sagebrush jack rabbit 'n an oriole sang like an orange His breast full uh worms 'n his tail clawed the evenin' like uh hammer His wings took t' air like uh bomber 'n my rain can caught me uh cup uh water When I got into town Odd jobs mam ah yer horse I'll fodder I'm the round house man I once was yer father Uh little up the road uh wooden Candy stripe barber pole 'n above it read uh sign "painless parker" Lic-licorice twisted around under uh fly 'n uh youngster cocked 'er eye God before me if I'm not crazy Is my daughter Come little one with yer little dimpled fingers Gimme one 'n I'll buy you uh cherry phosphate Take you down t' the foamin' brine 'n water 'n show you the wooden tits On the Goddess with the pole out s'full sail That tempted away yer peg legged father I was shanghied by uh high hat beaver moustache man 'n his pirate friend I woke up in vomit 'n beer in uh banana bin 'n uh soft lass with brown skin Bore me seven babies with snappin' black eyes 'n beautiful ebony skin 'n here it is I'm with you my daughter Thirty years away can make uh seaman's eyes Uh round house man's eyes flow out water Salt water	\N	https://music.apple.com/us/album/orange-claw-hammer-live/1057777742?i=1057777748&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.509312+00	2026-05-26 20:25:11.467529+00
31a22da7-3bb0-4e9c-a072-a6efafdff6f9	Owed T’Alex	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	2012	\N	\N	Stupid heart, cupid heart\nWhere will you go from here?\nMagnetic ring, magnetic draw\nOoh, what you got me into?\nI?m a wolf, chrome craw\nLeavin? you now\n- I?ll write ya, ma\nTakin? a putt up to Carson City\nWell, if you hear me howlin?\nWehell, sittin? pretty\nTasted nitty gritty\nPuttin? on into Carson City\nSparks, tattoos, two tats and a toot\nHelmets, crosses, and a patch to boot\nEngine hot, pipes burn white\nGlad I?m not home tonight\nFive miles back I took a spill\n- Thought I almost paid my bill\nMakin? my putt to Carson City\nParty time with the Jones-by-name\nAh, it?s a shame\nSay, it?s a pity\nGotta put outta Carson City\nHa ha ha ha ha\nHa ha ha ha ha ha	\N	https://music.apple.com/us/album/owed-talex/1059241448?i=1059242089&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.408534+00	2026-05-26 20:11:35.977784+00
37bd0dc6-9408-43c1-9613-29378a88c7f7	Pachuco Cadaver	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1969	\N	\N	Spoken: "A squid eating dough in a polyethylene bag is fast and bulbous. Got me?" When she wears her bolero then she begin t' dance All the pachucos start withold'n hands When she drives her Chevy Sissy's don't dare t' glance Yellow jackets 'n red debbles buzzin' round 'er hair hive ho She wears her past like uh present Take her fancy in the past Her sedan skims along the floorboard Her two pipes hummin' carbon cum Got her wheel out of uh B-29 Bomber brodey knob amber Spanish fringe 'n talcum tazzles FOREVER AMBER She looks like an old squaw indian she's 99 she won't go down Avocado green 'n alfalfa yellow adorn her t' the ground Tatooes 'n tarnished utenzles uh snow white bag full o' tunes Drives uh cartune around drives uh cartune around Broma' seltzet blue umbrella keeps her up off the ground Round red sombreros wrap 'er high tap horsey shoes When she unfolds her umbrella pachucos got the blues Her lovin' makes me so happy If I smiled I'd crack m' chin Her eyes are so peaceful thinks it's heaven she been Her skin is as smooth as the daisies In the center where the sun shines in Smiles as sweet as honey Her teeth as clean as the combs where the bees go in When she walks flowers surround her Let their nectar come in to the air around her She loves her love sticks out like straws Her lovin' sticks out like straws	\N	https://music.apple.com/us/album/pachuco-cadaver/137665947?i=137667310&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.252284+00	2026-05-26 20:11:35.977944+00
e414815c-1859-4fe4-bb5d-4d1c7a89fed5	Sugar ‘N Spikes	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1969	\N	\N	'n sugar 'n spikes 'n neon lights\n'n walks 'n lights 'n chains coughin' smoke whoopin' hope\nCardinal sky rush by falls bark in dark\nFall back in dark\nPies steam stale shoes move broom 'n pale\nMoon in uh dime store sale\nSugar 'n spikes 'n everything nice 'n everything nice 'n crazy\nThat's what little worlds are made of lady\nI'm paid up in home in 'm new Friday's house\nThere's no H on my faucet there's no bed for m' mouse\nMy punch 'n grow mind in diamond back time\nNow it's king for uh day with my lady look fine\nGot m' peakin' up hat 'n my caramel mask\nTremelo car got m' speidel wrist round m' honey\nGoin' t' see the navy blue vicar\nPaul Peter 'n misses wray flicker Interestingly, I received email from a Peter Wray, who might just be the fellow mentioned above in the song. Here's a chunk of his email. "My only claim to fame was being mentioned in one of his songs (Sugar n Spikes). How I got in the lyrics I don't know except that I met Beefheart on tour in Columbus Ohio in 1968 or 69." "I remember that one of my friends in college got one of the first issues of TMR - when warners included the lyric sheet - and came running into my room yelling and insisting that I somehow had done something directly to get in the song. I couldn't convince him otherwise."	\N	https://music.apple.com/us/album/sugar-n-spikes/137665947?i=137667343&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.275327+00	2026-05-26 20:11:35.980735+00
e0f00358-61dd-42b9-ac58-f26bd7dda8d8	Pena	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1969	\N	\N	Dialogue:\nDon Van Vliet: (laughter)\ntaped DVV: "Fast and bulbous"\nThe Mascara Snake: "Fast and bulbous" DVV: "That's er . . . " (more laughter) Frank Zappa: "Okay, do it again, then you've won."\nDVV: "I love it, it's one of those words."\nMS: "Fast and bulbous"\nDVV: "That's right, The Mascara Snake, fast and bulbous."\nMS: "Bulbous also tapered"\nDVV: "Yeah, but yer gotta wait until I say, 'Also, a tin teardrop' "\nMS: (laughing) "Huh. . . christ"\nFZ: "Again, beginning"\nMS: "Fast and bulbous"\nDVV: "That's right, The Mascara Snake, fast and bulbous. Also a tin teardrop."\nMS: "Bulbous also tapered"\nDVV: "That's right" Pena\nHer litle head clinking\nLike uh barrel of red velvet balls\nFull past noise\nTreats filled 'er eyes\nTurning them yellow like enamel coated tacks\nSoft like butter hard not t' pour\nOut enjoying the sun while sitting on\nUh turned on waffle iron\nSmoke billowing up from between her legs\nMade me vomit beautifully\n'n crush uh chandelier\nFall on my stomach 'n view her\nFrom uh thousand happened facets\nLiquid red salt ran over crystals\nI later band-aided the area\nSighed\nOh well it was worth it\nPena pleased but sore from sitting\nChoose t' stub 'er toe\n'n view the white pulps horribly large\nin their red pockets\n"I'm tired of playing baby," she explained\n'n out of uh blue felt box let escape\nOne yellow butterfly the same size\nIts dropping were tiny green phosphorous wor\nms That moved in tuck 'n rolls that clacked\n'n whispered in their confinement\nThree little burnt scotch taped windows\nSeveral yards away\nMouths open t' tongues that vibrated\n'n lost saliva\nPena exclaimed, "That's the raspberries."	\N	\N	\N	\N	\N	{}	2026-05-26 18:39:42.267841+00	2026-05-26 18:39:42.267841+00
a53420a4-a0a9-45ff-ae0e-82238a1b412b	Safe As Milk	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1968	\N	\N	Well my cigarette died when I washed my face Dropped some drops in an ashtray hit a wrong place\nWoman at my blinds to see spiders spinning lines\nIts a safe as milk it's a safe as milk\nI never heard it put quite that way\nThe shape I'm in is a gone a way\nThey called a day they called a day\nyesterday's paper headlines approach rain gutter teasing rusty cat sneezing\nSoppin wet hammer dusty and wheezing Lusty alley whining trashcan blues\nChildren running after rainbows stocking poor\nGracious ladies nylon hanging on to line\nJumping onto leg looking mighty fine Sorrows lollipop lands stick-broken on a dark carnival ground\nPop up toaster cracklin Aluminium rhythm and sound\nEv'ry day pencil lazy and sharp\nThe icebox inside looking like a harp\nE-lectric bulb been out for years Freezer fumes feed the gas tears\nCheese in the corner with a mile long beard\nBeggin' blue bread dog eared (repeat twice) I may be hungry but I sure ain't weird	\N	https://music.apple.com/us/album/safe-as-milk-take-12/284001765?i=284001783&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.221449+00	2026-05-26 20:25:11.468326+00
4972abd1-91c5-4c2e-843d-79ab09a9efef	Safe As Milk	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2006	\N	\N	Well my cigarette died when I washed my face Dropped some drops in an ashtray hit a wrong place\nWoman at my blinds to see spiders spinning lines\nIts a safe as milk it's a safe as milk\nI never heard it put quite that way\nThe shape I'm in is a gone a way\nThey called a day they called a day\nyesterday's paper headlines approach rain gutter teasing rusty cat sneezing\nSoppin wet hammer dusty and wheezing Lusty alley whining trashcan blues\nChildren running after rainbows stocking poor\nGracious ladies nylon hanging on to line\nJumping onto leg looking mighty fine Sorrows lollipop lands stick-broken on a dark carnival ground\nPop up toaster cracklin Aluminium rhythm and sound\nEv'ry day pencil lazy and sharp\nThe icebox inside looking like a harp\nE-lectric bulb been out for years Freezer fumes feed the gas tears\nCheese in the corner with a mile long beard\nBeggin' blue bread dog eared (repeat twice) I may be hungry but I sure ain't weird	\N	https://music.apple.com/us/album/safe-as-milk-take-12/284001765?i=284001783&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.494003+00	2026-05-26 20:25:11.468495+00
69ab3866-bbad-4449-ab24-73ea7ef1df00	Seam Crooked Sam	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	2012	\N	\N	The mule kicked off a new one\nand the stockings ran up Seam Crooked Sam\nbandana frock stuffed with smoke\nand ears out flopped like bowlin' pins\nhog troughs hocked and wallered in cool mud bins\nand patent leather hooves\nsplit in twos\nrooms for rent down t' Ben's\nFrendsa danced in a frenzy\nchoked a juke bird with froth glass ferns\nand turpentine urns her sawdust daily keep\nand whiskey creeps down her neck naked front\nand red leatherette\npeen button set where her fanny sweat\nraised her wrist-a-fan and a mouse coughed cotton\nthrough a screen door cracked sand\nrooms rent only to friends\nHat Rack Hotel\narchitecture tincture of red Arkies\npinched the southern belle\nand splayed his cracked nail hand\ngrey fedora--snappy band\nand the camel walls yelluh like damp dead chickens\nbeak down the hard wood floor\nand the music--O the music\nharp man blew his best lung white shirt\nhis feet worked like a monkey out the door\nand Dora robbed a baby through a dark bebop\nlicorice lenses fogged in hot sorrow\nthrough the floorboards at the general store\nyuh foods still in the hot hand oven\napple pie cooked through a seed bruised stem eye\nsticky in the window of Momma Frame Broke\nrope bell dinglin'	\N	https://music.apple.com/us/album/seam-crooked-sam/1059241448?i=1059242082&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.405135+00	2026-05-26 20:11:35.979009+00
9afd11ab-7f47-4a90-bb98-f396e11f9401	Sheriff of Hong Kong	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1980	\N	\N	She always shows up when I'm up\nBut she never shows up when I'm down\nBut she's under arrest\n'cause I might guess\nThe Sheriff of Hong Kong\nThen she goes up in a flash\nI bite the end of her sash\nThen I'm long gone\nTo Hong Kong Kong She never makes a taste mistake\nShe's the Sheriff of Hong Kong\nNow I'm the Sheriff of Hong Kong\nNow she's the Sheriff of Hong Kong\nLong gone gone\nTo Hong Kong Kong Whoa I'm long gone\nTo Hong Kong Kong Long gone gone\nTo Hong Kong Kong\nAd hu\nAnd uh zing hu\nI don't know who I am\nDo you?\nOhhh ahhh oooh There's a string and bat dangle\nBlack and white bat and cat panda\nAnd uh\nShe's the Sheriff of Hong Kong\nAnd uh\nAd hu\nAnd uh zing hu\nI don't know who I am\nDo youuuu? Now she's the Sheriff of Hong Kong gone\nI bite the end of her sash\nAnd she's off in a flash\nAnd we're long gone gone\nTo Hong Kong Kong There's a string and bat dangle\nBlack and white bat and cat panda\nAnd uh\nShe's the Sheriff of Hong Kong and uh\nAd hu\nAnd uh zing hu\nWhoa-ohhhh ohhh ohhh wai ni sha yeh\nwai ni sha yeh\nshe say\nohhh - ohh Ad hu\nZing hu\nwai ni sha yeh\nwai ni sha yeh\nohhh\nAd hu\nZing hu\nShe's the Sheriff of Hong Kong\nZo hu\nZing hu\nAah ohhh\nAaaah oh\nAd hu\nZing hu\nAhhh me and you	\N	https://music.apple.com/us/album/sheriff-of-hong-kong/714553431?i=714553715&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.454945+00	2026-05-26 20:11:35.979496+00
2d141317-7d3e-43ad-a4a4-55a51a6a121e	Skeleton Makes Good	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1982	\N	\N	There's so many things\nto feel and see while you're awake they're just out of reach\nout of grasp\nyeah out of reach\nand just as many; maybe more\nthe minute that you sleep\nso I got to throw my preach\nskeleton breath\nscorpion blush\nI have a crush on your skeleton\nwatch out unsuspecting stranger\nyou'll fall off the log\nheadfirst into dreams\nend up screaming\nthis will comb the wolf\nand that will comb the fog\nwhat will peen the rain\nwhat will preen the hog\noh you mean earth\nand hell over you\nand laugh at your tire tracks\nif you get up\nskeleton makes good.	\N	https://music.apple.com/us/album/skeleton-makes-good/464978430?i=464978442&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.477818+00	2026-05-26 20:11:35.979671+00
5ec21fc2-a319-4ef2-8d57-8581b7ba7eb6	Sugar ‘n’ Spikes	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	live	\N	\N	2006	\N	\N	'n sugar 'n spikes 'n neon lights\n'n walks 'n lights 'n chains coughin' smoke whoopin' hope\nCardinal sky rush by falls bark in dark\nFall back in dark\nPies steam stale shoes move broom 'n pale\nMoon in uh dime store sale\nSugar 'n spikes 'n everything nice 'n everything nice 'n crazy\nThat's what little worlds are made of lady\nI'm paid up in home in 'm new Friday's house\nThere's no H on my faucet there's no bed for m' mouse\nMy punch 'n grow mind in diamond back time\nNow it's king for uh day with my lady look fine\nGot m' peakin' up hat 'n my caramel mask\nTremelo car got m' speidel wrist round m' honey\nGoin' t' see the navy blue vicar\nPaul Peter 'n misses wray flicker Interestingly, I received email from a Peter Wray, who might just be the fellow mentioned above in the song. Here's a chunk of his email. "My only claim to fame was being mentioned in one of his songs (Sugar n Spikes). How I got in the lyrics I don't know except that I met Beefheart on tour in Columbus Ohio in 1968 or 69." "I remember that one of my friends in college got one of the first issues of TMR - when warners included the lyric sheet - and came running into my room yelling and insisting that I somehow had done something directly to get in the song. I couldn't convince him otherwise."	\N	https://music.apple.com/us/album/sugar-n-spikes/137665947?i=137667343&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.496795+00	2026-05-26 20:11:35.980929+00
2fc21ed3-1d96-4977-bfd4-ae6e92e372e2	Sweet Sweet Bulbs	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1969	\N	\N	Sweet sweet sweet sweet bulbs grow in m' latest garden\nWarm warm warm warm warm sun fingers wave\nIn m' latest garden\nFlowers dance their faces brave\nCome talk freely in the garden of m' lady\nHer hominy smile her hominy snatch\nOnly uh crow would peck\nn' uh chicken would scratch\nHer lips turned up t' kiss\nI see yuh Phoebe baby in yer bonnet\nWith the sunset written on it\n'n the shadow of uh tree\nCurled around yuh knee in color\nn' just behind yuh was the sea of negativity\nTinklin' like mercury in the wind\nHer feet kept by the ground her toes bare brown\nHer carriage she'd abandoned like uh hand-me-down\nShe walked back into nature uh queen uncrowned\nShe had just recognised herself\nTo be an heir t' the throne\nHer garden gate swings lightly without weight\nOpen t' most anyone that needs uh little freedom\nFor God's sake\nO' come as many as you can\nIn dark or light you're free t' grow as flowers\nShare her throne 'n use her toothbrush\n'n spend some interesting hours	\N	https://music.apple.com/us/album/sweet-sweet-bulbs/137665947?i=137667404&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.255778+00	2026-05-26 20:11:35.981485+00
fc8a1095-8526-40b6-811a-37c9d51d232d	Tarotplane	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1971	\N	\N	Baby person told a Dixie Sue\nListen to me baby I'm gonna tell it to you\nGonna need somebody on your bond\nYou gonna need some bodies on your bond\nJust you bear this in mind True friends is hard to find\nYou gonna need some bodies on your bond\nGonna need somebody on your bond\nYou gonna need some bodies on your bond\nJust you bear this in mind True friends is hard to find\nYou gonna need some bodies on your bond\nI say bear this in mind\nI say bear this in mind\nJust you bear this in mind\nTrue friends is hard to find\nYou gonna need some bodies on your bond\nYa done put mice in the radiator\nRazors in the clay\nWell, they keeps us working all night\nDon't give us no pay\nDon't give us no pay\nAutomatic Sam told Everready Betty told Prestone Milly\nWith the long...\nAutomatic Sam told Everready Betty told Prestone Milly\nWith the long black wavy mane\nWith the long black...\nWith the long black wavy mane\nLittle girl, Little girl\nGonna take you for a ride in my Tarotplane\nI wanta take you for a ride in my Tarotplane\nFor a fly, for a fly\nBaby person told a Dixie Sue\nOh, listen to me baby I'm gonna tell it to you\nYou ain't too old\nOh, you ain't too old\nJust what you been heard - just what uou been told\nYou gonna need somebody on your bond\nYou gonna need some bodies on your bond\nJust you bear this in mind True friends is hard to find\nYou gonna need some bodies on your bond\nBaby person told a Dixie Sue\nListen to me baby Mice in the razors, clay in the heaters\nMice in the razors, clay in the heaters\nYou gonna need somebody on your bond\nYou gonna need some bodies on your bond\nJust you bear this in mind True friends is hard to find\nYou gonna need some bodies on your bond\nAutomatic Sam told Everready Betty told Prestone Milly\nWith the long black wavey mane\nOh listen little girl don't you understand?\nOh, you ain't too old\nNo you ain't too old\nWell you ain't too lold\nAs long as you can boogie you ain't too old\nLittle girl, little girl\nLittle girl, little girl\nGonna take you for a ride in my Tarotplane\nGonna take you for a ride in my Tarotplane\nYou goin' flyin'\nYou goin' flyin'\nCome on little girl\nGonna take you for a ride in my Tarotplane\nCome on little girl\nGonna take you for a ride in my Tarotplane\nCome on little girl\nGonna take you for a ride in my Tarotplane\nIn my Tarotplane\nIn my Tarotplane\nIn my Tarotplane\nIn my Tarotplane\nIn my Tarotplane\nYou gonna need somebody on your bond\nYou gonna need some bodies on your bond\nJust you bear this in mind True friends is hard to find\nYou gonna need some bodies on your bond	\N	https://music.apple.com/us/album/tarotplane/284001765?i=284001775&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.208469+00	2026-05-26 20:11:35.981654+00
14d48b5b-fc92-46d5-b11c-13c3216f0a04	Telephone	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1980	\N	\N	Paper and wire killed my brother and my sister too\nAnd if you don't watch out\nYou know they're going to get you too\nAnd if I don't watch out\nYou know they're going to get me too\nTelephone\nTelephone\nTelephone\nTelephone\nWell I strangled the cord\nRipped it off of the phone\nAnd I saw the bone\nAnd I saw the twinkling lights\nIt must have been rats [?? is this right? - any ideas?]\n'Cause it sure was a drone\nIt sure was a drag\nPaper and wire killed my brother and my sister too\nAnd if you don't watch out\nYou know they're going to get you\nAnd if I don't watch out\nYou know they're going to get me too\nTelephone\nTelephone\nTelephone\nAnd I strangled\nAnd I ripped the cord\nAnd I saw the bone\nAnd I heard these tweetin' things\nN twinkling lights\nN there was nobody home\nWhere are all those nerve endings coming out of the bone? Telephone\nTelephone\nWell I ripped the cord right out of the phone\nAnd I saw the bone\nDammed gleaming white bone\nTelephone\nPaper and wire killed my brother and my sister too\nAnd if you don't watch out\nYou know they're going to get you\nAnd if I don't watch out\nYou know they're going to get me too\nTelephone\nTelephone\nAnd I can?t get away\nAnd I can?t get away\nIt?s like a grey adder at the end of the hall\nIt?s like a plastic horned devil	\N	https://music.apple.com/us/album/telephone/714553431?i=714553683&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.451548+00	2026-05-26 20:11:35.981818+00
26e96601-d56b-47fa-81de-727988b23718	The Blimp	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1969	\N	\N	Dialogue:\nMothers band member: "One, two . . ."\nFrank Zappa: "You ready?"\nMBM: ". . .three, four"\nFZ: "Okay, go"\nMaster master\nThis is recorded thru uh flies ear\n'n you have t' have uh flies eye t' see it\nIt's the thing that's gonna make Captain Beefheart\nAnd his magic band fat\nFrank it's the big hit\nIt's the blimp\nIt's the blimp Frank\nIt's the blimp When I see you floatin' down the gutter\nI'll give you uh bottle uh wine\nPut me on the white hook\nBack in the fat rack\nShad rack ee shack\nThe sumptin' hoop the sumptin' hoop\nThe blimp the blimp\nThe drazy hoops the drazy hoops\nThey're camp they're camp\nTits tits the blimp the blimp\nThe mother ship the mother ship\nThe brothers hid under their hood\nFrom the blimp the blimp\nChildren stop yer nursin' unless yer renderin' fun\nThe mother ship\nThe mother ship's the one\nThe blimp the blimp\nThe tapes uh trip it's uh trailin' tail\nIt's traipse'n along behind the blimp the blimp\nThe nose has uh crimp\nThe nose is the blimp the blimp\nIt blows the air the snoot isn't fair\nLook up in the sky there's uh dirigible there\nThe drazy hoops whirl\nYou can see them just as they were\nAll the people stir\n'n the girls knees trembles\n'n run 'n wave their hands\n'n run their hands over the blimp the blimp\nDaughter don't yuh dare\nOh momma who cares\nIt's the blimp it's the blimp Dialogue:\nDon Van Vliet: "That's it . . . hello?"\nFrank Zappa: "Hello."\nDVV: "Did you get it?"\nFZ: "Sure did. It's beautiful. (laughs) I think that we have enough on the tape to, er, just use that as it is for the album. Okay, I'm gonna listen to it back now. I gotta go right to where . . ."	\N	https://music.apple.com/us/album/the-blimp-live-from-le-nouvel-hippodrome-paris-19-11-1977/1807813341?i=1807813367&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.288405+00	2026-05-26 20:25:54.953005+00
8144ea5f-7c54-4481-a8dd-47bdf4b8c279	Trust Us	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1968	\N	\N	The path is the mask of love a way a way The flow is the task above today there is no other way (repeat) You gotta trust us when you need a friend To find us you gotta look within\nYou gotta trust us (repeat) before you turn to dust (repeat)\nYou gotta see before you see you gotta be before be (we love you) You gotta touch without take\nYou gotta hear without fear You gotta feel to reveal\nYou gotta touch without take\nSuch is is and hate us hate (repeat) We're for you love you with you love you just a few We love you we tell you true we love you The path is youth let the dying die\nThe path is life yeah ;let the lying lie\nLet the dying die let the lying lie\n(trust trust trust)	\N	https://music.apple.com/us/album/trust-us-take-6/284001765?i=284001781&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.223286+00	2026-05-26 20:25:11.471376+00
28cbee10-7def-4f0a-ad0f-41800ef94380	The Floppy Boot Stomp	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1978	\N	\N	The floppy boot stomped down into the ground\nThe farmer screamed 'n blew the sky off the mountains\nEye sockets looked down on the chestbone mountains\n'n the sun dropped down, 'n the moon ran off,\nHis heels 'n elbows pale as chalk\n'n all the comets collided 'n blew t' dust\nFor fear they'd be seen.\n'n the sky turned white in the middle of the night\n'n the sky turned white in the middle of the night\n'n the big floppy boot stomped down into the ground\n'n the red violin took the bow\nto do the hoodoo hoe-down\n'n the red violin took the bow\nfor to do the hoodoo hoe-down\nThe farmer jumped in ah circle 'n flung his chalk right down\nDo-si-do the devil sho' showed 'n he broke of his horns\n'n fiddled him down the road\nthrough the fork\n'n the farmer's floppy boot stomped down\nRed tail squirmin' and the hot leg kicked\n'n the fire leaped 'n licked\nAnd when the boot came up, the fire went out\nAnd hell was just an ice cube melting off on the ground.\nAnd the bold caught down for to do the hoodoo hoedown\nAnd the bold caught down for to do the hoodoo, the devil hoedown\nTo the fork, huddlin? in a hollow, standin? at the crossroads\nWith that bunged-up bandaged broken bum that fell in the wrong circle\nHe had a sole red tail ? once went red, now was pale\nFe Fi Fo Fum he was summoned up from hell\nBooted down a spell\nBy a square-dancin? farmer\nBy a square-dancin? farmer, well\nThat old bum was sticking out his thumb\nWhen the farmer drew up, said\n"Listen son", and the horse compared his hooves.\n"If you fall into my circle again I?ll tan your red hide\nAnd dance you on your tail, and pitch you from now to now\nPitch you from now to now."\nAnd the hotlick kicked, and the fire leaped an? licked\nAnd the hotlick kicked and the fire just leaped an? licked\nAnd the hotlick kickin? an? the fire jus? leapin? an? lickin?\nAnd the fire leaped and licked.	\N	https://music.apple.com/us/album/the-floppy-boot-stomp/370925126?i=370925128&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.411711+00	2026-05-26 20:11:35.982462+00
3c6cfcd5-8b8f-42aa-9179-b108417b2bda	The Smithsonian Institute Blues (or the Big Dig)	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1970	\N	\N	Come on down t' the big dig\nCome on down t' the big dig\nCome on t' the big dig\nSingin' the Smithsonian Institute blues\nSingin' the Smithsonian Institute blues\nThe way it's goin' La Brea tar pits\nI know you just can't lose\nThe new dinosaur is walkin' in the old one's shoes\nCome on down t' the big dig\nCan't get around the big dig\nThis may be premature but if I'm wrong\nYou can just say it's the first time I was happy t' be confused\nSingin' the Smithsonian Institute blues\nAlll you new dinosaurs\nNow it's up t' you t' choose\nIt sure looks funny for a new dinosaur\nT' be in an old dinosaur's shoes\nDina Shore's shoes\nDinosaur shoes\nC'mon down to the big dig\nYou can't get around the big dig\nC'mon to the big dig\nYa can't get around the big dig\nSingin' the Smithsonian Institute blues	\N	https://music.apple.com/us/album/the-smithsonian-institute-blues-or-the-big-dig/415007099?i=415007214&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.312689+00	2026-05-26 20:11:35.983155+00
c81f435a-9015-4cc4-b4c0-deff1aea32ef	The Spotlight Kid	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1972	\N	\N	Said the momma t' the baby in the corn\nYou are my first born\nYou shall here on in be known as The Spotlight Kid\n'N the mornin' cry of the rooster\nThe baby lay alone\n'N the old cow in the green grass\nShed white tears in the red hot sun\n'N The Spotlight Kid stood under the moon that evenin'\nGivin' her alibis 'n eatin' her a la modes\n'N the green frogs croakin' around his abdoe\n'N the mud cat pond by the old willow road\nAll night the village waited 'n The Spotlight Kid never showed\nShe was up on the mountain\nTellin' her alibis 'n eatin' her a la modes\nMomma still knew she was the one\nShe was the one who stole the pie from old Momma Eye\nWindow bare rockin' chair groanin' like ah grizzly bear\n'N the ice cream searchin' high 'n low\nFor his a la modes for his a la modes\nAll night the village waited 'n The Spotlight Kid never showed\nShe was up on the mountain tellin' her alibis\n'N eatin' her a la modes	\N	https://music.apple.com/us/album/the-spotlight-kid/415006591?i=415006609&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.32737+00	2026-05-26 20:11:35.983312+00
e056d1c0-9ef6-43d4-aa9b-8ee3af1b44b9	The Thousandth and Tenth Day Of The Human Totem Pole	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1982	\N	\N	The thousandth and tenth day of the human totem pole.\nThe morning was distemper grey,\nOf the thousandth and tenth day of the human totem pole.\nThe man at the bottom was smiling.\nHe had just finished his breakfast smiling.\nIt hadn't rained or manured for over two hours. The man at the top was starving.\nThe pole was a horrible looking thing With all of those eyes and ears And waving hands for balance.\nThere was no way to get a copter in close So everybody was starving together.\nThe man at the top had long ago given up But didn't have nerve enough to climb down.\nAt night the pole would talk to itself and the chatter wasn't too good.\nObviously the pole didn't like itself, it wanted to walk!\nIt was the summer and it was hot\nAnd balance wouldn't permit skinning to undergarments.\nIt was an integrated pole, it was taking on an reddish brown cast.\nExercise on the pole was isometric, Kind of a flex and then balance Then the highest would roll together, The ears wiggle, hands balance.\nThere was a gurgling and googling heard A tenth of the way up the pole.\nApproaching was a small child With Statue of Liberty doll.	\N	https://music.apple.com/us/album/the-thousandth-and-tenth-day-of-the-human-totem-pole/714560239?i=714560585&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.47612+00	2026-05-26 20:11:35.983477+00
6d0ddf93-0b53-44d7-bc81-9e8f5655820d	The Witch Doctor Life	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1982	\N	\N	When the Witch Doctor Life\nthrows his silent bones\nsome are crowned kings\nwhile others lose their thrones\nWhen the Witch Doctor Life\nthrows his silent bones\nsmall "O" mouths scream\nand run to Mama Kangaroo\ninsecure pouches wherein hide\nbeggars and drones\nand babies and bums and buzzards\nMama crouches and smiles\nher old useful smile\nand old ego roars - laughs yesterday's gasses\nwhile children and angels gasp\nand follow a shepherd on crutches\nWhen the Witch Doctor Life\nthrows his silent bones\nsome flee the dream\nsome turn to stone\nand the children sing\nand the heavens ring\nworn by the shepherd with the folded wings\nand the bones that sing of silence	\N	https://music.apple.com/us/album/the-witch-doctor-life/714560239?i=714560539&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.47282+00	2026-05-26 20:11:35.983679+00
4996b88a-f8c4-4943-8026-2439ffa339f3	Tropical Hot Dog Night	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1978	\N	\N	Tropical Hot Dog Night\nLike two flamingoes in a fruit fight\nEv?ry colour of day\nWhirlin? around at night\nI?m playin? this music\nSo the young girls will come out\nTo meet the monster tonight\nTropical Hot Dog Night\nLike two flamingoes in a fruit fight\nI don?t wanna know ?bout wrong or right\nI don?t want to know\n- I?m anywhere tonight\nTropical Hot Dog Night\nLike two flamingoes in a fruit fight\nLike steppin? out of a triangle\nInto striped light\nStriped light, striped light\nTropical Hot Dog Night\n- Everything?s wrong, at the same time it?s right\nThe truth has no patterns for me tonight\nI?m playing this music so the young girls will come out\nTo meet the monster tonight\nMeet the monster tonight\nWhat do all you women do\nWhen the men get Tropical Hot Dog payday?\nWhat do you do on Tropical Hot Dog day day?\nYay; Yay\nStep out of a triangle into striped light\nTurn around and step back into striped light\nTropical Hot Dog Night\nI?m playin? this song\nFor all the young girls to come out to meet the monster tonight\nMeet the monster tonight\nHow would you like to be the lucky girl,\nThe lucky one?\n- To be the monster tonight\nOw, to be the monster tonight\nOh, everything?s wrong, at the same time it?s white!\nYou get to be - you get to be - with me\nAnd also to be the monster tonight	\N	https://music.apple.com/us/album/tropical-hot-dog-night/1783193106?i=1783193482&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.414259+00	2026-05-26 20:11:35.984211+00
c272a857-ee14-4004-a561-b31e15d13173	Well	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1969	\N	\N	Light floats down day river on uh red raft o' blood\nNight blocks out d' heaven like uh big black shiny bug\nIts hard soft shell shinin' white in one spot well\nIt's hard place dat I'm livin' but I'm doin' well well\nThe white ice horse melted like uh spot uh silver well\nIts mane went last then disappeared the tail\nMy life ran thru my veins\nWhistlin' hollow well\nI froze in solid motion well well\nI heard the ocean swarmin' body well well\nI heard the beetle clickin' well\nI sensed the thickest silence scream\nThen I begin t' dream\nMy mind cracked like custard\nRan red until it sealed\nTurn t' wooden 'n rolled like uh wheel well well\nThick black felt birds uh flyin'\nWith capes of solid chrome\nWith feathers of solid chrome\n'n beaks of solid bone\n'n bleach the air around them\nWhite 'n cold well well\nTill it showed in pain\nThe hollow cane clicked like ever after\nIts shadow vanished shinin' silence\nWell well	\N	https://music.apple.com/us/album/well-live/415588757?i=415588889&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.269599+00	2026-05-26 20:25:54.955416+00
4a9c1bce-79f8-48ba-8512-f985e2b0a941	When Big Joan Sets Up	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1969	\N	\N	Hoy hoy\nWhen Big Joan comes out\nHer arms are too small\nHer head like uh ball\nShe tied off her horse\n'n galloped off into the moonbeams\nShe pulled up her blouse\n'n compared her navel to the moon\nI dig my life for uh while\nWhen Big Joan sets up\nHer hands are too small\nShe's too fat t' go out in the daylight\nSo she rolls around all night\nI'm just sorta thread\nWith uh drooped body\nI'll set up with yuh Big Joan\nI'm too fat t' go out\nIn the daylight\nI'll stay up all night\nI won't droop if you\nWon't talk about your\nHands bein' too small\nYou know something's happenin'\nOr you wouldn't of come out like yuh did\nShe ain't built for goin' naked\nSo she can't wear any new clothes\nOr go t' the beach\nThey laugh at her body\nCause her hands are too small\nWhen Big Joan sets up her hands are too smal\nl She's outta reach\nUh turquoise scarf 'n uh sleeve\nRolled up over uh Merc Montclair\nI'll sit up with yuh Big Joan\nI'm too fat to go out in the daytime\nI'll stay up all night\nIf yuh promise not t' talk\nAbout yer hands bein' too small\nHoy hoy is she uh boy?	\N	https://music.apple.com/us/album/when-big-joan-sets-up/137665947?i=137667988&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.271389+00	2026-05-26 20:11:35.984555+00
690f4280-281d-4f49-848f-950ca30b075d	White Jam	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1972	\N	\N	She serves me flowers 'n yams\n'N in the night when i'm full\nShe brings me white jam\n'N I don't know where I am\nIn the meadow she brings me\nLike ah bee she stings me\n'N I don't know where I am\nClouds clingin' to us\n'N the sun lookin' through us\n'N in the night when I'm full\nShe brings me white jam\n'N I don't know where I am	\N	https://music.apple.com/us/album/white-jam/415006591?i=415006601&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.320641+00	2026-05-26 20:11:35.985365+00
cee9b984-01a8-4736-a963-d516a180d7de	Wild Life	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1969	\N	\N	Wild life along with my wife\nI'm goin' up on the mountain fo' the rest uh m' life\n'fore they take m' life\n'fore they take m' wild life\n'fore they take m' wife\nThey got m' mother 'n father\n'n run down all my kin\nFolks I know I'm next\nWild life along with m' wife\nI'm goin' up on the mountain fo' the rest uh m' life\n'fore they take m' wild life\n'fore they take m' wife? wife?\n'fore they take m' wife\nWild life wild life wild life\nWild life wild life wild life\nI'm goin' up on the mountain along with m' wife\nFind me uh cave 'n talk them bears\nIn t' takin' me in\nWild life along with m' wife\nWild life\nIt's uh man's best friend\nWild life along with m' wife\nI'm goin' up on the mountain fo' the rest uh m' life\n'fore they take m' life\n'fore they take m' wild life\n'fore they take m' wife?\n'fore they take m' wife\nWild life wild life\nWild life wild life\nI'm goin' up on the mountain\nFind me uh cave 'n talk the bears\nIn t' takin' me in\nWild life is uh mans best friend\nWild life	\N	\N	\N	\N	\N	{}	2026-05-26 18:39:42.282576+00	2026-05-26 18:39:42.282576+00
a095556f-6027-447c-9df0-31fc0bf804d9	Zig Zag Wanderer	9d35ba30-7b70-4287-bccf-1c31cc26e913	Captain Beefheart and His Magic Band	audio	studio	\N	\N	1967	\N	\N	Zig zag zig zag wanderer (rep.)\nYou can huff, you can puff\nnever know what I have found\nYou can zig you can zag\nWhoa I'm gonna stay gonna stay around (rep.) You can jump you can holler\nNever lose what I have found\nheaven's free 'cept for a dollar\nyou can zig you can zag\nWhoa I'm gonna stay around gonna stay around Zigzag wanderer had a zigzag child\nZigzag traveller for the mercy mile\n.......(found his strength in?) and nature scene Twist his face (quenched his thirst) where he never been Zig zag wanderer (rep.) You can dance you can prance freeze those timbers drop some beans\nHide my shield throw away my lance\nZig zag child mercy mile\nzig zag dreams zig zag dreams zig zag dreams....\n(NB surely CB would not advocate that someone club his seal? I always heard\nsomething to do with a shield, which would tie in with the lance metaphor)	\N	https://music.apple.com/us/album/zig-zag-wanderer/290334563?i=290334565&uo=4	\N	\N	\N	{}	2026-05-26 18:39:42.161108+00	2026-05-26 20:11:35.986308+00
\.


--
-- Name: _migrations _migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public._migrations
    ADD CONSTRAINT _migrations_pkey PRIMARY KEY (name);


--
-- Name: albums albums_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.albums
    ADD CONSTRAINT albums_pkey PRIMARY KEY (id);


--
-- Name: api_keys api_keys_key_hash_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_key_hash_key UNIQUE (key_hash);


--
-- Name: api_keys api_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_pkey PRIMARY KEY (id);


--
-- Name: artists artists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.artists
    ADD CONSTRAINT artists_pkey PRIMARY KEY (id);


--
-- Name: personnel personnel_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.personnel
    ADD CONSTRAINT personnel_pkey PRIMARY KEY (id);


--
-- Name: song_albums song_albums_album_id_sequence_number_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.song_albums
    ADD CONSTRAINT song_albums_album_id_sequence_number_key UNIQUE (album_id, sequence_number);


--
-- Name: song_albums song_albums_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.song_albums
    ADD CONSTRAINT song_albums_pkey PRIMARY KEY (song_id, album_id);


--
-- Name: song_personnel song_personnel_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.song_personnel
    ADD CONSTRAINT song_personnel_pkey PRIMARY KEY (song_id, personnel_id, role);


--
-- Name: songs songs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.songs
    ADD CONSTRAINT songs_pkey PRIMARY KEY (id);


--
-- Name: idx_albums_artist_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_albums_artist_id ON public.albums USING btree (artist_id);


--
-- Name: idx_albums_release_year; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_albums_release_year ON public.albums USING btree (release_year);


--
-- Name: idx_songs_artist_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_songs_artist_id ON public.songs USING btree (artist_id);


--
-- Name: idx_songs_media_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_songs_media_type ON public.songs USING btree (media_type);


--
-- Name: idx_songs_release_year; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_songs_release_year ON public.songs USING btree (release_year);


--
-- Name: albums albums_artist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.albums
    ADD CONSTRAINT albums_artist_id_fkey FOREIGN KEY (artist_id) REFERENCES public.artists(id);


--
-- Name: song_albums song_albums_album_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.song_albums
    ADD CONSTRAINT song_albums_album_id_fkey FOREIGN KEY (album_id) REFERENCES public.albums(id) ON DELETE CASCADE;


--
-- Name: song_albums song_albums_song_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.song_albums
    ADD CONSTRAINT song_albums_song_id_fkey FOREIGN KEY (song_id) REFERENCES public.songs(id) ON DELETE CASCADE;


--
-- Name: song_personnel song_personnel_personnel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.song_personnel
    ADD CONSTRAINT song_personnel_personnel_id_fkey FOREIGN KEY (personnel_id) REFERENCES public.personnel(id) ON DELETE CASCADE;


--
-- Name: song_personnel song_personnel_song_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.song_personnel
    ADD CONSTRAINT song_personnel_song_id_fkey FOREIGN KEY (song_id) REFERENCES public.songs(id) ON DELETE CASCADE;


--
-- Name: songs songs_artist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.songs
    ADD CONSTRAINT songs_artist_id_fkey FOREIGN KEY (artist_id) REFERENCES public.artists(id);


--
-- PostgreSQL database dump complete
--

\unrestrict Ageuh1SGnw0uYt5IbeJA5xFGMOsqF8EjZnJ27KrkKWRwDg3VTFUvp0O5Ep08lCW

