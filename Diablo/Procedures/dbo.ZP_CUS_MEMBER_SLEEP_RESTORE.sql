USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: ZP_CUS_MEMBER_SLEEP_RESTORE
■ DESCRIPTION				: 휴면 대상 고객 회원으로 복구
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC DIABLO.DBO.ZP_CUS_MEMBER_SLEEP_RESTORE 

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2021-01-19		김영민			최초생성 POINT_TYPE(
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_CUS_MEMBER_SLEEP_RESTORE]
AS
BEGIN
		DECLARE
				@TODAY DATE = CONVERT(DATE, GETDATE()),		-- 오늘 YYYY-MM-DD 00:00:00
				@CUS_NO INT								    -- 고객번호

	DECLARE USER_CURSOR CURSOR FOR
		-- 휴면회원 대상자 조회
		SELECT CUS_NO  FROM (
     	SELECT A.CUS_NO
		FROM DIABLO.DBO.CUS_MEMBER_SLEEP A WITH(NOLOCK)
		WHERE A.CUS_NO IN ( --포인트 이력 History안봄
					SELECT  CUS_NO FROM   CUS_POINT  WHERE NEW_DATE  >    DATEADD(DAY, -365, @TODAY)
					AND NEW_DATE  < DATEADD(DD, 1, @TODAY)  AND POINT_NO  NOT IN  (
					SELECT  CUS_POINT.POINT_NO
					FROM CUS_POINT  WHERE POINT_TYPE  = '2' AND ACC_USE_TYPE = '2') 
					GROUP BY CUS_NO)
		UNION ALL
		SELECT A.CUS_NO
		FROM DIABLO.DBO.CUS_MEMBER_SLEEP A WITH(NOLOCK)
		WHERE A.CUS_NO IN (--상담이력
					SELECT  CUS_NO FROM SIRENS.CTI.CTI_CONSULT  WHERE CONSULT_DATE > DATEADD(DAY, -365, @TODAY) AND
					CONSULT_DATE < DATEADD(DD, 1, @TODAY)  
					GROUP BY SIRENS.CTI.CTI_CONSULT.CUS_NO)
		UNION ALL
     	SELECT A.CUS_NO
		FROM DIABLO.DBO.CUS_MEMBER_SLEEP A WITH(NOLOCK)
		WHERE A.CUS_NO IN (--출발이력(결재완료건)
						SELECT A.CUS_NO FROM RES_CUSTOMER_DAMO A  JOIN 
						RES_MASTER B ON A.RES_CODE = B.RES_CODE 
						WHERE B.DEP_DATE >  DATEADD(DAY, -365, @TODAY) 
						AND B.DEP_DATE + 1 < DATEADD(DD, 1, @TODAY) AND B.RES_STATE  IN('4') GROUP BY A.CUS_NO)
		)G  GROUP BY G.CUS_NO

	OPEN USER_CURSOR

	FETCH NEXT FROM USER_CURSOR	INTO @CUS_NO

	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- 휴면회원 => 회원전환
		EXEC DBO.XP_CUS_MEMBER_SLEEP_INSERT @CUS_NO, 2--휴면복구타입(2)

		FETCH NEXT FROM USER_CURSOR	INTO @CUS_NO
	END

	CLOSE USER_CURSOR
	DEALLOCATE USER_CURSOR
	
END
GO
