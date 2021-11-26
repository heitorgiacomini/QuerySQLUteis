-- FUNCTION: imobiliario.aasearch_columns(text, name[], name[], name[])

-- DROP FUNCTION IF EXISTS imobiliario.aasearch_columns(text, name[], name[], name[]);
SELECT * FROM aasearch_columns('360164', '{codcliente}','{}','{imobiliario}')


CREATE OR REPLACE FUNCTION imobiliario.aasearch_columns(
	needle text,
	haystack_columns name[] DEFAULT '{}'::name[],
	haystack_tables name[] DEFAULT '{}'::name[],
	haystack_schema name[] DEFAULT '{imobiliario}'::name[])
    RETURNS TABLE(schemaname text, tablename text, columnname text, rowctid text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
--SELECT * FROM aasearch_columns('360164', '{codcliente}','{}','{imobiliario}')
  FOR schemaname,tablename,columnname IN
      SELECT c.table_schema,c.table_name,c.column_name
      FROM information_schema.columns c
      JOIN information_schema.tables t ON
        (t.table_name=c.table_name AND t.table_schema=c.table_schema)
      WHERE (c.table_name=ANY(haystack_tables) OR haystack_tables='{}')
        AND c.table_schema=ANY(haystack_schema)
        AND (c.column_name=ANY(haystack_columns) OR haystack_columns='{}')
        AND t.table_type='BASE TABLE'
  LOOP
    EXECUTE format('SELECT ctid FROM %I.%I WHERE cast(%I as text)=%L',
       schemaname,
       tablename,
       columnname,
       needle
    ) INTO rowctid;
    IF rowctid is not null THEN
      RETURN NEXT;
    END IF;
 END LOOP;
 
 
END;
$BODY$;

ALTER FUNCTION imobiliario.aasearch_columns(text, name[], name[], name[])
    OWNER TO ctgis;
