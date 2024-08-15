SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(4);

SELECT sum(pg_lip_bloom_add(0, v.UserId)) FROM votes AS v WHERE TRUE
  AND v.CreationDate>='2010-07-20 00:00:00'::timestamp;
SELECT sum(pg_lip_bloom_add(1, p.OwnerUserId)) FROM posts AS p WHERE TRUE
  AND p.AnswerCount>=0
  AND p.FavoriteCount>=0;
SELECT sum(pg_lip_bloom_add(2, ph.UserId)) FROM postHistory AS ph WHERE TRUE
  AND ph.PostHistoryTypeId=2;
SELECT sum(pg_lip_bloom_add(3, u.Id)) FROM users AS u WHERE TRUE
  AND u.Reputation>=1
  AND u.DownVotes>=0
  AND u.DownVotes<=0
  AND u.UpVotes<=439
  AND u.CreationDate<='2014-08-07 11:18:45'::timestamp;


/*+
HashJoin(ph b pl p u v)
NestLoop(pl p u v b)
NestLoop(pl p u v)
NestLoop(pl p u)
NestLoop(p pl)
Leading((ph ((((p pl) u) v) b)))
*/
SELECT COUNT(*)
FROM (
        select * 
        from posts AS p
        where true
        and pg_lip_bloom_probe(0, p.OwnerUserId)
        and pg_lip_bloom_probe(1, p.OwnerUserId)
        and pg_lip_bloom_probe(2, p.OwnerUserId)
        and pg_lip_bloom_probe(3, p.OwnerUserId)
     ) as p,
     postLinks AS pl,
     postHistory AS ph,
     votes AS v,
     badges AS b,
     users AS u
WHERE p.Id = pl.RelatedPostId
  AND u.Id = p.OwnerUserId
  AND u.Id = b.UserId
  AND u.Id = ph.UserId
  AND u.Id = v.UserId
  AND p.AnswerCount>=0
  AND p.FavoriteCount>=0
  AND pl.LinkTypeId=1
  AND ph.PostHistoryTypeId=2
  AND v.CreationDate>='2010-07-20 00:00:00'::timestamp
  AND u.Reputation>=1
  AND u.DownVotes>=0
  AND u.DownVotes<=0
  AND u.UpVotes<=439
  AND u.CreationDate<='2014-08-07 11:18:45'::timestamp;