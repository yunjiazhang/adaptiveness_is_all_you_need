SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(3);
SELECT sum(pg_lip_bloom_add(0, v.PostId)) FROM votes as v WHERE TRUE
  AND v.VoteTypeId=2
  AND v.CreationDate>='2010-07-27 00:00:00'::timestamp;
SELECT sum(pg_lip_bloom_add(1, b.UserId)) FROM badges AS b WHERE TRUE
  AND b.Date>='2010-07-27 17:58:45'::timestamp
  AND b.Date<='2014-09-06 17:33:22'::timestamp;
SELECT sum(pg_lip_bloom_add(2, c.PostId)) FROM comments AS c WHERE TRUE
  AND c.CreationDate>='2010-07-26 20:21:15'::timestamp
  AND c.CreationDate<='2014-09-13 18:12:10'::timestamp;
  

/*+
NestLoop(p pl c v ph b)
NestLoop(p pl c v ph)
NestLoop(p pl c v)
NestLoop(p pl c)
NestLoop(p pl)
Leading((((((p pl) c) v) ph) b))
*/
SELECT COUNT(*)
FROM (
        select * 
        from comments AS c
        where true
        and pg_lip_bloom_probe(1, c.UserId)
     ) as c,
     posts AS p,
     (
         select * 
         from postLinks AS pl
         where true
         and pg_lip_bloom_probe(2, pl.RelatedPostId)
         and pg_lip_bloom_probe(0, pl.RelatedPostId)
     ) as pl,
     postHistory AS ph,
     votes AS v,
     badges AS b
WHERE p.Id = c.PostId
  AND p.Id = pl.RelatedPostId
  AND p.Id = ph.PostId
  AND p.Id = v.PostId
  AND b.UserId = c.UserId
  AND c.CreationDate>='2010-07-26 20:21:15'::timestamp
  AND c.CreationDate<='2014-09-13 18:12:10'::timestamp
  AND p.Score<=61
  AND p.ViewCount<=3627
  AND p.AnswerCount>=0
  AND p.AnswerCount<=5
  AND p.CommentCount<=8
  AND p.FavoriteCount>=0
  AND v.VoteTypeId=2
  AND v.CreationDate>='2010-07-27 00:00:00'::timestamp
  AND b.Date>='2010-07-30 03:49:24'::timestamp;