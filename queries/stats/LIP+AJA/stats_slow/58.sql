SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(5);
SELECT sum(pg_lip_bloom_add(0, p.OwnerUserId)) FROM posts AS p WHERE TRUE
  AND p.CommentCount>=0
  AND p.CommentCount<=13;
SELECT sum(pg_lip_bloom_add(1, ph.UserId)) FROM postHistory AS ph WHERE TRUE
  AND ph.PostHistoryTypeId=5
  AND ph.CreationDate<='2014-08-13 09:20:10'::timestamp;
SELECT sum(pg_lip_bloom_add(2, v.UserId)) FROM votes AS v WHERE TRUE
  AND v.CreationDate>='2010-07-19 00:00:00'::timestamp;
SELECT sum(pg_lip_bloom_add(3, b.UserId)) FROM badges AS b WHERE TRUE
  AND b.Date<='2014-09-09 10:24:35'::timestamp;
SELECT sum(pg_lip_bloom_add(4, u.Id)) FROM users AS u WHERE TRUE
  AND u.Views>=0
  AND u.DownVotes>=0
  AND u.CreationDate>='2010-08-04 16:59:53'::timestamp
  AND u.CreationDate<='2014-07-22 15:15:22'::timestamp;


/*+
HashJoin(ph b v pl p u)
HashJoin(ph b)
HashJoin(v pl p u)
HashJoin(pl p u)
HashJoin(pl p)
Leading(((ph b) (v ((pl p) u))))
*/
SELECT COUNT(*)
FROM posts AS p,
     postLinks AS pl,
     (
         select * 
         from postHistory AS ph
         where true
         and pg_lip_bloom_probe(0, ph.UserId)
         and pg_lip_bloom_probe(2, ph.UserId)
         and pg_lip_bloom_probe(4, ph.UserId)
     ) as ph,
     votes AS v,
     badges AS b,
     (
         select * 
         from users AS u
         where true
         and pg_lip_bloom_probe(1, u.Id)
         and pg_lip_bloom_probe(3, u.Id)
     ) as u
WHERE p.Id = pl.RelatedPostId
  AND u.Id = p.OwnerUserId
  AND u.Id = b.UserId
  AND u.Id = ph.UserId
  AND u.Id = v.UserId
  AND p.CommentCount>=0
  AND p.CommentCount<=13
  AND ph.PostHistoryTypeId=5
  AND ph.CreationDate<='2014-08-13 09:20:10'::timestamp
  AND v.CreationDate>='2010-07-19 00:00:00'::timestamp
  AND b.Date<='2014-09-09 10:24:35'::timestamp
  AND u.Views>=0
  AND u.DownVotes>=0
  AND u.CreationDate>='2010-08-04 16:59:53'::timestamp
  AND u.CreationDate<='2014-07-22 15:15:22'::timestamp;