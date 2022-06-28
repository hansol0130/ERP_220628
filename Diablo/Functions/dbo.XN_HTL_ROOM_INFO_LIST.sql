USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/* =============================================
-- Author:		<박형만>
-- Create date: <2013-04-30>
-- Description:	<호텔 룸정보 테이블을 반환한다>

ex) 
SELECT (STUFF ((
	SELECT (', ' + ROOM_INFO  ) AS [TEXT()] FROM DBO.XN_HTL_ROOM_INFO_LIST('RH1209274746')
FOR XML PATH('')), 1, 2, ''))
 
-- =============================================*/
CREATE FUNCTION [dbo].[XN_HTL_ROOM_INFO_LIST] 
(	
	@RES_CODE RES_CODE
)
RETURNS @ROOM_LIST TABLE 
(
	ROON_NO	INT, 
	ROOM_INFO VARCHAR(200)		--	요금코드
)
AS
BEGIN
	-- 호텔 룸 정보
	DECLARE @ROOM_NO INT 
	SET @ROOM_NO  = 1 
	WHILE EXISTS ( SELECT * FROM RES_HTL_ROOM_DETAIL WITH(NOLOCK) WHERE RES_CODE = @RES_CODE AND ROOM_NO = @ROOM_NO ) 
	BEGIN
		INSERT @ROOM_LIST
		SELECT @ROOM_NO , ROOM_NAME + ' ' + 
			CASE WHEN ROOM_TYPE = 1 THEN '싱글룸'  
				WHEN ROOM_TYPE = 2 THEN '더블룸' 
				WHEN ROOM_TYPE = 3 THEN '트윈룸'
				WHEN ROOM_TYPE = 4 THEN '트리플룸'
				WHEN ROOM_TYPE = 5 THEN '4인실' ELSE '' END + ' ' +  
			CONVERT(VARCHAR,ROOM_COUNT) + '개 * ' + CONVERT(VARCHAR, DATEDIFF( D, B.CHECK_IN , B.CHECK_OUT ) ) + '박'
			
		FROM RES_HTL_ROOM_DETAIL A WITH(NOLOCK)
			INNER JOIN RES_HTL_ROOM_MASTER B WITH(NOLOCK) 
				ON A.RES_CODE = B.RES_CODE 
		WHERE A.RES_CODE = @RES_CODE
		AND A.ROOM_NO = @ROOM_NO 

		SET @ROOM_NO = @ROOM_NO + 1 
	END 


	RETURN
END
GO
