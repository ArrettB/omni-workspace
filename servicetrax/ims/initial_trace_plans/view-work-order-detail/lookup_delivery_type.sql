SELECT lt.code lookup_type, l.lookup_id   FROM lookups l INNER JOIN lookup_types lt ON l.lookup_type_id=lt.lookup_type_id  WHERE ((lt.code='delivery_type' OR (lt.code='furniture_line_type' AND l.attribute2='system')) AND l.code='n_a')     OR (lt.code='yes_no_type' AND l.code='N')