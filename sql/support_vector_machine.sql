-- public.support_vector_machine definition

-- Drop table

-- DROP TABLE public.support_vector_machine;

CREATE TABLE public.support_vector_machine ( "day" timestamptz NULL, value float8 NULL, day_of_week int4 NULL, rolling_mean float8 NULL, rolling_std float8 NULL, diff float8 NULL, anomaly int8 NULL);

-- Permissions

ALTER TABLE public.support_vector_machine OWNER TO postgres;
GRANT ALL ON TABLE public.support_vector_machine TO postgres;
GRANT ALL ON TABLE public.support_vector_machine TO anon;
GRANT ALL ON TABLE public.support_vector_machine TO authenticated;
GRANT ALL ON TABLE public.support_vector_machine TO service_role;