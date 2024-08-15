SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(2);
SELECT sum(pg_lip_bloom_add(0, UserId)) FROM comments AS c WHERE c.CreationDate<='2014-08-28 00:18:24'::timestamp;
SELECT sum(pg_lip_bloom_add(1, Id)) FROM users AS u WHERE u.Reputation>=1
  AND u.Reputation<=1443
  AND u.DownVotes>=0
  AND u.DownVotes<=3;


/*+
HashJoin(ph b c u)
NestLoop(c u)
NestLoop(ph b)
Leading(((ph b) (u c)))
*/
SELECT COUNT(*)
FROM comments AS c,
     (
         SELECT * FROM 
         postHistory AS ph
         WHERE true 
         and pg_lip_bloom_probe(0, ph.UserId) 
         AND pg_lip_bloom_probe(1, ph.UserId)
     ) AS ph,
     badges AS b,
     users AS u
WHERE u.Id = b.UserId
  AND u.Id = ph.UserId
  AND u.Id = c.UserId
  AND c.CreationDate<='2014-08-28 00:18:24'::timestamp
  AND b.Date>='2010-09-15 02:50:48'::timestamp
  AND u.Reputation>=1
  AND u.Reputation<=1443
  AND u.DownVotes>=0
  AND u.DownVotes<=3;