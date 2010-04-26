
CREATE TABLE tmp_dup
(orig numeric, copy numeric)
go

INSERT INTO tmp_dup (orig, copy)
 (select min(a.item_id), max(a.item_id) from items a JOIN
(select organization_id, ext_item_id, count(*) dupcount
 FROM items
 GROUP BY organization_id, ext_item_id
 HAVING count(*) > 1) b
ON a.organization_id = b.organization_id
AND a.ext_item_id = b.ext_item_id
GROUP BY b.organization_id, b.ext_item_id)
go


UPDATE job_item_rates
SET item_id = t.orig
FROM job_item_rates jir, tmp_dup t
WHERE jir.item_id = t.copy
go

delete from invoice_lines where invoice_line_id in 
(select jir.invoice_line_id FROM invoice_lines jir, invoice_lines jiro, tmp_dup t, items i
WHERE jir.item_id = t.copy
AND jir.invoice_id = jiro.invoice_id
AND jir.qty = jiro.qty
AND jir.qty = 1
AND jiro.item_id = t.orig
AND jir.item_id = i.item_id
AND i.name = 'Labor-Tax')
go

UPDATE invoice_lines
SET item_id = t.orig
FROM invoice_lines jir, tmp_dup t
WHERE jir.item_id = t.copy
go


UPDATE item_costing_history
SET item_id = t.orig
FROM item_costing_history jir, tmp_dup t
WHERE jir.item_id = t.copy
go

UPDATE pooled_hours_calc
SET item_id = t.orig
FROM pooled_hours_calc jir, tmp_dup t
WHERE jir.item_id = t.copy
go


UPDATE resource_items
SET item_id = t.orig
FROM resource_items jir, tmp_dup t
WHERE jir.item_id = t.copy
go


UPDATE resource_type_items
SET item_id = t.orig
FROM resource_type_items jir, tmp_dup t
WHERE jir.item_id = t.copy
go


UPDATE service_lines
SET item_id = t.orig
FROM service_lines jir, tmp_dup t
WHERE jir.item_id = t.copy
go


UPDATE xref_items
SET item_id = t.orig
FROM xref_items jir, tmp_dup t
WHERE jir.item_id = t.copy
go


delete from items where item_id in (SELECT copy FROM tmp_dup)
go

drop table tmp_dup
go