--
-- PostgreSQL database dump
--

\restrict tm0Wt7CuNHnaREkPBebYY01grIsJbDimiIqW6SxkfQecOzXvk9ScJ3EGn85WbwN

-- Dumped from database version 15.16
-- Dumped by pg_dump version 17.6 (Debian 17.6-0+deb13u1)

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
-- Name: enum_ReactionComments_type; Type: TYPE; Schema: public; Owner: user
--

CREATE TYPE public."enum_ReactionComments_type" AS ENUM (
    'like',
    'dislike',
    'love',
    'wow',
    'haha',
    'sad',
    'angry'
);


ALTER TYPE public."enum_ReactionComments_type" OWNER TO "user";

--
-- Name: enum_ReactionDiscussions_type; Type: TYPE; Schema: public; Owner: user
--

CREATE TYPE public."enum_ReactionDiscussions_type" AS ENUM (
    'like',
    'dislike',
    'love',
    'wow',
    'haha',
    'sad',
    'angry'
);


ALTER TYPE public."enum_ReactionDiscussions_type" OWNER TO "user";

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Comments; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public."Comments" (
    id integer NOT NULL,
    user_id integer,
    discussion_id integer,
    content text,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."Comments" OWNER TO "user";

--
-- Name: Comments_id_seq; Type: SEQUENCE; Schema: public; Owner: user
--

CREATE SEQUENCE public."Comments_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Comments_id_seq" OWNER TO "user";

--
-- Name: Comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user
--

ALTER SEQUENCE public."Comments_id_seq" OWNED BY public."Comments".id;


--
-- Name: Discussions; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public."Discussions" (
    id integer NOT NULL,
    owner_id integer,
    title character varying(255),
    content text,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."Discussions" OWNER TO "user";

--
-- Name: Discussions_id_seq; Type: SEQUENCE; Schema: public; Owner: user
--

CREATE SEQUENCE public."Discussions_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Discussions_id_seq" OWNER TO "user";

--
-- Name: Discussions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user
--

ALTER SEQUENCE public."Discussions_id_seq" OWNED BY public."Discussions".id;


--
-- Name: Permissions; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public."Permissions" (
    id integer NOT NULL,
    name character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."Permissions" OWNER TO "user";

--
-- Name: Permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: user
--

CREATE SEQUENCE public."Permissions_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Permissions_id_seq" OWNER TO "user";

--
-- Name: Permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user
--

ALTER SEQUENCE public."Permissions_id_seq" OWNED BY public."Permissions".id;


--
-- Name: ReactionComments; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public."ReactionComments" (
    id integer NOT NULL,
    user_id integer,
    comment_id integer,
    type public."enum_ReactionComments_type",
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."ReactionComments" OWNER TO "user";

--
-- Name: ReactionComments_id_seq; Type: SEQUENCE; Schema: public; Owner: user
--

CREATE SEQUENCE public."ReactionComments_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."ReactionComments_id_seq" OWNER TO "user";

--
-- Name: ReactionComments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user
--

ALTER SEQUENCE public."ReactionComments_id_seq" OWNED BY public."ReactionComments".id;


--
-- Name: ReactionDiscussions; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public."ReactionDiscussions" (
    id integer NOT NULL,
    user_id integer,
    disscussion_id integer,
    type public."enum_ReactionDiscussions_type",
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."ReactionDiscussions" OWNER TO "user";

--
-- Name: ReactionDiscussions_id_seq; Type: SEQUENCE; Schema: public; Owner: user
--

CREATE SEQUENCE public."ReactionDiscussions_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."ReactionDiscussions_id_seq" OWNER TO "user";

--
-- Name: ReactionDiscussions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user
--

ALTER SEQUENCE public."ReactionDiscussions_id_seq" OWNED BY public."ReactionDiscussions".id;


--
-- Name: RolePermissions; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public."RolePermissions" (
    id integer NOT NULL,
    r_id integer,
    p_id integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."RolePermissions" OWNER TO "user";

--
-- Name: RolePermissions_id_seq; Type: SEQUENCE; Schema: public; Owner: user
--

CREATE SEQUENCE public."RolePermissions_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."RolePermissions_id_seq" OWNER TO "user";

--
-- Name: RolePermissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user
--

ALTER SEQUENCE public."RolePermissions_id_seq" OWNED BY public."RolePermissions".id;


--
-- Name: Roles; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public."Roles" (
    id integer NOT NULL,
    role_name character varying(255),
    description text,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."Roles" OWNER TO "user";

--
-- Name: Roles_id_seq; Type: SEQUENCE; Schema: public; Owner: user
--

CREATE SEQUENCE public."Roles_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Roles_id_seq" OWNER TO "user";

--
-- Name: Roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user
--

ALTER SEQUENCE public."Roles_id_seq" OWNED BY public."Roles".id;


--
-- Name: SequelizeMeta; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public."SequelizeMeta" (
    name character varying(255) NOT NULL
);


ALTER TABLE public."SequelizeMeta" OWNER TO "user";

--
-- Name: Sessions; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public."Sessions" (
    id integer NOT NULL,
    u_id integer,
    session character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."Sessions" OWNER TO "user";

--
-- Name: Sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: user
--

CREATE SEQUENCE public."Sessions_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Sessions_id_seq" OWNER TO "user";

--
-- Name: Sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user
--

ALTER SEQUENCE public."Sessions_id_seq" OWNED BY public."Sessions".id;


--
-- Name: UserRoles; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public."UserRoles" (
    id integer NOT NULL,
    u_id integer,
    r_id integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."UserRoles" OWNER TO "user";

--
-- Name: UserRoles_id_seq; Type: SEQUENCE; Schema: public; Owner: user
--

CREATE SEQUENCE public."UserRoles_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."UserRoles_id_seq" OWNER TO "user";

--
-- Name: UserRoles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user
--

ALTER SEQUENCE public."UserRoles_id_seq" OWNED BY public."UserRoles".id;


--
-- Name: Users; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public."Users" (
    id integer NOT NULL,
    username character varying(255),
    password character varying(255),
    fname character varying(255),
    lname character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."Users" OWNER TO "user";

--
-- Name: Users_id_seq; Type: SEQUENCE; Schema: public; Owner: user
--

CREATE SEQUENCE public."Users_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Users_id_seq" OWNER TO "user";

--
-- Name: Users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user
--

ALTER SEQUENCE public."Users_id_seq" OWNED BY public."Users".id;


--
-- Name: Comments id; Type: DEFAULT; Schema: public; Owner: user
--

ALTER TABLE ONLY public."Comments" ALTER COLUMN id SET DEFAULT nextval('public."Comments_id_seq"'::regclass);


--
-- Name: Discussions id; Type: DEFAULT; Schema: public; Owner: user
--

ALTER TABLE ONLY public."Discussions" ALTER COLUMN id SET DEFAULT nextval('public."Discussions_id_seq"'::regclass);


--
-- Name: Permissions id; Type: DEFAULT; Schema: public; Owner: user
--

ALTER TABLE ONLY public."Permissions" ALTER COLUMN id SET DEFAULT nextval('public."Permissions_id_seq"'::regclass);


--
-- Name: ReactionComments id; Type: DEFAULT; Schema: public; Owner: user
--

ALTER TABLE ONLY public."ReactionComments" ALTER COLUMN id SET DEFAULT nextval('public."ReactionComments_id_seq"'::regclass);


--
-- Name: ReactionDiscussions id; Type: DEFAULT; Schema: public; Owner: user
--

ALTER TABLE ONLY public."ReactionDiscussions" ALTER COLUMN id SET DEFAULT nextval('public."ReactionDiscussions_id_seq"'::regclass);


--
-- Name: RolePermissions id; Type: DEFAULT; Schema: public; Owner: user
--

ALTER TABLE ONLY public."RolePermissions" ALTER COLUMN id SET DEFAULT nextval('public."RolePermissions_id_seq"'::regclass);


--
-- Name: Roles id; Type: DEFAULT; Schema: public; Owner: user
--

ALTER TABLE ONLY public."Roles" ALTER COLUMN id SET DEFAULT nextval('public."Roles_id_seq"'::regclass);


--
-- Name: Sessions id; Type: DEFAULT; Schema: public; Owner: user
--

ALTER TABLE ONLY public."Sessions" ALTER COLUMN id SET DEFAULT nextval('public."Sessions_id_seq"'::regclass);


--
-- Name: UserRoles id; Type: DEFAULT; Schema: public; Owner: user
--

ALTER TABLE ONLY public."UserRoles" ALTER COLUMN id SET DEFAULT nextval('public."UserRoles_id_seq"'::regclass);


--
-- Name: Users id; Type: DEFAULT; Schema: public; Owner: user
--

ALTER TABLE ONLY public."Users" ALTER COLUMN id SET DEFAULT nextval('public."Users_id_seq"'::regclass);


--
-- Name: Comments Comments_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public."Comments"
    ADD CONSTRAINT "Comments_pkey" PRIMARY KEY (id);


--
-- Name: Discussions Discussions_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public."Discussions"
    ADD CONSTRAINT "Discussions_pkey" PRIMARY KEY (id);


--
-- Name: Permissions Permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public."Permissions"
    ADD CONSTRAINT "Permissions_pkey" PRIMARY KEY (id);


--
-- Name: ReactionComments ReactionComments_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public."ReactionComments"
    ADD CONSTRAINT "ReactionComments_pkey" PRIMARY KEY (id);


--
-- Name: ReactionDiscussions ReactionDiscussions_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public."ReactionDiscussions"
    ADD CONSTRAINT "ReactionDiscussions_pkey" PRIMARY KEY (id);


--
-- Name: RolePermissions RolePermissions_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public."RolePermissions"
    ADD CONSTRAINT "RolePermissions_pkey" PRIMARY KEY (id);


--
-- Name: Roles Roles_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public."Roles"
    ADD CONSTRAINT "Roles_pkey" PRIMARY KEY (id);


--
-- Name: SequelizeMeta SequelizeMeta_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public."SequelizeMeta"
    ADD CONSTRAINT "SequelizeMeta_pkey" PRIMARY KEY (name);


--
-- Name: Sessions Sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public."Sessions"
    ADD CONSTRAINT "Sessions_pkey" PRIMARY KEY (id);


--
-- Name: UserRoles UserRoles_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public."UserRoles"
    ADD CONSTRAINT "UserRoles_pkey" PRIMARY KEY (id);


--
-- Name: Users Users_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_pkey" PRIMARY KEY (id);


--
-- Name: Comments Comments_discussion_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public."Comments"
    ADD CONSTRAINT "Comments_discussion_id_fkey" FOREIGN KEY (discussion_id) REFERENCES public."Discussions"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Comments Comments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public."Comments"
    ADD CONSTRAINT "Comments_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Discussions Discussions_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public."Discussions"
    ADD CONSTRAINT "Discussions_owner_id_fkey" FOREIGN KEY (owner_id) REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: ReactionComments ReactionComments_comment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public."ReactionComments"
    ADD CONSTRAINT "ReactionComments_comment_id_fkey" FOREIGN KEY (comment_id) REFERENCES public."Comments"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: ReactionComments ReactionComments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public."ReactionComments"
    ADD CONSTRAINT "ReactionComments_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: ReactionDiscussions ReactionDiscussions_disscussion_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public."ReactionDiscussions"
    ADD CONSTRAINT "ReactionDiscussions_disscussion_id_fkey" FOREIGN KEY (disscussion_id) REFERENCES public."Discussions"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: ReactionDiscussions ReactionDiscussions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public."ReactionDiscussions"
    ADD CONSTRAINT "ReactionDiscussions_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: RolePermissions RolePermissions_r_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public."RolePermissions"
    ADD CONSTRAINT "RolePermissions_r_id_fkey" FOREIGN KEY (r_id) REFERENCES public."Roles"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Sessions Sessions_u_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public."Sessions"
    ADD CONSTRAINT "Sessions_u_id_fkey" FOREIGN KEY (u_id) REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: UserRoles UserRoles_r_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public."UserRoles"
    ADD CONSTRAINT "UserRoles_r_id_fkey" FOREIGN KEY (r_id) REFERENCES public."Roles"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: UserRoles UserRoles_u_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public."UserRoles"
    ADD CONSTRAINT "UserRoles_u_id_fkey" FOREIGN KEY (u_id) REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

\unrestrict tm0Wt7CuNHnaREkPBebYY01grIsJbDimiIqW6SxkfQecOzXvk9ScJ3EGn85WbwN

