SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);
SELECT sum(pg_lip_bloom_add(0, ph.PostId)) FROM postHistory AS ph WHERE ph.CreationDate>='2010-09-20 19:11:45'::timestamp;
SELECT sum(pg_lip_bloom_add(1, v.PostId)) FROM votes AS v WHERE v.CreationDate<='2014-09-11 00:00:00'::timestamp;
  

/*+
NestLoop(pl p c v ph)
NestLoop(pl p c v)
NestLoop(pl p c)
NestLoop(pl p)
Leading(((((pl p) c) v) ph))
*/

SELECT COUNT(*)
FROM comments AS c,
     posts AS p,
     postLinks AS pl,
     postHistory AS ph,
     votes AS v
WHERE p.Id = pl.PostId
  AND p.Id = v.PostId
  AND p.Id = ph.PostId
  AND p.Id = c.PostId
  AND c.CreationDate<='2014-09-10 02:42:35'::timestamp
  AND p.Score>=-1
  AND p.ViewCount<=5896
  AND p.AnswerCount>=0
  AND p.CreationDate>='2010-07-29 15:57:21'::timestamp
  AND v.VoteTypeId=2;