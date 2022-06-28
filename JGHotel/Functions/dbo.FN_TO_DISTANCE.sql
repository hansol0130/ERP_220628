USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FN_TO_DISTANCE](
    @lat1 AS FLOAT,
    @long1 AS FLOAT,
    @lat2 AS FLOAT,
    @long2 AS FLOAT
)
/*
 위도,경도를 이용한 두 위치사이의 거리 구하기
*/
RETURNS FLOAT AS

BEGIN
    DECLARE @V_RETURN FLOAT;

    SELECT @V_RETURN = distance
      FROM
           (SELECT 2 * atn2(sqrt(p.a), sqrt(1-p.a)) * 6387700 as distance
             FROM
                  (SELECT sin(l.dLat/2) * sin(l.dLat/2) + sin(l.dLon/2) * sin(l.dLon/2) * cos(l.lat1) * cos(l.lat2) as a
                    FROM
                         (SELECT radians(k.lat2 - k.lat1) as dLat,
                                radians(k.long2 - k.long1) as dLon,
                                radians(k.lat1) as lat1,
                                radians(k.lat2) as lat2
                           FROM
                                (SELECT @lat1 as lat1,
                                       @long1 as long1,
                                       @lat2 as lat2,
                                       @long2 as long2
                                ) k
                         ) l
                  ) p
           ) o;
    RETURN @V_RETURN;
END
GO
