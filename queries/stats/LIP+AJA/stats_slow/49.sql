SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(5);
SELECT sum(pg_lip_bloom_add(0, c.UserId)) FROM comments AS c WHERE TRUE
  AND c.Score=1 ;
SELECT sum(pg_lip_bloom_add(1, p.OwnerUserId)) FROM posts as p WHERE TRUE
  AND p.Score>=-1 
  AND p.Score<=29 
  AND p.CreationDate>='2010-07-19 20:40:36'::timestamp 
  AND p.CreationDate<='2014-09-10 20:52:30'::timestamp;
SELECT sum(pg_lip_bloom_add(2, v.UserId)) FROM votes as v WHERE TRUE
  AND v.BountyAmount<=50;
SELECT sum(pg_lip_bloom_add(3, b.UserId)) FROM badges as b WHERE TRUE
  AND b.Date<='2014-08-25 19:05:46'::timestamp;  
SELECT sum(pg_lip_bloom_add(4, u.Id)) FROM users as u WHERE TRUE
  AND u.DownVotes<=11 
  AND u.CreationDate>='2010-07-31 17:32:56'::timestamp 
  AND u.CreationDate<='2014-09-07 16:06:26'::timestamp;



/*+
HashJoin(v b p u c)
NestLoop(u c)
NestLoop(v b p)
NestLoop(v b)
Leading((((v b) p) (u c)))
*/
SELECT COUNT(*) 
FROM 
comments as c, 
posts as p, 
(
    select * 
    from votes as v
    where true
    and pg_lip_bloom_probe(0, v.UserId)
    and pg_lip_bloom_probe(4, v.UserId)
) as v, 
badges as b, 
(
    select * from users as u 
    where true
    and pg_lip_bloom_probe(1, u.Id)
    and pg_lip_bloom_probe(2, u.Id)
    and pg_lip_bloom_probe(3, u.Id)
) as u
WHERE true
AND u.Id =c.UserId 
AND c.UserId = p.OwnerUserId 
AND p.OwnerUserId = v.UserId 
AND v.UserId = b.UserId 
AND c.Score=1 
AND p.Score>=-1 
AND p.Score<=29 
AND p.CreationDate>='2010-07-19 20:40:36'::timestamp 
AND p.CreationDate<='2014-09-10 20:52:30'::timestamp 
AND v.BountyAmount<=50 
AND b.Date<='2014-08-25 19:05:46'::timestamp 
AND u.DownVotes<=11 
AND u.CreationDate>='2010-07-31 17:32:56'::timestamp 
AND u.CreationDate<='2014-09-07 16:06:26'::timestamp;