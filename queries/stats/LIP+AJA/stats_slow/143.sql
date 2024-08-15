SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);
SELECT sum(pg_lip_bloom_add(0, b.UserId)) FROM badges AS b WHERE TRUE
  AND b.Date<='2014-08-02 12:24:29'::timestamp;
SELECT sum(pg_lip_bloom_add(1, v.PostId)) FROM votes AS v WHERE TRUE
  AND v.VoteTypeId=2
  AND v.CreationDate<='2014-09-10 00:00:00'::timestamp;


/*+
HashJoin(b p pl c u v ph)
NestLoop(p pl c u v ph)
NestLoop(p pl c u v)
NestLoop(p pl c u)
NestLoop(p pl c)
NestLoop(p pl)
Leading((b (((((p pl) c) u) v) ph)))
*/
SELECT COUNT(*)
FROM 
     (
        select * from 
         comments AS c
         where true 
         and pg_lip_bloom_probe(0, c.UserId)
     ) as c,
     posts AS p,
     (
         select * 
         from postLinks AS pl
         where true
         and pg_lip_bloom_probe(1, pl.RelatedPostId)
     ) as pl,
     postHistory AS ph,
     votes AS v,
     badges AS b,
     users AS u
WHERE p.Id = pl.RelatedPostId
  AND b.UserId = u.Id
  AND c.UserId = u.Id
  AND p.Id = v.PostId
  AND p.Id = c.PostId
  AND p.Id = ph.PostId
  AND c.CreationDate>='2010-08-01 19:11:47'::timestamp
  AND c.CreationDate<='2014-09-11 13:42:51'::timestamp
  AND p.AnswerCount<=4
  AND p.FavoriteCount>=0
  AND pl.LinkTypeId=1
  AND v.VoteTypeId=2
  AND v.CreationDate<='2014-09-10 00:00:00'::timestamp
  AND b.Date<='2014-08-02 12:24:29'::timestamp;