CREATE DATABASE number_guess WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.UTF-8';

\connect number_guess

CREATE TABLE public.users (
    username character varying(22) NOT NULL,
    games_played integer NOT NULL,
    best_game integer NOT NULL
);

ALTER TABLE public.users OWNER TO freecodecamp;

ALTER TABLE ONLY public.users
    ADD CONSTRAINT username_pkey PRIMARY KEY (username);
