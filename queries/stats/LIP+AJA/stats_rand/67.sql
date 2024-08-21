SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);
SELECT sum(pg_lip_bloom_add(0, c.PostId)) FROM comments AS c WHERE c.Score=0
  AND c.CreationDate>='2010-08-02 20:27:48'::timestamp
  AND c.CreationDate<='2014-09-10 16:09:23'::timestamp;
  

/*+
NestLoop(p pl ph c u v)
NestLoop(p pl ph c u)
NestLoop(p pl ph c)
NestLoop(p pl ph)
NestLoop(p pl)
Leading((((((p pl) ph) c) u) v))
*/
SELECT COUNT(*)
FROM comments AS c,
     (
         select * 
         from posts AS p
         where pg_lip_bloom_probe(0, p.Id)
     ) as p,
     postLinks AS pl,
     postHistory AS ph,
     votes AS v,
     users AS u
WHERE p.Id = pl.PostId
  AND p.Id = ph.PostId
  AND p.Id = c.PostId
  AND u.Id = c.UserId
  AND u.Id = v.UserId
  AND c.Score=0
  AND c.CreationDate>='2010-08-02 20:27:48'::timestamp
  AND c.CreationDate<='2014-09-10 16:09:23'::timestamp
  AND p.PostTypeId=1
  AND p.Score=4
  AND p.ViewCount<=4937
  AND pl.CreationDate>='2011-11-03 05:09:35'::timestamp
  AND ph.PostHistoryTypeId=1
  AND u.Reputation<=270
  AND u.Views>=0
  AND u.Views<=51
  AND u.DownVotes>=0;