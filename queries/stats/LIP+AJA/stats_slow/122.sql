SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(1);
SELECT sum(pg_lip_bloom_add(0, UserId)) FROM postHistory AS ph WHERE ph.CreationDate>='2010-07-27 18:08:19'::timestamp
  AND ph.CreationDate<='2014-09-10 08:22:43'::timestamp;


/*+
HashJoin(p u b ph)
HashJoin(p u b)
HashJoin(p u)
Leading(((b (p u)) ph))
*/
SELECT COUNT(*)
FROM postHistory AS ph,
     (
         SELECT * 
         FROM posts AS p
         WHERE pg_lip_bloom_probe(0, p.OwnerUserId)
     ) AS p,
     users AS u,
     badges AS b
WHERE b.UserId = u.Id
  AND p.OwnerUserId = u.Id
  AND ph.UserId = u.Id
  AND ph.CreationDate>='2010-07-27 18:08:19'::timestamp
  AND ph.CreationDate<='2014-09-10 08:22:43'::timestamp
  AND p.PostTypeId=2;