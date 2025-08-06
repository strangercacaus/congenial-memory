-- public.series_decomposition definition

-- Drop table

-- DROP TABLE public.series_decomposition;

CREATE TABLE public.series_decomposition ( "day" timestamptz NULL, value float8 NULL, trend float8 NULL, seasonality float8 NULL, residue float8 NULL, anomaly bool NULL);

-- Permissions

ALTER TABLE public.series_decomposition OWNER TO postgres;
GRANT ALL ON TABLE public.series_decomposition TO postgres;
GRANT ALL ON TABLE public.series_decomposition TO anon;
GRANT ALL ON TABLE public.series_decomposition TO authenticated;
GRANT ALL ON TABLE public.series_decomposition TO service_role;