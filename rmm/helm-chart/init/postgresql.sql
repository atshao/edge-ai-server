DO
$$
BEGIN
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

  {{ with .Values.serverConfig.dbServer.sql.postgresql -}}
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname='{{ .username }}') THEN
    CREATE ROLE {{ .username }}
    WITH
      NOSUPERUSER
      INHERIT
      NOCREATEROLE
      NOCREATEDB
      LOGIN
      NOREPLICATION
      NOBYPASSRLS
      PASSWORD '{{ .password }}'
      VALID UNTIL 'infinity';

    GRANT g_rmm TO {{ .username }};
    GRANT g_rw_public TO {{ .username }};
    GRANT g_ota TO {{ .username }};
    GRANT wisepaas TO {{ .username }};
  END IF;
  {{- end }}
END
$$
