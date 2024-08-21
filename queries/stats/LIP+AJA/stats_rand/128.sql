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
     (
         select * 
         from postLinks AS pl
         where true
         and pg_lip_bloom_probe(0, pl.PostId)
         and pg_lip_bloom_probe(1, pl.PostId)
     ) as pl,
     postHistory AS ph,
     votes AS v
WHERE p.Id = pl.PostId
  AND p.Id = v.PostId
  AND p.Id = ph.PostId
  AND p.Id = c.PostId
  AND c.CreationDate>='2010-08-01 12:12:41'::timestamp
  AND p.Score<=44
  AND p.FavoriteCount>=0
  AND p.FavoriteCount<=3
  AND p.CreationDate>='2010-08-11 13:53:56'::timestamp
  AND p.CreationDate<='2014-09-03 11:52:36'::timestamp
  AND pl.LinkTypeId=1
  AND pl.CreationDate<='2014-08-11 17:26:31'::timestamp
  AND ph.CreationDate>='2010-09-20 19:11:45'::timestamp
  AND v.CreationDate<='2014-09-11 00:00:00'::timestamp;