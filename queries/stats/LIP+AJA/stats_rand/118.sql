SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);
SELECT sum(pg_lip_bloom_add(0, v.PostId)) FROM votes AS v where v.CreationDate>='2010-07-20 00:00:00'::timestamp
  AND v.CreationDate<='2014-09-03 00:00:00'::timestamp;
SELECT sum(pg_lip_bloom_add(1, u.Id)) FROM users AS u where u.DownVotes=0
  AND u.CreationDate<='2014-08-08 07:03:29'::timestamp;

/*+
HashJoin(p ph u v)
NestLoop(p ph u)
NestLoop(p ph)
Leading((v ((p ph) u)))
*/
SELECT COUNT(*)
FROM postHistory AS ph,
     (
         select *
         from posts AS p
         where true 
         and pg_lip_bloom_probe(1, p.OwnerUserId)
         and pg_lip_bloom_probe(0, p.Id)
     ) as p,
     votes AS v,
     users AS u
WHERE u.Id = p.OwnerUserId
  AND p.Id = ph.PostId
  AND p.Id = v.PostId
  AND ph.CreationDate<='2014-07-28 13:25:35'::timestamp
  AND p.PostTypeId=1
  AND p.AnswerCount>=0
  AND p.AnswerCount<=4
  AND v.CreationDate>='2010-07-20 00:00:00'::timestamp
  AND v.CreationDate<='2014-09-03 00:00:00'::timestamp
  AND u.DownVotes=0
  AND u.CreationDate<='2014-08-08 07:03:29'::timestamp;