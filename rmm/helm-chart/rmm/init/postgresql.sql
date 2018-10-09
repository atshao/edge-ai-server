DO
$$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname='g_ro_public') THEN
    CREATE ROLE g_ro_public
    WITH
      NOSUPERUSER
      INHERIT
      NOCREATEROLE
      NOCREATEDB
      NOLOGIN
      NOREPLICATION
      NOBYPASSRLS
      VALID UNTIL 'infinity';
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname='g_rw_public') THEN
    CREATE ROLE g_rw_public
    WITH
      NOSUPERUSER
      INHERIT
      NOCREATEROLE
      NOCREATEDB
      NOLOGIN
      NOREPLICATION
      NOBYPASSRLS
      VALID UNTIL 'infinity';
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname='g_rmm') THEN
    CREATE ROLE g_rmm
    WITH
      NOSUPERUSER
      INHERIT
      NOCREATEROLE
      NOCREATEDB
      NOLOGIN
      NOREPLICATION
      NOBYPASSRLS
      VALID UNTIL 'infinity';
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname='g_ota') THEN
    CREATE ROLE g_ota
    WITH
      NOSUPERUSER
      INHERIT
      NOCREATEROLE
      NOCREATEDB
      NOLOGIN
      NOREPLICATION
      NOBYPASSRLS
      VALID UNTIL 'infinity';
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname='wisepaas') THEN
    CREATE ROLE wisepaas
    WITH
      NOSUPERUSER
      INHERIT
      NOCREATEROLE
      NOCREATEDB
      NOLOGIN
      NOREPLICATION
      NOBYPASSRLS
      VALID UNTIL 'infinity';
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname='rmm') THEN
    CREATE ROLE rmm
    WITH
      NOSUPERUSER
      INHERIT
      NOCREATEROLE
      NOCREATEDB
      LOGIN
      NOREPLICATION
      NOBYPASSRLS
      PASSWORD 'md5168f3490345f870ecb4dbbeaaa6d22d8'
      VALID UNTIL 'infinity';

    GRANT g_ro_public TO rmm;
    GRANT g_rw_public TO rmm;
    GRANT g_rmm TO rmm;
    GRANT g_ota TO rmm;
    GRANT wisepaas TO rmm;
  END IF;
END
$$
