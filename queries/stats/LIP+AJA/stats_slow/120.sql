SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, UserId)) FROM postHistory AS ph WHERE ph.CreationDate>='2010-07-19 19:52:31'::timestamp;

/*+
HashJoin(u p b ph)
HashJoin(u p b)
HashJoin(u p)
Leading(((b (p u)) ph))
*/
SELECT COUNT(*)
FROM postHistory AS ph,
     (
         SELECT * 
         FROM posts AS p
         -- WHERE pg_lip_bloom_probe(0, p.OwnerUserId)
     ) AS p,
     (
         select * 
         from users AS u
     ) AS u,
     badges AS b
WHERE b.UserId = u.Id
  AND p.OwnerUserId = u.Id
  AND ph.UserId = u.Id
  AND ph.CreationDate>='2010-07-19 19:52:31'::timestamp
  AND p.Score>=0
  AND u.CreationDate>='2010-07-27 02:56:06'::timestamp
  AND u.CreationDate<='2014-09-10 10:44:00'::timestamp;