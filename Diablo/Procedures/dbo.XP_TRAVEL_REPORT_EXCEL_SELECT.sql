USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_TRAVEL_REPORT_EXCEL_SELECT
■ DESCRIPTION				: 대외업무시스템 인솔자관리 출장보고서 리스트 검색
■ INPUT PARAMETER			: 
	@PAGE_INDEX  INT		: 현재 페이지
	@PAGE_SIZE  INT			: 한 페이지 표시 게시물 수
	@KEY		VARCHAR(400): 검색 키
	@ORDER_BY	INT			: 정렬 순서
■ OUTPUT PARAMETER			: 
	@TOTAL_COUNT INT OUTPUT	: 총 검색된 수       
■ EXEC						: 
							  EXEC XP_TRAVEL_REPORT_EXCEL_SELECT '4', '2019'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2019-05-07		이명훈			생성	
================================================================================================================*/ 

CREATE PROCEDURE [dbo].[XP_TRAVEL_REPORT_EXCEL_SELECT]
(
	@MM_START VARCHAR(2),
	@YY VARCHAR(5)
)

AS  
BEGIN
	DECLARE @SQLSTRING NVARCHAR(MAX),
			@WHERE NVARCHAR(4000),
			@MM_END VARCHAR(2), 
			@PARMDEFINITION NVARCHAR(1000);
   
	-- WHERE 조건 만들기
	IF @MM_START = '12'
	BEGIN
		SET @MM_END = 1
		SET @YY = @YY + 1
	END
	ELSE
	BEGIN
		SET @MM_END = @MM_START + 1
	END

	SET @YY = @YY + '-'
	SET @WHERE = 'AND C.DEP_DATE >= ''' + @YY + @MM_START +  '-1'' AND C.DEP_DATE < ''' + @YY + @MM_END +  '-1'''

	SET @SQLSTRING = N'
					SELECT A.OTR_SEQ, A.PRO_CODE, A.OTR_STATE, A.REMARK, G.KOR_NAME AS AGT_NAME, A.NEW_CODE, F.KOR_NAME AS MEM_NAME,
						 B.SECTION, B.BEST_WORST, B.SECTION_CODE, B.NAME, B.CLASSIFY, B.REASON,
						 C.DEP_DATE, E.KOR_NAME AS REGION_NAME
					FROM TRAVEL_REPORT_MASTER A
						LEFT JOIN TRAVEL_REPORT_DETAIL B ON A.OTR_SEQ = B.OTR_SEQ
						LEFT JOIN PKG_DETAIL C ON A.PRO_CODE = C.PRO_CODE
						LEFT JOIN PKG_MASTER D ON C.MASTER_CODE = D.MASTER_CODE
						LEFT JOIN PUB_REGION E ON D.SIGN_CODE = E.SIGN
						LEFT JOIN AGT_MEMBER F ON A.NEW_CODE = F.MEM_CODE
						LEFT JOIN AGT_MASTER G ON A.AGT_CODE = G.AGT_CODE
					WHERE OTR_STATE = 3 AND EDI_CODE IS NOT NULL '  + @WHERE

	PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING

END






GO
