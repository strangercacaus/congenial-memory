-- public.transaction_agg definition

-- Drop table

-- DROP TABLE public.transaction_agg;

CREATE TABLE public.transaction_agg ( "day" timestamptz NULL, entity varchar NULL, product varchar NULL, price_tier varchar NULL, anticipation_method varchar NULL, payment_method varchar NULL, installments int4 NULL, amount_transacted numeric NULL, quantity_transactions int8 NULL, quantity_of_merchants int8 NULL, dow int4 NULL);
CREATE INDEX transaction_agg_anticipation_method_idx ON public.transaction_agg USING btree (anticipation_method);
CREATE INDEX transaction_agg_day_idx ON public.transaction_agg USING btree (day);
CREATE INDEX transaction_agg_entity_idx ON public.transaction_agg USING btree (entity);
CREATE INDEX transaction_agg_installments_idx ON public.transaction_agg USING btree (installments);
CREATE INDEX transaction_agg_payment_method_idx ON public.transaction_agg USING btree (payment_method);
CREATE INDEX transaction_agg_price_tier_idx ON public.transaction_agg USING btree (price_tier);
CREATE INDEX transaction_agg_product_idx ON public.transaction_agg USING btree (product);

-- Permissions

ALTER TABLE public.transaction_agg OWNER TO postgres;
GRANT ALL ON TABLE public.transaction_agg TO postgres;
GRANT ALL ON TABLE public.transaction_agg TO anon;
GRANT ALL ON TABLE public.transaction_agg TO authenticated;
GRANT ALL ON TABLE public.transaction_agg TO service_role;