SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, c.UserId)) FROM comments AS c WHERE TRUE
  AND c.Score=1
  AND c.CreationDate>='2010-07-20 23:17:28'::timestamp;



/*+
HashJoin(c u v b)
NestLoop(u v b)
NestLoop(u v)
Leading((c ((u v) b)))
*/
SELECT COUNT(*)
FROM comments AS c,
     votes AS v,
     badges AS b,
     (
         select * 
         from users AS u
         where true
         and pg_lip_bloom_probe(0, u.Id)
     ) as u
WHERE u.Id = c.UserId
  AND u.Id = v.UserId
  AND u.Id = b.UserId
  AND c.Score=1
  AND c.CreationDate>='2010-07-20 23:17:28'::timestamp
  AND u.CreationDate>='2010-07-20 01:27:29'::timestamp;