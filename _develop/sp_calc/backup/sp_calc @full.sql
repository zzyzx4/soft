--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: postgres
--

CREATE OR REPLACE PROCEDURAL LANGUAGE plpgsql;


ALTER PROCEDURAL LANGUAGE plpgsql OWNER TO postgres;

SET search_path = public, pg_catalog;

--
-- Name: breakpoint; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE breakpoint AS (
	func oid,
	linenumber integer,
	targetname text
);


ALTER TYPE public.breakpoint OWNER TO postgres;

--
-- Name: frame; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE frame AS (
	level integer,
	targetname text,
	func oid,
	linenumber integer,
	args text
);


ALTER TYPE public.frame OWNER TO postgres;

--
-- Name: proxyinfo; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE proxyinfo AS (
	serverversionstr text,
	serverversionnum integer,
	proxyapiver integer,
	serverprocessid integer
);


ALTER TYPE public.proxyinfo OWNER TO postgres;

--
-- Name: targetinfo; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE targetinfo AS (
	target oid,
	schema oid,
	nargs integer,
	argtypes oidvector,
	targetname name,
	argmodes "char"[],
	argnames text[],
	targetlang oid,
	fqname text,
	returnsset boolean,
	returntype oid
);


ALTER TYPE public.targetinfo OWNER TO postgres;

--
-- Name: var; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE var AS (
	name text,
	varclass character(1),
	linenumber integer,
	isunique boolean,
	isconst boolean,
	isnotnull boolean,
	dtype oid,
	value text
);


ALTER TYPE public.var OWNER TO postgres;

--
-- Name: pldbg_abort_target(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pldbg_abort_target(session integer) RETURNS SETOF boolean
    LANGUAGE c STRICT
    AS '$libdir/pldbgapi', 'pldbg_abort_target';


ALTER FUNCTION public.pldbg_abort_target(session integer) OWNER TO postgres;

--
-- Name: pldbg_attach_to_port(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pldbg_attach_to_port(portnumber integer) RETURNS integer
    LANGUAGE c STRICT
    AS '$libdir/pldbgapi', 'pldbg_attach_to_port';


ALTER FUNCTION public.pldbg_attach_to_port(portnumber integer) OWNER TO postgres;

--
-- Name: pldbg_continue(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pldbg_continue(session integer) RETURNS breakpoint
    LANGUAGE c STRICT
    AS '$libdir/pldbgapi', 'pldbg_continue';


ALTER FUNCTION public.pldbg_continue(session integer) OWNER TO postgres;

--
-- Name: pldbg_create_listener(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pldbg_create_listener() RETURNS integer
    LANGUAGE c STRICT
    AS '$libdir/pldbgapi', 'pldbg_create_listener';


ALTER FUNCTION public.pldbg_create_listener() OWNER TO postgres;

--
-- Name: pldbg_deposit_value(integer, text, integer, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pldbg_deposit_value(session integer, varname text, linenumber integer, value text) RETURNS boolean
    LANGUAGE c STRICT
    AS '$libdir/pldbgapi', 'pldbg_deposit_value';


ALTER FUNCTION public.pldbg_deposit_value(session integer, varname text, linenumber integer, value text) OWNER TO postgres;

--
-- Name: pldbg_drop_breakpoint(integer, oid, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pldbg_drop_breakpoint(session integer, func oid, linenumber integer) RETURNS boolean
    LANGUAGE c STRICT
    AS '$libdir/pldbgapi', 'pldbg_drop_breakpoint';


ALTER FUNCTION public.pldbg_drop_breakpoint(session integer, func oid, linenumber integer) OWNER TO postgres;

--
-- Name: pldbg_get_breakpoints(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pldbg_get_breakpoints(session integer) RETURNS SETOF breakpoint
    LANGUAGE c STRICT
    AS '$libdir/pldbgapi', 'pldbg_get_breakpoints';


ALTER FUNCTION public.pldbg_get_breakpoints(session integer) OWNER TO postgres;

--
-- Name: pldbg_get_proxy_info(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pldbg_get_proxy_info() RETURNS proxyinfo
    LANGUAGE c STRICT
    AS '$libdir/pldbgapi', 'pldbg_get_proxy_info';


ALTER FUNCTION public.pldbg_get_proxy_info() OWNER TO postgres;

--
-- Name: pldbg_get_source(integer, oid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pldbg_get_source(session integer, func oid) RETURNS text
    LANGUAGE c STRICT
    AS '$libdir/pldbgapi', 'pldbg_get_source';


ALTER FUNCTION public.pldbg_get_source(session integer, func oid) OWNER TO postgres;

--
-- Name: pldbg_get_stack(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pldbg_get_stack(session integer) RETURNS SETOF frame
    LANGUAGE c STRICT
    AS '$libdir/pldbgapi', 'pldbg_get_stack';


ALTER FUNCTION public.pldbg_get_stack(session integer) OWNER TO postgres;

--
-- Name: pldbg_get_target_info(text, "char"); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pldbg_get_target_info(signature text, targettype "char") RETURNS targetinfo
    LANGUAGE c STRICT
    AS '$libdir/targetinfo', 'pldbg_get_target_info';


ALTER FUNCTION public.pldbg_get_target_info(signature text, targettype "char") OWNER TO postgres;

--
-- Name: pldbg_get_variables(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pldbg_get_variables(session integer) RETURNS SETOF var
    LANGUAGE c STRICT
    AS '$libdir/pldbgapi', 'pldbg_get_variables';


ALTER FUNCTION public.pldbg_get_variables(session integer) OWNER TO postgres;

--
-- Name: pldbg_select_frame(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pldbg_select_frame(session integer, frame integer) RETURNS breakpoint
    LANGUAGE c STRICT
    AS '$libdir/pldbgapi', 'pldbg_select_frame';


ALTER FUNCTION public.pldbg_select_frame(session integer, frame integer) OWNER TO postgres;

--
-- Name: pldbg_set_breakpoint(integer, oid, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pldbg_set_breakpoint(session integer, func oid, linenumber integer) RETURNS boolean
    LANGUAGE c STRICT
    AS '$libdir/pldbgapi', 'pldbg_set_breakpoint';


ALTER FUNCTION public.pldbg_set_breakpoint(session integer, func oid, linenumber integer) OWNER TO postgres;

--
-- Name: pldbg_set_global_breakpoint(integer, oid, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pldbg_set_global_breakpoint(session integer, func oid, linenumber integer, targetpid integer) RETURNS boolean
    LANGUAGE c
    AS '$libdir/pldbgapi', 'pldbg_set_global_breakpoint';


ALTER FUNCTION public.pldbg_set_global_breakpoint(session integer, func oid, linenumber integer, targetpid integer) OWNER TO postgres;

--
-- Name: pldbg_step_into(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pldbg_step_into(session integer) RETURNS breakpoint
    LANGUAGE c STRICT
    AS '$libdir/pldbgapi', 'pldbg_step_into';


ALTER FUNCTION public.pldbg_step_into(session integer) OWNER TO postgres;

--
-- Name: pldbg_step_over(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pldbg_step_over(session integer) RETURNS breakpoint
    LANGUAGE c STRICT
    AS '$libdir/pldbgapi', 'pldbg_step_over';


ALTER FUNCTION public.pldbg_step_over(session integer) OWNER TO postgres;

--
-- Name: pldbg_wait_for_breakpoint(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pldbg_wait_for_breakpoint(session integer) RETURNS breakpoint
    LANGUAGE c STRICT
    AS '$libdir/pldbgapi', 'pldbg_wait_for_breakpoint';


ALTER FUNCTION public.pldbg_wait_for_breakpoint(session integer) OWNER TO postgres;

--
-- Name: pldbg_wait_for_target(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pldbg_wait_for_target(session integer) RETURNS integer
    LANGUAGE c STRICT
    AS '$libdir/pldbgapi', 'pldbg_wait_for_target';


ALTER FUNCTION public.pldbg_wait_for_target(session integer) OWNER TO postgres;

--
-- Name: plpgsql_oid_debug(oid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION plpgsql_oid_debug(functionoid oid) RETURNS integer
    LANGUAGE c STRICT
    AS '$libdir/plugins/plugin_debugger', 'plpgsql_oid_debug';


ALTER FUNCTION public.plpgsql_oid_debug(functionoid oid) OWNER TO postgres;

--
-- Name: tripdk_dt-add(date, real); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION "tripdk_dt-add"(dt_date date, dt_amount real) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  tripdk_id NUMERIC;
  dest_id NUMERIC;
  r RECORD;
  r_refbook RECORD;
  kredit REAL;
  dist REAL;
  price REAL;
  bal_in REAL;
BEGIN
INSERT INTO calc_tripdk (a_date, balance_out, kt, dt)
                 VALUES (dt_date, 0, 0, dt_amount);
SELECT currval('calc_tripdk_id_seq') INTO tripdk_id;

kredit=0; -- Водитель наездил
FOR r IN SELECT * FROM calc_triporder WHERE dk_id IS NULL AND a_date<=dt_date
LOOP
  SELECT distance INTO dist FROM calc_routerefbook WHERE id=r.id;
  FOR r_refbook IN SELECT * FROM calc_globalrefbook WHERE name='Бензин' ORDER BY a_date DESC 
  LOOP
    IF r_refbook.a_date<=r.a_date THEN price = r_refbook.num_value; EXIT; END IF;
  END LOOP;
  -- RAISE NOTICE 'dist = %', dist;
  kredit=kredit+dist*price;
  UPDATE calc_triporder SET dk_id=tripdk_id WHERE id=r.id;
END LOOP;
SELECT balance_out INTO bal_in FROM calc_tripdk WHERE a_date<dt_date ORDER BY a_date DESC FETCH FIRST ROW ONLY; 

IF bal_in IS NULL THEN bal_in=0; END IF;

UPDATE calc_tripdk SET kt=kredit, balance_out=bal_in+kredit-dt_amount;

END;
$$;


ALTER FUNCTION public."tripdk_dt-add"(dt_date date, dt_amount real) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE auth_group (
    id integer NOT NULL,
    name character varying(80) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO postgres;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_id_seq OWNER TO postgres;

--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE auth_group_id_seq OWNED BY auth_group.id;


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('auth_group_id_seq', 1, false);


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO postgres;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_permissions_id_seq OWNER TO postgres;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE auth_group_permissions_id_seq OWNED BY auth_group_permissions.id;


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('auth_group_permissions_id_seq', 1, false);


--
-- Name: auth_message; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE auth_message (
    id integer NOT NULL,
    user_id integer NOT NULL,
    message text NOT NULL
);


ALTER TABLE public.auth_message OWNER TO postgres;

--
-- Name: auth_message_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE auth_message_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_message_id_seq OWNER TO postgres;

--
-- Name: auth_message_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE auth_message_id_seq OWNED BY auth_message.id;


--
-- Name: auth_message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('auth_message_id_seq', 1, false);


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE auth_permission (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO postgres;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_permission_id_seq OWNER TO postgres;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE auth_permission_id_seq OWNED BY auth_permission.id;


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('auth_permission_id_seq', 204, true);


--
-- Name: auth_user; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE auth_user (
    id integer NOT NULL,
    username character varying(30) NOT NULL,
    first_name character varying(30) NOT NULL,
    last_name character varying(30) NOT NULL,
    email character varying(75) NOT NULL,
    password character varying(128) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    is_superuser boolean NOT NULL,
    last_login timestamp with time zone NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


ALTER TABLE public.auth_user OWNER TO postgres;

--
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE auth_user_groups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.auth_user_groups OWNER TO postgres;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_groups_id_seq OWNER TO postgres;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE auth_user_groups_id_seq OWNED BY auth_user_groups.id;


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('auth_user_groups_id_seq', 1, false);


--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_id_seq OWNER TO postgres;

--
-- Name: auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE auth_user_id_seq OWNED BY auth_user.id;


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('auth_user_id_seq', 1, true);


--
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE auth_user_user_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_user_user_permissions OWNER TO postgres;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_user_permissions_id_seq OWNER TO postgres;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE auth_user_user_permissions_id_seq OWNED BY auth_user_user_permissions.id;


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('auth_user_user_permissions_id_seq', 1, false);


--
-- Name: calc_client; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE calc_client (
    id integer NOT NULL,
    first_name character varying(30) NOT NULL,
    last_name character varying(40) NOT NULL,
    tel character(10),
    other_data character(50),
    email character(30)
);


ALTER TABLE public.calc_client OWNER TO postgres;

--
-- Name: calc_client_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE calc_client_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.calc_client_id_seq OWNER TO postgres;

--
-- Name: calc_client_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE calc_client_id_seq OWNED BY calc_client.id;


--
-- Name: calc_client_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('calc_client_id_seq', 11, true);


--
-- Name: calc_employee; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE calc_employee (
    id integer NOT NULL,
    first_name character varying(30) NOT NULL,
    last_name character varying(30) NOT NULL,
    hire_date date NOT NULL,
    dismissal_date date
);


ALTER TABLE public.calc_employee OWNER TO postgres;

--
-- Name: calc_employee_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE calc_employee_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.calc_employee_id_seq OWNER TO postgres;

--
-- Name: calc_employee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE calc_employee_id_seq OWNED BY calc_employee.id;


--
-- Name: calc_employee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('calc_employee_id_seq', 12, true);


--
-- Name: calc_employeeposition; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE calc_employeeposition (
    id integer NOT NULL,
    title character varying(15) NOT NULL
);


ALTER TABLE public.calc_employeeposition OWNER TO postgres;

--
-- Name: calc_employeeposition_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE calc_employeeposition_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.calc_employeeposition_id_seq OWNER TO postgres;

--
-- Name: calc_employeeposition_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE calc_employeeposition_id_seq OWNED BY calc_employeeposition.id;


--
-- Name: calc_employeeposition_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('calc_employeeposition_id_seq', 1, false);


--
-- Name: calc_globalrefbook; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE calc_globalrefbook (
    id integer NOT NULL,
    name character varying(128) NOT NULL,
    a_date date NOT NULL,
    num_value double precision,
    str_value character varying(128)
);


ALTER TABLE public.calc_globalrefbook OWNER TO postgres;

--
-- Name: calc_globalrefbook_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE calc_globalrefbook_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.calc_globalrefbook_id_seq OWNER TO postgres;

--
-- Name: calc_globalrefbook_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE calc_globalrefbook_id_seq OWNED BY calc_globalrefbook.id;


--
-- Name: calc_globalrefbook_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('calc_globalrefbook_id_seq', 2, true);


--
-- Name: calc_machine; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE calc_machine (
    id integer NOT NULL,
    m_name character varying(31) NOT NULL,
    note character varying(127) NOT NULL,
    plate_id integer NOT NULL,
    pu_amount integer NOT NULL,
    density_min integer NOT NULL,
    density_max integer NOT NULL,
    width_min integer NOT NULL,
    width_max integer NOT NULL,
    height_min integer NOT NULL,
    height_max integer NOT NULL,
    head_space integer NOT NULL
);


ALTER TABLE public.calc_machine OWNER TO postgres;

--
-- Name: calc_machine_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE calc_machine_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.calc_machine_id_seq OWNER TO postgres;

--
-- Name: calc_machine_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE calc_machine_id_seq OWNED BY calc_machine.id;


--
-- Name: calc_machine_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('calc_machine_id_seq', 3, true);


--
-- Name: calc_machine_paper_type; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE calc_machine_paper_type (
    id integer NOT NULL,
    machine_id integer NOT NULL,
    materialtype_id integer NOT NULL
);


ALTER TABLE public.calc_machine_paper_type OWNER TO postgres;

--
-- Name: calc_machine_paper_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE calc_machine_paper_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.calc_machine_paper_type_id_seq OWNER TO postgres;

--
-- Name: calc_machine_paper_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE calc_machine_paper_type_id_seq OWNED BY calc_machine_paper_type.id;


--
-- Name: calc_machine_paper_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('calc_machine_paper_type_id_seq', 9, true);


--
-- Name: calc_material; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE calc_material (
    id integer NOT NULL,
    title character varying(50) NOT NULL,
    material_type_id integer NOT NULL,
    height integer,
    density integer,
    thickness double precision,
    length integer,
    price_id integer,
    width integer
);


ALTER TABLE public.calc_material OWNER TO postgres;

--
-- Name: calc_material_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE calc_material_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.calc_material_id_seq OWNER TO postgres;

--
-- Name: calc_material_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE calc_material_id_seq OWNED BY calc_material.id;


--
-- Name: calc_material_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('calc_material_id_seq', 78, true);


--
-- Name: calc_materialprice; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE calc_materialprice (
    id integer NOT NULL,
    material_id integer NOT NULL,
    supplier_id integer NOT NULL,
    start_date date NOT NULL,
    end_date date,
    price double precision NOT NULL,
    packing real NOT NULL,
    nomen_title character varying(50)
);


ALTER TABLE public.calc_materialprice OWNER TO postgres;

--
-- Name: calc_materialprice_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE calc_materialprice_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.calc_materialprice_id_seq OWNER TO postgres;

--
-- Name: calc_materialprice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE calc_materialprice_id_seq OWNED BY calc_materialprice.id;


--
-- Name: calc_materialprice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('calc_materialprice_id_seq', 115, true);


--
-- Name: calc_materialtype; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE calc_materialtype (
    id integer NOT NULL,
    title character varying(50) NOT NULL,
    unit_of_meas character varying(8) NOT NULL,
    one_for_order boolean NOT NULL,
    type_group_id integer
);


ALTER TABLE public.calc_materialtype OWNER TO postgres;

--
-- Name: calc_materialtype_group; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE calc_materialtype_group (
    id integer NOT NULL,
    title character varying(32) NOT NULL
);


ALTER TABLE public.calc_materialtype_group OWNER TO postgres;

--
-- Name: calc_materialtype_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE calc_materialtype_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.calc_materialtype_group_id_seq OWNER TO postgres;

--
-- Name: calc_materialtype_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE calc_materialtype_group_id_seq OWNED BY calc_materialtype_group.id;


--
-- Name: calc_materialtype_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('calc_materialtype_group_id_seq', 4, true);


--
-- Name: calc_materialtype_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE calc_materialtype_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.calc_materialtype_id_seq OWNER TO postgres;

--
-- Name: calc_materialtype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE calc_materialtype_id_seq OWNED BY calc_materialtype.id;


--
-- Name: calc_materialtype_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('calc_materialtype_id_seq', 30, true);


--
-- Name: calc_order; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE calc_order (
    id integer NOT NULL,
    title character varying(100) NOT NULL,
    client_id integer NOT NULL,
    order_date date NOT NULL,
    deadline_date date,
    start_date date,
    end_date date,
    order_type_id integer NOT NULL,
    size_type_id integer NOT NULL,
    circ integer NOT NULL,
    price double precision,
    page_amount integer
);


ALTER TABLE public.calc_order OWNER TO postgres;

--
-- Name: calc_order_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE calc_order_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.calc_order_id_seq OWNER TO postgres;

--
-- Name: calc_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE calc_order_id_seq OWNED BY calc_order.id;


--
-- Name: calc_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('calc_order_id_seq', 27, true);


--
-- Name: calc_ordertype; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE calc_ordertype (
    id integer NOT NULL,
    title character varying(50) NOT NULL,
    description character varying(255) NOT NULL,
    singlesheet boolean NOT NULL
);


ALTER TABLE public.calc_ordertype OWNER TO postgres;

--
-- Name: calc_ordertype_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE calc_ordertype_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.calc_ordertype_id_seq OWNER TO postgres;

--
-- Name: calc_ordertype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE calc_ordertype_id_seq OWNED BY calc_ordertype.id;


--
-- Name: calc_ordertype_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('calc_ordertype_id_seq', 1, false);


--
-- Name: calc_ordertype_press_type; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE calc_ordertype_press_type (
    id integer NOT NULL,
    ordertype_id integer NOT NULL,
    presstype_id integer NOT NULL
);


ALTER TABLE public.calc_ordertype_press_type OWNER TO postgres;

--
-- Name: calc_ordertype_press_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE calc_ordertype_press_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.calc_ordertype_press_type_id_seq OWNER TO postgres;

--
-- Name: calc_ordertype_press_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE calc_ordertype_press_type_id_seq OWNED BY calc_ordertype_press_type.id;


--
-- Name: calc_ordertype_press_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('calc_ordertype_press_type_id_seq', 1, false);


--
-- Name: calc_ordertype_size_type; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE calc_ordertype_size_type (
    id integer NOT NULL,
    ordertype_id integer NOT NULL,
    sizetype_id integer NOT NULL
);


ALTER TABLE public.calc_ordertype_size_type OWNER TO postgres;

--
-- Name: calc_ordertype_size_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE calc_ordertype_size_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.calc_ordertype_size_type_id_seq OWNER TO postgres;

--
-- Name: calc_ordertype_size_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('calc_ordertype_size_type_id_seq', 1, true);


--
-- Name: calc_ordertype_size_type_id_seq1; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE calc_ordertype_size_type_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.calc_ordertype_size_type_id_seq1 OWNER TO postgres;

--
-- Name: calc_ordertype_size_type_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE calc_ordertype_size_type_id_seq1 OWNED BY calc_ordertype_size_type.id;


--
-- Name: calc_ordertype_size_type_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('calc_ordertype_size_type_id_seq1', 1, false);


--
-- Name: calc_ordertype_work_type; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE calc_ordertype_work_type (
    id integer NOT NULL,
    ordertype_id integer NOT NULL,
    worktype_id integer NOT NULL
);


ALTER TABLE public.calc_ordertype_work_type OWNER TO postgres;

--
-- Name: calc_ordertype_work_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE calc_ordertype_work_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.calc_ordertype_work_type_id_seq OWNER TO postgres;

--
-- Name: calc_ordertype_work_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE calc_ordertype_work_type_id_seq OWNED BY calc_ordertype_work_type.id;


--
-- Name: calc_ordertype_work_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('calc_ordertype_work_type_id_seq', 1, false);


--
-- Name: calc_positionsalary; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE calc_positionsalary (
    id integer NOT NULL,
    employee_position_id integer NOT NULL,
    salary integer,
    human_hour_salary integer,
    start_date date NOT NULL
);


ALTER TABLE public.calc_positionsalary OWNER TO postgres;

--
-- Name: calc_positionsalary_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE calc_positionsalary_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.calc_positionsalary_id_seq OWNER TO postgres;

--
-- Name: calc_positionsalary_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE calc_positionsalary_id_seq OWNED BY calc_positionsalary.id;


--
-- Name: calc_positionsalary_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('calc_positionsalary_id_seq', 1, false);


--
-- Name: calc_pressconsumptionnorm; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE calc_pressconsumptionnorm (
    id integer NOT NULL,
    press_type_id integer NOT NULL,
    material_id integer NOT NULL,
    amount double precision NOT NULL
);


ALTER TABLE public.calc_pressconsumptionnorm OWNER TO postgres;

--
-- Name: calc_pressconsumptionnorm_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE calc_pressconsumptionnorm_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.calc_pressconsumptionnorm_id_seq OWNER TO postgres;

--
-- Name: calc_pressconsumptionnorm_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE calc_pressconsumptionnorm_id_seq OWNED BY calc_pressconsumptionnorm.id;


--
-- Name: calc_pressconsumptionnorm_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('calc_pressconsumptionnorm_id_seq', 8, true);


--
-- Name: calc_pressdata; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE calc_pressdata (
    id integer NOT NULL,
    order_id integer NOT NULL,
    press_type_id integer,
    sheet_amount integer NOT NULL,
    paper_amount integer NOT NULL,
    paper_id integer NOT NULL,
    note character varying(200) NOT NULL
);


ALTER TABLE public.calc_pressdata OWNER TO postgres;

--
-- Name: calc_pressdata_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE calc_pressdata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.calc_pressdata_id_seq OWNER TO postgres;

--
-- Name: calc_pressdata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE calc_pressdata_id_seq OWNED BY calc_pressdata.id;


--
-- Name: calc_pressdata_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('calc_pressdata_id_seq', 1, false);


--
-- Name: calc_pressout; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE calc_pressout (
    id integer NOT NULL,
    employee_id integer NOT NULL,
    press_data_id integer NOT NULL,
    sheet_count integer NOT NULL,
    a_date date NOT NULL,
    duration double precision NOT NULL,
    note character varying(200) NOT NULL
);


ALTER TABLE public.calc_pressout OWNER TO postgres;

--
-- Name: calc_pressout_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE calc_pressout_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.calc_pressout_id_seq OWNER TO postgres;

--
-- Name: calc_pressout_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE calc_pressout_id_seq OWNED BY calc_pressout.id;


--
-- Name: calc_pressout_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('calc_pressout_id_seq', 1, false);


--
-- Name: calc_pressprice; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE calc_pressprice (
    id integer NOT NULL,
    press_type_id integer NOT NULL,
    fitting_charge double precision NOT NULL,
    item_charge double precision NOT NULL,
    start_date date NOT NULL
);


ALTER TABLE public.calc_pressprice OWNER TO postgres;

--
-- Name: calc_pressprice_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE calc_pressprice_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.calc_pressprice_id_seq OWNER TO postgres;

--
-- Name: calc_pressprice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE calc_pressprice_id_seq OWNED BY calc_pressprice.id;


--
-- Name: calc_pressprice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('calc_pressprice_id_seq', 2, true);


--
-- Name: calc_presstype; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE calc_presstype (
    id integer NOT NULL,
    title character varying(50) NOT NULL,
    machine_id integer NOT NULL,
    paper_type_id integer NOT NULL,
    fitting_time double precision NOT NULL,
    fitting_paper integer NOT NULL,
    press_speed integer NOT NULL,
    iter_amount integer NOT NULL,
    turn boolean,
    selfback boolean
);


ALTER TABLE public.calc_presstype OWNER TO postgres;

--
-- Name: calc_presstype_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE calc_presstype_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.calc_presstype_id_seq OWNER TO postgres;

--
-- Name: calc_presstype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE calc_presstype_id_seq OWNED BY calc_presstype.id;


--
-- Name: calc_presstype_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('calc_presstype_id_seq', 4, true);


--
-- Name: calc_pricecutoff; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE calc_pricecutoff (
    id integer NOT NULL,
    order_id integer NOT NULL
);


ALTER TABLE public.calc_pricecutoff OWNER TO postgres;

--
-- Name: calc_pricecutoff_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE calc_pricecutoff_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.calc_pricecutoff_id_seq OWNER TO postgres;

--
-- Name: calc_pricecutoff_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE calc_pricecutoff_id_seq OWNED BY calc_pricecutoff.id;


--
-- Name: calc_pricecutoff_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('calc_pricecutoff_id_seq', 1, false);


--
-- Name: calc_routerefbook; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE calc_routerefbook (
    id integer NOT NULL,
    dest_name character varying(128) NOT NULL,
    distance double precision NOT NULL
);


ALTER TABLE public.calc_routerefbook OWNER TO postgres;

--
-- Name: calc_routerefbook_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE calc_routerefbook_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.calc_routerefbook_id_seq OWNER TO postgres;

--
-- Name: calc_routerefbook_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE calc_routerefbook_id_seq OWNED BY calc_routerefbook.id;


--
-- Name: calc_routerefbook_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('calc_routerefbook_id_seq', 13, true);


--
-- Name: calc_sizetype; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE calc_sizetype (
    id integer NOT NULL,
    title character varying(50) NOT NULL,
    width integer,
    height integer
);


ALTER TABLE public.calc_sizetype OWNER TO postgres;

--
-- Name: calc_sizetype_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE calc_sizetype_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.calc_sizetype_id_seq OWNER TO postgres;

--
-- Name: calc_sizetype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE calc_sizetype_id_seq OWNED BY calc_sizetype.id;


--
-- Name: calc_sizetype_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('calc_sizetype_id_seq', 3, true);


--
-- Name: calc_supplier; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE calc_supplier (
    id integer NOT NULL,
    title character varying(50) NOT NULL,
    telno character varying(40) NOT NULL,
    note character varying(100) NOT NULL
);


ALTER TABLE public.calc_supplier OWNER TO postgres;

--
-- Name: calc_supplier_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE calc_supplier_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.calc_supplier_id_seq OWNER TO postgres;

--
-- Name: calc_supplier_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE calc_supplier_id_seq OWNED BY calc_supplier.id;


--
-- Name: calc_supplier_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('calc_supplier_id_seq', 30, true);


--
-- Name: calc_tripdk; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE calc_tripdk (
    id integer NOT NULL,
    a_date date NOT NULL,
    employee_id integer NOT NULL,
    kt double precision NOT NULL,
    dt double precision NOT NULL,
    balance_out double precision NOT NULL
);


ALTER TABLE public.calc_tripdk OWNER TO postgres;

--
-- Name: calc_tripdk_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE calc_tripdk_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.calc_tripdk_id_seq OWNER TO postgres;

--
-- Name: calc_tripdk_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE calc_tripdk_id_seq OWNED BY calc_tripdk.id;


--
-- Name: calc_tripdk_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('calc_tripdk_id_seq', 1, false);


--
-- Name: calc_triporder; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE calc_triporder (
    id integer NOT NULL,
    a_date date NOT NULL,
    employee_id integer NOT NULL,
    destination_id integer NOT NULL,
    dk_id integer
);


ALTER TABLE public.calc_triporder OWNER TO postgres;

--
-- Name: calc_triporder_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE calc_triporder_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.calc_triporder_id_seq OWNER TO postgres;

--
-- Name: calc_triporder_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE calc_triporder_id_seq OWNED BY calc_triporder.id;


--
-- Name: calc_triporder_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('calc_triporder_id_seq', 1, false);


--
-- Name: calc_workconsumptionnorm; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE calc_workconsumptionnorm (
    id integer NOT NULL,
    work_type_id integer NOT NULL,
    material_id integer NOT NULL,
    amount double precision NOT NULL
);


ALTER TABLE public.calc_workconsumptionnorm OWNER TO postgres;

--
-- Name: calc_workconsumptionnorm_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE calc_workconsumptionnorm_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.calc_workconsumptionnorm_id_seq OWNER TO postgres;

--
-- Name: calc_workconsumptionnorm_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE calc_workconsumptionnorm_id_seq OWNED BY calc_workconsumptionnorm.id;


--
-- Name: calc_workconsumptionnorm_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('calc_workconsumptionnorm_id_seq', 1, false);


--
-- Name: calc_workdata; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE calc_workdata (
    id integer NOT NULL,
    order_id integer NOT NULL,
    work_type_id integer NOT NULL,
    work_amount integer NOT NULL,
    note character varying(200) NOT NULL
);


ALTER TABLE public.calc_workdata OWNER TO postgres;

--
-- Name: calc_workdata_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE calc_workdata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.calc_workdata_id_seq OWNER TO postgres;

--
-- Name: calc_workdata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE calc_workdata_id_seq OWNED BY calc_workdata.id;


--
-- Name: calc_workdata_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('calc_workdata_id_seq', 66, true);


--
-- Name: calc_workdata_material; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE calc_workdata_material (
    id integer NOT NULL,
    workdata_id integer NOT NULL,
    materialsubtype_id integer NOT NULL
);


ALTER TABLE public.calc_workdata_material OWNER TO postgres;

--
-- Name: calc_workdata_material_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE calc_workdata_material_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.calc_workdata_material_id_seq OWNER TO postgres;

--
-- Name: calc_workdata_material_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE calc_workdata_material_id_seq OWNED BY calc_workdata_material.id;


--
-- Name: calc_workdata_material_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('calc_workdata_material_id_seq', 34, true);


--
-- Name: calc_workout; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE calc_workout (
    id integer NOT NULL,
    employee_id integer NOT NULL,
    work_data_id integer NOT NULL,
    count integer NOT NULL,
    a_date date NOT NULL,
    duration double precision NOT NULL,
    note character varying(200) NOT NULL
);


ALTER TABLE public.calc_workout OWNER TO postgres;

--
-- Name: calc_workout_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE calc_workout_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.calc_workout_id_seq OWNER TO postgres;

--
-- Name: calc_workout_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE calc_workout_id_seq OWNED BY calc_workout.id;


--
-- Name: calc_workout_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('calc_workout_id_seq', 132, true);


--
-- Name: calc_worktype; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE calc_worktype (
    id integer NOT NULL,
    title character varying(50) NOT NULL,
    fitting_charge double precision NOT NULL,
    item_charge double precision NOT NULL
);


ALTER TABLE public.calc_worktype OWNER TO postgres;

--
-- Name: calc_worktype_default_materials; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE calc_worktype_default_materials (
    id integer NOT NULL,
    worktype_id integer NOT NULL,
    materialsubtype_id integer NOT NULL
);


ALTER TABLE public.calc_worktype_default_materials OWNER TO postgres;

--
-- Name: calc_worktype_default_materials_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE calc_worktype_default_materials_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.calc_worktype_default_materials_id_seq OWNER TO postgres;

--
-- Name: calc_worktype_default_materials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE calc_worktype_default_materials_id_seq OWNED BY calc_worktype_default_materials.id;


--
-- Name: calc_worktype_default_materials_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('calc_worktype_default_materials_id_seq', 15, true);


--
-- Name: calc_worktype_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE calc_worktype_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.calc_worktype_id_seq OWNER TO postgres;

--
-- Name: calc_worktype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE calc_worktype_id_seq OWNED BY calc_worktype.id;


--
-- Name: calc_worktype_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('calc_worktype_id_seq', 27, true);


--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    user_id integer NOT NULL,
    content_type_id integer,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log OWNER TO postgres;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_admin_log_id_seq OWNER TO postgres;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE django_admin_log_id_seq OWNED BY django_admin_log.id;


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('django_admin_log_id_seq', 799, true);


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE django_content_type (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO postgres;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_content_type_id_seq OWNER TO postgres;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE django_content_type_id_seq OWNED BY django_content_type.id;


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('django_content_type_id_seq', 68, true);


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO postgres;

--
-- Name: django_site; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE django_site (
    id integer NOT NULL,
    domain character varying(100) NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.django_site OWNER TO postgres;

--
-- Name: django_site_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE django_site_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_site_id_seq OWNER TO postgres;

--
-- Name: django_site_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE django_site_id_seq OWNED BY django_site.id;


--
-- Name: django_site_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('django_site_id_seq', 1, true);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE auth_group ALTER COLUMN id SET DEFAULT nextval('auth_group_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('auth_group_permissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE auth_message ALTER COLUMN id SET DEFAULT nextval('auth_message_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE auth_permission ALTER COLUMN id SET DEFAULT nextval('auth_permission_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE auth_user ALTER COLUMN id SET DEFAULT nextval('auth_user_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE auth_user_groups ALTER COLUMN id SET DEFAULT nextval('auth_user_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('auth_user_user_permissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE calc_client ALTER COLUMN id SET DEFAULT nextval('calc_client_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE calc_employee ALTER COLUMN id SET DEFAULT nextval('calc_employee_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE calc_employeeposition ALTER COLUMN id SET DEFAULT nextval('calc_employeeposition_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE calc_globalrefbook ALTER COLUMN id SET DEFAULT nextval('calc_globalrefbook_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE calc_machine ALTER COLUMN id SET DEFAULT nextval('calc_machine_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE calc_machine_paper_type ALTER COLUMN id SET DEFAULT nextval('calc_machine_paper_type_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE calc_material ALTER COLUMN id SET DEFAULT nextval('calc_material_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE calc_materialprice ALTER COLUMN id SET DEFAULT nextval('calc_materialprice_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE calc_materialtype ALTER COLUMN id SET DEFAULT nextval('calc_materialtype_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE calc_materialtype_group ALTER COLUMN id SET DEFAULT nextval('calc_materialtype_group_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE calc_order ALTER COLUMN id SET DEFAULT nextval('calc_order_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE calc_ordertype ALTER COLUMN id SET DEFAULT nextval('calc_ordertype_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE calc_ordertype_press_type ALTER COLUMN id SET DEFAULT nextval('calc_ordertype_press_type_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE calc_ordertype_size_type ALTER COLUMN id SET DEFAULT nextval('calc_ordertype_size_type_id_seq1'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE calc_ordertype_work_type ALTER COLUMN id SET DEFAULT nextval('calc_ordertype_work_type_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE calc_positionsalary ALTER COLUMN id SET DEFAULT nextval('calc_positionsalary_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE calc_pressconsumptionnorm ALTER COLUMN id SET DEFAULT nextval('calc_pressconsumptionnorm_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE calc_pressdata ALTER COLUMN id SET DEFAULT nextval('calc_pressdata_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE calc_pressout ALTER COLUMN id SET DEFAULT nextval('calc_pressout_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE calc_pressprice ALTER COLUMN id SET DEFAULT nextval('calc_pressprice_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE calc_presstype ALTER COLUMN id SET DEFAULT nextval('calc_presstype_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE calc_pricecutoff ALTER COLUMN id SET DEFAULT nextval('calc_pricecutoff_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE calc_routerefbook ALTER COLUMN id SET DEFAULT nextval('calc_routerefbook_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE calc_sizetype ALTER COLUMN id SET DEFAULT nextval('calc_sizetype_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE calc_supplier ALTER COLUMN id SET DEFAULT nextval('calc_supplier_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE calc_tripdk ALTER COLUMN id SET DEFAULT nextval('calc_tripdk_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE calc_triporder ALTER COLUMN id SET DEFAULT nextval('calc_triporder_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE calc_workconsumptionnorm ALTER COLUMN id SET DEFAULT nextval('calc_workconsumptionnorm_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE calc_workdata ALTER COLUMN id SET DEFAULT nextval('calc_workdata_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE calc_workdata_material ALTER COLUMN id SET DEFAULT nextval('calc_workdata_material_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE calc_workout ALTER COLUMN id SET DEFAULT nextval('calc_workout_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE calc_worktype ALTER COLUMN id SET DEFAULT nextval('calc_worktype_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE calc_worktype_default_materials ALTER COLUMN id SET DEFAULT nextval('calc_worktype_default_materials_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE django_admin_log ALTER COLUMN id SET DEFAULT nextval('django_admin_log_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE django_content_type ALTER COLUMN id SET DEFAULT nextval('django_content_type_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE django_site ALTER COLUMN id SET DEFAULT nextval('django_site_id_seq'::regclass);


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY auth_group (id, name) FROM stdin;
\.


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Data for Name: auth_message; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY auth_message (id, user_id, message) FROM stdin;
\.


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add permission	1	add_permission
2	Can change permission	1	change_permission
3	Can delete permission	1	delete_permission
4	Can add group	2	add_group
5	Can change group	2	change_group
6	Can delete group	2	delete_group
7	Can add user	3	add_user
8	Can change user	3	change_user
9	Can delete user	3	delete_user
13	Can add content type	5	add_contenttype
14	Can change content type	5	change_contenttype
15	Can delete content type	5	delete_contenttype
16	Can add session	6	add_session
17	Can change session	6	change_session
18	Can delete session	6	delete_session
19	Can add site	7	add_site
20	Can change site	7	change_site
21	Can delete site	7	delete_site
31	Can add log entry	11	add_logentry
32	Can change log entry	11	change_logentry
33	Can delete log entry	11	delete_logentry
49	Can add client	17	add_client
50	Can change client	17	change_client
51	Can delete client	17	delete_client
55	Can add order	19	add_order
56	Can change order	19	change_order
57	Can delete order	19	delete_order
64	Can add press type	22	add_presstype
65	Can change press type	22	change_presstype
66	Can delete press type	22	delete_presstype
67	Can add work type	23	add_worktype
68	Can change work type	23	change_worktype
69	Can delete work type	23	delete_worktype
70	Can add order type	24	add_ordertype
71	Can change order type	24	change_ordertype
72	Can delete order type	24	delete_ordertype
73	Can add supplier	25	add_supplier
74	Can change supplier	25	change_supplier
75	Can delete supplier	25	delete_supplier
82	Can add work data	28	add_workdata
83	Can change work data	28	change_workdata
84	Can delete work data	28	delete_workdata
85	Can add material type	29	add_materialtype
86	Can change material type	29	change_materialtype
87	Can delete material type	29	delete_materialtype
88	Can add material subtype	30	add_materialsubtype
89	Can change material subtype	30	change_materialsubtype
90	Can delete material subtype	30	delete_materialsubtype
91	Can add material price	31	add_materialprice
92	Can change material price	31	change_materialprice
93	Can delete material price	31	delete_materialprice
94	Can add press data	32	add_pressdata
95	Can change press data	32	change_pressdata
96	Can delete press data	32	delete_pressdata
97	Can add size type	33	add_sizetype
98	Can change size type	33	change_sizetype
99	Can delete size type	33	delete_sizetype
100	Can add employee	34	add_employee
101	Can change employee	34	change_employee
102	Can delete employee	34	delete_employee
103	Can add workout	35	add_workout
104	Can change workout	35	change_workout
105	Can delete workout	35	delete_workout
106	Can add client	36	add_client
107	Can change client	36	change_client
108	Can delete client	36	delete_client
109	Can add supplier	37	add_supplier
110	Can change supplier	37	change_supplier
111	Can delete supplier	37	delete_supplier
112	Can add press type	38	add_presstype
113	Can change press type	38	change_presstype
114	Can delete press type	38	delete_presstype
115	Can add material type	39	add_materialtype
116	Can change material type	39	change_materialtype
117	Can delete material type	39	delete_materialtype
121	Can add work type	41	add_worktype
122	Can change work type	41	change_worktype
123	Can delete work type	41	delete_worktype
124	Can add order type	42	add_ordertype
125	Can change order type	42	change_ordertype
126	Can delete order type	42	delete_ordertype
127	Can add material price	43	add_materialprice
128	Can change material price	43	change_materialprice
129	Can delete material price	43	delete_materialprice
130	Can add size type	44	add_sizetype
131	Can change size type	44	change_sizetype
132	Can delete size type	44	delete_sizetype
133	Can add order	45	add_order
134	Can change order	45	change_order
135	Can delete order	45	delete_order
136	Can add press data	46	add_pressdata
137	Can change press data	46	change_pressdata
138	Can delete press data	46	delete_pressdata
139	Can add work data	47	add_workdata
140	Can change work data	47	change_workdata
141	Can delete work data	47	delete_workdata
142	Can add employee	48	add_employee
143	Can change employee	48	change_employee
144	Can delete employee	48	delete_employee
145	Can add workout	49	add_workout
146	Can change workout	49	change_workout
147	Can delete workout	49	delete_workout
148	Can add pressout	50	add_pressout
149	Can change pressout	50	change_pressout
150	Can delete pressout	50	delete_pressout
151	Can add material	51	add_material
152	Can change material	51	change_material
153	Can delete material	51	delete_material
157	Can add machine	53	add_machine
158	Can change machine	53	change_machine
159	Can delete machine	53	delete_machine
163	Can add material type_ group	55	add_materialtype_group
164	Can change material type_ group	55	change_materialtype_group
165	Can delete material type_ group	55	delete_materialtype_group
166	Can add press consumption norm	56	add_pressconsumptionnorm
167	Can change press consumption norm	56	change_pressconsumptionnorm
168	Can delete press consumption norm	56	delete_pressconsumptionnorm
169	Can add press price	57	add_pressprice
170	Can change press price	57	change_pressprice
171	Can delete press price	57	delete_pressprice
172	Can add work consumption norm	58	add_workconsumptionnorm
173	Can change work consumption norm	58	change_workconsumptionnorm
174	Can delete work consumption norm	58	delete_workconsumptionnorm
178	Can add price cutoff	60	add_pricecutoff
179	Can change price cutoff	60	change_pricecutoff
180	Can delete price cutoff	60	delete_pricecutoff
184	Can add global refbook	62	add_globalrefbook
185	Can change global refbook	62	change_globalrefbook
186	Can delete global refbook	62	delete_globalrefbook
187	Can add route refbook	63	add_routerefbook
188	Can change route refbook	63	change_routerefbook
189	Can delete route refbook	63	delete_routerefbook
190	Can add trip dk	64	add_tripdk
191	Can change trip dk	64	change_tripdk
192	Can delete trip dk	64	delete_tripdk
196	Can add trip order	66	add_triporder
197	Can change trip order	66	change_triporder
198	Can delete trip order	66	delete_triporder
199	Can add employee position	67	add_employeeposition
200	Can change employee position	67	change_employeeposition
201	Can delete employee position	67	delete_employeeposition
202	Can add position salary	68	add_positionsalary
203	Can change position salary	68	change_positionsalary
204	Can delete position salary	68	delete_positionsalary
\.


--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY auth_user (id, username, first_name, last_name, email, password, is_staff, is_active, is_superuser, last_login, date_joined) FROM stdin;
1	admin			admin@admin.com	pbkdf2_sha256$12000$tG6eoiRxu2oB$BElm+i9bPmeb9R+4xtI7IxXIL7vKyeguJAIRXI0PzpA=	t	t	t	2015-09-07 15:48:22.467+07	2011-08-31 06:03:24.499+07
\.


--
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY auth_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Data for Name: calc_client; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY calc_client (id, first_name, last_name, tel, other_data, email) FROM stdin;
1	ИП Какойтович		\N	\N	\N
2	Андрей		\N	\N	\N
3	Клиент с пригласительным		\N	\N	\N
4	Намаз		\N	\N	\N
5	Институт учителей		\N	\N	\N
6	Акнур		\N	\N	\N
7	Гайворонский		\N	\N	\N
8	Ана Мен Бала		\N	\N	\N
9	Шашкин		\N	\N	\N
10	Роза Бектаевна		111       	                                                  	                              
11	Канат	Серикпаев	111-11-11 	                                                  	                              
\.


--
-- Data for Name: calc_employee; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY calc_employee (id, first_name, last_name, hire_date, dismissal_date) FROM stdin;
1	Екатерина	Василиади	2011-01-01	\N
2	Шерен	Анварова	2011-01-01	\N
11	Оксана	Нурбаева	2011-01-01	\N
3	Уля	Бектемирова	2011-01-01	\N
4	Татьяна	Дарницина	2011-01-01	\N
5	Светлана	Чевычалова	2011-01-01	\N
6	Алия	Ажибаева	2011-01-01	\N
7	Мухаббат	Саитова	2011-01-01	\N
8	Маша	Русинова	2011-01-01	\N
9	Елена	Болкун	2011-01-01	\N
10	Гульмира		2011-01-01	\N
12	Елена	Кучина	2011-01-01	\N
\.


--
-- Data for Name: calc_employeeposition; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY calc_employeeposition (id, title) FROM stdin;
\.


--
-- Data for Name: calc_globalrefbook; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY calc_globalrefbook (id, name, a_date, num_value, str_value) FROM stdin;
2	Бензин	2014-08-04	115	
\.


--
-- Data for Name: calc_machine; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY calc_machine (id, m_name, note, plate_id, pu_amount, density_min, density_max, width_min, width_max, height_min, height_max, head_space) FROM stdin;
3	RZ370		5	1	65	120	210	305	297	430	0
1	SM52-2		1	2	65	280	460	520	320	360	10
\.


--
-- Data for Name: calc_machine_paper_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY calc_machine_paper_type (id, machine_id, materialtype_id) FROM stdin;
6	3	3
7	1	1
8	1	3
9	1	15
\.


--
-- Data for Name: calc_material; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY calc_material (id, title, material_type_id, height, density, thickness, length, price_id, width) FROM stdin;
38	80г (900х640)	3	640	120	\N	\N	\N	900
73	Termal 525x459x0.15	2	459	\N	0.14999999999999999	\N	\N	525
5	Мастер-пленка	5	\N	\N	\N	\N	\N	\N
31	90г (920х640) мат	1	920	90	\N	\N	43	640
6	Sentoplex GLP 500	9	\N	\N	\N	\N	5	\N
74	Termal 745x605x0.3	2	605	\N	0.29999999999999999	\N	\N	745
16	130г (920x640) мат	1	640	130	\N	\N	15	920
75	Очиститель проявочных машин	16	\N	\N	\N	\N	109	\N
47	Термоклей	17	\N	\N	\N	\N	\N	\N
68	UV 510x400x0.15	2	400	\N	0.14999999999999999	\N	\N	510
10	Очиститель пластин А21	12	\N	\N	\N	\N	\N	\N
12	Zhisen (536x460)	13	460	\N	\N	\N	\N	535
13	S 240/200 д.76-64	14	\N	\N	\N	\N	\N	76
43	GIROFORM 55г (430х305) верх	23	305	55	\N	\N	51	430
42	GIROFORM 53г (430х305) середина	23	305	53	\N	\N	\N	430
41	GIROFORM 60г (430х305) верх	23	305	60	\N	\N	49	430
23	Проявитель пластин	16	\N	\N	\N	\N	\N	\N
24	Клей для крышкоделки	17	\N	\N	\N	\N	\N	\N
25	2.0мм (70х100)	18	70	\N	2	\N	\N	100
57	Аналоговая 450x370x0.15	2	370	\N	0.14999999999999999	\N	67	450
45	Каптал x/б белый	24	\N	\N	\N	\N	54	\N
28	Заточка ножа 92см	19	\N	\N	\N	\N	\N	\N
1	Форма 525х459x0.15 (термальная)	20	459	\N	0.14999999999999999	\N	1	525
7	1000 микрон ?????	10	\N	\N	\N	\N	6	\N
26	120г (900x640)	3	640	\N	\N	\N	29	900
20	Краска для листовой печати	11	\N	\N	\N	\N	8	\N
18	80г (860х620)	3	620	80	\N	\N	17	860
4	65г (860х620)	3	620	65	\N	\N	3	\N
46	65г (900х640)	3	640	65	\N	\N	\N	900
59	1.5мм (70х100)	18	70	\N	1.5	\N	\N	100
15	270г (920х640)	15	640	270	\N	\N	\N	920
76	250г (920x640) глян	1	640	250	\N	\N	111	920
48	115г (920х640) глян	1	640	115	\N	\N	\N	920
32	Пленка для гор. ламинации 25мк. (305мм) глян	21	\N	\N	\N	\N	\N	305
33	Пленка для гор. ламинации 25мк. (305мм) мат	21	\N	\N	\N	\N	\N	305
49	170г (920х640) глян	1	640	170	\N	\N	\N	920
51	170г (1040х720) глян	1	720	170	\N	\N	\N	1040
35	(1040х720)	22	720	\N	\N	\N	\N	1040
34	(940х620)	22	620	\N	\N	\N	\N	940
27	130г (1040x720) глян	1	720	130	\N	\N	31	1040
36	250г (920x640) мат	1	640	250	\N	\N	42	920
14	150г (920х640) мат	1	640	150	\N	\N	30	920
37	120г (860x620)	3	620	120	\N	\N	44	860
17	105г (920x640) мат	1	640	105	\N	\N	7	920
53	UV 525x459x0.15	2	459	\N	0.14999999999999999	\N	62	525
50	150г (920х640) глян	1	640	150	\N	\N	112	920
56	UV 745x605x0.3	2	605	\N	0.29999999999999999	\N	66	745
60	(640х450)	26	450	\N	\N	\N	\N	640
54	Проявитель концентрат	25	\N	\N	\N	\N	64	\N
61	Клише - 0.3мм	27	10	\N	3	\N	\N	10
55	Аналоговая 510x400x0.15	2	400	\N	0.14999999999999999	\N	65	510
63	Аналоговая 720x557x0.3	2	557	\N	0.29999999999999999	\N	79	720
64	90г (1040х720) глян	1	\N	\N	\N	\N	\N	\N
65	250г (1040х720) глян	1	720	250	\N	\N	81	1040
66	70г (870х620)	3	620	70	\N	\N	\N	870
44	270г (1040х720)	15	720	270	\N	\N	52	1040
30	200г (920x640) глян	1	640	200	\N	\N	\N	920
67	Пленка для гор. ламинации 25мк. (320мм) глян	21	\N	\N	\N	\N	\N	320
40	90г (920х640) глян	1	640	90	\N	\N	47	920
21	Аналоговая 525x459x0.15	2	459	\N	0.14999999999999999	\N	21	525
77	270г (1040x720)	29	720	270	\N	\N	113	1040
22	Аналоговая 650x530x0.3	2	530	\N	0.29999999999999999	\N	\N	650
52	Аналоговая 745x605x0.3	2	605	\N	0.29999999999999999	\N	61	745
58	Аналоговая 650x490x0.3	2	490	\N	0.29999999999999999	\N	68	650
70	Изопропиловый спирт	12	\N	\N	\N	\N	\N	\N
69	Краска черная S-4253E	28	\N	\N	\N	\N	\N	\N
71	200г (860х620) - Ватман	3	620	200	\N	\N	\N	860
72	UV 650x490x0.3	2	490	\N	0.29999999999999999	\N	\N	650
62	UV 450x370x0.15	2	370	\N	0.14999999999999999	\N	\N	450
78	Картон переплетный 2,0мм (1000x700)	30	750	\N	2	\N	114	1000
39	70г (620)	4	\N	70	\N	\N	115	620
\.


--
-- Data for Name: calc_materialprice; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY calc_materialprice (id, material_id, supplier_id, start_date, end_date, price, packing, nomen_title) FROM stdin;
1	1	10	2014-05-25	\N	535	100	\N
86	40	27	2015-03-02	\N	15	500	Nevia Snow Eagle
21	21	15	2014-06-05	\N	160	100	PL-PS IV 525x459x0.15
20	15	11	2014-06-06	\N	50.399999999999999	1	Cristal Board 920x640
19	20	17	2014-06-02	\N	1200	2.5	Jobbing Black
66	56	17	2014-09-25	\N	467	50	745*605-0,30 UV-P Пластины
67	57	17	2014-09-29	\N	107	100	Пластины 450*370-0,15 YP-Q
16	17	2	2014-06-27	\N	17.100000000000001	250	Ecosatin
15	16	2	2014-05-27	\N	21.399999999999999	250	Ecostar
14	15	2	2014-05-27	\N	53	1	Cristal Board C2S
13	14	16	2014-05-28	\N	23.170000000000002	250	Art Tex мат
12	13	7	2014-05-27	\N	5300	1	S 240/200 д.76-64
11	12	7	2014-05-27	\N	3700	1	Zhisen
68	58	17	2014-09-29	\N	290	50	Пластины 650*490-0,3 YP-II
9	10	7	2014-05-27	\N	1560	1	A21
10	22	7	2014-05-27	\N	329	50	Dongfang
22	22	15	2014-06-11	\N	325	50	PL-PS IV 650x530x0.3
6	7	15	2014-05-28	\N	2500	1	Противоотмарывающий порошок
5	6	14	2013-12-23	\N	10000	1	Sentiplex GLP 500
4	5	13	2014-05-26	\N	80	300	Мастер-пленка
3	4	5	2014-05-26	\N	8.5	500	Бумага офсетная листовая 65г
18	20	17	2014-06-02	\N	1195	2.5	Rapida FW 10 RP/2.5V2
7	17	16	2014-05-29	\N	15.56	1	Art Tex мат
8	20	7	2014-05-27	\N	1304	2.5	Angel TGS-N
23	17	16	2014-06-12	\N	14.279999999999999	250	Роял Стар blanche мат
24	16	16	2014-06-12	\N	17.32	250	Royal Star blanche 128г мат
25	23	7	2014-06-12	\N	462.5	20	Т.
26	24	18	2014-05-23	\N	725	2.5	Клей животный
27	25	19	2014-06-13	\N	195	1	Картон обложечный
28	21	17	2014-06-13	\N	155	100	YP-II
29	26	5	2014-06-10	\N	16.936	250	
30	14	2	2014-06-13	\N	22	250	Everest Fine 148
31	27	11	2014-06-13	\N	23.800000000000001	250	Everest Fine 128
17	18	5	2014-05-21	\N	10.449999999999999	500	Офсет/лист 860x620
32	28	15	2014-05-19	\N	3960	1	
33	30	20	2014-04-30	\N	29	250	Snow Eagle
34	27	20	2014-04-30	\N	21.25	250	Nevia 128
35	15	2	2014-06-20	\N	51	1	Cristal Board C2S
36	30	16	2014-06-20	\N	27.050000000000001	250	Royal Star blanche 200 г/м2
37	31	16	2014-06-20	\N	11.609999999999999	500	Роял Стар blanche мат 090г/м2
38	32	21	2014-06-20	\N	10.75	200	Пленка д/гор.ламин. 25мик.
39	33	21	2014-06-20	\N	10.75	200	Пленка д/гор.ламин. 25мик.
41	35	11	2014-07-01	\N	23	500	Бумага этикеточная (72х104)
40	34	11	2014-07-01	\N	17	500	Бумага этикеточная (62х94)
42	36	2	2014-07-25	\N	41	100	ECOSATIN 64*92/250
43	31	2	2014-07-25	\N	15.199999999999999	500	ECOSATIN 64*92/90
44	37	5	2014-07-31	\N	15.676	250	MAESTRO PRINT 62*86/120 гр /250 л.
45	38	5	2014-07-31	\N	11.289999999999999	500	MAESTRO PRINT 64*90/80 гр /500 л.
46	39	22	2014-06-27	\N	215	450	Бум офсетная рол 70 г/м2/б/100 ф62
47	40	2	2014-07-02	\N	13.199999999999999	500	EVEREST FINE SILK 64*92/ 90
48	16	16	2014-06-30	\N	19.399999999999999	250	HI-KOTE матт 128г/м2, 64х92
69	52	7	2014-09-23	\N	430	50	Пластины 745х605х0,3 PS
51	43	2	2014-06-27	\N	4.2999999999999998	500	GIROFORM ULTRA CF 43*30,5/55
50	42	2	2014-06-27	\N	5.7000000000000002	500	GIROFORM ULTRA CFB 43*30,5/53
49	41	2	2014-06-27	\N	5.2000000000000002	500	GIROFORM ULTRA CB 43*30,5/60
52	44	2	2014-06-27	\N	65	1	CRYSTAL BOARD C2S 72*104/270
53	40	2	2014-07-03	\N	16.699999999999999	500	QUATRO SILK 64*92/ 90
54	45	19	2014-07-03	\N	35	200	Каптал x/б белый
55	46	5	2014-06-24	\N	9.1720000000000006	500	Офсет/лист ф.64/90 65гр.
56	47	23	2014-08-08	\N	1850	25	Клей Tehcnomelt 3116 (25кг)
57	48	2	2014-08-13	\N	18	250	
58	49	2	2014-08-13	\N	29	250	
59	50	2	2014-08-13	\N	27	250	
60	51	2	2014-08-13	\N	35	250	
61	52	15	2014-09-29	\N	440	50	Пластины PL-PS IV 605x745x0.3
62	53	15	2014-09-29	\N	173	100	Пластины PL (CTCP) 459x525x0.15
63	53	17	2014-09-04	\N	223	100	Пластины 525*459-0,15 UV-P
64	54	7	2014-09-29	\N	463	20	Проявитель пластин Т.
65	55	7	2014-09-25	\N	131	100	Пластины 510х400х0,15 PS
70	57	7	2014-08-29	\N	111	100	Пластины 450х370х0,15 PS
71	21	7	2014-08-29	\N	155	100	Пластины 525х459х0,15 PS
72	55	17	2014-10-08	\N	130	100	Пластины 510*400-0,15 YP-Q
73	59	24	2014-10-10	\N	184.80000000000001	1	Картон переплетный 1сорт 1,5 мм 700*1000
74	40	25	2014-10-16	\N	13.5	500	Иксплора Глосс 90гр. 64х92 см
75	60	2	2014-10-23	\N	44	250	
76	54	7	2014-11-04	\N	1207	10	Проявитель пластин P975 (10л)
77	61	26	2014-11-06	\N	70	1	Клише
78	62	17	2014-10-09	\N	154	100	450*370-0,15 UV-P Пластины
79	63	7	2015-01-19	\N	383	50	Пластины офсетные DONGFANG 720x557x0,3
80	64	25	2015-03-02	\N	17	500	
81	65	2	2015-03-06	\N	48.600000000000001	250	
82	66	5	2015-03-10	\N	169.91	500	MAESTRO PRINT 62*87/70 гр /500 л.
83	44	2	2015-03-31	\N	63.700000000000003	1	CRYSTAL BOARD C2S 72*104/270
84	30	2	2015-03-31	\N	32.299999999999997	250	ART-TECH GLOSS 64*92/ 200
85	67	21	2015-04-01	\N	11.25	200	Пленка д/гор.ламин. 25мик.
88	22	17	2015-04-08	\N	308	50	Пластины 650*530-0,3 YP-II
89	57	7	2015-04-09	\N	106	100	Пластины 450х370х0,15 PS
90	52	17	2015-04-13	\N	403	50	Пластины 745*605-0,3 YP-II
91	58	17	2015-03-30	\N	330	50	Пластины 650*490-0,3 YP-II
92	68	15	2015-03-26	\N	145	100	Пластины PL (CTCP) 400x510x0.15
87	55	17	2015-03-18	\N	132	100	Пластины 510*400-0,15 YP-Q
93	57	17	2015-04-20	\N	105	100	Пластины 450*370-0,15 YP-II
94	55	17	2015-04-20	\N	129	100	Пластины 510*400-0,15 YP-Q
95	21	17	2015-04-20	\N	152	100	YP-II
96	52	17	2015-04-20	\N	402	50	Пластины 745*605-0,3 YP-II
97	55	7	2015-04-28	\N	128	100	
98	21	7	2015-04-28	\N	154	100	
99	22	7	2015-04-28	\N	309	50	
100	52	7	2015-04-28	\N	405	50	
101	58	7	2015-04-28	\N	286	50	
103	70	28	2014-10-06	\N	337	200	
102	69	29	2014-10-24	\N	8035	2	S-4253E Краска черная Z тип
104	71	30	2015-04-30	\N	50	1	
105	72	15	2015-05-05	\N	350	50	
106	62	15	2015-05-05	\N	125	100	
107	73	17	2015-05-23	\N	295	100	Пластины 459*525-0,15 CTP TP-II
108	74	17	2015-05-23	\N	558	50	Пластины 745*605-0,3 CTP TP-II
109	75	15	2015-07-24	\N	2300	1	Очиститель проявочных машин ASR
110	47	23	2015-07-27	\N	1640	25	Клей Tehcnomelt 3116 (25кг)
111	76	2	2015-08-05	\N	36.5	125	LUXART SILK 64*92/250
112	50	2	2015-08-05	\N	21.600000000000001	250	LUX ART 64*92/148
113	77	2	2015-08-07	\N	68.5	1	Cristal Pack 270г
114	78	19	2015-08-07	\N	175	1	Картон обложечный 2,0мм 700*1000 /1250
115	39	22	2015-07-31	\N	195	404	Бумага офсетная марки Б 620/70 "Котласский ЦБК""
\.


--
-- Data for Name: calc_materialtype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY calc_materialtype (id, title, unit_of_meas, one_for_order, type_group_id) FROM stdin;
5	Мастер-пленка	рулон	f	2
4	Бумага офсетная ролевая	кг	f	1
3	Бумага офсетная листовая	кг	f	1
2	Пластина офсетная	шт	f	2
9	Смазка	кг	f	\N
1	Бумага мелованная	лист	f	1
12	Печатная химия	литр	f	\N
13	Резина офсетная	шт	f	\N
15	Картон двусторонний	лист	f	\N
16	Допечатная химия	л	f	\N
17	Клей	кг	f	\N
18	Переплетный картон	лист	f	\N
19	Сторонние услуги	шт	f	\N
20	Форма офсетная (готовая к печати)	шт	f	3
10	Противоотмарочный порошок	кг	f	3
11	Краска офсетная	кг	f	3
14	Чехол увлажнения	м	f	3
21	Пленка для ламинации	м	f	\N
22	Бумага этикеточная	лист	f	1
23	Бумага самокопир	шт	f	1
24	Переплетные материалы	м	f	\N
25	Проявитель	л	f	2
26	Бумага самоклящаяся	шт	f	1
27	Другое	шт	f	\N
28	Краска для дубликатора	туба	f	3
29	Картон односторонний	шт	f	1
30	Картон переплетный	шт	f	4
\.


--
-- Data for Name: calc_materialtype_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY calc_materialtype_group (id, title) FROM stdin;
1	Бумага
2	Пластины офсетные/мастера
3	Печатные материалы
4	Переплетные/отделочные материалы
\.


--
-- Data for Name: calc_order; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY calc_order (id, title, client_id, order_date, deadline_date, start_date, end_date, order_type_id, size_type_id, circ, price, page_amount) FROM stdin;
1	Книга 1.1 - Педагогика тарихы бойынша атлас	1	2012-04-26	2012-05-22	2012-04-26	\N	1	1	350	\N	\N
2	Книга 1.2 - Прикладная биология с основами почвоведения Ч1	1	2012-04-26	2012-05-22	2012-04-26	\N	1	1	300	\N	\N
3	Книга 1.3 - Прикладная биология с основами почвоведения Ч2	1	2012-04-26	2012-05-22	2012-04-26	\N	1	1	300	\N	\N
4	Книга 1.4 - Экономикалык талдау	1	2012-04-26	2012-05-22	2012-04-26	\N	1	1	300	\N	\N
5	Книга 1.5 - Коликте экономика негиздери жане менеджмент	1	2012-04-26	2012-05-22	2012-04-26	\N	1	1	300	\N	\N
6	Книга 1.6 - Коликте жане онеркесепте гылыми	1	2012-04-26	2012-05-22	2012-04-26	\N	1	1	300	\N	\N
7	Книга 1.7 - Теоретические основы проектирования и расчет	1	2012-04-26	2012-05-22	2012-04-26	\N	1	1	300	\N	\N
8	Книга 1.8 - Катпарлы конвейелердин серпенди	1	2012-04-26	2012-05-22	2012-04-26	\N	1	1	300	\N	\N
9	Книга 1.9 - Автомобильдерге технологиялык	1	2012-04-26	2012-05-22	2012-04-26	\N	1	1	300	\N	\N
10	Книга 1.10 - Колтанбалы биология топырактану негиздермен 1б	1	2012-04-26	2012-05-22	2012-04-26	\N	1	1	350	\N	\N
11	Книга 1.11 - Колтанбалы биология топырактану негиздермен 2б	1	2012-04-26	2012-05-22	2012-04-26	\N	1	1	350	\N	\N
12	Книга 1.12 - Поиск и реализация наукоемких продукций в промышленности и транспорте	1	2012-04-26	2012-05-22	2012-04-26	\N	1	1	300	\N	\N
13	Книга 1.13 - Формирования и компенсация уравнительных усилий в цепных конвейерах	1	2012-04-26	2012-05-22	2012-04-26	\N	1	1	300	\N	\N
14	Книга 2.1 - Психология мамандыгына кириспе	1	2012-04-26	2012-05-22	2012-04-26	\N	1	1	400	\N	\N
15	Книга 2.2 - Дене мадениетте жане спорт психологиясы	1	2012-04-26	2012-05-22	2012-04-26	\N	1	1	350	\N	\N
16	Меню	2	2012-05-03	2012-05-03	2012-05-03	2012-05-03	2	2	1500	\N	\N
17	Пригласительный билет	3	2012-05-04	2012-05-04	2012-05-04	2012-05-04	3	2	120	\N	\N
18	Намаз	4	2012-05-05	2012-05-05	2012-05-05	2012-05-05	4	1	1000	\N	\N
19	Книга - Алматы устазы	5	2012-05-07	2012-05-07	2012-05-07	\N	5	1	300	\N	\N
20	Книга - Историко-культурное наследие	6	2012-11-01	2012-12-31	2012-11-01	\N	1	1	500	\N	\N
21	Книга - Избранное	7	2012-12-13	2012-12-13	2012-12-13	\N	1	2	2000	\N	\N
22	Книга - Биология ч2	6	2012-12-13	2012-12-13	2012-12-13	\N	1	1	550	\N	\N
23	Журнал - Ана Мен Бала	8	2012-12-20	2012-12-20	2012-12-20	\N	6	3	500	\N	\N
24	Книга - Шашкин	9	2012-12-21	2012-12-21	2012-12-21	\N	1	1	2000	\N	\N
25	Журнал - Физика	10	2013-04-09	2013-08-08	2013-04-09	\N	6	3	450	\N	\N
26	Журнал - Ана мен бала	1	2013-04-09	2013-08-08	2013-04-09	\N	6	3	1000	\N	\N
27	Книга - Заповеди Тенгри	11	2013-04-13	2013-08-08	2013-04-13	2013-08-08	1	1	1000	\N	\N
\.


--
-- Data for Name: calc_ordertype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY calc_ordertype (id, title, description, singlesheet) FROM stdin;
\.


--
-- Data for Name: calc_ordertype_press_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY calc_ordertype_press_type (id, ordertype_id, presstype_id) FROM stdin;
\.


--
-- Data for Name: calc_ordertype_size_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY calc_ordertype_size_type (id, ordertype_id, sizetype_id) FROM stdin;
\.


--
-- Data for Name: calc_ordertype_work_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY calc_ordertype_work_type (id, ordertype_id, worktype_id) FROM stdin;
\.


--
-- Data for Name: calc_positionsalary; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY calc_positionsalary (id, employee_position_id, salary, human_hour_salary, start_date) FROM stdin;
\.


--
-- Data for Name: calc_pressconsumptionnorm; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY calc_pressconsumptionnorm (id, press_type_id, material_id, amount) FROM stdin;
5	1	6	1.0000000000000001e-005
6	1	7	1.0000000000000001e-005
7	1	1	2
8	4	1	4
\.


--
-- Data for Name: calc_pressdata; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY calc_pressdata (id, order_id, press_type_id, sheet_amount, paper_amount, paper_id, note) FROM stdin;
\.


--
-- Data for Name: calc_pressout; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY calc_pressout (id, employee_id, press_data_id, sheet_count, a_date, duration, note) FROM stdin;
\.


--
-- Data for Name: calc_pressprice; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY calc_pressprice (id, press_type_id, fitting_charge, item_charge, start_date) FROM stdin;
2	4	400	1.6000000000000001	2014-05-13
1	1	300	1.3999999999999999	2014-05-26
\.


--
-- Data for Name: calc_presstype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY calc_presstype (id, title, machine_id, paper_type_id, fitting_time, fitting_paper, press_speed, iter_amount, turn, selfback) FROM stdin;
2	Печать в 2 краски	1	3	0.20000000000000001	30	4000	1	f	f
1	Печать в 2 краски односторонняя	1	1	0.20000000000000001	30	6000	1	f	f
4	Печать в 4 краски односторонняя	1	1	0.5	60	6000	2	f	f
\.


--
-- Data for Name: calc_pricecutoff; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY calc_pricecutoff (id, order_id) FROM stdin;
\.


--
-- Data for Name: calc_routerefbook; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY calc_routerefbook (id, dest_name, distance) FROM stdin;
1	AllForPress	12.199999999999999
2	Казпочта, Эврика, Евразия	12
3	Итрако	4
4	Атип	10.6
5	Гридан	17.800000000000001
6	Остров крым	8
8	Книжная палата	8
9	AlmaPaper + Регент Алатау + Меховое ателье	27
7	Берег	7.2000000000000002
10	Берег + Принт ресурс	10
11	Институт металургии + Дворец спорта	20
12	Дауир Сервис	7.2000000000000002
13	Графика Сервис / Размер	10.5
\.


--
-- Data for Name: calc_sizetype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY calc_sizetype (id, title, width, height) FROM stdin;
1	1/16 (64x92) - 145x200mm - A5	145	200
3	А4 (200x290)	200	290
2	Длинный узкий	98	200
\.


--
-- Data for Name: calc_supplier; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY calc_supplier (id, title, telno, note) FROM stdin;
1	Базар		
2	Берег		
3	Поставщик переплетного картона		
4	Поставщик клея ПВА		
5	Литан		
6	Поставщик пленки для ламинации		
8	Поставщик каптала		
9	Поставщик проволоки		
10	SprintR		
12	Сами		
13	Технология+		
14	Гейдельберг Нордазиен		
15	Гридан комерц		
16	Регент Алатау		
17	ВИП Системы		
18	ИП Дуболазов Дмитрий Дмитриевич		
19	Сателлит	(727) 279-20-66, 279-13-44, 279-13-45	
20	AB Graf		
21	Принт Ресурс		
22	Казбумторг		
23	Юркур	392-55-22	
7	AllForPress	275-11-21	
11	Берег	склад: 312-31-52	
24	TST-Company		
25	Бумага И Картон		
26	APH		
27	Резервснаб ПЛЮС		
28	Демеу		
29	Статус - А		
30	Alma Paper		
\.


--
-- Data for Name: calc_tripdk; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY calc_tripdk (id, a_date, employee_id, kt, dt, balance_out) FROM stdin;
\.


--
-- Data for Name: calc_triporder; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY calc_triporder (id, a_date, employee_id, destination_id, dk_id) FROM stdin;
\.


--
-- Data for Name: calc_workconsumptionnorm; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY calc_workconsumptionnorm (id, work_type_id, material_id, amount) FROM stdin;
\.


--
-- Data for Name: calc_workdata; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY calc_workdata (id, order_id, work_type_id, work_amount, note) FROM stdin;
2	7	6	300	121-144
1	9	6	0	300*kol-vo stranic
3	7	1	0	кол-во тетрадей
4	16	8	1500	
5	2	9	300	
6	16	7	1500	
7	16	10	1500	
49	20	26	20	
50	21	3	2000	
9	9	2	600	
8	9	12	600	форзац
11	16	14	0	
12	9	6	0	
13	3	1	13	
14	9	1	3300	
15	7	3	75	
16	17	14	120	
17	17	10	120	
18	2	3	1	
19	2	15	1	
20	2	16	1	
21	3	17	1	
22	3	16	1	
23	9	16	1	
24	2	18	300	
25	9	13	0	
27	18	19	1000	
26	18	21	1000	
28	2	4	1	
29	18	20	1	
30	3	3	1	
31	2	3	1	
32	1	22	98	
33	6	3	300	
34	12	2	600	
35	1	15	350	Обложка
10	3	13	13	
36	3	4	1	
37	2	8	15	
38	3	8	15	1.5
39	9	3	1	
40	19	9	1	
41	9	23	1	
42	7	2	2	
43	1	3	1	
44	19	19	0	
45	19	24	1	
46	6	15	1	Обложка
47	12	6	1	
48	4	25	0	
51	22	15	550	
52	22	27	0	
53	21	18	2060	
54	21	4	1	
55	22	9	1	
56	22	2	2	
57	22	22	0	
58	21	17	1	
59	22	13	1	
60	22	12	2	
61	23	10	0	
62	24	22	0	
63	23	15	1	
64	25	19	10	
65	26	15	1	
66	27	3	1	
\.


--
-- Data for Name: calc_workdata_material; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY calc_workdata_material (id, workdata_id, materialsubtype_id) FROM stdin;
1	5	6
2	6	5
4	9	4
5	15	3
6	15	4
7	18	3
8	18	4
9	19	8
10	20	9
11	21	6
12	22	9
13	23	9
14	24	10
15	28	4
16	29	11
17	30	3
18	30	4
19	31	3
20	31	4
21	32	9
22	33	3
23	33	4
24	34	2
25	34	4
26	35	8
27	36	4
28	39	3
29	39	4
30	40	6
31	42	4
32	43	3
33	43	4
34	46	8
\.


--
-- Data for Name: calc_workout; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY calc_workout (id, employee_id, work_data_id, count, a_date, duration, note) FROM stdin;
2	1	2	900	2012-05-03	1.2	121-144
1	1	1	1800	2012-05-03	3	97-120; 169-192;
3	1	3	0	2012-05-03	3.5	130*kol-vo tetradey
4	1	4	1500	2012-05-03	1	
5	2	1	323	2012-05-03	1.75	121-144
6	2	1	324	2012-05-03	1.75	217-240
7	2	5	110	2012-05-03	1.25	
8	2	6	800	2012-05-03	1.75	
9	2	7	220	2012-05-03	0.25	меню - гриль
10	3	8	650	2012-05-03	1.25	форзац
11	3	9	320	2012-05-03	1.5	
12	3	10	130	2012-05-03	1	
13	3	11	1299	2012-05-03	2.25	
14	4	12	600	2012-05-03	3	73-96; 145-168
15	1	2	300	2012-05-04	1.25	
16	1	13	2275	2012-05-04	3.5	175 blokov
17	1	14	3355	2012-05-04	4.5	
18	5	2	627	2012-05-04	4	49-72; 1-24
19	5	15	75	2012-05-04	4	
20	6	16	120	2012-05-04	0.75	
21	6	2	200	2012-05-04	1.25	25-48
22	6	19	150	2012-05-04	1.5	
23	6	18	105	2012-05-04	4.25	
24	2	20	1	2012-05-04	0.29999999999999999	
25	2	21	120	2012-05-04	0.75	
26	2	22	1	2012-05-04	0.25	
27	2	23	1	2012-05-04	0.25	
28	2	24	302	2012-05-04	3.25	
29	3	10	50	2012-05-04	0.75	
30	3	25	320	2012-05-04	2.25	
31	3	2	116	2012-05-04	0.75	
32	3	18	100	2012-05-04	4.25	
33	4	26	700	2012-05-05	2	
34	4	27	700	2012-05-05	2	
35	1	28	10	2012-05-05	0.25	
36	1	27	300	2012-05-05	0.5	
37	1	26	300	2012-05-05	0.5	
38	1	29	1000	2012-05-05	2	
39	1	30	100	2012-05-05	3	
40	6	31	30	2012-05-05	1	
41	6	28	110	2012-05-05	4.75	
42	6	30	85	2012-05-05	2.25	
43	5	28	80	2012-05-05	4	
44	5	30	54	2012-05-05	4	
45	3	28	110	2012-05-05	6.25	
46	3	31	65	2012-05-05	2.5	
47	2	32	98	2012-05-05	8	
48	6	33	74	2012-05-14	2.5	
49	6	34	160	2012-05-14	1.5	тетрадь 217-246
50	6	35	350	2012-05-14	2.5	
51	6	36	20	2012-05-07	0.5	
52	6	37	15	2012-05-07	1.5	
53	6	38	15	2012-05-07	1.5	
54	6	39	43	2012-05-07	1.75	
55	6	40	264	2012-05-07	2	
56	3	41	250	2012-05-07	1	
57	3	36	21	2012-05-07	0.5	
58	3	39	93	2012-05-07	3.25	
59	3	42	75	2012-05-07	0.75	
60	4	43	190	2012-05-10	4.5	
61	4	45	300	2012-05-07	2	
62	6	46	160	2012-05-13	2	
63	6	47	320	2012-05-13	1.5	217-248
64	6	33	100	2012-05-13	4.5	
65	7	48	240	2012-05-14	2.75	73-96
79	8	49	510	2012-11-26	2.5	стр
80	4	50	90	2012-11-13	2.75	-
81	4	51	330	2012-11-13	3	-
82	4	52	700	2012-11-13	2	
83	9	50	80	2012-11-13	3.25	
84	9	52	550	2012-11-13	2.75	стр 225-256
85	9	53	180	2012-11-13	2.5	
86	10	54	80	2012-11-13	2.25	
87	3	50	80	2012-11-13	3	
88	3	52	1100	2012-11-13	2.25	
89	3	54	75	2012-11-13	2	
90	8	50	80	2012-11-13	3	
91	8	52	550	2012-11-13	2	
92	8	54	30	2012-11-13	0.75	
93	11	52	100	2012-11-13	0.5	стр 33
94	11	55	103	2012-11-13	2.25	
95	11	53	150	2012-11-13	1.25	
96	4	50	100	2012-11-12	3.25	-
97	4	50	40	2012-11-12	1	-
98	4	56	500	2012-11-12	2.75	-
99	2	57	14	2012-11-12	3.5	-
129	1	65	158	2013-04-09	1.5	
130	1	65	857	2013-04-09	7.5	
101	12	52	1350	2012-11-12	4.75	
102	3	50	242	2012-11-12	7.5	
103	11	52	350	2012-11-12	0.75	
104	11	58	125	2012-11-12	2.75	
105	11	52	2100	2012-11-12	4.5	стр33,73,129,137
106	8	59	150	2012-11-12	0.33000000000000002	
107	8	50	230	2012-11-12	7.6600000000000001	
108	9	52	150	2012-11-12	0.75	
109	9	50	200	2012-11-12	7.75	
110	4	54	132	2012-11-10	4	
111	8	52	1100	2012-11-10	2	
112	9	54	90	2012-11-10	3.25	
114	9	52	400	2012-11-10	2	
115	10	54	190	2012-11-10	3.5	
116	11	60	350	2012-11-10	0.5	
117	11	58	870	2012-11-10	8	
118	8	54	45	2012-11-09	1	
119	8	61	504	2012-11-09	0.75	Обложка
120	2	57	26	2012-11-10	5	
121	2	52	550	2012-11-10	2	
122	2	62	32	2012-11-09	6.5	
123	11	52	750	2012-11-09	1.75	
124	11	63	500	2012-11-09	5.75	
125	11	60	500	2012-11-09	0.80000000000000004	
126	4	54	90	2012-11-09	3	
127	9	54	218	2012-11-09	9.25	
128	1	64	450	2013-04-09	2.25	
131	1	66	100	2013-04-13	3.5	
132	1	66	212	2013-04-15	6.5	
\.


--
-- Data for Name: calc_worktype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY calc_worktype (id, title, fitting_charge, item_charge) FROM stdin;
1	Ниткошвейка	2000	3
2	Наклейка форзаца	0	2
3	Изготовление крышек	500	100
4	Вставка блока	0	30
5	Штриховка	0	0.25
7	Степлер	0	0
8	Упаковка	0	0
9	Биндер	2000	20
10	Фальцовка (1сгиб)	0	0
13	Комплектация блоков	0	0
14	Биговка	200	0.25
15	Ламинация	0	0
16	Форма для разлиновки обложки на твердый переплет	0	0
17	Проклейка блока - биндер	200	20
18	Наклейка каптала	0	0
19	Подборка	0	0
20	Сшивка - проволокошвейка	0	0
21	Фальцовка тетради (1сгиб)	0	0
23	Обрыв блоков после биндера	0	0
24	Рассоединение блоков	0	0
25	Подборка(6л)+1фальц	0	0
26	Подбор 4 листа + 1 фальц	0	2
27	Фальцовка - третий сгиб	0	0
22	Изготовление печатных форм - A2	0	0
6	Подборка A3 (3листа)+2фальца	0	1
12	Фальцовка форзаца	0	0
\.


--
-- Data for Name: calc_worktype_default_materials; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY calc_worktype_default_materials (id, worktype_id, materialsubtype_id) FROM stdin;
1	1	1
2	2	2
4	4	4
5	3	3
6	3	4
7	7	5
8	9	6
10	15	8
11	16	9
12	17	6
13	18	10
14	20	11
15	22	9
\.


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY django_admin_log (id, action_time, user_id, content_type_id, object_id, object_repr, action_flag, change_message) FROM stdin;
5	2012-02-21 12:57:15.923+06	1	22	1	PressType object	1	
6	2012-02-21 12:57:30.648+06	1	22	2	PressType object	1	
7	2012-02-21 12:58:11.587+06	1	22	1	PressType object	2	Changed title.
8	2012-02-21 12:59:15.093+06	1	23	1	Фальцовка	1	
9	2012-02-21 13:00:02.48+06	1	24	1	Буклет двусгибка (1/3 A4)	1	
10	2012-02-21 13:00:43.734+06	1	25	1	Берег	1	
13	2012-02-21 13:04:58.131+06	1	17	1	Бронислав Бронислав	1	
14	2012-02-21 13:05:32.248+06	1	19	1	Xango	1	
15	2012-02-21 13:11:19.317+06	1	28	1	WorkData object	1	
16	2012-05-06 00:33:33.225+07	1	17	1	ИП Какойтович 	1	
17	2012-05-06 00:34:29.79+07	1	25	1	Берег	1	
18	2012-05-06 00:38:35.304+07	1	29	1	Бумага-self.subtype	1	
19	2012-05-06 00:39:48.39+07	1	30	1	MaterialSubtype object	1	
20	2012-05-06 00:47:25.845+07	1	31	1	MaterialPrice object	1	
21	2012-05-06 00:54:58.51+07	1	23	1	Подборка тетради	1	
22	2012-05-06 00:56:56.961+07	1	23	2	Сборка блока	1	
23	2012-05-06 01:14:47.784+07	1	24	1	Книга - твердый переплет	1	
24	2012-05-06 01:16:28.919+07	1	22	1	Ризограф	1	
25	2012-05-06 01:17:09.791+07	1	32	1	PressData object	1	
26	2012-05-06 01:24:01.46+07	1	29	1	Бумага-self.subtype	1	
27	2012-05-06 01:24:16.03+07	1	29	2	Нитка-self.subtype	1	
28	2012-05-06 01:24:50.553+07	1	29	3	Крючки-иголки-self.subtype	1	
29	2012-05-06 01:25:47.712+07	1	25	2	Базар	1	
30	2012-05-06 01:25:54.966+07	1	30	2	MaterialSubtype object	1	
31	2012-05-06 01:26:33.56+07	1	25	3	Какой-то перец	1	
32	2012-05-06 01:26:47.663+07	1	30	3	MaterialSubtype object	1	
33	2012-05-06 01:32:31.909+07	1	31	1	MaterialPrice object	1	
34	2012-05-06 01:36:02.68+07	1	31	2	Нитка (Базар) - 300.0	1	
35	2012-05-06 01:36:25.16+07	1	31	3	Крючки-иголки (Какой-то перец) - 500.0	1	
36	2012-05-06 02:31:52.009+07	1	33	1	1/16 (64x92) - 145x200mm - A5	1	
37	2012-05-06 03:47:22.709+07	1	34	1	Екатерина Василиади	1	
38	2012-05-06 03:51:55.238+07	1	19	1	Книга №3 - Автомобильдерге	1	
39	2012-05-06 04:06:10.749+07	1	28	3	Подборка тетради	1	
40	2012-05-06 04:17:29.5+07	1	35	6	Workout object	1	
41	2012-05-06 04:25:55.557+07	1	28	3	Подборка тетради	2	Changed note.
42	2012-05-06 04:31:21.267+07	1	35	1	Екатерина - Подборка тетради(Книга №3 - Автомобильдерге)	1	
43	2012-05-06 04:34:57.672+07	1	19	2	Книга №4 - Теоретические основы	1	
44	2012-05-06 04:36:14.654+07	1	28	4	Подборка тетради - Книга №4 - Теоретические основы	1	
45	2012-05-06 04:37:11.849+07	1	35	2	Екатерина - Подборка тетради(Книга №4 - Теоретические основы)	1	
46	2012-05-06 04:46:03.759+07	1	23	1	Ниткошвейка	1	
47	2012-05-06 04:46:54.387+07	1	28	5	Ниткошвейка - Книга №4 - Теоретические основы	1	
48	2012-05-06 04:51:15.784+07	1	35	3	Екатерина - Ниткошвейка(Книга №4 - Теоретические основы)	1	
49	2012-05-06 04:52:39.71+07	1	17	2	Андрей 	1	
50	2012-05-06 06:13:10.321+07	1	29	4	Скобы на степлер	1	
51	2012-05-06 06:13:26.998+07	1	25	4	Абди	1	
52	2012-05-06 06:13:29.94+07	1	30	4	Скобы на степлер - Скобы 66/6	1	
53	2012-05-06 06:14:16.476+07	1	23	2	Сшивка на степлер	1	
54	2012-05-06 06:14:25.05+07	1	24	2	Брошюра	1	
55	2012-05-06 06:16:06.741+07	1	33	2	1/2 A4	1	
56	2012-05-06 06:16:24.957+07	1	19	3	Меню	1	
57	2012-05-06 06:18:16.632+07	1	23	3	Упаковка	1	
58	2012-05-06 06:18:28.046+07	1	28	6	Упаковка - Меню	1	
59	2012-05-06 06:18:51.156+07	1	35	4	Екатерина - Упаковка(Меню)	1	
60	2012-05-06 06:20:17.93+07	1	35	3	Екатерина - Ниткошвейка(Книга №4 - Теоретические основы)	3	
61	2012-05-06 06:20:47.27+07	1	35	1	Екатерина - Ниткошвейка(Книга №3 - Автомобильдерге)	3	
62	2012-05-06 06:21:29.361+07	1	28	5	Ниткошвейка - Книга №4 - Теоретические основы	3	
63	2012-05-06 06:21:47.193+07	1	28	3	Ниткошвейка - Книга №3 - Автомобильдерге	3	
64	2012-05-06 06:23:39.792+07	1	23	4	Подборка	1	
65	2012-05-06 06:23:47.415+07	1	28	7	Подборка - Книга №4 - Теоретические основы	1	
66	2012-05-06 06:25:35.246+07	1	35	5	Екатерина - Подборка(Книга №4 - Теоретические основы)	1	
67	2012-05-06 06:26:00.242+07	1	28	8	Подборка - Книга №3 - Автомобильдерге	1	
68	2012-05-06 06:26:28.738+07	1	35	6	Екатерина - Подборка(Книга №3 - Автомобильдерге)	1	
69	2012-05-08 08:18:08.353+07	1	39	1	Нитка	1	
70	2012-05-08 08:18:18.783+07	1	37	1	Базар	1	
72	2012-05-08 08:18:37.271+07	1	41	1	Ниткошвейка	1	
73	2012-05-08 08:21:37.846+07	1	39	2	Бумага	1	
74	2012-05-08 08:21:48.898+07	1	37	2	Берег	1	
76	2012-05-08 08:22:28.853+07	1	41	2	Наклейка форзаца	1	
77	2012-05-08 08:24:17.184+07	1	39	3	Переплетный картон	1	
78	2012-05-08 08:24:49.994+07	1	37	3	Поставщик переплетного картона	1	
80	2012-05-08 08:25:20.758+07	1	41	3	Изготовление крышек	1	
81	2012-05-08 08:26:26.173+07	1	39	4	Клей	1	
82	2012-05-08 08:26:53.179+07	1	37	4	Поставщик клея ПВА	1	
84	2012-05-08 08:27:40.287+07	1	41	4	Вставка блока	1	
85	2012-05-08 08:28:26.496+07	1	41	5	Штриховка	1	
86	2012-05-08 08:28:40.568+07	1	42	1	Книга - твердый переплет	1	
87	2012-05-08 08:29:11.054+07	1	41	3	Изготовление крышек	2	Changed default_materials.
88	2012-05-08 08:32:32.687+07	1	36	1	ИП Какойтович 	1	
89	2012-05-08 08:33:54.496+07	1	44	1	1/16 (64x92) - 145x200mm - A5	1	
90	2012-05-08 08:34:18.061+07	1	45	1	Книга 1.1 - Педагогика тарихы бойынша атлас	1	
91	2012-05-08 08:35:59.946+07	1	45	2	Книга 2.2 - Прикладная биология с основами почвоведения Ч1	1	
92	2012-05-08 08:36:54.083+07	1	45	2	Книга 1.2 - Прикладная биология с основами почвоведения Ч1	2	Changed title.
93	2012-05-08 08:38:24.628+07	1	45	3	Книга 1.3 - Прикладная биология с основами почвоведения Ч2	1	
94	2012-05-08 08:40:08.23+07	1	45	4	Книга 1.4 - Экономикалык талдау	1	
95	2012-05-08 08:42:52.873+07	1	45	5	Книга 1.5 - Коликте экономика негиздери жане менеджмент	1	
96	2012-05-08 08:45:40.376+07	1	45	6	Книга 1.6 - Коликте жане онеркесепте гылыми	1	
97	2012-05-08 08:48:24.364+07	1	45	7	Книга 1.7 - Теоретические основы проектирования и расчет	1	
98	2012-05-08 08:50:17.998+07	1	45	8	Книга 1.8 - Катпарлы конвейелердин серпенди	1	
99	2012-05-08 08:51:52.348+07	1	45	9	Книга 1.9 - Автомобильдерге технологиялык	1	
100	2012-05-08 08:54:06.884+07	1	45	10	Книга 1.10 - Колтанбалы биология топырактану негиздермен 1б	1	
101	2012-05-08 08:55:20.47+07	1	45	11	Книга 1.10 - Колтанбалы биология топырактану негиздермен 2б	1	
102	2012-05-08 08:55:57.055+07	1	45	11	Книга 1.11 - Колтанбалы биология топырактану негиздермен 2б	2	Changed title.
103	2012-05-08 08:58:16.178+07	1	45	12	Книга 1.12 - Поиск и реализация наукоемких продукций в промышленности и транспорте	1	
104	2012-05-08 08:59:55.333+07	1	45	13	Книга 1.13 - Формирования и компенсация уравнительных усилий в цепных конвейерах	1	
105	2012-05-08 09:02:09.136+07	1	45	14	Книга 2.1 - Психология мамандыгына кириспе	1	
106	2012-05-08 09:03:43.783+07	1	45	15	Книга 2.2 - Дене мадениетте жане спорт психологиясы	1	
107	2012-05-09 05:05:42.52+07	1	48	1	Екатерина Василиади	1	
108	2012-05-09 05:07:25.651+07	1	41	6	Подборка+фальцовка	1	
109	2012-05-09 05:10:47.687+07	1	41	6	Подборка+2фальца	2	Changed title.
110	2012-05-09 05:12:22.333+07	1	47	1	Подборка+2фальца - Книга 1.9 - Автомобильдерге технологиялык	1	
111	2012-05-09 05:16:51.137+07	1	49	1	Екатерина - Подборка+2фальца(Книга 1.9 - Автомобильдерге технологиялык)	1	
112	2012-05-09 05:49:33.979+07	1	47	2	Подборка+2фальца - Книга 1.7 - Теоретические основы проектирования и расчет	1	
113	2012-05-09 05:52:07.093+07	1	49	2	Екатерина - Подборка+2фальца(Книга 1.7 - Теоретические основы проектирования и расчет)	1	
114	2012-05-09 05:53:31.77+07	1	47	1	Подборка+2фальца - Книга 1.9 - Автомобильдерге технологиялык	2	Changed work_amount and note.
115	2012-05-09 05:54:34.888+07	1	49	1	Екатерина - Подборка+2фальца(Книга 1.9 - Автомобильдерге технологиялык)	2	Changed note.
116	2012-05-09 05:56:17.739+07	1	47	3	Ниткошвейка - Книга 1.7 - Теоретические основы проектирования и расчет	1	
117	2012-05-09 05:57:33.758+07	1	49	3	Екатерина - Ниткошвейка(Книга 1.7 - Теоретические основы проектирования и расчет)	1	
118	2012-05-09 05:58:24.193+07	1	36	2	Андрей 	1	
119	2012-05-09 06:00:10.647+07	1	39	5	Скрепки	1	
121	2012-05-09 06:00:36.871+07	1	41	7	Степлер	1	
122	2012-05-09 06:00:45.872+07	1	42	2	Брошюра	1	
123	2012-05-09 06:01:59.208+07	1	44	2	Длинный узкий	1	
124	2012-05-09 06:02:14.137+07	1	45	16	Меню	1	
125	2012-05-09 06:03:26.693+07	1	41	8	Упаковка	1	
126	2012-05-09 06:03:56.77+07	1	47	4	Упаковка - Меню	1	
127	2012-05-09 06:04:09.375+07	1	49	4	Екатерина - Упаковка(Меню)	1	
128	2012-05-09 06:15:31.267+07	1	48	2	Шерен Анварова	1	
129	2012-05-09 06:19:14.504+07	1	49	5	Шерен - Подборка+2фальца(Книга 1.9 - Автомобильдерге технологиялык)	1	
130	2012-05-09 06:20:42.862+07	1	49	6	Шерен - Подборка+2фальца(Книга 1.9 - Автомобильдерге технологиялык)	1	
131	2012-05-09 06:23:35.539+07	1	39	6	Термо-клей	1	
133	2012-05-09 06:23:53.791+07	1	41	9	Биндер	1	
134	2012-05-09 06:27:02.52+07	1	47	5	Биндер - Книга 1.2 - Прикладная биология с основами почвоведения Ч1	1	
135	2012-05-09 06:28:00.162+07	1	49	7	Шерен - Биндер(Книга 1.2 - Прикладная биология с основами почвоведения Ч1)	1	
136	2012-05-09 07:05:01.903+07	1	47	6	Степлер - Меню	1	
137	2012-05-09 07:06:44.91+07	1	49	8	Шерен - Степлер(Меню)	1	
138	2012-05-09 07:08:00.117+07	1	41	10	Фальцовка (1сгиб)	1	
139	2012-05-09 07:08:14.719+07	1	47	7	Фальцовка (1сгиб) - Меню	1	
140	2012-05-09 07:09:00.942+07	1	49	9	Шерен - Фальцовка (1сгиб)(Меню)	1	
141	2012-05-09 07:10:17.382+07	1	48	3	Уля Бектемирова	1	
142	2012-05-10 23:37:41.869+07	1	47	8	Фальцовка (1сгиб) - Книга 1.9 - Автомобильдерге технологиялык	1	
143	2012-05-10 23:38:27.901+07	1	49	10	Уля - Фальцовка (1сгиб)(Книга 1.9 - Автомобильдерге технологиялык)	1	
144	2012-05-10 23:40:20.845+07	1	41	11	Клейка форзаца	1	
145	2012-05-10 23:44:13.442+07	1	47	9	Клейка форзаца - Книга 1.9 - Автомобильдерге технологиялык	1	
146	2012-05-10 23:44:55.39+07	1	49	11	Уля - Клейка форзаца(Книга 1.9 - Автомобильдерге технологиялык)	1	
435	2014-05-27 03:30:35.495+07	1	51	5	Мастер-пленка - Мастер-пленка	1	
439	2014-05-28 08:17:55.714+07	1	39	9	Смазка	1	
441	2014-05-28 09:34:07.88+07	1	56	5	Sentiplex for Печать в 2 краски - 1.0	1	
147	2012-05-10 23:48:19.059+07	1	47	9	Наклейка форзаца - Книга 1.9 - Автомобильдерге технологиялык	2	Changed work_type.
148	2012-05-10 23:48:37.046+07	1	41	11	Клейка форзаца	3	
149	2012-05-10 23:50:13.798+07	1	41	12	Фальцовка 120г (форзац)	1	
150	2012-05-10 23:50:47.712+07	1	47	8	Фальцовка 120г (форзац) - Книга 1.9 - Автомобильдерге технологиялык	2	Changed work_type and work_amount.
151	2012-05-10 23:52:53.842+07	1	41	13	Комплектация блоков	1	
152	2012-05-10 23:53:29.846+07	1	47	10	Комплектация блоков - Книга 1.3 - Прикладная биология с основами почвоведения Ч2	1	
153	2012-05-10 23:55:16.847+07	1	49	12	Уля - Комплектация блоков(Книга 1.3 - Прикладная биология с основами почвоведения Ч2)	1	
154	2012-05-10 23:56:56.796+07	1	41	14	Беговка	1	
155	2012-05-10 23:57:57.28+07	1	47	11	Беговка - Меню	1	
156	2012-05-10 23:59:17.963+07	1	49	13	Уля - Беговка(Меню)	1	
157	2012-05-11 00:06:49.974+07	1	48	4	Татьяна 	1	
158	2012-05-11 00:08:23.714+07	1	41	6	Подборка(3листа)+2фальца	2	Changed title.
159	2012-05-11 00:09:19.126+07	1	47	12	Подборка(3листа)+2фальца - Книга 1.9 - Автомобильдерге технологиялык	1	
160	2012-05-11 00:10:46.205+07	1	49	14	Татьяна - Подборка(3листа)+2фальца(Книга 1.9 - Автомобильдерге технологиялык)	1	
161	2012-05-11 00:11:15.424+07	1	38	1	Ризограф	1	
162	2012-05-11 00:12:40.116+07	1	37	5	Литан	1	
164	2012-05-11 00:13:06.293+07	1	46	1	Ризограф (оффсет 65г) - 0	1	
165	2012-05-11 00:34:28.483+07	1	46	1	Ризограф (оффсет 65г) - 2	2	Changed press_iteration_amount.
166	2012-05-11 00:35:34.131+07	1	50	1	Татьяна - Ризограф(Книга 1.7 - Теоретические основы проектирования и расчет)	1	
167	2012-05-11 00:50:10.455+07	1	49	15	Екатерина - Подборка(3листа)+2фальца(Книга 1.7 - Теоретические основы проектирования и расчет)	1	
168	2012-05-11 00:52:06.441+07	1	47	13	Ниткошвейка - Книга 1.3 - Прикладная биология с основами почвоведения Ч2	1	
169	2012-05-11 00:58:03.452+07	1	47	13	Ниткошвейка - Книга 1.3 - Прикладная биология с основами почвоведения Ч2	2	Changed material_amount.
170	2012-05-11 01:08:08.028+07	1	49	16	Екатерина - Ниткошвейка(Книга 1.3 - Прикладная биология с основами почвоведения Ч2)	1	
171	2012-05-11 01:13:50.371+07	1	47	14	Ниткошвейка - Книга 1.9 - Автомобильдерге технологиялык	1	
172	2012-05-11 01:15:17.7+07	1	49	17	Екатерина - Ниткошвейка(Книга 1.9 - Автомобильдерге технологиялык)	1	
173	2012-05-11 01:17:59.675+07	1	50	2	Татьяна - Ризограф(Книга 1.7 - Теоретические основы проектирования и расчет)	1	
174	2012-05-11 01:19:40.498+07	1	48	5	Светлана Чевычалова	1	
175	2012-05-11 01:58:42.138+07	1	48	4	Татьяна Дарницина	2	Changed last_name.
176	2012-05-11 02:04:29.349+07	1	49	18	Светлана - Подборка(3листа)+2фальца(Книга 1.7 - Теоретические основы проектирования и расчет)	1	
177	2012-05-11 02:06:02.299+07	1	47	15	Изготовление крышек - Книга 1.7 - Теоретические основы проектирования и расчет	1	
178	2012-05-11 02:06:45.409+07	1	49	19	Светлана - Изготовление крышек(Книга 1.7 - Теоретические основы проектирования и расчет)	1	
179	2012-05-11 02:10:33.059+07	1	42	3	Буклет (1 сгиб)	1	
180	2012-05-11 02:11:00.689+07	1	36	3	Клиент с пригласительным 	1	
181	2012-05-11 02:11:19.189+07	1	45	17	Пригласительный билет	1	
182	2012-05-11 02:11:35.129+07	1	41	14	Биговка	2	Changed title.
183	2012-05-11 02:12:11.139+07	1	48	6	Алия Ажибаева	1	
184	2012-05-11 02:13:06.019+07	1	47	16	Биговка - Пригласительный билет	1	
185	2012-05-11 02:13:26.78+07	1	47	17	Фальцовка (1сгиб) - Пригласительный билет	1	
186	2012-05-11 02:14:11.07+07	1	49	20	Алия - Биговка(Пригласительный билет)	1	
187	2012-05-11 02:16:31.25+07	1	49	21	Алия - Подборка(3листа)+2фальца(Книга 1.7 - Теоретические основы проектирования и расчет)	1	
188	2012-05-11 02:18:13.33+07	1	47	18	Изготовление крышек - Книга 1.2 - Прикладная биология с основами почвоведения Ч1	1	
189	2012-05-11 02:20:12.97+07	1	39	7	Пленка для ламинации	1	
190	2012-05-11 02:20:41.38+07	1	37	6	Поставщик пленки для ламинации	1	
192	2012-05-11 02:20:58.03+07	1	41	15	Ламинация	1	
193	2012-05-11 02:21:30.58+07	1	47	19	Ламинация - Книга 1.2 - Прикладная биология с основами почвоведения Ч1	1	
194	2012-05-11 02:22:10.83+07	1	49	22	Алия - Ламинация(Книга 1.2 - Прикладная биология с основами почвоведения Ч1)	1	
195	2012-05-11 02:23:36.91+07	1	49	23	Алия - Изготовление крышек(Книга 1.2 - Прикладная биология с основами почвоведения Ч1)	1	
196	2012-05-11 02:28:01.441+07	1	39	8	Форма	1	
197	2012-05-11 02:28:25.563+07	1	37	7	AllForPress	1	
199	2012-05-11 02:28:32.143+07	1	41	16	Форма для разлиновки обложки на твердый переплет	1	
200	2012-05-11 02:29:09.203+07	1	47	20	Форма для разлиновки обложки на твердый переплет - Книга 1.2 - Прикладная биология с основами почвоведения Ч1	1	
201	2012-05-11 02:29:35.073+07	1	39	8	Форма	2	Changed one_for_order.
436	2014-05-27 03:31:29.455+07	1	55	2	Пластины офсетные/мастера	2	Changed title.
440	2014-05-28 08:18:37.804+07	1	51	6	Смазка - Sentiplex	1	
442	2014-05-28 22:34:38.686+07	1	51	6	Смазка - Sentoplex GLP 500	2	Changed title.
202	2012-05-11 02:42:26.424+07	1	49	24	Шерен - Форма для разлиновки обложки на твердый переплет(Книга 1.2 - Прикладная биология с основами почвоведения Ч1)	1	
203	2012-05-11 02:43:45.994+07	1	41	17	Проклейка блока - биндер	1	
204	2012-05-11 02:44:14.974+07	1	47	21	Проклейка блока - биндер - Книга 1.3 - Прикладная биология с основами почвоведения Ч2	1	
205	2012-05-11 02:44:48.934+07	1	49	25	Шерен - Проклейка блока - биндер(Книга 1.3 - Прикладная биология с основами почвоведения Ч2)	1	
206	2012-05-11 02:46:24.784+07	1	47	22	Форма для разлиновки обложки на твердый переплет - Книга 1.3 - Прикладная биология с основами почвоведения Ч2	1	
207	2012-05-11 02:46:49.044+07	1	49	26	Шерен - Форма для разлиновки обложки на твердый переплет(Книга 1.3 - Прикладная биология с основами почвоведения Ч2)	1	
208	2012-05-11 02:48:48.515+07	1	47	23	Форма для разлиновки обложки на твердый переплет - Книга 1.9 - Автомобильдерге технологиялык	1	
209	2012-05-11 02:49:29.905+07	1	49	27	Шерен - Форма для разлиновки обложки на твердый переплет(Книга 1.9 - Автомобильдерге технологиялык)	1	
210	2012-05-11 02:51:18.365+07	1	39	9	Каптал	1	
211	2012-05-11 02:51:48.945+07	1	37	8	Поставщик каптала	1	
213	2012-05-11 02:51:56.405+07	1	41	18	Наклейка каптала	1	
214	2012-05-11 02:52:44.395+07	1	47	24	Наклейка каптала - Книга 1.2 - Прикладная биология с основами почвоведения Ч1	1	
215	2012-05-11 02:54:46.095+07	1	49	28	Шерен - Наклейка каптала(Книга 1.2 - Прикладная биология с основами почвоведения Ч1)	1	
216	2012-05-11 02:58:36.635+07	1	49	29	Уля - Комплектация блоков(Книга 1.3 - Прикладная биология с основами почвоведения Ч2)	1	
217	2012-05-11 03:00:45.836+07	1	47	25	Комплектация блоков - Книга 1.9 - Автомобильдерге технологиялык	1	
218	2012-05-11 03:01:44.476+07	1	49	30	Уля - Комплектация блоков(Книга 1.9 - Автомобильдерге технологиялык)	1	
219	2012-05-11 03:03:50.496+07	1	49	31	Уля - Подборка(3листа)+2фальца(Книга 1.7 - Теоретические основы проектирования и расчет)	1	
220	2012-05-11 03:05:56.656+07	1	49	32	Уля - Изготовление крышек(Книга 1.2 - Прикладная биология с основами почвоведения Ч1)	1	
221	2012-05-11 03:08:09.596+07	1	36	4	Намаз 	1	
222	2012-05-11 03:11:11.226+07	1	41	19	Подборка	1	
223	2012-05-11 03:12:26.986+07	1	39	10	Проволока	1	
224	2012-05-11 03:12:50.327+07	1	37	9	Поставщик проволоки	1	
226	2012-05-11 03:12:56.607+07	1	41	20	Сшивка - проволокошвейка	1	
227	2012-05-11 03:13:24.727+07	1	42	4	Брошюра (на скобе)	1	
228	2012-05-11 03:13:41.967+07	1	45	18	Намаз	1	
229	2012-05-11 03:14:53.427+07	1	41	21	Фальцовка тетради (1сгиб)	1	
230	2012-05-11 03:15:05.067+07	1	42	4	Брошюра (на скобе)	2	Changed work_type.
231	2012-05-11 03:17:49.787+07	1	47	26	Фальцовка тетради (1сгиб) - Намаз	1	
232	2012-05-11 03:18:09.547+07	1	49	33	Татьяна - Фальцовка тетради (1сгиб)(Намаз)	1	
233	2012-05-11 03:18:59.377+07	1	47	27	Подборка - Намаз	1	
234	2012-05-11 03:19:42.317+07	1	47	26	Фальцовка тетради (1сгиб) - Намаз	2	Changed work_amount.
235	2012-05-11 03:19:55.247+07	1	49	34	Татьяна - Подборка(Намаз)	1	
236	2012-05-11 03:24:17.197+07	1	46	2	Ризограф (оффсет 65г) - 0	1	
237	2012-05-11 05:12:46.425+07	1	46	3	Ризограф; (Книга 1.8 - Катпарлы конвейелердин серпенди, оффсет 65г, progonov - 2) listov - 0	1	
238	2012-05-11 05:13:21.735+07	1	50	3	Татьяна - Ризограф(Книга 1.8 - Катпарлы конвейелердин серпенди)	1	
239	2012-05-11 05:14:50.495+07	1	47	28	Вставка блока - Книга 1.2 - Прикладная биология с основами почвоведения Ч1	1	
240	2012-05-11 05:15:10.165+07	1	49	35	Екатерина - Вставка блока(Книга 1.2 - Прикладная биология с основами почвоведения Ч1)	1	
241	2012-05-11 05:16:07.595+07	1	49	36	Екатерина - Подборка(Намаз)	1	
242	2012-05-11 05:16:46.755+07	1	49	37	Екатерина - Фальцовка тетради (1сгиб)(Намаз)	1	
243	2012-05-11 05:19:02.785+07	1	47	29	Сшивка - проволокошвейка - Намаз	1	
244	2012-05-11 05:19:19.815+07	1	49	38	Екатерина - Сшивка - проволокошвейка(Намаз)	1	
245	2012-05-11 05:20:47.345+07	1	47	30	Изготовление крышек - Книга 1.3 - Прикладная биология с основами почвоведения Ч2	1	
246	2012-05-11 05:21:00.905+07	1	49	39	Екатерина - Изготовление крышек(Книга 1.3 - Прикладная биология с основами почвоведения Ч2)	1	
247	2012-05-11 05:23:15.526+07	1	47	31	Изготовление крышек - Книга 1.2 - Прикладная биология с основами почвоведения Ч1	1	
248	2012-05-11 05:23:40.936+07	1	49	40	Алия - Изготовление крышек(Книга 1.2 - Прикладная биология с основами почвоведения Ч1)	1	
249	2012-05-11 05:25:09.276+07	1	49	41	Алия - Вставка блока(Книга 1.2 - Прикладная биология с основами почвоведения Ч1)	1	
250	2012-05-11 05:26:16.676+07	1	49	42	Алия - Изготовление крышек(Книга 1.3 - Прикладная биология с основами почвоведения Ч2)	1	
251	2012-05-11 05:28:57.956+07	1	49	43	Светлана - Вставка блока(Книга 1.2 - Прикладная биология с основами почвоведения Ч1)	1	
252	2012-05-11 05:30:00.906+07	1	49	44	Светлана - Изготовление крышек(Книга 1.3 - Прикладная биология с основами почвоведения Ч2)	1	
253	2012-05-11 05:34:01.566+07	1	49	45	Уля - Вставка блока(Книга 1.2 - Прикладная биология с основами почвоведения Ч1)	1	
254	2012-05-11 05:36:48.947+07	1	49	45	Уля - Вставка блока(Книга 1.2 - Прикладная биология с основами почвоведения Ч1)	2	Changed count and duration.
255	2012-05-11 05:37:53.107+07	1	49	46	Уля - Изготовление крышек(Книга 1.2 - Прикладная биология с основами почвоведения Ч1)	1	
256	2012-05-11 05:40:32.537+07	1	41	22	Изготовление печатных форм	1	
257	2012-05-11 05:42:55.037+07	1	47	32	Изготовление печатных форм - Книга 1.1 - Педагогика тарихы бойынша атлас	1	
258	2012-05-11 05:43:16.167+07	1	49	47	Шерен - Изготовление печатных форм(Книга 1.1 - Педагогика тарихы бойынша атлас)	1	
259	2012-05-19 01:51:24.225+07	1	47	33	Изготовление крышек - Книга 1.6 - Коликте жане онеркесепте гылыми	1	
260	2012-05-19 01:52:36.875+07	1	49	48	Алия - Изготовление крышек(Книга 1.6 - Коликте жане онеркесепте гылыми)	1	
261	2012-05-19 01:57:17.833+07	1	47	34	Наклейка форзаца - Книга 1.12 - Поиск и реализация наукоемких продукций в промышленности и транспорте	1	
262	2012-05-19 01:58:58.282+07	1	49	49	Алия - Наклейка форзаца(Книга 1.12 - Поиск и реализация наукоемких продукций в промышленности и транспорте)	1	
263	2012-05-19 02:01:18.611+07	1	47	35	Ламинация - Книга 1.1 - Педагогика тарихы бойынша атлас	1	
264	2012-05-19 02:02:23.539+07	1	49	50	Алия - Ламинация(Книга 1.1 - Педагогика тарихы бойынша атлас)	1	
265	2012-05-19 07:03:43.317+07	1	47	10	Комплектация блоков - Книга 1.3 - Прикладная биология с основами почвоведения Ч2	2	Changed work_amount.
266	2012-05-19 07:04:33.253+07	1	47	36	Вставка блока - Книга 1.3 - Прикладная биология с основами почвоведения Ч2	1	
267	2012-05-19 07:06:40.057+07	1	49	51	Алия - Вставка блока(Книга 1.3 - Прикладная биология с основами почвоведения Ч2)	1	
268	2012-05-19 07:12:09.387+07	1	47	37	Упаковка - Книга 1.2 - Прикладная биология с основами почвоведения Ч1	1	
269	2012-05-19 07:14:35.949+07	1	49	52	Алия - Упаковка(Книга 1.2 - Прикладная биология с основами почвоведения Ч1)	1	
270	2012-05-19 07:15:26.4+07	1	47	38	Упаковка - Книга 1.3 - Прикладная биология с основами почвоведения Ч2	1	
271	2012-05-19 07:18:30.589+07	1	49	53	Алия - Упаковка(Книга 1.3 - Прикладная биология с основами почвоведения Ч2)	1	
272	2012-05-19 23:43:47.823+07	1	47	39	Изготовление крышек - Книга 1.9 - Автомобильдерге технологиялык	1	
273	2012-05-19 23:44:59.757+07	1	49	54	Алия - Изготовление крышек(Книга 1.9 - Автомобильдерге технологиялык)	1	
274	2012-05-19 23:45:54.112+07	1	36	5	Институт учителей 	1	
275	2012-05-19 23:49:15.693+07	1	42	5	Книга - мягкий переплёт	1	
276	2012-05-19 23:49:38.064+07	1	45	19	Книга - Алматы устазы	1	
277	2012-05-19 23:50:59.126+07	1	47	40	Биндер - Книга - Алматы устазы	1	
278	2012-05-19 23:51:49.002+07	1	49	55	Алия - Биндер(Книга - Алматы устазы)	1	
279	2012-05-19 23:58:20.324+07	1	41	23	Обрыв блоков после биндера	1	
280	2012-05-19 23:58:30.896+07	1	47	41	Обрыв блоков после биндера - Книга 1.9 - Автомобильдерге технологиялык	1	
281	2012-05-20 00:01:12.238+07	1	49	56	Уля - Обрыв блоков после биндера(Книга 1.9 - Автомобильдерге технологиялык)	1	
282	2012-05-20 00:03:11.957+07	1	49	57	Уля - Вставка блока(Книга 1.3 - Прикладная биология с основами почвоведения Ч2)	1	
283	2012-05-20 00:04:31.331+07	1	49	58	Уля - Изготовление крышек(Книга 1.9 - Автомобильдерге технологиялык)	1	
284	2012-05-20 00:05:45.897+07	1	49	58	Уля - Изготовление крышек(Книга 1.9 - Автомобильдерге технологиялык)	2	Changed count and duration.
285	2012-05-20 00:06:50.553+07	1	49	58	Уля - Изготовление крышек(Книга 1.9 - Автомобильдерге технологиялык)	2	Changed count and duration.
286	2012-05-20 00:11:56.579+07	1	47	42	Наклейка форзаца - Книга 1.7 - Теоретические основы проектирования и расчет	1	
287	2012-05-20 00:20:55.076+07	1	49	59	Уля - Наклейка форзаца(Книга 1.7 - Теоретические основы проектирования и расчет)	1	
288	2012-05-20 00:25:41.207+07	1	47	43	Изготовление крышек - Книга 1.1 - Педагогика тарихы бойынша атлас	1	
289	2012-05-20 00:27:29.673+07	1	49	60	Татьяна - Изготовление крышек(Книга 1.1 - Педагогика тарихы бойынша атлас)	1	
290	2012-05-20 00:29:11.511+07	1	47	44	Подборка - Книга - Алматы устазы	1	
291	2012-05-20 00:36:44.096+07	1	41	24	Рассоединение блоков	1	
292	2012-05-20 00:36:59.801+07	1	47	45	Рассоединение блоков - Книга - Алматы устазы	1	
293	2012-05-20 00:38:20.594+07	1	49	61	Татьяна - Рассоединение блоков(Книга - Алматы устазы)	1	
294	2012-05-20 00:39:46.949+07	1	46	4	Ризограф; (Книга 1.6 - Коликте жане онеркесепте гылыми, оффсет 65г, progonov - 2) listov - 16	1	
295	2012-05-20 00:41:24.436+07	1	50	4	Татьяна - Ризограф(Книга 1.6 - Коликте жане онеркесепте гылыми)	1	
296	2012-05-22 00:05:39.19+07	1	48	7	Мухабат Саитова	1	
438	2014-05-27 10:12:18.811+07	1	57	1	PressPrice object	1	
297	2012-05-22 00:13:15.569+07	1	47	46	Ламинация - Книга 1.6 - Коликте жане онеркесепте гылыми	1	
298	2012-05-22 00:15:03.037+07	1	49	62	Алия - Ламинация(Книга 1.6 - Коликте жане онеркесепте гылыми)	1	
299	2012-05-22 00:18:56.554+07	1	47	47	Подборка(3листа)+2фальца - Книга 1.12 - Поиск и реализация наукоемких продукций в промышленности и транспорте	1	
300	2012-05-22 00:20:50.824+07	1	49	63	Алия - Подборка(3листа)+2фальца(Книга 1.12 - Поиск и реализация наукоемких продукций в промышленности и транспорте)	1	
301	2012-05-22 00:23:31.068+07	1	49	64	Алия - Изготовление крышек(Книга 1.6 - Коликте жане онеркесепте гылыми)	1	
302	2012-05-22 00:24:06.277+07	1	48	7	Мухаббат Саитова	2	Changed first_name.
303	2012-05-22 00:26:41.092+07	1	41	25	Подборка(6л)+1фальц	1	
304	2012-05-22 00:27:11.2+07	1	47	48	Подборка(6л)+1фальц - Книга 1.4 - Экономикалык талдау	1	
305	2012-05-22 00:28:44.472+07	1	49	65	Мухаббат - Подборка(6л)+1фальц(Книга 1.4 - Экономикалык талдау)	1	
306	2012-06-16 00:13:24.276+07	1	49	75	Подборка(3листа)+2фальца - 1	3	
307	2012-06-16 00:13:25.259+07	1	49	76	Подборка(3листа)+2фальца - 2	3	
308	2012-06-16 00:13:25.305+07	1	49	77	Ниткошвейка - 1	3	
309	2012-06-16 00:13:25.352+07	1	49	78	Подборка(6л)+1фальц - 7	3	
310	2012-06-16 00:47:35.544+07	1	42	1	Книга A5 - твердый переплет	2	Changed title.
311	2012-07-10 10:48:17.245+07	1	51	1	Переплетный картон - Картон 2мм	1	
312	2012-07-10 10:59:47.983+07	1	39	11	Офсетная бумага от 120г	1	
313	2012-07-10 11:00:36.515+07	1	51	2	Офсетная бумага от 120г - Офсетная бумага 120г	1	
314	2012-07-10 11:06:50.541+07	1	38	2	SM-52-2	1	
315	2012-07-11 13:09:49.866+07	1	39	2	Бумага мелованная	2	Changed title.
316	2012-07-11 13:10:19.989+07	1	39	11	Бумага офсетная от 120г	2	Changed title.
317	2012-12-04 23:38:30.139+06	1	36	6	Акнур 	1	
318	2012-12-04 23:40:39.357+06	1	45	20	Историко-культурное наследие	1	
319	2012-12-04 23:41:52.018+06	1	48	8	Маша Русинова	1	
320	2012-12-04 23:43:00.654+06	1	45	20	Книга - Историко-культурное наследие	2	Changed title.
321	2012-12-04 23:45:15.137+06	1	41	26	Подбор 4 листа + 1 фальц	1	
322	2012-12-05 00:00:21.293+06	1	47	49	Книга - Историко-культурное наследие - Подбор 4 листа + 1 фальц	1	
323	2012-12-14 10:32:55.396+06	1	36	7	Гайворонский 	1	
324	2012-12-14 10:34:07.582+06	1	45	21	Книга - Избранное	1	
325	2012-12-14 10:34:27.232+06	1	47	50	Книга - Избранное - Изготовление крышек	1	
326	2012-12-14 10:43:40.219+06	1	45	22	Книга - Биология ч2	1	
327	2012-12-14 10:44:31.754+06	1	47	51	Книга - Биология ч2 - Ламинация	1	
328	2012-12-14 10:47:24.593+06	1	41	27	Фальцовка - третий сгиб	1	
329	2012-12-14 10:48:55.541+06	1	47	52	Книга - Биология ч2 - Фальцовка - третий сгиб	1	
330	2012-12-14 10:53:46.437+06	1	48	9	Елена Болкун	1	
331	2012-12-14 10:59:49.647+06	1	47	53	Книга - Избранное - Наклейка каптала	1	
332	2012-12-14 11:09:00.394+06	1	47	54	Книга - Избранное - Вставка блока	1	
333	2012-12-14 11:11:26.769+06	1	48	10	Гульмира 	1	
334	2012-12-14 11:26:26.912+06	1	48	11	Оксана Нурбаева	1	
335	2012-12-14 11:28:54.904+06	1	47	55	Книга - Биология ч2 - Биндер	1	
336	2012-12-21 00:38:27.919+06	1	47	56	Книга - Биология ч2 - Наклейка форзаца	1	
337	2012-12-21 00:41:37.302+06	1	47	57	Книга - Биология ч2 - Изготовление печатных форм	1	
338	2012-12-21 01:25:10.467+06	1	48	12	Елена Кучина	1	
339	2012-12-21 01:41:31.956+06	1	49	100	Фальцовка - третий сгиб - 250	3	
340	2012-12-21 01:41:45.673+06	1	49	101	Фальцовка - третий сгиб - 1350	2	Changed count.
341	2012-12-21 01:43:30.583+06	1	49	101	Фальцовка - третий сгиб - 1350	2	Changed duration.
342	2012-12-21 01:43:37.985+06	1	49	101	Фальцовка - третий сгиб - 1350	2	No fields changed.
343	2012-12-21 01:54:05.047+06	1	47	58	Книга - Избранное - Проклейка блока - биндер	1	
344	2012-12-21 01:59:48.579+06	1	47	59	Книга - Биология ч2 - Комплектация блоков	1	
345	2012-12-21 02:15:17.257+06	1	36	8	Ана Мен Бала 	1	
346	2012-12-21 02:18:24.478+06	1	42	6	Журнал А4 - на скобе	1	
347	2012-12-21 02:23:17.784+06	1	44	3	А4 (200x290)	1	
348	2012-12-21 02:23:41.424+06	1	45	23	Ана Мен Бала	1	
349	2012-12-21 02:26:44.115+06	1	45	23	Журнал - Ана Мен Бала	2	Changed title.
350	2012-12-21 23:41:16.149+06	1	49	113	Фальцовка - третий сгиб - 100	3	
351	2012-12-22 00:03:54.696+06	1	47	60	Книга - Биология ч2 - Фальцовка 120г (форзац)	1	
352	2012-12-22 00:10:26.734+06	1	47	61	Журнал - Ана Мен Бала - Фальцовка (1сгиб)	1	
353	2012-12-22 00:14:08.387+06	1	41	22	Изготовление печатных форм - A2	2	Changed title.
354	2012-12-22 00:19:27.422+06	1	36	9	Шашкин 	1	
355	2012-12-22 00:19:30.204+06	1	45	24	Книга - Шашкин	1	
356	2012-12-22 00:20:56.84+06	1	47	62	Книга - Шашкин - Изготовление печатных форм - A2	1	
357	2012-12-22 00:29:04.853+06	1	47	63	Журнал - Ана Мен Бала - Ламинация	1	
358	2013-08-09 04:28:27.049+07	1	36	10	Роза Бектаевна 	1	
359	2013-08-09 04:29:25.273+07	1	45	25	Журнал - Физика	1	
360	2013-08-09 04:31:17.892+07	1	47	64	Журнал - Физика - Подборка	1	
361	2013-08-09 04:38:00.961+07	1	45	26	Журнал - Ана мен бала	1	
362	2013-08-09 04:45:53.619+07	1	47	65	Журнал - Ана мен бала - Ламинация	1	
363	2013-08-09 04:52:20.408+07	1	36	11	Канат Серикпаев	1	
364	2013-08-09 04:53:23.107+07	1	45	27	Книга - Заповеди Тенгри (2013-04-13)	1	
365	2013-08-09 04:54:50.539+07	1	47	66	Книга - Заповеди Тенгри - Изготовление крышек	1	
366	2013-08-13 05:05:02.346+07	1	37	10	SprintR	1	
367	2013-08-13 05:05:21.485+07	1	51	3	Форма - CTP 525x459	1	
368	2013-08-13 05:43:10.67+07	1	38	1	Печать на меловке 4+4	1	
369	2013-08-13 05:44:00.304+07	1	38	1	SM52-2 на меловке 4+4	2	Changed title.
370	2013-08-13 12:37:01.211+07	1	39	12	Бумага офсетная	1	
371	2013-08-13 12:37:28.414+07	1	39	13	Бумага - самокопир	1	
372	2013-08-13 12:38:33.511+07	1	53	1	Machine object	1	
373	2013-08-15 21:54:51.058+07	1	53	1	SM52-2	1	
374	2013-08-17 23:18:09.221+07	1	38	2	SM52-2 - Бумага мелованная - 8	1	
375	2013-08-18 22:31:31.897+07	1	37	11	Берег	1	
376	2013-08-18 22:31:51.474+07	1	51	4	Бумага мелованная - Бумага мелованная гл. 130г	1	
377	2013-08-18 22:33:09.86+07	1	39	2	Бумага мелованная (90-200г)	2	Changed title.
378	2013-08-18 22:33:35.196+07	1	39	11	Бумага офсетная (120-160г)	2	Changed title.
379	2013-08-18 22:44:40.552+07	1	39	14	Клише	1	
380	2013-08-21 02:45:23.368+07	1	43	2	Бумага мелованная гл. 130г (Берег) - 19.5	1	
381	2013-08-21 02:46:22.399+07	1	51	4	Бумага мелованная (90-200г) - Бумага мелованная гл. 130г (64x92)	2	Changed title.
382	2013-08-28 11:44:39.106+07	1	55	1	MaterialType_group object	1	
383	2014-04-30 05:42:47.291+07	1	41	6	Подборка A3 (3листа)+2фальца	2	Changed title.
384	2014-04-30 05:44:36.288+07	1	41	12	Фальцовка форзаца	2	Changed title.
385	2014-04-30 05:50:17.788+07	1	42	1	Книга A5 - твердый переплет	2	Changed size_type and work_type.
386	2014-05-04 13:46:10.976+07	1	39	11	Бумага офсетная (115-120г)	2	Changed title and type_group.
387	2014-05-04 13:46:35.226+07	1	39	15	Бумага офсетная (65-80г)	1	
388	2014-05-04 13:47:18.566+07	1	53	1	SM52-2	2	Changed material_type.
389	2014-05-04 13:48:39.377+07	1	53	2	RO66	1	
390	2014-05-04 13:48:44.867+07	1	53	2	RO66	2	No fields changed.
391	2014-05-04 13:50:11.827+07	1	51	5	Бумага офсетная (65-80г) - Бумага офсетная 65г (620мм)	1	
392	2014-05-04 13:53:28.198+07	1	51	6	Форма - Форма - CTP 650x530	1	
393	2014-05-04 13:53:51.228+07	1	38	4	RO66 - Бумага офсетная (65-80г) - 2	1	
394	2014-05-09 09:37:13.227+07	1	39	1	Бумага мелованная	1	
395	2014-05-09 09:42:41.198+07	1	51	1	Бумага мелованная - Бумага глянцевая	1	
396	2014-05-09 09:42:56.838+07	1	51	1	Бумага мелованная - Бумага глянцевая	2	Changed price.
397	2014-05-09 09:59:08.827+07	1	55	2	Пластины офсетные	1	
398	2014-05-09 09:59:35.037+07	1	39	2	Пластина офсетная	1	
399	2014-05-09 10:00:07.157+07	1	51	2	Пластина офсетная - Пластина офсетная	1	
400	2014-05-09 11:54:43.681+07	1	39	1	Бумага мелованная	2	Changed width and height.
401	2014-05-09 11:55:49.311+07	1	43	1	Бумага глянцевая (Берег) - 5.75	2	Changed price.
402	2014-05-11 10:52:27.557+07	1	39	3	Бумага офсетная (листовая)	1	
403	2014-05-11 10:53:36.747+07	1	53	1	SM-52-2	1	
404	2014-05-11 10:59:57.419+07	1	51	1	Пластина офсетная - Пластина SM-52	1	
405	2014-05-11 11:03:40.269+07	1	38	4	SM-52-2 - Бумага мелованная - 4	1	
406	2014-05-11 11:26:55.555+07	1	38	5	SM-52-2 - Бумага офсетная (листовая) - 4 color	1	
407	2014-05-11 11:29:39.495+07	1	38	6	SM-52-2 - Бумага офсетная (листовая) - 1 color	1	
408	2014-05-11 11:34:05.656+07	1	39	4	Бумага офсетная ролевая	1	
409	2014-05-11 11:34:32.076+07	1	53	2	RO66-5	1	
410	2014-05-11 11:40:49.307+07	1	37	12	Сами	1	
411	2014-05-11 11:41:08.177+07	1	51	2	Пластина офсетная - Форма - с кальки	1	
412	2014-05-11 11:41:56.027+07	1	38	7	RO66-5 - Бумага офсетная ролевая - 1 color	1	
413	2014-05-11 11:45:29.072+07	1	51	2	Пластина офсетная - Форма с кальки	2	Changed title.
414	2014-05-11 11:45:57.652+07	1	51	1	Пластина офсетная - Форма SM-52	2	Changed title.
415	2014-05-11 11:51:29.923+07	1	51	3	Бумага офсетная ролевая - Бумага офсетная 620мм - 65г	1	
416	2014-05-11 11:51:45.193+07	1	51	3	Бумага офсетная ролевая - Бумага офсетная 620мм - 65г	2	Changed price.
417	2014-05-11 11:52:13.533+07	1	39	3	Бумага офсетная листовая	2	Changed title.
418	2014-05-26 10:30:54.28+07	1	51	1	Пластина офсетная - Пластина термальная 525х459	1	
419	2014-05-26 10:33:36.096+07	1	53	1	SM-52-2	1	
420	2014-05-26 10:48:41.844+07	1	38	1	SM-52-2 - Бумага мелованная - 2 color	1	
421	2014-05-26 10:50:21.062+07	1	38	2	SM-52-2 - Бумага офсетная листовая - 2 color	1	
422	2014-05-26 10:57:54.405+07	1	51	2	Бумага мелованная - Бумага мелованная 130г (920х640)	1	
423	2014-05-26 10:58:22.568+07	1	51	2	Бумага мелованная - Бумага мелованная 130г (920х640)	2	Added material price "Бумага мелованная 130г (920х640) (Берег) - 23.0".
424	2014-05-26 10:58:48.684+07	1	51	2	Бумага мелованная - Бумага мелованная 130г (920х640)	2	Changed price.
425	2014-05-26 11:10:05.065+07	1	51	3	Пластина офсетная - Пластина аналоговая HuangGuang (650x530)	1	
426	2014-05-26 11:18:05.573+07	1	53	2	RO66-5	1	
427	2014-05-26 11:23:13.65+07	1	38	3	RO66-5 - Бумага офсетная ролевая - 2 color	1	
428	2014-05-26 11:26:34.663+07	1	53	1	SM52-2	2	Changed m_name.
429	2014-05-27 03:12:03.824+07	1	51	2	Бумага мелованная - 130г, глянцевая (920х640)	2	Changed title.
430	2014-05-27 03:13:20.464+07	1	51	1	Пластина офсетная - термальная 525х459	2	Changed title.
431	2014-05-27 03:13:50.904+07	1	51	3	Пластина офсетная - аналоговая HuangGuang (650x530)	2	Changed title.
432	2014-05-27 03:18:24.424+07	1	51	4	Бумага офсетная листовая - 65г (860х620)	1	
433	2014-05-27 03:28:49.825+07	1	39	5	Мастер-пленка	1	
434	2014-05-27 03:30:15.845+07	1	37	13	Технология+	1	
437	2014-05-27 03:36:26.596+07	1	53	3	RZ370	1	
443	2014-05-28 22:35:52.599+07	1	37	14	Гейдельберг Нордазиен	1	
444	2014-05-28 22:37:47.603+07	1	43	5	Sentoplex GLP 500 (Гейдельберг Нордазиен) - 10000.0	1	
445	2014-05-28 22:58:34.488+07	1	43	4	Мастер-пленка (Технология+) - 80.0	2	Changed packing.
446	2014-05-28 22:58:50.665+07	1	43	3	65г (860х620) (Литан) - 8.5	2	Changed packing.
447	2014-05-28 22:59:03.317+07	1	43	1	термальная 525х459 (SprintR) - 535.0	2	Changed packing.
448	2014-05-28 22:59:16.062+07	1	43	5	Sentoplex GLP 500 (Гейдельберг Нордазиен) - 10000.0	2	Changed packing.
449	2014-05-28 22:59:36.638+07	1	39	9	Смазка	2	No fields changed.
450	2014-05-28 22:59:41.833+07	1	39	9	Смазка	2	No fields changed.
451	2014-05-28 23:01:06.37+07	1	39	5	Мастер-пленка	2	Changed unit_of_meas.
452	2014-05-28 23:01:17.118+07	1	39	4	Бумага офсетная ролевая	2	No fields changed.
453	2014-05-28 23:01:47.679+07	1	39	3	Бумага офсетная листовая	2	No fields changed.
454	2014-05-28 23:01:53.232+07	1	39	2	Пластина офсетная	2	No fields changed.
455	2014-05-28 23:02:04.23+07	1	39	9	Смазка	2	No fields changed.
456	2014-05-28 23:04:54.71+07	1	43	2	130г, глянцевая (920х640) (Берег) - 23.0	2	Changed packing.
457	2014-05-28 23:05:45.77+07	1	39	1	Бумага мелованная	2	Changed unit_of_meas.
458	2014-05-28 23:07:56.139+07	1	51	6	Смазка - Sentoplex GLP 500	2	Changed price.
459	2014-05-29 08:31:22.881+07	1	56	5	Sentoplex GLP 500 for Печать в 2 краски - 0.001	2	Changed amount.
460	2014-05-29 08:32:20.821+07	1	56	5	Sentoplex GLP 500 for Печать в 2 краски - 1e-05	2	Changed amount.
461	2014-05-29 08:34:03.961+07	1	39	10	Противоотмарочный парашок	1	
462	2014-05-29 08:35:01.891+07	1	51	7	Противоотмарочный парашок - 1000 микрон ?????	1	
463	2014-05-29 08:35:19.201+07	1	56	6	1000 микрон ????? for Печать в 2 краски - 1e-05	1	
464	2014-05-29 08:39:03.202+07	1	37	15	Гридан комерц	1	
465	2014-05-29 08:59:22.445+07	1	43	6	1000 микрон ????? (Гридан комерц) - 2500.0	1	
466	2014-05-29 09:00:20.005+07	1	51	7	Противоотмарочный парашок - 1000 микрон ?????	2	Changed price.
467	2014-05-29 22:41:34.675+07	1	37	16	Регент Алатау	1	
468	2014-05-29 22:42:58.665+07	1	51	8	Бумага мелованная - Art Тех (мат)	1	
469	2014-05-29 22:43:39.725+07	1	51	2	Бумага мелованная - 130г, глянцевая (920х640)	2	Changed width.
470	2014-05-29 22:44:19.015+07	1	51	2	Бумага мелованная - 130г (глян-920х640)	2	Changed title.
471	2014-05-29 22:45:22.055+07	1	51	8	Бумага мелованная - Art Тех (мат-920х640)	2	Changed title. Added material price "Art Тех (мат-920х640) (Регент Алатау) - 15.56".
472	2014-05-29 22:46:17.625+07	1	51	8	Бумага мелованная - 105г - Art Тех (мат-920х640)	2	Changed title.
473	2014-05-29 22:47:17.355+07	1	51	8	Бумага мелованная - 105г - Art Тех (мат-920х640)	2	Changed price.
474	2014-05-29 22:47:47.925+07	1	51	8	Бумага мелованная - 105г - Art Тех (мат-920х640)	2	Changed width and height.
475	2014-05-30 12:29:28.983+07	1	51	1	Пластина офсетная - термальная 525х459	2	Changed price.
476	2014-06-11 11:22:51.484+07	1	39	11	Краска офсетная	1	
477	2014-06-11 11:28:15.424+07	1	51	9	Краска офсетная - Angel TGS-N (черная)	1	
478	2014-06-11 11:33:49.426+07	1	39	12	Печатная химия	1	
479	2014-06-11 11:35:32.906+07	1	51	10	Печатная химия - Очиститель пластина А21	1	
480	2014-06-11 11:35:57.216+07	1	51	10	Печатная химия - Очиститель пластин А21	2	Changed title.
481	2014-06-11 11:39:28.586+07	1	51	11	Пластина офсетная - Dongfang (650x530;0.3)	1	
482	2014-06-11 11:42:09.886+07	1	39	13	Резина офсетная	1	
483	2014-06-11 11:44:22.907+07	1	51	12	Резина офсетная - Zhisen (536x460)	1	
484	2014-06-11 11:53:23.797+07	1	39	14	Чехол увлажнения	1	
485	2014-06-11 11:56:20.338+07	1	51	13	Чехол увлажнения - S 240/200 д.76-64	1	
486	2014-06-11 11:59:45.318+07	1	51	14	Бумага мелованная - Арт Тех	1	
487	2014-06-11 12:01:25.886+07	1	51	14	Бумага мелованная - Арт Тех (920х640; мат)	2	Changed title.
488	2014-06-11 12:01:46.336+07	1	51	8	Бумага мелованная - 105г - Art Тех (920х640; мат)	2	Changed title.
489	2014-06-11 12:02:20.186+07	1	51	2	Бумага мелованная - 130г (920х640; глян)	2	Changed title.
490	2014-06-11 12:04:32.097+07	1	51	14	Бумага мелованная - 150г - Арт Тех (920х640; мат)	2	Changed title.
491	2014-06-11 12:07:48.508+07	1	39	15	Картон двусторонний	1	
492	2014-06-11 12:09:48.578+07	1	51	15	Картон двусторонний - Cristal Board C2S - 270г (920х640)	1	
493	2014-06-11 12:10:50.918+07	1	51	15	Картон двусторонний - 270г - Cristal Board C2S (920х640; 2ст)	2	Changed title.
494	2014-06-11 12:12:16.728+07	1	51	16	Бумага мелованная - Ecostar	1	
495	2014-06-11 12:13:46.688+07	1	51	16	Бумага мелованная - 130г - Ecostar (920x640; глян)	2	Changed title.
496	2014-06-11 12:16:14.488+07	1	51	17	Бумага мелованная - 105г - Ecosatin (920x640; мат)	1	
497	2014-06-11 12:20:20.859+07	1	51	18	Бумага офсетная листовая - 80г - (860х620)	1	
498	2014-06-11 12:24:23.809+07	1	37	17	ВИП Системы	1	
499	2014-06-11 12:24:58.319+07	1	51	19	Краска офсетная - Rapida FW 10 RP/2.5V2	1	
500	2014-06-11 12:26:37.049+07	1	51	20	Краска офсетная - Jobbing Black	1	
501	2014-06-11 12:31:03.55+07	1	51	15	Картон двусторонний - 270г - Cristal Board C2S (920х640; 2ст)	2	Added material price "270г - Cristal Board C2S (920х640; 2ст) (Берег) - 50.4".
502	2014-06-11 12:34:21.03+07	1	51	21	Пластина офсетная - PL-PS IV (525x459x0.15)	1	
503	2014-06-11 12:34:52.42+07	1	51	21	Пластина офсетная - PL-PS IV (525x459x0.15)	2	Changed price.
504	2014-06-12 07:19:03.29+07	1	51	22	Пластина офсетная - PL-PS IV (650x530x0.3)	1	
505	2014-06-13 12:43:42.9+07	1	38	2	Бумага офсетная листовая - SM52-2 - Печать в 2 краски	2	Changed title.
683	2014-08-11 23:07:34.02+07	1	66	2	Дауир Сервис	1	
506	2014-06-13 13:08:24.551+07	1	43	22	PL-PS IV (650x530x0.3) (Гридан комерц) - 325.0	2	Changed nomen_title.
507	2014-06-13 13:08:53.052+07	1	43	21	PL-PS IV (525x459x0.15) (Гридан комерц) - 160.0	2	Changed nomen_title.
508	2014-06-13 13:09:34.052+07	1	43	20	270г - Cristal Board C2S (920х640; 2ст) (Берег) - 50.4	2	Changed nomen_title.
509	2014-06-13 13:09:58.982+07	1	43	19	Jobbing Black (ВИП Системы) - 1200.0	2	Changed nomen_title.
510	2014-06-13 13:11:02.162+07	1	43	18	Rapida FW 10 RP/2.5V2 (ВИП Системы) - 1195.0	2	Changed nomen_title.
511	2014-06-13 13:11:56.382+07	1	43	17	80г - (860х620) (Литан) - 10.45	2	Changed nomen_title.
512	2014-06-13 13:14:20.962+07	1	43	16	105г - Ecosatin (920x640; мат) (Берег) - 17.1	2	Changed nomen_title.
513	2014-06-13 13:14:39.372+07	1	43	15	130г - Ecostar (920x640; глян) (Берег) - 21.4	2	Changed nomen_title.
514	2014-06-13 13:15:05.512+07	1	43	14	270г - Cristal Board C2S (920х640; 2ст) (Берег) - 53.0	2	Changed nomen_title.
515	2014-06-13 13:15:46.952+07	1	43	13	150г - Арт Тех (920х640; мат) (Регент Алатау) - 23.17	2	Changed nomen_title.
516	2014-06-13 13:16:22.922+07	1	43	12	S 240/200 д.76-64 (AllForPress) - 5300.0	2	Changed nomen_title.
517	2014-06-13 13:17:08.682+07	1	43	11	Zhisen (536x460) (AllForPress) - 3700.0	2	Changed nomen_title.
518	2014-06-13 13:17:27.542+07	1	43	10	Dongfang (650x530;0.3) (AllForPress) - 329.0	2	Changed nomen_title.
519	2014-06-13 13:17:40.572+07	1	43	9	Очиститель пластин А21 (AllForPress) - 1560.0	2	Changed nomen_title.
520	2014-06-13 13:18:00.722+07	1	43	8	Angel TGS-N (черная) (AllForPress) - 1304.0	2	Changed nomen_title.
521	2014-06-13 13:18:23.822+07	1	43	7	105г - Art Тех (920х640; мат) (Регент Алатау) - 15.56	2	Changed nomen_title.
522	2014-06-13 13:19:30.152+07	1	43	6	1000 микрон ????? (Гридан комерц) - 2500.0	2	Changed nomen_title.
523	2014-06-13 13:19:59.102+07	1	43	5	Sentoplex GLP 500 (Гейдельберг Нордазиен) - 10000.0	2	Changed nomen_title.
524	2014-06-13 13:20:19.262+07	1	43	4	Мастер-пленка (Технология+) - 80.0	2	Changed nomen_title.
525	2014-06-13 13:20:59.083+07	1	43	3	65г (860х620) (Литан) - 8.5	2	Changed nomen_title.
526	2014-06-13 13:22:09.633+07	1	51	22	Пластина офсетная - 650x530x0.3	2	Changed title.
527	2014-06-13 13:22:29.444+07	1	51	21	Пластина офсетная - 525x459x0.15	2	Changed title.
528	2014-06-13 13:23:07.154+07	1	51	20	Краска офсетная - краска для листовой печати	2	Changed title.
529	2014-06-13 13:24:56.244+07	1	43	18	краска для листовой печати (ВИП Системы) - 1195.0	2	Changed material.
530	2014-06-13 13:27:17.039+07	1	51	17	Бумага мелованная - 105г (920x640)	2	Changed title.
531	2014-06-13 13:27:51.601+07	1	51	8	Бумага мелованная - 105г (920х640)	2	Changed title.
532	2014-06-13 13:28:49.161+07	1	51	16	Бумага мелованная - 130г (920x640)	2	Changed title.
533	2014-06-13 13:35:34.062+07	1	43	7	105г (920x640) (Регент Алатау) - 15.56	2	Changed material.
534	2014-06-13 13:36:59.812+07	1	51	8	Бумага мелованная - 105г (920х640)	3	
535	2014-06-13 13:38:18.992+07	1	51	2	Бумага мелованная - 130г (920х640; глян)	3	
536	2014-06-13 13:38:46.792+07	1	51	14	Бумага мелованная - 150г (920х640)	2	Changed title.
537	2014-06-13 13:39:22.642+07	1	51	18	Бумага офсетная листовая - 80г (860х620)	2	Changed title.
538	2014-06-13 13:40:12.082+07	1	51	1	Пластина офсетная - Термальная 525х459	2	Changed title and width.
539	2014-06-13 13:41:02.122+07	1	43	10	650x530x0.3 (AllForPress) - 329.0	2	Changed material.
540	2014-06-13 13:41:19.562+07	1	51	11	Пластина офсетная - Dongfang (650x530;0.3)	3	
541	2014-06-13 13:41:55.052+07	1	51	22	Пластина офсетная - аналоговая 650x530x0.3	2	Changed title.
542	2014-06-13 13:42:17.612+07	1	51	21	Пластина офсетная - аналоговая 525x459x0.15	2	Changed title.
543	2014-06-13 13:42:41.082+07	1	51	3	Пластина офсетная - аналоговая HuangGuang (650x530)	3	
544	2014-06-13 13:43:08.222+07	1	51	21	Пластина офсетная - Аналоговая 525x459x0.15	2	Changed title.
545	2014-06-13 13:43:24.303+07	1	51	22	Пластина офсетная - Аналоговая 650x530x0.3	2	Changed title.
546	2014-06-13 13:43:48.893+07	1	51	1	Пластина офсетная - Термальная 525х459x0.15	2	Changed title.
547	2014-06-13 13:44:28.763+07	1	51	19	Краска офсетная - Rapida FW 10 RP/2.5V2	3	
548	2014-06-13 13:45:28.353+07	1	51	20	Краска офсетная - Краска для листовой печати	2	Changed title.
549	2014-06-13 13:46:00.733+07	1	43	8	Краска для листовой печати (AllForPress) - 1304.0	2	Changed material.
550	2014-06-13 13:46:12.963+07	1	51	9	Краска офсетная - Angel TGS-N (черная)	3	
551	2014-06-13 13:48:12.073+07	1	51	15	Картон двусторонний - 270г (920х640)	2	Changed title.
552	2014-06-13 21:33:48.875+07	1	51	17	Бумага мелованная - 105г (920x640)	2	Added material price "105г (920x640) (Регент Алатау) - 14.28".
553	2014-06-13 21:35:48.785+07	1	51	16	Бумага мелованная - 130г (920x640)	2	Added material price "130г (920x640) (Регент Алатау) - 17.32".
554	2014-06-13 21:38:17.335+07	1	39	16	Допечатная химия	1	
555	2014-06-13 21:40:39.005+07	1	51	23	Допечатная химия - Проявитель пластин	1	
556	2014-06-13 21:41:48.815+07	1	39	17	Клей	1	
557	2014-06-13 21:46:41.206+07	1	37	18	ИП Дуболазов Дмитрий Дмитриевич	1	
558	2014-06-13 21:48:24.986+07	1	51	24	Клей - Клей для крышкоделки	1	
559	2014-06-13 23:16:02.864+07	1	39	18	Переплетный картон	1	
560	2014-06-13 23:18:28.966+07	1	37	19	Сателлит	1	
561	2014-06-13 23:19:35.766+07	1	51	25	Переплетный картон - 2.0мм (70х100)	1	
562	2014-06-14 04:42:47.981+07	1	51	21	Пластина офсетная - Аналоговая 525x459x0.15	2	Added material price "Аналоговая 525x459x0.15 (ВИП Системы) - 155.0".
563	2014-06-14 05:34:48.337+07	1	51	26	Бумага офсетная листовая - 120г (90x64)	1	
564	2014-06-14 05:35:15.957+07	1	51	26	Бумага офсетная листовая - 120г (900x640)	2	Changed title.
684	2014-08-11 23:07:55.258+07	1	66	3	Остров крым	1	
685	2014-08-11 23:08:09.788+07	1	66	4	Берег	1	
565	2014-06-14 05:41:20.522+07	1	51	14	Бумага мелованная - 150г (920х640)	2	Added material price "150г (920х640) (Берег) - 22.0".
566	2014-06-14 05:43:20.014+07	1	51	27	Бумага мелованная - 130г (1040x720)	1	
567	2014-06-14 05:44:25.888+07	1	51	27	Бумага мелованная - 130г (1040x720)	2	Added material price "130г (1040x720) (Берег) - 23.8".
568	2014-06-14 05:54:05.218+07	1	51	18	Бумага офсетная листовая - 80г (860х620)	2	Changed nomen_title for material price "80г (860х620) (Литан) - 10.45".
569	2014-06-14 05:55:59.602+07	1	39	19	Сторонние услуги	1	
570	2014-06-14 05:57:18.672+07	1	51	28	Сторонние услуги - Заточка ножа 92см	1	
571	2014-06-16 11:26:33.162+07	1	39	20	Печатные материалы	1	
572	2014-06-16 11:27:25.079+07	1	51	29	Печатные материалы - Форма офсетная (готовая к печати)	1	
573	2014-06-16 11:30:05.229+07	1	51	1	Печатные материалы - Форма 525х459x0.15 (термальная)	2	Changed title and material_type.
574	2014-06-16 11:30:35.961+07	1	38	1	Бумага мелованная - SM52-2 - Печать в 2 краски односторонняя	2	Changed title.
575	2014-06-16 11:31:23.354+07	1	38	1	Бумага мелованная - SM52-2 - Печать в 2 краски односторонняя	2	Added press consumption norm "Форма 525х459x0.15 (термальная) for Печать в 2 краски односторонняя - 2.0".
576	2014-06-16 11:32:22.072+07	1	51	29	Печатные материалы - Форма офсетная (готовая к печати)	3	
577	2014-06-16 11:33:14.348+07	1	51	7	Печатные материалы - 1000 микрон ?????	2	Changed material_type.
578	2014-06-16 11:33:52.35+07	1	39	10	Противоотмарочный порошок	2	Changed title.
579	2014-06-16 11:34:40.429+07	1	39	20	Форма офсетная (готовая к печати)	2	Changed title.
580	2014-06-16 11:36:05.808+07	1	51	7	Противоотмарочный порошок - 1000 микрон ?????	2	Changed material_type.
581	2014-06-16 11:36:43.404+07	1	55	3	Печатные материалы	1	
582	2014-06-16 11:37:56.632+07	1	39	20	Форма офсетная (готовая к печати)	2	Changed type_group.
583	2014-06-16 11:38:05.617+07	1	39	10	Противоотмарочный порошок	2	Changed type_group.
584	2014-06-16 11:38:16.241+07	1	39	11	Краска офсетная	2	Changed type_group.
585	2014-06-16 11:39:01.528+07	1	39	14	Чехол увлажнения	2	Changed type_group.
586	2014-06-16 11:47:28.853+07	1	53	1	SM52-2	2	Changed paper_type.
587	2014-06-16 11:51:30.17+07	1	51	27	Бумага мелованная - 130г (1040x720)	2	Changed price.
588	2014-06-16 11:51:53.414+07	1	51	26	Бумага офсетная листовая - 120г (900x640)	2	Changed price.
589	2014-06-16 11:53:00.479+07	1	51	20	Краска офсетная - Краска для листовой печати	2	Changed price.
590	2014-06-16 11:53:16.391+07	1	51	18	Бумага офсетная листовая - 80г (860х620)	2	Changed price.
591	2014-06-16 11:53:53.737+07	1	51	17	Бумага мелованная - 105г (920x640)	2	Changed price.
592	2014-06-16 11:54:12.879+07	1	51	16	Бумага мелованная - 130г (920x640)	2	Changed price.
593	2014-06-16 11:54:43.018+07	1	51	14	Бумага мелованная - 150г (920х640)	2	Changed price.
594	2014-06-16 11:55:21.503+07	1	51	4	Бумага офсетная листовая - 65г (860х620)	2	Changed price.
595	2014-06-16 12:16:00.193+07	1	38	4	Бумага мелованная - SM52-2 - Печать в 4 краски односторонняя	1	
596	2014-06-16 12:17:03.233+07	1	38	4	Бумага мелованная - SM52-2 - Печать в 4 краски односторонняя	2	Added press consumption norm "Форма 525х459x0.15 (термальная) for Печать в 4 краски односторонняя - 4.0".
597	2014-06-16 12:21:22.739+07	1	57	2	Печать в 4 краски односторонняя	1	
598	2014-06-16 12:23:07.744+07	1	57	2	Печать в 4 краски односторонняя	2	Changed item_charge.
599	2014-06-16 12:23:31.128+07	1	57	1	Печать в 2 краски односторонняя	2	Changed item_charge.
600	2014-06-16 12:25:15.274+07	1	57	2	Печать в 4 краски односторонняя	2	Changed fitting_charge.
601	2014-06-16 12:25:30.671+07	1	57	1	Печать в 2 краски односторонняя	2	Changed fitting_charge.
602	2014-06-18 06:35:53.822+07	1	37	20	AB Graph	1	
603	2014-06-18 06:36:39.124+07	1	37	20	AB Graf	2	Changed title.
604	2014-06-18 06:44:15.893+07	1	51	30	Бумага мелованная - 200г (920x640) глянец	1	
605	2014-06-18 06:46:22.487+07	1	51	27	Бумага мелованная - 130г (1040x720)	2	Added material price "130г (1040x720) (AB Graf) - 21.25".
606	2014-06-18 06:46:55.7+07	1	51	27	Бумага мелованная - 130г (1040x720) глянец	2	Changed title.
607	2014-06-21 04:53:56.416+07	1	51	15	Картон двусторонний - 270г (920х640)	2	Added material price "270г (920х640) (Берег) - 51.0".
608	2014-06-21 04:54:38.084+07	1	51	15	Картон двусторонний - 270г (920х640)	2	Changed width, height and density.
609	2014-06-21 04:58:11.04+07	1	51	30	Бумага мелованная - 200г (920x640) глянец	2	Added material price "200г (920x640) глянец (Регент Алатау) - 27.05".
610	2014-06-21 05:00:27.056+07	1	51	31	Бумага мелованная - 90г мат	1	
611	2014-06-21 05:01:23.372+07	1	51	31	Бумага мелованная - 90г (920х640) мат	2	Changed title.
612	2014-06-21 05:16:05.219+07	1	39	21	Пленка для ламинации	1	
613	2014-06-21 05:17:21.815+07	1	37	21	Принт Ресурс	1	
614	2014-06-21 05:20:02.402+07	1	51	32	Пленка для ламинации - Пленка для гор. ламинации 25мк. (305мм) глян	1	
615	2014-06-21 05:25:25.354+07	1	51	33	Пленка для ламинации - Пленка для гор. ламинации 25мк. (305мм) мат	1	
616	2014-07-02 03:10:43.846+07	1	39	22	Бумага этикеточная	1	
617	2014-07-02 03:11:45.866+07	1	51	34	Бумага этикеточная - 940х620	1	
618	2014-07-02 03:12:29.346+07	1	51	34	Бумага этикеточная - 940х620	2	Added material price "940х620 (Берег) - 17.0".
619	2014-07-02 03:12:40.63+07	1	51	34	Бумага этикеточная - 940х620	2	No fields changed.
620	2014-07-02 03:13:01.947+07	1	51	34	Бумага этикеточная - (940х620)	2	Changed title.
621	2014-07-02 04:07:07.262+07	1	51	35	Бумага этикеточная - (1040х720)	1	
622	2014-07-02 04:07:48.764+07	1	51	34	Бумага этикеточная - (940х620)	2	Changed nomen_title for material price "(940х620) (Берег) - 17.0".
623	2014-07-29 06:00:43.413+07	1	51	36	Бумага мелованная - 250г (920x640) мат	1	
624	2014-07-29 06:03:11.752+07	1	51	36	Бумага мелованная - 250г (920x640) мат	2	Added material price "250г (920x640) мат (Берег) - 41.0".
625	2014-07-29 06:03:38.499+07	1	51	36	Бумага мелованная - 250г (920x640) мат	2	Changed price.
626	2014-07-29 06:28:15.456+07	1	51	36	Бумага мелованная - 250г (920x640) мат	2	No fields changed.
627	2014-07-29 06:30:52.811+07	1	51	31	Бумага мелованная - 90г (920х640) мат	2	Added material price "90г (920х640) мат (Берег) - 15.2".
628	2014-07-29 06:31:09.656+07	1	51	31	Бумага мелованная - 90г (920х640) мат	2	Changed price.
629	2014-08-01 00:14:20.089+07	1	51	37	Бумага офсетная листовая - 120г (860x620)	1	
630	2014-08-01 00:16:44.015+07	1	51	37	Бумага офсетная листовая - 120г (860x620)	2	Added material price "120г (860x620) (Литан) - 15.676".
631	2014-08-01 00:16:55.7+07	1	51	37	Бумага офсетная листовая - 120г (860x620)	2	Changed price.
632	2014-08-01 00:18:14.606+07	1	51	38	Бумага офсетная листовая - 80г (900х640)	1	
633	2014-08-01 00:19:11.506+07	1	51	38	Бумага офсетная листовая - 80г (900х640)	2	Added material price "80г (900х640) (Литан) - 11.29".
634	2014-08-07 00:41:17.729+07	1	37	22	Казбумторг	1	
635	2014-08-07 00:42:59.899+07	1	51	39	Бумага офсетная ролевая - 70г (620)	1	
636	2014-08-07 00:48:36.709+07	1	51	31	Бумага мелованная - 90г (920х640) мат	2	Added material price "90г (920х640) мат (Берег) - 13.2".
637	2014-08-07 00:49:00.487+07	1	51	31	Бумага мелованная - 90г (920х640) мат	2	Changed price.
638	2014-08-07 00:51:36.647+07	1	51	40	Бумага мелованная - 90г (920х640) глян	1	
639	2014-08-07 00:51:52.281+07	1	51	40	Бумага мелованная - 90г (920х640) глян	2	Changed price.
640	2014-08-07 00:54:13.908+07	1	51	31	Бумага мелованная - 90г (920х640) мат	2	Changed price.
641	2014-08-07 00:55:29.898+07	1	43	47	90г (920х640) глян (Берег) - 13.2	2	Changed material.
642	2014-08-07 00:58:57.635+07	1	51	16	Бумага мелованная - 130г (920x640) мат	2	Changed title.
643	2014-08-07 01:02:12.645+07	1	51	16	Бумага мелованная - 130г (920x640) мат	2	Added material price "130г (920x640) мат (Регент Алатау) - 19.4".
644	2014-08-07 01:04:09.908+07	1	39	23	Бумага самокопир	1	
645	2014-08-07 01:06:02.68+07	1	51	41	Бумага самокопир - GIROFORM ULTRA 60г	1	
646	2014-08-07 01:06:54.693+07	1	51	41	Бумага самокопир - GIROFORM ULTRA 60г (430х305)	2	Changed title.
647	2014-08-07 01:08:25.666+07	1	51	41	Бумага самокопир - GIROFORM 60г (430х305)	2	Changed title. Added material price "GIROFORM 60г (430х305) (Берег) - 5.2".
648	2014-08-07 02:06:01.035+07	1	51	41	Бумага самокопир - GIROFORM 60г (430х305) верх	2	Changed title. Changed nomen_title for material price "GIROFORM 60г (430х305) верх (Берег) - 5.2".
649	2014-08-07 02:07:07.774+07	1	51	41	Бумага самокопир - GIROFORM 60г (430х305) верх	2	Changed price.
650	2014-08-07 02:09:28.223+07	1	51	42	Бумага самокопир - GIROFORM 60г (430х305) середина	1	
651	2014-08-07 02:13:06.961+07	1	51	43	Бумага самокопир - GIROFORM 60г (430х305) верх	1	
652	2014-08-07 02:13:33.192+07	1	51	43	Бумага самокопир - GIROFORM 55г (430х305) верх	2	Changed title and density.
653	2014-08-07 02:13:44.022+07	1	51	43	Бумага самокопир - GIROFORM 55г (430х305) верх	2	Changed price.
654	2014-08-07 02:14:56.85+07	1	51	42	Бумага самокопир - GIROFORM 53г (430х305) середина	2	Changed title and density. Changed nomen_title for material price "GIROFORM 53г (430х305) середина (Берег) - 5.7".
655	2014-08-07 02:16:28.564+07	1	51	41	Бумага самокопир - GIROFORM 60г (430х305) верх	2	Changed nomen_title for material price "GIROFORM 60г (430х305) верх (Берег) - 5.2".
656	2014-08-07 02:19:43.539+07	1	51	44	Картон двусторонний - 270г (1040х720)	1	
657	2014-08-07 02:19:58.061+07	1	51	44	Картон двусторонний - 270г (1040х720)	2	Changed price.
658	2014-08-07 02:24:56.783+07	1	51	40	Бумага мелованная - 90г (920х640) глян	2	Added material price "90г (920х640) глян (Берег) - 16.7".
659	2014-08-07 02:27:35.153+07	1	39	24	Переплетные материалы	1	
660	2014-08-07 02:29:40.919+07	1	51	45	Переплетные материалы - Каптал x/б белый	1	
661	2014-08-07 02:29:49.723+07	1	51	45	Переплетные материалы - Каптал x/б белый	2	Changed price.
662	2014-08-08 02:01:48.227+07	1	51	46	Бумага офсетная листовая - 65г (900х640)	1	
663	2014-08-08 02:04:01.757+07	1	51	46	Бумага офсетная листовая - 65г (900х640)	2	Added material price "65г (900х640) (Литан) - 9.172".
664	2014-08-08 22:13:05.64+07	1	37	23	Юркур	1	
665	2014-08-08 22:14:03.421+07	1	51	47	Клей - Термоклей	1	
666	2014-08-08 22:17:16.092+07	1	37	7	AllForPress	2	Changed telno.
667	2014-08-08 22:20:34.862+07	1	37	11	Берег	2	Changed telno.
668	2014-08-11 13:16:37.098+07	1	62	2	Бензин = 115.0	1	
669	2014-08-11 13:18:19.468+07	1	63	1	AllForPress	1	
670	2014-08-11 13:18:52.278+07	1	63	2	Казпочта, Эврика, Евразия	1	
671	2014-08-11 13:19:08.608+07	1	63	3	Итрако	1	
672	2014-08-11 13:19:28.968+07	1	63	4	Атип	1	
673	2014-08-11 13:19:45.688+07	1	63	5	Гридан	1	
674	2014-08-11 22:17:25.53+07	1	63	6	Остров крым	1	
675	2014-08-11 22:19:16.53+07	1	63	7	Берег	1	
676	2014-08-11 22:19:52.01+07	1	63	8	Книжная палата	1	
677	2014-08-11 22:21:12.62+07	1	63	9	AlmaPaper + Регент Алатау + Меховое ателье	1	
678	2014-08-11 22:21:34.42+07	1	63	7	Берег	2	Changed distance.
679	2014-08-11 22:22:08.78+07	1	63	10	Берег + Принт ресурс	1	
680	2014-08-11 22:54:25.162+07	1	63	11	Институт металургии + Дворец спорта	1	
681	2014-08-11 23:06:40.129+07	1	66	1	AlmaPaper + Регент Алатау + Меховое ателье	1	
682	2014-08-11 23:07:26.569+07	1	63	12	Дауир Сервис	1	
686	2014-08-11 23:08:37.048+07	1	66	5	Берег + Принт ресурс	1	
687	2014-08-11 23:08:44.358+07	1	66	5	Берег + Принт ресурс	2	No fields changed.
688	2014-08-11 23:09:02.898+07	1	66	6	Книжная палата	1	
689	2014-08-11 23:09:25.658+07	1	66	7	Институт металургии + Дворец спорта	1	
690	2014-08-11 23:09:51.608+07	1	66	8	Гридан	1	
691	2014-08-13 23:30:23.084+07	1	51	48	Бумага мелованная - 115г (920х640) глян	1	
692	2014-08-14 00:11:22.912+07	1	51	49	Бумага мелованная - 170г (920х640) глян	1	
693	2014-08-14 00:13:58.833+07	1	51	50	Бумага мелованная - 150г (920х640) глян	1	
694	2014-08-14 00:15:32.743+07	1	51	51	Бумага мелованная - 170г (1040х720) глян	1	
695	2014-08-14 00:17:01.123+07	1	51	27	Бумага мелованная - 130г (1040x720) глян	2	Changed title.
696	2014-08-14 00:17:19.003+07	1	51	30	Бумага мелованная - 200г (920x640) глян	2	Changed title.
697	2014-08-14 00:18:33.173+07	1	51	14	Бумага мелованная - 150г (920х640) мат	2	Changed title.
698	2014-08-14 00:19:12.213+07	1	51	17	Бумага мелованная - 105г (920x640) мат	2	Changed title.
699	2014-09-29 17:49:03.062+07	1	51	52	Пластина офсетная - Аналоговая 605x745x0.3	1	
700	2014-09-29 17:49:52.022+07	1	51	52	Пластина офсетная - Аналоговая 605x745x0.3	2	Changed price.
701	2014-09-29 17:52:29.124+07	1	51	53	Пластина офсетная - UV 525x459x0.15	1	
702	2014-09-29 17:52:41.414+07	1	51	53	Пластина офсетная - UV 525x459x0.15	2	Changed price.
703	2014-09-29 17:56:11.665+07	1	51	53	Пластина офсетная - UV 525x459x0.15	2	Added material price "UV 525x459x0.15 (ВИП Системы) - 223.0".
704	2014-09-29 18:00:04.208+07	1	39	25	Проявитель концентрат	1	
705	2014-09-29 18:07:16.461+07	1	39	25	Проявитель	2	Changed title.
706	2014-09-29 18:09:31.981+07	1	51	54	Проявитель - Проявитель концентрат	1	
707	2014-09-29 18:10:23.564+07	1	51	54	Проявитель - Проявитель концентрат	2	Changed price.
708	2014-09-29 18:16:08.943+07	1	51	55	Пластина офсетная - Аналоговая 510x400x0.15	1	
709	2014-09-29 18:16:17.633+07	1	51	55	Пластина офсетная - Аналоговая 510x400x0.15	2	Changed price.
710	2014-09-29 18:22:30.224+07	1	51	52	Пластина офсетная - Аналоговая 745x605x0.3	2	Changed title.
711	2014-09-29 18:24:49.484+07	1	51	56	Пластина офсетная - UV 745x605x0.3	1	
712	2014-09-29 18:25:41.874+07	1	51	56	Пластина офсетная - UV 745x605x0.3	2	Changed price.
713	2014-09-29 19:01:05.588+07	1	51	57	Пластина офсетная - Аналоговая 450x370x0.15	1	
714	2014-09-29 19:04:56.27+07	1	51	57	Пластина офсетная - Аналоговая 450x370x0.15	2	No fields changed.
715	2014-09-29 19:09:03.4+07	1	51	57	Пластина офсетная - Аналоговая 450x370x0.15	2	Changed price.
716	2014-09-29 19:15:08.272+07	1	51	58	Пластина офсетная - Аналоговая 650x490x0.3	1	
717	2014-09-29 19:15:41.232+07	1	51	58	Пластина офсетная - Аналоговая 650x490x0.3	2	Changed price.
718	2014-09-30 19:36:29.805+07	1	51	22	Пластина офсетная - Аналоговая 650x530x0.3	2	Changed packing for material price "Аналоговая 650x530x0.3 (AllForPress) - 329.0". Changed packing for material price "Аналоговая 650x530x0.3 (Гридан комерц) - 325.0".
719	2014-10-01 14:15:13.148+07	1	51	52	Пластина офсетная - Аналоговая 745x605x0.3	2	Added material price "Аналоговая 745x605x0.3 (AllForPress) - 430.0".
720	2014-10-01 14:20:38.679+07	1	51	57	Пластина офсетная - Аналоговая 450x370x0.15	2	Added material price "Аналоговая 450x370x0.15 (AllForPress) - 111.0".
721	2014-10-01 14:22:42.159+07	1	51	21	Пластина офсетная - Аналоговая 525x459x0.15	2	Added material price "Аналоговая 525x459x0.15 (AllForPress) - 155.0".
722	2014-10-08 15:27:46.809+07	1	51	55	Пластина офсетная - Аналоговая 510x400x0.15	2	Added material price "Аналоговая 510x400x0.15 (ВИП Системы) - 130.0".
723	2014-10-15 13:22:43.214+07	1	51	59	Переплетный картон - 1.5мм (70х100)	1	
724	2014-10-15 13:25:04.304+07	1	37	24	TST-Company	1	
725	2014-10-15 13:27:33.254+07	1	51	59	Переплетный картон - 1.5мм (70х100)	2	Added material price "1.5мм (70х100) (TST-Company) - 184.8".
726	2014-10-16 17:18:04.371+07	1	37	25	Бумага И Картон	1	
727	2014-10-16 17:19:13.171+07	1	51	40	Бумага мелованная - 90г (920х640) глян	2	Added material price "90г (920х640) глян (Бумага И Картон) - 13.5".
728	2014-10-23 15:50:21.038+07	1	39	26	Бумага самоклящаяся	1	
729	2014-10-23 15:51:56.884+07	1	51	60	Бумага самоклящаяся - (640х450)	1	
730	2014-10-23 15:52:28.376+07	1	51	60	Бумага самоклящаяся - (640х450)	2	Added material price "(640х450) (Берег) - 44.0".
731	2014-11-04 18:34:17.668+06	1	51	54	Проявитель - Проявитель концентрат	2	Added material price "Проявитель концентрат (AllForPress) - 1207.0".
732	2014-11-06 13:12:14.583+06	1	39	27	Другое	1	
733	2014-11-06 13:14:05.408+06	1	37	26	APH	1	
734	2014-11-06 13:14:54.981+06	1	51	61	Другое - Клише	1	
735	2014-11-06 13:15:15.119+06	1	51	61	Другое - Клише - 0.3мм	2	Changed title.
736	2014-11-11 13:33:42.589+06	1	51	62	Пластина офсетная - UV 450x370x0.15	1	
737	2014-12-13 17:54:12.14+06	1	63	13	Графика Сервис / Размер	1	
738	2015-01-24 13:16:49.306+06	1	51	63	Пластина офсетная - Аналоговая 720x557x0.3	1	
739	2015-01-24 13:18:43.8+06	1	51	63	Пластина офсетная - Аналоговая 720x557x0.3	2	Added material price "Аналоговая 720x557x0.3 (AllForPress) - 383.0".
740	2015-01-24 13:18:57.199+06	1	51	63	Пластина офсетная - Аналоговая 720x557x0.3	2	Changed price.
741	2015-03-02 13:24:56.071+06	1	51	64	Бумага мелованная - 72x104	1	
742	2015-03-02 13:25:35.805+06	1	51	64	Бумага мелованная - 90г (1040х720) глян	2	Changed title.
743	2015-03-06 14:34:07.881+06	1	51	65	Бумага мелованная - 250г (1040х720) глян	1	
744	2015-03-06 14:34:24.365+06	1	51	65	Бумага мелованная - 250г (1040х720) глян	2	Changed price.
745	2015-03-30 12:53:07.047+07	1	51	66	Бумага офсетная листовая - 70г (870х620)	1	
746	2015-03-31 14:48:42.906+07	1	51	44	Картон двусторонний - 270г (1040х720)	2	Added material price "270г (1040х720) (Берег) - 63.7".
747	2015-03-31 14:50:21.658+07	1	51	30	Бумага мелованная - 200г (920x640) глян	2	Added material price "200г (920x640) глян (Берег) - 32.3".
748	2015-04-01 17:35:16.368+07	1	51	67	Пленка для ламинации - Пленка для гор. ламинации 25мк. (305мм) глян	1	
749	2015-04-01 17:35:58.646+07	1	51	67	Пленка для ламинации - Пленка для гор. ламинации 25мк. (320мм) глян	2	Changed title.
750	2015-04-03 19:41:10.885+07	1	37	27	Резервснаб ПЛЮС	1	
751	2015-04-03 19:42:51.319+07	1	51	40	Бумага мелованная - 90г (920х640) глян	2	Added material price "90г (920х640) глян (Резервснаб ПЛЮС) - 15.0".
752	2015-04-20 10:54:40.896+07	1	51	55	Пластина офсетная - Аналоговая 510x400x0.15	2	Added material price "Аналоговая 510x400x0.15 (ВИП Системы) - 132.0".
753	2015-04-20 10:56:14.912+07	1	51	22	Пластина офсетная - Аналоговая 650x530x0.3	2	Added material price "Аналоговая 650x530x0.3 (ВИП Системы) - 308.0".
754	2015-04-20 10:59:53.912+07	1	51	57	Пластина офсетная - Аналоговая 450x370x0.15	2	Added material price "Аналоговая 450x370x0.15 (AllForPress) - 106.0".
755	2015-04-20 11:00:45.961+07	1	51	57	Пластина офсетная - Аналоговая 450x370x0.15	2	No fields changed.
756	2015-04-20 11:02:11.385+07	1	51	21	Пластина офсетная - Аналоговая 525x459x0.15	2	No fields changed.
757	2015-04-20 11:04:57.013+07	1	51	52	Пластина офсетная - Аналоговая 745x605x0.3	2	Changed width and height. Added material price "Аналоговая 745x605x0.3 (ВИП Системы) - 403.0".
758	2015-04-20 11:15:40.463+07	1	51	58	Пластина офсетная - Аналоговая 650x490x0.3	2	Added material price "Аналоговая 650x490x0.3 (ВИП Системы) - 330.0".
759	2015-04-20 11:19:57.274+07	1	51	68	Пластина офсетная - UV 510x400x0.15	1	
760	2015-04-20 11:22:11.636+07	1	51	55	Пластина офсетная - Аналоговая 510x400x0.15	2	Changed start_date for material price "Аналоговая 510x400x0.15 (ВИП Системы) - 132.0".
761	2015-04-20 14:35:55.145+07	1	51	57	Пластина офсетная - Аналоговая 450x370x0.15	2	Added material price "Аналоговая 450x370x0.15 (ВИП Системы) - 105.0".
762	2015-04-20 14:36:48.986+07	1	51	55	Пластина офсетная - Аналоговая 510x400x0.15	2	Added material price "Аналоговая 510x400x0.15 (ВИП Системы) - 129.0".
763	2015-04-20 14:39:25.045+07	1	51	21	Пластина офсетная - Аналоговая 525x459x0.15	2	Added material price "Аналоговая 525x459x0.15 (ВИП Системы) - 152.0".
764	2015-04-20 14:41:09.709+07	1	51	52	Пластина офсетная - Аналоговая 745x605x0.3	2	Added material price "Аналоговая 745x605x0.3 (ВИП Системы) - 402.0".
765	2015-04-28 19:33:47.952+07	1	51	55	Пластина офсетная - Аналоговая 510x400x0.15	2	Added material price "Аналоговая 510x400x0.15 (AllForPress) - 128.0".
766	2015-04-28 19:35:09.157+07	1	51	21	Пластина офсетная - Аналоговая 525x459x0.15	2	Added material price "Аналоговая 525x459x0.15 (AllForPress) - 154.0".
767	2015-04-28 19:35:54.871+07	1	51	22	Пластина офсетная - Аналоговая 650x530x0.3	2	Added material price "Аналоговая 650x530x0.3 (AllForPress) - 309.0".
768	2015-04-28 19:36:59.327+07	1	51	52	Пластина офсетная - Аналоговая 745x605x0.3	2	Added material price "Аналоговая 745x605x0.3 (AllForPress) - 405.0".
769	2015-04-28 19:37:54.756+07	1	51	58	Пластина офсетная - Аналоговая 650x490x0.3	2	Added material price "Аналоговая 650x490x0.3 (AllForPress) - 286.0".
770	2015-04-29 17:28:25.385+07	1	39	28	Краска для дубликатора	1	
771	2015-04-29 17:33:06.523+07	1	51	69	Краска для дубликатора - Краска черная S-4253E	1	
772	2015-04-29 17:40:44.785+07	1	37	28	Демеу	1	
773	2015-04-29 17:40:53.577+07	1	51	70	Печатная химия - Изопропиловый спирт	1	
774	2015-04-29 17:42:40.381+07	1	37	29	Статус - А	1	
775	2015-04-29 17:42:45.642+07	1	51	69	Краска для дубликатора - Краска черная S-4253E	2	Changed supplier for material price "Краска черная S-4253E (Статус - А) - 8035.0".
776	2015-04-30 13:20:41.44+07	1	37	30	Alma Paper	1	
777	2015-04-30 13:21:28.977+07	1	51	71	Бумага офсетная листовая - 200г (860х620) - Ватман	1	
778	2015-05-07 12:19:02.801+07	1	51	72	Пластина офсетная - UV 650x490x0.3	1	
779	2015-05-07 12:19:58.035+07	1	51	62	Пластина офсетная - UV 450x370x0.15	2	Added material price "UV 450x370x0.15 (Гридан комерц) - 125.0".
780	2015-05-23 18:38:02.353+07	1	51	73	Пластина офсетная - Termal 525x459x0.15	1	
781	2015-05-23 18:41:05.767+07	1	51	74	Пластина офсетная - Termal 745x605x0.3	1	
782	2015-07-24 18:42:58.923+07	1	51	75	Допечатная химия - Очиститель проявочных машин	1	
783	2015-07-24 18:43:11.387+07	1	51	75	Допечатная химия - Очиститель проявочных машин	2	Changed price.
784	2015-07-27 14:45:35.726+07	1	51	47	Клей - Термоклей	2	Added material price "Термоклей (Юркур) - 1640.0".
785	2015-08-05 16:43:41.651+07	1	51	76	Бумага мелованная - 250г (920x640) глян	1	
786	2015-08-05 16:43:57.864+07	1	51	76	Бумага мелованная - 250г (920x640) глян	2	Changed price.
787	2015-08-05 16:45:58.837+07	1	51	50	Бумага мелованная - 150г (920х640) глян	2	Added material price "150г (920х640) глян (Берег) - 21.6".
788	2015-08-05 16:46:12.902+07	1	51	50	Бумага мелованная - 150г (920х640) глян	2	Changed price.
789	2015-08-07 11:46:19.707+07	1	39	29	Картон односторонний	1	
790	2015-08-07 11:55:59.016+07	1	51	77	Картон односторонний - 270г (104x72)	1	
791	2015-08-07 11:56:14.543+07	1	51	77	Картон односторонний - 270г (104x72)	2	Changed price.
792	2015-08-07 11:56:47.644+07	1	51	77	Картон односторонний - 270г (1040x720)	2	Changed title.
793	2015-08-08 09:53:10.043+07	1	55	4	Переплетные/отделочные материалы	1	
794	2015-08-08 09:53:14.266+07	1	39	30	Картон переплетный	1	
795	2015-08-08 09:55:17.397+07	1	51	78	Картон переплетный - Картон переплетный 2,0мм 1000x700	1	
796	2015-08-08 09:55:43.401+07	1	51	78	Картон переплетный - Картон переплетный 2,0мм 1000x700	2	Changed price.
797	2015-08-08 09:56:21.419+07	1	51	78	Картон переплетный - Картон переплетный 2,0мм (1000x700)	2	Changed title.
798	2015-08-08 12:44:39.209+07	1	51	39	Бумага офсетная ролевая - 70г (620)	2	Added material price "70г (620) (Казбумторг) - 195.0".
799	2015-08-08 12:44:59.438+07	1	51	39	Бумага офсетная ролевая - 70г (620)	2	Changed price.
\.


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY django_content_type (id, name, app_label, model) FROM stdin;
1	permission	auth	permission
2	group	auth	group
3	user	auth	user
5	content type	contenttypes	contenttype
6	session	sessions	session
7	site	sites	site
11	log entry	admin	logentry
17	client	books	client
19	order	books	order
22	press type	books	presstype
23	work type	books	worktype
24	order type	books	ordertype
25	supplier	books	supplier
28	work data	books	workdata
29	material type	books	materialtype
30	material subtype	books	materialsubtype
31	material price	books	materialprice
32	press data	books	pressdata
33	size type	books	sizetype
34	employee	books	employee
35	workout	books	workout
36	client	calc	client
37	supplier	calc	supplier
38	press type	calc	presstype
39	material type	calc	materialtype
41	work type	calc	worktype
42	order type	calc	ordertype
43	material price	calc	materialprice
44	size type	calc	sizetype
45	order	calc	order
46	press data	calc	pressdata
47	work data	calc	workdata
48	employee	calc	employee
49	workout	calc	workout
50	pressout	calc	pressout
51	material	calc	material
53	machine	calc	machine
55	material type_ group	calc	materialtype_group
56	press consumption norm	calc	pressconsumptionnorm
57	press price	calc	pressprice
58	work consumption norm	calc	workconsumptionnorm
60	price cutoff	calc	pricecutoff
62	global refbook	calc	globalrefbook
63	route refbook	calc	routerefbook
64	trip dk	calc	tripdk
66	trip order	calc	triporder
67	employee position	calc	employeeposition
68	position salary	calc	positionsalary
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY django_session (session_key, session_data, expire_date) FROM stdin;
2c004521f30366c017a999372bac8bca	ODhmYTcyNzc3M2QwY2QzOTYxODFkNWNiMDI0ZGM2Y2Y1YzM3OTE3NDqAAn1xAShVEl9hdXRoX3Vz\nZXJfYmFja2VuZHECVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZHED\nVQ1fYXV0aF91c2VyX2lkcQRLAXUu\n	2012-04-03 23:25:10.781+07
2a0ede31aa47d2e8f6a946cf3206bb93	ODExMTIxZWU4NjFkMjg3YmFiNzZlNzZlMzA3NmM5YjIyY2E1YjkxNDqAAn1xAShVEl9hdXRoX3Vz\nZXJfYmFja2VuZHECVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZHED\nVQ1fYXV0aF91c2VyX2lkcQRLAXUu\n	2012-05-21 22:32:54.311+07
8915434a82aa22565eaa49ee218624da	NDhhZTg3NmEyYWVkOTliZGI1ZmQwZDkzZmU4YTY1ODU3NzkxOTBlNTqAAn1xAVUKdGVzdGNvb2tp\nZXECVQZ3b3JrZWRxA3Mu\n	2011-09-22 06:49:05.249+07
48d5bf483e08ecbeca58d4df7292c4b3	ODhmYTcyNzc3M2QwY2QzOTYxODFkNWNiMDI0ZGM2Y2Y1YzM3OTE3NDqAAn1xAShVEl9hdXRoX3Vz\nZXJfYmFja2VuZHECVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZHED\nVQ1fYXV0aF91c2VyX2lkcQRLAXUu\n	2012-02-28 01:58:32.396+06
7dc9d03f950d737a72c382fad2271e15	ODhmYTcyNzc3M2QwY2QzOTYxODFkNWNiMDI0ZGM2Y2Y1YzM3OTE3NDqAAn1xAShVEl9hdXRoX3Vz\nZXJfYmFja2VuZHECVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZHED\nVQ1fYXV0aF91c2VyX2lkcQRLAXUu\n	2012-03-22 03:59:03.937+06
118152fb00be5c11eab0358ac77d780f	ODExMTIxZWU4NjFkMjg3YmFiNzZlNzZlMzA3NmM5YjIyY2E1YjkxNDqAAn1xAShVEl9hdXRoX3Vz\nZXJfYmFja2VuZHECVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZHED\nVQ1fYXV0aF91c2VyX2lkcQRLAXUu\n	2012-06-02 01:40:35.978+07
9f46c6135a8e85ec04573fe4889899a7	OGVlMmI3MDc5NDUyYThjMjVhMTc0YjRjZjUzOWFhYjZmYWQxMGRlZDqAAn1xAVUKdGVzdGNvb2tp\nZXECVQZ3b3JrZWRxA3Mu\n	2012-06-20 08:46:43.612+07
44a0958ad66c0473a6bb4b71aaf0183d	ODExMTIxZWU4NjFkMjg3YmFiNzZlNzZlMzA3NmM5YjIyY2E1YjkxNDqAAn1xAShVEl9hdXRoX3Vz\nZXJfYmFja2VuZHECVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZHED\nVQ1fYXV0aF91c2VyX2lkcQRLAXUu\n	2013-08-23 04:15:30.919+07
43ea131a8d7331b7952933ec673e9755	ODExMTIxZWU4NjFkMjg3YmFiNzZlNzZlMzA3NmM5YjIyY2E1YjkxNDqAAn1xAShVEl9hdXRoX3Vz\nZXJfYmFja2VuZHECVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZHED\nVQ1fYXV0aF91c2VyX2lkcQRLAXUu\n	2012-06-29 23:10:02.688+07
5d00e1f1654493091e38249c22e8561f	OGVlMmI3MDc5NDUyYThjMjVhMTc0YjRjZjUzOWFhYjZmYWQxMGRlZDqAAn1xAVUKdGVzdGNvb2tp\nZXECVQZ3b3JrZWRxA3Mu\n	2012-07-05 01:30:45.924+07
0f4d850715db97de20deb2cb495864bc	OGVlMmI3MDc5NDUyYThjMjVhMTc0YjRjZjUzOWFhYjZmYWQxMGRlZDqAAn1xAVUKdGVzdGNvb2tp\nZXECVQZ3b3JrZWRxA3Mu\n	2012-07-05 01:33:48.088+07
37bbd26dc4f4a35ce57f6491c09caf58	ODExMTIxZWU4NjFkMjg3YmFiNzZlNzZlMzA3NmM5YjIyY2E1YjkxNDqAAn1xAShVEl9hdXRoX3Vz\nZXJfYmFja2VuZHECVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZHED\nVQ1fYXV0aF91c2VyX2lkcQRLAXUu\n	2012-07-24 10:47:14.86+07
23fda8c4dc58c57b22f1ffbd69a4da00	ODExMTIxZWU4NjFkMjg3YmFiNzZlNzZlMzA3NmM5YjIyY2E1YjkxNDqAAn1xAShVEl9hdXRoX3Vz\nZXJfYmFja2VuZHECVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZHED\nVQ1fYXV0aF91c2VyX2lkcQRLAXUu\n	2012-12-15 23:17:37.502+06
6cf2501c7f106214702e30bfb20374da	ODExMTIxZWU4NjFkMjg3YmFiNzZlNzZlMzA3NmM5YjIyY2E1YjkxNDqAAn1xAShVEl9hdXRoX3Vz\nZXJfYmFja2VuZHECVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZHED\nVQ1fYXV0aF91c2VyX2lkcQRLAXUu\n	2013-09-11 11:25:14.095+07
6c03edb4bcc9bbde26d37d32760b48c0	ODExMTIxZWU4NjFkMjg3YmFiNzZlNzZlMzA3NmM5YjIyY2E1YjkxNDqAAn1xAShVEl9hdXRoX3Vz\nZXJfYmFja2VuZHECVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZHED\nVQ1fYXV0aF91c2VyX2lkcQRLAXUu\n	2013-01-04 00:27:56.075+06
baca5754ffa62c19eeec5e03b4c32b26	ODExMTIxZWU4NjFkMjg3YmFiNzZlNzZlMzA3NmM5YjIyY2E1YjkxNDqAAn1xAShVEl9hdXRoX3Vz\nZXJfYmFja2VuZHECVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZHED\nVQ1fYXV0aF91c2VyX2lkcQRLAXUu\n	2013-11-07 06:03:10.439+06
145f4c7df055b89b2c926a5a43f3b882	MWMyZWI0ZmI4MzIzOTkxNzgyMjY1ZThiNjUwNWQ2OWIxZjI4YzdlMTqAAn1xAS4=\n	2013-04-07 05:36:24.13+07
f44207a41f37e19553c2e43458461560	OGVlMmI3MDc5NDUyYThjMjVhMTc0YjRjZjUzOWFhYjZmYWQxMGRlZDqAAn1xAVUKdGVzdGNvb2tp\nZXECVQZ3b3JrZWRxA3Mu\n	2014-01-24 22:34:16.172+06
03009af027d6c8b5e6eeedeba643d40d	ODExMTIxZWU4NjFkMjg3YmFiNzZlNzZlMzA3NmM5YjIyY2E1YjkxNDqAAn1xAShVEl9hdXRoX3Vz\nZXJfYmFja2VuZHECVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZHED\nVQ1fYXV0aF91c2VyX2lkcQRLAXUu\n	2014-05-13 02:11:12.988+07
af57ebeec9c8308a69ff2f3997337748	OGVlMmI3MDc5NDUyYThjMjVhMTc0YjRjZjUzOWFhYjZmYWQxMGRlZDqAAn1xAVUKdGVzdGNvb2tp\nZXECVQZ3b3JrZWRxA3Mu\n	2014-05-18 00:32:32.654+07
3befc23c9051669e50d5b33fd36f301f	ODExMTIxZWU4NjFkMjg3YmFiNzZlNzZlMzA3NmM5YjIyY2E1YjkxNDqAAn1xAShVEl9hdXRoX3Vz\nZXJfYmFja2VuZHECVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZHED\nVQ1fYXV0aF91c2VyX2lkcQRLAXUu\n	2014-05-18 04:41:38.428+07
33f7c41ae7c717d2ad229169ab35c600	ODExMTIxZWU4NjFkMjg3YmFiNzZlNzZlMzA3NmM5YjIyY2E1YjkxNDqAAn1xAShVEl9hdXRoX3Vz\nZXJfYmFja2VuZHECVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZHED\nVQ1fYXV0aF91c2VyX2lkcQRLAXUu\n	2014-06-09 04:44:51.422+07
e93a1af34340631fe9aeb9ff17d3d6ae	ODExMTIxZWU4NjFkMjg3YmFiNzZlNzZlMzA3NmM5YjIyY2E1YjkxNDqAAn1xAShVEl9hdXRoX3Vz\nZXJfYmFja2VuZHECVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZHED\nVQ1fYXV0aF91c2VyX2lkcQRLAXUu\n	2014-06-25 11:18:47.573+07
5300efd4e096ecf213db22928d1c5284	ODExMTIxZWU4NjFkMjg3YmFiNzZlNzZlMzA3NmM5YjIyY2E1YjkxNDqAAn1xAShVEl9hdXRoX3Vz\nZXJfYmFja2VuZHECVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZHED\nVQ1fYXV0aF91c2VyX2lkcQRLAXUu\n	2014-07-16 03:09:46.253+07
ccc89ed945360ccc5e26526c9d45a6c9	ODExMTIxZWU4NjFkMjg3YmFiNzZlNzZlMzA3NmM5YjIyY2E1YjkxNDqAAn1xAShVEl9hdXRoX3Vz\nZXJfYmFja2VuZHECVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZHED\nVQ1fYXV0aF91c2VyX2lkcQRLAXUu\n	2014-08-12 05:53:15.188+07
4ur9rc93mrqeh9udbiax76us2h89ccdx	Y2M1ZTI4NjZkODU4OWNjYTNhYWVlMDEzM2I2MzE5MzhjZDY2MWQwMTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6MX0=	2014-10-11 18:12:38.26+07
b4ae84b00e21e792a752a62b54ff3af8	ODExMTIxZWU4NjFkMjg3YmFiNzZlNzZlMzA3NmM5YjIyY2E1YjkxNDqAAn1xAShVEl9hdXRoX3Vz\nZXJfYmFja2VuZHECVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZHED\nVQ1fYXV0aF91c2VyX2lkcQRLAXUu\n	2014-08-27 05:39:08.325+07
miiomq6eozmauibjzcmbv7co9xj1usqr	Y2M1ZTI4NjZkODU4OWNjYTNhYWVlMDEzM2I2MzE5MzhjZDY2MWQwMTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6MX0=	2014-10-02 21:27:16.594+07
81azp2u9izppcvcisxnetr478av4agng	Y2M1ZTI4NjZkODU4OWNjYTNhYWVlMDEzM2I2MzE5MzhjZDY2MWQwMTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6MX0=	2014-10-27 19:13:51.604+06
ncpfff7g4hg6d881qbn6etbm3r1y1gae	Y2M1ZTI4NjZkODU4OWNjYTNhYWVlMDEzM2I2MzE5MzhjZDY2MWQwMTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6MX0=	2014-10-31 11:48:11.011+06
mzkyruwfz9xixjpwg4qzk6wrfjn00ewi	ODdmZTdiNTBkZDFhMDViY2UzYmYyZWIzODE0NjNhNmE4NjM3NjVlODp7fQ==	2014-10-31 17:54:06.502+06
9m58vzabubsd2khlfeiafvdnbcp8y2kz	Y2M1ZTI4NjZkODU4OWNjYTNhYWVlMDEzM2I2MzE5MzhjZDY2MWQwMTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6MX0=	2014-11-03 02:05:38.772+06
lrywgyrovsgdzin9nphivpof7vid16rt	ODdmZTdiNTBkZDFhMDViY2UzYmYyZWIzODE0NjNhNmE4NjM3NjVlODp7fQ==	2014-11-07 15:06:56.427+06
0jw3l7b42wvy9bnjxnwzrf7e3g7jliw9	ODdmZTdiNTBkZDFhMDViY2UzYmYyZWIzODE0NjNhNmE4NjM3NjVlODp7fQ==	2014-11-07 15:06:59.067+06
e2t51d5qp3mpi6mg8nui8zqwu3ofo83w	ODdmZTdiNTBkZDFhMDViY2UzYmYyZWIzODE0NjNhNmE4NjM3NjVlODp7fQ==	2014-11-08 10:08:05.173+06
1vld685k1lufdyai2ay8vatzjn8h4n1r	ODdmZTdiNTBkZDFhMDViY2UzYmYyZWIzODE0NjNhNmE4NjM3NjVlODp7fQ==	2014-11-08 10:08:05.173+06
4pyi14q7m15zt0e62g035csvsfdknriw	Y2M1ZTI4NjZkODU4OWNjYTNhYWVlMDEzM2I2MzE5MzhjZDY2MWQwMTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6MX0=	2014-11-17 11:36:19.486+06
vrlfmpknnbg3j783tw9mzgptdkkxv56y	Y2M1ZTI4NjZkODU4OWNjYTNhYWVlMDEzM2I2MzE5MzhjZDY2MWQwMTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6MX0=	2014-11-18 12:46:56.722+06
qf68dnc5rihzp72gah5x7x93xxsj1iae	Y2M1ZTI4NjZkODU4OWNjYTNhYWVlMDEzM2I2MzE5MzhjZDY2MWQwMTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6MX0=	2014-12-16 13:24:21.878+06
ccbzgqpe4hkkq8soksjs6qef4djc6pmz	Y2M1ZTI4NjZkODU4OWNjYTNhYWVlMDEzM2I2MzE5MzhjZDY2MWQwMTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6MX0=	2015-01-02 15:05:09.854+06
exoqlx7u7db46xdb15dshtuviqtwscme	Y2M1ZTI4NjZkODU4OWNjYTNhYWVlMDEzM2I2MzE5MzhjZDY2MWQwMTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6MX0=	2015-02-02 12:44:38.635+06
z9oco24g6fxk6q9mev6q7fhmyj14cluc	Y2M1ZTI4NjZkODU4OWNjYTNhYWVlMDEzM2I2MzE5MzhjZDY2MWQwMTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6MX0=	2015-02-02 12:45:30.861+06
b0pap4wmlv2r7oiz1tinifn6l06pt0lx	Y2M1ZTI4NjZkODU4OWNjYTNhYWVlMDEzM2I2MzE5MzhjZDY2MWQwMTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6MX0=	2015-02-16 16:42:21.441+06
hhwd2mnsusbke2sq5pzmj5sthibqz2ve	Y2M1ZTI4NjZkODU4OWNjYTNhYWVlMDEzM2I2MzE5MzhjZDY2MWQwMTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6MX0=	2015-03-04 17:32:57.209+06
1egldntgrwt2qcabpwwvzjeyjtmsyr4s	Y2M1ZTI4NjZkODU4OWNjYTNhYWVlMDEzM2I2MzE5MzhjZDY2MWQwMTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6MX0=	2015-03-19 13:36:26.197+06
v4mwl9r43vnfb03hzbvwpmngvlc1opv6	Y2M1ZTI4NjZkODU4OWNjYTNhYWVlMDEzM2I2MzE5MzhjZDY2MWQwMTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6MX0=	2015-04-13 12:22:52.559+07
job84nl67z66nuegd33e1rlmbidcmts4	Y2M1ZTI4NjZkODU4OWNjYTNhYWVlMDEzM2I2MzE5MzhjZDY2MWQwMTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6MX0=	2015-04-28 14:14:12.906+07
k6uizcyok1dpm6q1qcocon704tng1qyt	Y2M1ZTI4NjZkODU4OWNjYTNhYWVlMDEzM2I2MzE5MzhjZDY2MWQwMTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6MX0=	2015-06-06 18:35:40.175+07
rvo3ybler0kjunfzlwvr1sgvomqjrfco	Y2M1ZTI4NjZkODU4OWNjYTNhYWVlMDEzM2I2MzE5MzhjZDY2MWQwMTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6MX0=	2015-05-04 10:53:12.606+07
focpxjcjrdmnb6ym2lym11fridq1j7z6	Y2M1ZTI4NjZkODU4OWNjYTNhYWVlMDEzM2I2MzE5MzhjZDY2MWQwMTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6MX0=	2015-05-04 14:34:30.716+07
hpawxgv2hj2joo7ytig9oxvfoondrxvt	ODdmZTdiNTBkZDFhMDViY2UzYmYyZWIzODE0NjNhNmE4NjM3NjVlODp7fQ==	2015-05-05 02:29:55.838+07
hsbr63id0d19ld68cn9y6ysnnshqd0eo	Y2M1ZTI4NjZkODU4OWNjYTNhYWVlMDEzM2I2MzE5MzhjZDY2MWQwMTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6MX0=	2015-06-25 17:11:35.7+07
8lojc64p2mawzna2ek0wuch1uryy7rgu	Y2M1ZTI4NjZkODU4OWNjYTNhYWVlMDEzM2I2MzE5MzhjZDY2MWQwMTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6MX0=	2015-05-05 11:47:59.046+07
4kmy277znfbbckgrtlcef9db6cz6shfc	Y2M1ZTI4NjZkODU4OWNjYTNhYWVlMDEzM2I2MzE5MzhjZDY2MWQwMTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6MX0=	2015-05-21 12:14:55.612+07
ym2bnu7p448mc5r57n4ibitbrfh71rzu	Y2M1ZTI4NjZkODU4OWNjYTNhYWVlMDEzM2I2MzE5MzhjZDY2MWQwMTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6MX0=	2015-05-27 13:45:31.123+07
09a30ywa94mm2bbvyvwz76w7o2zsmkog	Y2M1ZTI4NjZkODU4OWNjYTNhYWVlMDEzM2I2MzE5MzhjZDY2MWQwMTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6MX0=	2015-07-10 16:39:27.078+07
npgcwy7eqy6uidqzbmpo2g4gw4sz5m68	Y2M1ZTI4NjZkODU4OWNjYTNhYWVlMDEzM2I2MzE5MzhjZDY2MWQwMTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6MX0=	2015-07-28 15:54:57.557+07
uxn83vgih65u3npfc26p502iqan6tufc	Y2M1ZTI4NjZkODU4OWNjYTNhYWVlMDEzM2I2MzE5MzhjZDY2MWQwMTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6MX0=	2015-08-19 14:46:36.132+07
z9470vtuie9nedaopbexr7lcj3p6n0px	Y2M1ZTI4NjZkODU4OWNjYTNhYWVlMDEzM2I2MzE5MzhjZDY2MWQwMTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6MX0=	2015-09-17 13:13:22.04+07
uaunp4cborhizzcq335gwbjj5pgfomo0	Y2M1ZTI4NjZkODU4OWNjYTNhYWVlMDEzM2I2MzE5MzhjZDY2MWQwMTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6MX0=	2015-09-05 00:05:24.593+07
3iu1s4odptlmiclw63flalwjpwv7zfo9	ODdmZTdiNTBkZDFhMDViY2UzYmYyZWIzODE0NjNhNmE4NjM3NjVlODp7fQ==	2015-09-08 13:57:55.786+07
say9fbfngq9y7kyjeo5vrjpxizzfzv6h	Y2M1ZTI4NjZkODU4OWNjYTNhYWVlMDEzM2I2MzE5MzhjZDY2MWQwMTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6MX0=	2015-09-21 15:48:22.473+07
\.


--
-- Data for Name: django_site; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY django_site (id, domain, name) FROM stdin;
1	example.com	example.com
\.


--
-- Name: auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions_group_id_permission_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_key UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_message_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auth_message
    ADD CONSTRAINT auth_message_pkey PRIMARY KEY (id);


--
-- Name: auth_permission_content_type_id_codename_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_key UNIQUE (content_type_id, codename);


--
-- Name: auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups_user_id_group_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_key UNIQUE (user_id, group_id);


--
-- Name: auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions_user_id_permission_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_key UNIQUE (user_id, permission_id);


--
-- Name: auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- Name: calc_client_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calc_client
    ADD CONSTRAINT calc_client_pkey PRIMARY KEY (id);


--
-- Name: calc_employee_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calc_employee
    ADD CONSTRAINT calc_employee_pkey PRIMARY KEY (id);


--
-- Name: calc_employeeposition_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calc_employeeposition
    ADD CONSTRAINT calc_employeeposition_pkey PRIMARY KEY (id);


--
-- Name: calc_globalrefbook_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calc_globalrefbook
    ADD CONSTRAINT calc_globalrefbook_pkey PRIMARY KEY (id);


--
-- Name: calc_machine_paper_type_machine_id_materialtype_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calc_machine_paper_type
    ADD CONSTRAINT calc_machine_paper_type_machine_id_materialtype_id_key UNIQUE (machine_id, materialtype_id);


--
-- Name: calc_machine_paper_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calc_machine_paper_type
    ADD CONSTRAINT calc_machine_paper_type_pkey PRIMARY KEY (id);


--
-- Name: calc_machine_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calc_machine
    ADD CONSTRAINT calc_machine_pkey PRIMARY KEY (id);


--
-- Name: calc_material_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calc_material
    ADD CONSTRAINT calc_material_pkey PRIMARY KEY (id);


--
-- Name: calc_materialprice_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calc_materialprice
    ADD CONSTRAINT calc_materialprice_pkey PRIMARY KEY (id);


--
-- Name: calc_materialtype_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calc_materialtype_group
    ADD CONSTRAINT calc_materialtype_group_pkey PRIMARY KEY (id);


--
-- Name: calc_materialtype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calc_materialtype
    ADD CONSTRAINT calc_materialtype_pkey PRIMARY KEY (id);


--
-- Name: calc_order_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calc_order
    ADD CONSTRAINT calc_order_pkey PRIMARY KEY (id);


--
-- Name: calc_ordertype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calc_ordertype
    ADD CONSTRAINT calc_ordertype_pkey PRIMARY KEY (id);


--
-- Name: calc_ordertype_press_type_ordertype_id_presstype_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calc_ordertype_press_type
    ADD CONSTRAINT calc_ordertype_press_type_ordertype_id_presstype_id_key UNIQUE (ordertype_id, presstype_id);


--
-- Name: calc_ordertype_press_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calc_ordertype_press_type
    ADD CONSTRAINT calc_ordertype_press_type_pkey PRIMARY KEY (id);


--
-- Name: calc_ordertype_size_type_ordertype_id_sizetype_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calc_ordertype_size_type
    ADD CONSTRAINT calc_ordertype_size_type_ordertype_id_sizetype_id_key UNIQUE (ordertype_id, sizetype_id);


--
-- Name: calc_ordertype_size_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calc_ordertype_size_type
    ADD CONSTRAINT calc_ordertype_size_type_pkey PRIMARY KEY (id);


--
-- Name: calc_ordertype_work_type_ordertype_id_worktype_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calc_ordertype_work_type
    ADD CONSTRAINT calc_ordertype_work_type_ordertype_id_worktype_id_key UNIQUE (ordertype_id, worktype_id);


--
-- Name: calc_ordertype_work_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calc_ordertype_work_type
    ADD CONSTRAINT calc_ordertype_work_type_pkey PRIMARY KEY (id);


--
-- Name: calc_positionsalary_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calc_positionsalary
    ADD CONSTRAINT calc_positionsalary_pkey PRIMARY KEY (id);


--
-- Name: calc_pressconsumptionnorm_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calc_pressconsumptionnorm
    ADD CONSTRAINT calc_pressconsumptionnorm_pkey PRIMARY KEY (id);


--
-- Name: calc_pressdata_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calc_pressdata
    ADD CONSTRAINT calc_pressdata_pkey PRIMARY KEY (id);


--
-- Name: calc_pressout_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calc_pressout
    ADD CONSTRAINT calc_pressout_pkey PRIMARY KEY (id);


--
-- Name: calc_pressprice_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calc_pressprice
    ADD CONSTRAINT calc_pressprice_pkey PRIMARY KEY (id);


--
-- Name: calc_presstype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calc_presstype
    ADD CONSTRAINT calc_presstype_pkey PRIMARY KEY (id);


--
-- Name: calc_pricecutoff_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calc_pricecutoff
    ADD CONSTRAINT calc_pricecutoff_pkey PRIMARY KEY (id);


--
-- Name: calc_routerefbook_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calc_routerefbook
    ADD CONSTRAINT calc_routerefbook_pkey PRIMARY KEY (id);


--
-- Name: calc_sizetype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calc_sizetype
    ADD CONSTRAINT calc_sizetype_pkey PRIMARY KEY (id);


--
-- Name: calc_supplier_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calc_supplier
    ADD CONSTRAINT calc_supplier_pkey PRIMARY KEY (id);


--
-- Name: calc_tripdk_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calc_tripdk
    ADD CONSTRAINT calc_tripdk_pkey PRIMARY KEY (id);


--
-- Name: calc_triporder_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calc_triporder
    ADD CONSTRAINT calc_triporder_pkey PRIMARY KEY (id);


--
-- Name: calc_workconsumptionnorm_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calc_workconsumptionnorm
    ADD CONSTRAINT calc_workconsumptionnorm_pkey PRIMARY KEY (id);


--
-- Name: calc_workdata_material_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calc_workdata_material
    ADD CONSTRAINT calc_workdata_material_pkey PRIMARY KEY (id);


--
-- Name: calc_workdata_material_workdata_id_materialsubtype_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calc_workdata_material
    ADD CONSTRAINT calc_workdata_material_workdata_id_materialsubtype_id_key UNIQUE (workdata_id, materialsubtype_id);


--
-- Name: calc_workdata_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calc_workdata
    ADD CONSTRAINT calc_workdata_pkey PRIMARY KEY (id);


--
-- Name: calc_workout_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calc_workout
    ADD CONSTRAINT calc_workout_pkey PRIMARY KEY (id);


--
-- Name: calc_worktype_default_materia_worktype_id_materialsubtype_i_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calc_worktype_default_materials
    ADD CONSTRAINT calc_worktype_default_materia_worktype_id_materialsubtype_i_key UNIQUE (worktype_id, materialsubtype_id);


--
-- Name: calc_worktype_default_materials_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calc_worktype_default_materials
    ADD CONSTRAINT calc_worktype_default_materials_pkey PRIMARY KEY (id);


--
-- Name: calc_worktype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calc_worktype
    ADD CONSTRAINT calc_worktype_pkey PRIMARY KEY (id);


--
-- Name: django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type_app_label_model_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_key UNIQUE (app_label, model);


--
-- Name: django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: django_site_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY django_site
    ADD CONSTRAINT django_site_pkey PRIMARY KEY (id);


--
-- Name: auth_message_user_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX auth_message_user_id ON auth_message USING btree (user_id);


--
-- Name: auth_permission_content_type_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX auth_permission_content_type_id ON auth_permission USING btree (content_type_id);


--
-- Name: calc_machine_paper_type_machine_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_machine_paper_type_machine_id ON calc_machine_paper_type USING btree (machine_id);


--
-- Name: calc_machine_paper_type_materialtype_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_machine_paper_type_materialtype_id ON calc_machine_paper_type USING btree (materialtype_id);


--
-- Name: calc_machine_plate_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_machine_plate_id ON calc_machine USING btree (plate_id);


--
-- Name: calc_material_a_type_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_material_a_type_id ON calc_material USING btree (material_type_id);


--
-- Name: calc_material_price_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_material_price_id ON calc_material USING btree (price_id);


--
-- Name: calc_materialprice_material_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_materialprice_material_id ON calc_materialprice USING btree (material_id);


--
-- Name: calc_materialprice_supplier_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_materialprice_supplier_id ON calc_materialprice USING btree (supplier_id);


--
-- Name: calc_materialtype_type_group_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_materialtype_type_group_id ON calc_materialtype USING btree (type_group_id);


--
-- Name: calc_order_client_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_order_client_id ON calc_order USING btree (client_id);


--
-- Name: calc_order_order_type_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_order_order_type_id ON calc_order USING btree (order_type_id);


--
-- Name: calc_order_size_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_order_size_id ON calc_order USING btree (size_type_id);


--
-- Name: calc_ordertype_press_type_ordertype_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_ordertype_press_type_ordertype_id ON calc_ordertype_press_type USING btree (ordertype_id);


--
-- Name: calc_ordertype_press_type_presstype_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_ordertype_press_type_presstype_id ON calc_ordertype_press_type USING btree (presstype_id);


--
-- Name: calc_ordertype_size_type_ordertype_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_ordertype_size_type_ordertype_id ON calc_ordertype_size_type USING btree (ordertype_id);


--
-- Name: calc_ordertype_size_type_sizetype_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_ordertype_size_type_sizetype_id ON calc_ordertype_size_type USING btree (sizetype_id);


--
-- Name: calc_ordertype_work_type_ordertype_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_ordertype_work_type_ordertype_id ON calc_ordertype_work_type USING btree (ordertype_id);


--
-- Name: calc_ordertype_work_type_worktype_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_ordertype_work_type_worktype_id ON calc_ordertype_work_type USING btree (worktype_id);


--
-- Name: calc_positionsalary_employee_position_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_positionsalary_employee_position_id ON calc_positionsalary USING btree (employee_position_id);


--
-- Name: calc_pressconsumptionnorm_material_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_pressconsumptionnorm_material_id ON calc_pressconsumptionnorm USING btree (material_id);


--
-- Name: calc_pressconsumptionnorm_press_type_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_pressconsumptionnorm_press_type_id ON calc_pressconsumptionnorm USING btree (press_type_id);


--
-- Name: calc_pressdata_firstside_presstype_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_pressdata_firstside_presstype_id ON calc_pressdata USING btree (press_type_id);


--
-- Name: calc_pressdata_order_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_pressdata_order_id ON calc_pressdata USING btree (order_id);


--
-- Name: calc_pressdata_paper_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_pressdata_paper_id ON calc_pressdata USING btree (paper_id);


--
-- Name: calc_pressout_employee_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_pressout_employee_id ON calc_pressout USING btree (employee_id);


--
-- Name: calc_pressout_press_data_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_pressout_press_data_id ON calc_pressout USING btree (press_data_id);


--
-- Name: calc_pressprice_press_type_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_pressprice_press_type_id ON calc_pressprice USING btree (press_type_id);


--
-- Name: calc_presstype_machine_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_presstype_machine_id ON calc_presstype USING btree (machine_id);


--
-- Name: calc_presstype_paper_type_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_presstype_paper_type_id ON calc_presstype USING btree (paper_type_id);


--
-- Name: calc_pricecutoff_order_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_pricecutoff_order_id ON calc_pricecutoff USING btree (order_id);


--
-- Name: calc_tripdk_employee_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_tripdk_employee_id ON calc_tripdk USING btree (employee_id);


--
-- Name: calc_triporder_destination_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_triporder_destination_id ON calc_triporder USING btree (destination_id);


--
-- Name: calc_triporder_dk_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_triporder_dk_id ON calc_triporder USING btree (dk_id);


--
-- Name: calc_triporder_employee_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_triporder_employee_id ON calc_triporder USING btree (employee_id);


--
-- Name: calc_workconsumptionnorm_material_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_workconsumptionnorm_material_id ON calc_workconsumptionnorm USING btree (material_id);


--
-- Name: calc_workconsumptionnorm_work_type_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_workconsumptionnorm_work_type_id ON calc_workconsumptionnorm USING btree (work_type_id);


--
-- Name: calc_workdata_material_materialsubtype_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_workdata_material_materialsubtype_id ON calc_workdata_material USING btree (materialsubtype_id);


--
-- Name: calc_workdata_material_workdata_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_workdata_material_workdata_id ON calc_workdata_material USING btree (workdata_id);


--
-- Name: calc_workdata_order_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_workdata_order_id ON calc_workdata USING btree (order_id);


--
-- Name: calc_workdata_work_type_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_workdata_work_type_id ON calc_workdata USING btree (work_type_id);


--
-- Name: calc_workout_employee_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_workout_employee_id ON calc_workout USING btree (employee_id);


--
-- Name: calc_workout_work_data_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_workout_work_data_id ON calc_workout USING btree (work_data_id);


--
-- Name: calc_worktype_default_materials_materialsubtype_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_worktype_default_materials_materialsubtype_id ON calc_worktype_default_materials USING btree (materialsubtype_id);


--
-- Name: calc_worktype_default_materials_worktype_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_worktype_default_materials_worktype_id ON calc_worktype_default_materials USING btree (worktype_id);


--
-- Name: django_admin_log_content_type_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX django_admin_log_content_type_id ON django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX django_admin_log_user_id ON django_admin_log USING btree (user_id);


--
-- Name: auth_group_permissions_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_fkey FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_message_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_message
    ADD CONSTRAINT auth_message_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_fkey FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: calc_machine_paper_type_materialtype_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calc_machine_paper_type
    ADD CONSTRAINT calc_machine_paper_type_materialtype_id_fkey FOREIGN KEY (materialtype_id) REFERENCES calc_materialtype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: calc_machine_plate_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calc_machine
    ADD CONSTRAINT calc_machine_plate_id_fkey FOREIGN KEY (plate_id) REFERENCES calc_material(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: calc_material_a_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calc_material
    ADD CONSTRAINT calc_material_a_type_id_fkey FOREIGN KEY (material_type_id) REFERENCES calc_materialtype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: calc_material_price_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calc_material
    ADD CONSTRAINT calc_material_price_id_fkey FOREIGN KEY (price_id) REFERENCES calc_materialprice(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: calc_materialprice_supplier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calc_materialprice
    ADD CONSTRAINT calc_materialprice_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES calc_supplier(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: calc_materialtype_type_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calc_materialtype
    ADD CONSTRAINT calc_materialtype_type_group_id_fkey FOREIGN KEY (type_group_id) REFERENCES calc_materialtype_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: calc_order_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calc_order
    ADD CONSTRAINT calc_order_client_id_fkey FOREIGN KEY (client_id) REFERENCES calc_client(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: calc_order_size_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calc_order
    ADD CONSTRAINT calc_order_size_id_fkey FOREIGN KEY (size_type_id) REFERENCES calc_sizetype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: calc_ordertype_press_type_presstype_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calc_ordertype_press_type
    ADD CONSTRAINT calc_ordertype_press_type_presstype_id_fkey FOREIGN KEY (presstype_id) REFERENCES calc_presstype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: calc_ordertype_size_type_sizetype_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calc_ordertype_size_type
    ADD CONSTRAINT calc_ordertype_size_type_sizetype_id_fkey FOREIGN KEY (sizetype_id) REFERENCES calc_sizetype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: calc_ordertype_work_type_worktype_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calc_ordertype_work_type
    ADD CONSTRAINT calc_ordertype_work_type_worktype_id_fkey FOREIGN KEY (worktype_id) REFERENCES calc_worktype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: calc_positionsalary_employee_position_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calc_positionsalary
    ADD CONSTRAINT calc_positionsalary_employee_position_id_fkey FOREIGN KEY (employee_position_id) REFERENCES calc_employeeposition(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: calc_pressconsumptionnorm_material_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calc_pressconsumptionnorm
    ADD CONSTRAINT calc_pressconsumptionnorm_material_id_fkey FOREIGN KEY (material_id) REFERENCES calc_material(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: calc_pressconsumptionnorm_press_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calc_pressconsumptionnorm
    ADD CONSTRAINT calc_pressconsumptionnorm_press_type_id_fkey FOREIGN KEY (press_type_id) REFERENCES calc_presstype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: calc_pressdata_firstside_presstype_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calc_pressdata
    ADD CONSTRAINT calc_pressdata_firstside_presstype_id_fkey FOREIGN KEY (press_type_id) REFERENCES calc_presstype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: calc_pressdata_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calc_pressdata
    ADD CONSTRAINT calc_pressdata_order_id_fkey FOREIGN KEY (order_id) REFERENCES calc_order(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: calc_pressdata_paper_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calc_pressdata
    ADD CONSTRAINT calc_pressdata_paper_id_fkey FOREIGN KEY (paper_id) REFERENCES calc_material(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: calc_pressout_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calc_pressout
    ADD CONSTRAINT calc_pressout_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES calc_employee(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: calc_pressout_press_data_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calc_pressout
    ADD CONSTRAINT calc_pressout_press_data_id_fkey FOREIGN KEY (press_data_id) REFERENCES calc_pressdata(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: calc_pressprice_press_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calc_pressprice
    ADD CONSTRAINT calc_pressprice_press_type_id_fkey FOREIGN KEY (press_type_id) REFERENCES calc_presstype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: calc_presstype_machine_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calc_presstype
    ADD CONSTRAINT calc_presstype_machine_id_fkey FOREIGN KEY (machine_id) REFERENCES calc_machine(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: calc_presstype_paper_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calc_presstype
    ADD CONSTRAINT calc_presstype_paper_type_id_fkey FOREIGN KEY (paper_type_id) REFERENCES calc_materialtype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: calc_pricecutoff_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calc_pricecutoff
    ADD CONSTRAINT calc_pricecutoff_order_id_fkey FOREIGN KEY (order_id) REFERENCES calc_order(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: calc_tripdk_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calc_tripdk
    ADD CONSTRAINT calc_tripdk_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES calc_employee(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: calc_triporder_destination_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calc_triporder
    ADD CONSTRAINT calc_triporder_destination_id_fkey FOREIGN KEY (destination_id) REFERENCES calc_routerefbook(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: calc_triporder_dk_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calc_triporder
    ADD CONSTRAINT calc_triporder_dk_id_fkey FOREIGN KEY (dk_id) REFERENCES calc_tripdk(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: calc_triporder_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calc_triporder
    ADD CONSTRAINT calc_triporder_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES calc_employee(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: calc_workconsumptionnorm_material_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calc_workconsumptionnorm
    ADD CONSTRAINT calc_workconsumptionnorm_material_id_fkey FOREIGN KEY (material_id) REFERENCES calc_material(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: calc_workconsumptionnorm_work_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calc_workconsumptionnorm
    ADD CONSTRAINT calc_workconsumptionnorm_work_type_id_fkey FOREIGN KEY (work_type_id) REFERENCES calc_worktype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: calc_workdata_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calc_workdata
    ADD CONSTRAINT calc_workdata_order_id_fkey FOREIGN KEY (order_id) REFERENCES calc_order(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: calc_workdata_work_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calc_workdata
    ADD CONSTRAINT calc_workdata_work_type_id_fkey FOREIGN KEY (work_type_id) REFERENCES calc_worktype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: calc_workout_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calc_workout
    ADD CONSTRAINT calc_workout_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES calc_employee(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: calc_workout_work_data_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calc_workout
    ADD CONSTRAINT calc_workout_work_data_id_fkey FOREIGN KEY (work_data_id) REFERENCES calc_workdata(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: content_type_id_refs_id_728de91f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT content_type_id_refs_id_728de91f FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log_content_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_fkey FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: machine_id_refs_id_4d423f1a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calc_machine_paper_type
    ADD CONSTRAINT machine_id_refs_id_4d423f1a FOREIGN KEY (machine_id) REFERENCES calc_machine(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: material_id_refs_id_71083f57; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calc_materialprice
    ADD CONSTRAINT material_id_refs_id_71083f57 FOREIGN KEY (material_id) REFERENCES calc_material(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ordertype_id_refs_id_4cb2b4d9; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calc_ordertype_size_type
    ADD CONSTRAINT ordertype_id_refs_id_4cb2b4d9 FOREIGN KEY (ordertype_id) REFERENCES calc_ordertype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ordertype_id_refs_id_903b3b45; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calc_ordertype_press_type
    ADD CONSTRAINT ordertype_id_refs_id_903b3b45 FOREIGN KEY (ordertype_id) REFERENCES calc_ordertype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ordertype_id_refs_id_93d50818; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calc_ordertype_work_type
    ADD CONSTRAINT ordertype_id_refs_id_93d50818 FOREIGN KEY (ordertype_id) REFERENCES calc_ordertype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: workdata_id_refs_id_73e33c6e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calc_workdata_material
    ADD CONSTRAINT workdata_id_refs_id_73e33c6e FOREIGN KEY (workdata_id) REFERENCES calc_workdata(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: worktype_id_refs_id_50e2bd8c; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calc_worktype_default_materials
    ADD CONSTRAINT worktype_id_refs_id_50e2bd8c FOREIGN KEY (worktype_id) REFERENCES calc_worktype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

