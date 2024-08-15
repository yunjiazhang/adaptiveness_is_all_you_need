SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);
SELECT sum(pg_lip_bloom_add(0, UserId)) FROM badges AS b WHERE b.Date<='2014-08-19 10:32:13'::timestamp;
SELECT sum(pg_lip_bloom_add(1, v.UserId)) FROM votes AS v WHERE v.VoteTypeId=5
  AND v.CreationDate>='2010-07-19 00:00:00'::timestamp
  AND v.CreationDate<='2014-09-13 00:00:00'::timestamp;


/*+
HashJoin(c u v b)
NestLoop(u v b)
NestLoop(u v)
Leading((c ((u v) b)))
*/
SELECT COUNT(*)
FROM (
        SELECT * FROM
        comments AS c
        WHERE TRUE 
        AND pg_lip_bloom_probe(0, c.UserId)
        AND pg_lip_bloom_probe(1, c.UserId)
     ) AS c,
     (
         SELECT * 
         FROM votes AS v
     ) AS v,
     badges AS b,
     (
         SELECT * 
         FROM users AS u
     ) AS u
WHERE u.Id = b.UserId
  AND u.Id = c.UserId
  AND u.Id = v.UserId
  AND c.Score=1
  AND c.CreationDate>='2010-08-27 14:12:07'::timestamp
  AND v.VoteTypeId=5
  AND v.CreationDate>='2010-07-19 00:00:00'::timestamp
  AND v.CreationDate<='2014-09-13 00:00:00'::timestamp
  AND b.Date<='2014-08-19 10:32:13'::timestamp
  AND u.Reputation>=1;