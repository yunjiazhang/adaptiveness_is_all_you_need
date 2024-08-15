SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(3);
SELECT sum(pg_lip_bloom_add(0, p.OwnerUserId)) FROM posts AS p WHERE TRUE
  AND p.PostTypeId=1
  AND p.Score<=35
  AND p.AnswerCount=1
  AND p.CommentCount<=17
  AND p.FavoriteCount>=0;
SELECT sum(pg_lip_bloom_add(1, b.UserId)) FROM badges AS b WHERE TRUE
  AND b.Date>='2010-07-27 17:58:45'::timestamp
  AND b.Date<='2014-09-06 17:33:22'::timestamp;
SELECT sum(pg_lip_bloom_add(2, u.Id)) FROM users AS u WHERE TRUE
  AND u.Views<=233
  AND u.DownVotes<=2
  AND u.CreationDate>='2010-09-16 16:00:55'::timestamp
  AND u.CreationDate<='2014-08-24 21:12:02'::timestamp;


/*+
HashJoin(ph b u c p)
HashJoin(ph b)
NestLoop(u c p)
HashJoin(u c)
Leading(((ph b) ((u c) p)))
*/
SELECT COUNT(*)
FROM 
     comments AS c,
     posts AS p,
     (
         select * 
         from postHistory AS ph
         where true
         and pg_lip_bloom_probe(0, ph.UserId)
         and pg_lip_bloom_probe(2, ph.UserId)
     ) as ph,
     badges AS b,
     (
         select * 
         from users AS u
         where true
         and pg_lip_bloom_probe(1, u.Id)
     ) as u
WHERE u.Id = c.UserId
  AND u.Id = p.OwnerUserId
  AND u.Id = ph.UserId
  AND u.Id = b.UserId
  AND p.PostTypeId=1
  AND p.Score<=35
  AND p.AnswerCount=1
  AND p.CommentCount<=17
  AND p.FavoriteCount>=0
  AND b.Date>='2010-07-27 17:58:45'::timestamp
  AND b.Date<='2014-09-06 17:33:22'::timestamp
  AND u.Views<=233
  AND u.DownVotes<=2
  AND u.CreationDate>='2010-09-16 16:00:55'::timestamp
  AND u.CreationDate<='2014-08-24 21:12:02'::timestamp;