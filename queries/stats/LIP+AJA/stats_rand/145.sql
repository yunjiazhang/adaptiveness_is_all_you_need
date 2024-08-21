SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);

SELECT sum(pg_lip_bloom_add(0, u.Id)) FROM users AS u WHERE TRUE
  AND u.UpVotes>=0
  AND u.CreationDate<='2014-09-11 20:31:48'::timestamp;
SELECT sum(pg_lip_bloom_add(1, v.PostId)) FROM votes AS v WHERE TRUE
and v.CreationDate>='2010-07-21 00:00:00'::timestamp;

/*+
NestLoop(p pl ph u c v)
NestLoop(p pl ph u c)
NestLoop(p pl ph u)
NestLoop(p pl ph)
NestLoop(p pl)
Leading((((((p pl) ph) u) c) v))
*/
SELECT COUNT(*)
FROM comments AS c,
     (
         select * 
         from posts AS p
         where true
         and pg_lip_bloom_probe(0, p.OwnerUserId)
         and pg_lip_bloom_probe(1, p.Id)
     ) as p,
     postLinks AS pl,
     postHistory AS ph,
     votes AS v,
     users AS u
WHERE u.Id = p.OwnerUserId
  AND p.Id = v.PostId
  AND p.Id = c.PostId
  AND p.Id = pl.PostId
  AND p.Id = ph.PostId
  AND p.PostTypeId=1
  AND p.AnswerCount>=0
  AND p.CreationDate>='2010-07-21 15:23:53'::timestamp
  AND p.CreationDate<='2014-09-11 23:26:14'::timestamp
  AND pl.CreationDate>='2010-11-16 01:27:37'::timestamp
  AND pl.CreationDate<='2014-08-21 15:25:23'::timestamp
  AND ph.PostHistoryTypeId=5
  AND v.CreationDate>='2010-07-21 00:00:00'::timestamp
  AND u.UpVotes>=0
  AND u.CreationDate<='2014-09-11 20:31:48'::timestamp;