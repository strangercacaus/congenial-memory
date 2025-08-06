-- DROP FUNCTION public.analyze_flow(varchar, varchar, varchar, varchar, varchar, varchar);

CREATE OR REPLACE FUNCTION public.analyze_flow(step_1 character varying DEFAULT NULL::character varying, step_2 character varying DEFAULT NULL::character varying, step_3 character varying DEFAULT NULL::character varying, step_4 character varying DEFAULT NULL::character varying, measure_type character varying DEFAULT 'quantity_transactions'::character varying, agg_type character varying DEFAULT 'sum'::character varying)
 RETURNS TABLE(flow_step text, source_info text, target_info text, transition_count bigint, measure_value numeric)
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- Validate parameters
    IF measure_type NOT IN ('amount_transacted', 'quantity_transactions','installments') THEN
        RAISE EXCEPTION 'Invalid measure_type: %. Use: amount_transacted, quantity_transactions, installments', measure_type;
    END IF;
    
    IF agg_type NOT IN ('sum', 'avg', 'count') THEN
        RAISE EXCEPTION 'Invalid agg_type: %. Use: sum, avg, count', agg_type;
    END IF;

    RETURN QUERY
    WITH params AS (
        SELECT 
            step_1 as p_step_1,
            step_2 as p_step_2, 
            step_3 as p_step_3,
            step_4 as p_step_4,
            measure_type as p_measure,
            agg_type as p_agg
    ),
    flow_base AS (
        SELECT 
            ta.*,
            p.*
        FROM transaction_agg ta
        CROSS JOIN params p
        WHERE COALESCE(p.p_step_1, p.p_step_2, p.p_step_3, p.p_step_4) IS NOT NULL
    ),
    field_mapper AS (
        SELECT *,
            CASE p_step_1
                WHEN 'entity' THEN entity::TEXT
                WHEN 'product' THEN product::TEXT
                WHEN 'price_tier' THEN price_tier::TEXT
                WHEN 'anticipation_method' THEN anticipation_method::TEXT
                WHEN 'payment_method' THEN payment_method::TEXT
                WHEN 'installments' THEN installments::TEXT
                WHEN 'dow' THEN dow::TEXT
            END as step_1_value,
            
            CASE p_step_2
                WHEN 'entity' THEN entity::TEXT
                WHEN 'product' THEN product::TEXT
                WHEN 'price_tier' THEN price_tier::TEXT
                WHEN 'anticipation_method' THEN anticipation_method::TEXT
                WHEN 'payment_method' THEN payment_method::TEXT
                WHEN 'installments' THEN installments::TEXT
                WHEN 'dow' THEN dow::TEXT
            END as step_2_value,
            
            CASE p_step_3
                WHEN 'entity' THEN entity::TEXT
                WHEN 'product' THEN product::TEXT
                WHEN 'price_tier' THEN price_tier::TEXT
                WHEN 'anticipation_method' THEN anticipation_method::TEXT
                WHEN 'payment_method' THEN payment_method::TEXT
                WHEN 'installments' THEN installments::TEXT
                WHEN 'dow' THEN dow::TEXT
            END as step_3_value,
            
            CASE p_step_4
                WHEN 'entity' THEN entity::TEXT
                WHEN 'product' THEN product::TEXT
                WHEN 'price_tier' THEN price_tier::TEXT
                WHEN 'anticipation_method' THEN anticipation_method::TEXT
                WHEN 'payment_method' THEN payment_method::TEXT
                WHEN 'installments' THEN installments::TEXT
                WHEN 'dow' THEN dow::TEXT
            END as step_4_value,
            
            CASE p_measure
                WHEN 'amount_transacted' THEN amount_transacted
                WHEN 'quantity_transactions' THEN quantity_transactions
				WHEN 'installments' then installments
                ELSE 0
            END as measure_val
        FROM flow_base
    ),
    all_flows AS (
        -- Flow 1→2
        SELECT 
            '1→2'::TEXT as flow_step,
            p_step_1::TEXT as source_step,
            step_1_value::TEXT as source_node,
            p_step_2::TEXT as target_step,
            step_2_value::TEXT as target_node,
            COUNT(*) as transition_count,
            CASE p_agg
                WHEN 'sum' THEN SUM(measure_val)
                WHEN 'avg' THEN AVG(measure_val)
                WHEN 'count' THEN COUNT(*)::NUMERIC
            END as measure_value
        FROM field_mapper
        WHERE p_step_1 IS NOT NULL 
          AND p_step_2 IS NOT NULL
          AND step_1_value IS NOT NULL 
          AND step_2_value IS NOT NULL
        GROUP BY p_step_1, step_1_value, p_step_2, step_2_value, p_agg
        
        UNION ALL
        
        -- Flow 2→3  
        SELECT 
            '2→3'::TEXT as flow_step,
            p_step_2::TEXT as source_step,
            step_2_value::TEXT as source_node,
            p_step_3::TEXT as target_step,
            step_3_value::TEXT as target_node,
            COUNT(*) as transition_count,
            CASE p_agg
                WHEN 'sum' THEN SUM(measure_val)
                WHEN 'avg' THEN AVG(measure_val)
                WHEN 'count' THEN COUNT(*)::NUMERIC
            END as measure_value
        FROM field_mapper
        WHERE p_step_2 IS NOT NULL 
          AND p_step_3 IS NOT NULL
          AND step_2_value IS NOT NULL 
          AND step_3_value IS NOT NULL
        GROUP BY p_step_2, step_2_value, p_step_3, step_3_value, p_agg
        
        UNION ALL
        
        -- Flow 3→4
        SELECT 
            '3→4'::TEXT as flow_step,
            p_step_3::TEXT||'' as source_step,
            step_3_value::TEXT as source_node,
            p_step_4::TEXT as target_step,
            step_4_value::TEXT as target_node,
            COUNT(*) as transition_count,
            CASE p_agg
                WHEN 'sum' THEN SUM(measure_val)
                WHEN 'avg' THEN AVG(measure_val)
                WHEN 'count' THEN COUNT(*)::NUMERIC
            END as measure_value
        FROM field_mapper
        WHERE p_step_3 IS NOT NULL 
          AND p_step_4 IS NOT NULL
          AND step_3_value IS NOT NULL 
          AND step_4_value IS NOT NULL
        GROUP BY p_step_3, step_3_value, p_step_4, step_4_value, p_agg
    )
    SELECT 
        all_flows.flow_step,
        all_flows.source_step||': '||all_flows.source_node as source_info,
        all_flows.target_step||': '||all_flows.target_node as target_info,
        all_flows.transition_count,
        all_flows.measure_value 
    FROM all_flows
    ORDER BY all_flows.flow_step, all_flows.transition_count DESC;
    
END;
$function$
;

-- Permissions

ALTER FUNCTION public.analyze_flow(varchar, varchar, varchar, varchar, varchar, varchar) OWNER TO postgres;
GRANT ALL ON FUNCTION public.analyze_flow(varchar, varchar, varchar, varchar, varchar, varchar) TO public;
GRANT ALL ON FUNCTION public.analyze_flow(varchar, varchar, varchar, varchar, varchar, varchar) TO postgres;
GRANT ALL ON FUNCTION public.analyze_flow(varchar, varchar, varchar, varchar, varchar, varchar) TO anon;
GRANT ALL ON FUNCTION public.analyze_flow(varchar, varchar, varchar, varchar, varchar, varchar) TO authenticated;
GRANT ALL ON FUNCTION public.analyze_flow(varchar, varchar, varchar, varchar, varchar, varchar) TO service_role;