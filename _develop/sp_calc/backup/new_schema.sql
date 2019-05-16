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
-- Name: calc_order; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE calc_order (
    id integer NOT NULL,
    client_id integer NOT NULL,
    order_type_id integer NOT NULL,
    order_datetime date NOT NULL,
    title character varying(100) NOT NULL,
    deadline_date date,
    start_date date,
    end_date date,
    size_type_id integer NOT NULL,
    page_amount integer,
    circ integer NOT NULL,
    price double precision,
    given_price double precision,
    CONSTRAINT calc_order_circ_check CHECK ((circ >= 0))
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
-- Name: calc_order_size_type_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX calc_order_size_type_id ON calc_order USING btree (size_type_id);


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
-- Name: calc_order_order_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calc_order
    ADD CONSTRAINT calc_order_order_type_id_fkey FOREIGN KEY (order_type_id) REFERENCES calc_ordertype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: calc_order_size_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calc_order
    ADD CONSTRAINT calc_order_size_type_id_fkey FOREIGN KEY (size_type_id) REFERENCES calc_sizetype(id) DEFERRABLE INITIALLY DEFERRED;


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

