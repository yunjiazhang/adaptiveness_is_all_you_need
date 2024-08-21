SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);
SELECT sum(pg_lip_bloom_add(0, c.UserId)) FROM comments AS c WHERE c.Score=1
  AND c.CreationDate>='2010-08-27 14:12:07'::timestamp;

/*+
HashJoin(v u b c)
NestLoop(v u b)
NestLoop(v u)
Leading((c ((u v) b)))
*/
SELECT COUNT(*)
FROM comments AS c,
     votes AS v,
     badges AS b,
     (
         select * 
         from users AS u
         where pg_lip_bloom_probe(0, u.Id)
     ) as u
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