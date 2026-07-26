CREATE OR REPLACE FUNCTION get_rating_histogram(p_beer_id UUID)
RETURNS TABLE (
  count5 BIGINT,
  count4 BIGINT,
  count3 BIGINT,
  count2 BIGINT,
  count1 BIGINT,
  total BIGINT,
  average NUMERIC
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    COUNT(CASE WHEN overall = 5 THEN 1 END) AS count5,
    COUNT(CASE WHEN overall = 4 THEN 1 END) AS count4,
    COUNT(CASE WHEN overall = 3 THEN 1 END) AS count3,
    COUNT(CASE WHEN overall = 2 THEN 1 END) AS count2,
    COUNT(CASE WHEN overall = 1 THEN 1 END) AS count1,
    COUNT(*) AS total,
    COALESCE(ROUND(AVG(overall)::NUMERIC, 1), 0.0) AS average
  FROM public.ratings
  WHERE beer_id = p_beer_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
