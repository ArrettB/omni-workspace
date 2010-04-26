
CREATE VIEW pkt_job_user_res_v
AS
SELECT job_id, 
       user_id, 
       resource_id
  FROM (SELECT j.job_id, 
               jd.user_id, 
               r.resource_id
          FROM dbo.jobs j INNER JOIN
               dbo.job_distributions jd ON j.job_id = jd.job_id INNER JOIN
               dbo.resources r ON jd.user_id = r.user_id
         WHERE (r.active_flag = 'Y')
       UNION
        SELECT sr.job_id, 
               r.user_id, 
               r.resource_id
          FROM dbo.sch_resources sr INNER JOIN
               dbo.RESOURCES r ON sr.resource_id = r.resource_id
         WHERE CONVERT(DATETIME, CONVERT(VARCHAR, sr.res_start_date, 101)) <= CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101))
           AND ISNULL(CONVERT(DATETIME, CONVERT(VARCHAR, sr.res_end_date, 101)), DATEADD(DAY, 1, CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101)))) >= CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101)) 
           AND r.ACTIVE_FLAG = 'Y'
       UNION
        SELECT prc.job_id, 
               r.user_id, 
               prc.resource_id
          FROM dbo.pda_roster_changes prc INNER JOIN
               dbo.resources r ON prc.resource_id = r.resource_id
         WHERE r.active_flag = 'Y') tmp

