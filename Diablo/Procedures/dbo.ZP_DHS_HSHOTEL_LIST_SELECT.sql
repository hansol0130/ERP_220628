USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME						: ZP_DHS_HSHOTEL_LIST_SELECT
■ DESCRIPTION					: 조회_홈쇼핑호텔_리스트
■ INPUT PARAMETER				: 
■ OUTPUT PARAMETER			    :
■ EXEC						    :
■ MEMO						    : 

DECLARE @p12 INT
SET @p12 = NULL
EXEC ZP_DHS_HSHOTEL_LIST_SELECT @MASTER_CODE = 'XPP1112'
    ,@CODE_TYPE = 3
    ,@SEARCH_CODE = ''
    ,@RES_NAME = ''
    ,@DATE_TYPE = 1
    ,@START_DATE = '2022-01-10 00:00:00'
    ,@END_DATE = '2022-01-25 00:00:00'
    ,@RES_STATE = 10
    ,@BIT_CODE = '0'
    ,@PAGE_INDEX = 1
    ,@PAGE_SIZE = 10
    ,@TOTAL_COUNT = @p12 OUTPUT

SELECT @p12
GO

------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2022-01-18		오준혁			최초생성
   2022-02-10		김성호			추가금액 조회 컬럼 변경 (PKG_MASTER_PRICE -> PKG_DETAIL_PRICE)
   2022-02-10		오준혁			예약자명 또는 휴대폰 뒷번호로 조회 조건 추가
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_DHS_HSHOTEL_LIST_SELECT]
	 @MASTER_CODE     VARCHAR(10) = ''
    ,@CODE_TYPE       INT = 1 -- 1:예약코드, 2:홈쇼핑코드, 3:호텔예약코드
    ,@SEARCH_CODE     VARCHAR(20) = ''
    ,@CUS_SEARCH_TYPE VARCHAR(20) = 'CusName'
    ,@RES_NAME        VARCHAR(20) = ''
    ,@DATE_TYPE       INT = 0 -- 0:조회안함, 1:예약일, 2:체크인날짜
    ,@START_DATE      DATETIME
    ,@END_DATE        DATETIME
    ,@RES_STATE       INT = 10 -- 10:전체, 0:접수, 1:확인중, 2:예약확정, 4:결제완료, 5:출발완료, 9:취소
    ,@BIT_CODE        VARCHAR(4) = '0'
    
    ,@PAGE_INDEX      INT
    ,@PAGE_SIZE       INT
    ,@TOTAL_COUNT     INT OUTPUT
AS 
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	-- 예약상태, 예약코드, 예약일, 예약자, 인원, 상품명, 체크인, 예약문자발송일자, 확정문자발송일자, 호텔예약코드, 담당자
	SELECT RM.MASTER_CODE
	      ,PM.MASTER_NAME
	      ,RM.RES_STATE
	      ,RM.RES_CODE
	      ,FORMAT(RM.NEW_DATE ,'yy-MM-dd') AS 'NEW_DATE'
	      ,RM.RES_NAME
	      ,RM.NOR_TEL1 + '-' + RM.NOR_TEL2 + '-' + RM.NOR_TEL3 AS 'NOR_TEL'
	      ,RM.PNR_INFO
	      ,RM.PRO_CODE
	      ,RM.PRO_NAME
	      ,FORMAT(RM.DEP_DATE ,'yy-MM-dd') AS 'DEP_DATE'
	      ,RM.CUS_REQUEST -- 고객 요청사항
	      ,RM.SENDING_REMARK -- 담당자 메모
	      ,FORMAT(RDD.RES_TALK_SEND ,'yy-MM-dd HH:mm') AS 'RES_TALK_SEND' -- 예약문자 발송일시
	      ,FORMAT(RDD.CFM_TALK_SEND ,'yy-MM-dd HH:mm') AS 'CFM_TALK_SEND' -- 확정문자 발송일시
	      ,RDD.CFM_CODE
	      ,EM.KOR_NAME AS [NEW_NAME]
	      ,CONVERT(INT ,SUBSTRING(RM.PRO_CODE ,(CHARINDEX('-' ,RM.PRO_CODE) + 7) ,4)) AS [BIT_CODE]
	      ,PDP.SGL_PRICE
	FROM   dbo.RES_MASTER_damo RM
	       INNER JOIN dbo.RES_DHS_DETAIL RDD
	            ON  RM.RES_CODE = RDD.RES_CODE
	       INNER JOIN dbo.EMP_MASTER_damo EM
	            ON  RM.NEW_CODE = EM.EMP_CODE
	       INNER JOIN dbo.PKG_MASTER PM
	            ON  RM.MASTER_CODE = PM.MASTER_CODE
	       LEFT JOIN dbo.PKG_DETAIL_PRICE PDP
	            ON  RM.PRO_CODE = PDP.PRO_CODE
	                AND RM.PRICE_SEQ = PDP.PRICE_SEQ
	WHERE  RM.MASTER_CODE = @MASTER_CODE -- 항상 검색
	       AND (CASE 
	                 WHEN @RES_STATE = 10 THEN 1
	                 WHEN RM.RES_STATE = @RES_STATE THEN 1
	                 ELSE 0
	            END) = 1
	       AND (CASE 
	                 WHEN ISNULL(@SEARCH_CODE ,'') = '' THEN 1
	                 WHEN @CODE_TYPE = 1 AND RM.RES_CODE = @SEARCH_CODE THEN 1
	                 WHEN @CODE_TYPE = 2 AND RDD.DHS_RES_CODE = @SEARCH_CODE THEN 1
	                 WHEN @CODE_TYPE = 3 AND RDD.CFM_CODE = @SEARCH_CODE THEN 1
	                 ELSE 0
	            END) = 1
	       AND (CASE 
	                 WHEN @DATE_TYPE = 0 THEN 1
	                 WHEN @DATE_TYPE = 1 AND RM.NEW_DATE >= @START_DATE AND RM.NEW_DATE < @END_DATE THEN 1
	                 WHEN @DATE_TYPE = 2 AND RM.DEP_DATE >= @START_DATE AND RM.DEP_DATE < @END_DATE THEN 1
	                 ELSE 0
	            END) = 1
	       AND (CASE 
	                 WHEN ISNULL(@RES_NAME ,'') = '' THEN 1
	                 WHEN ISNULL(@CUS_SEARCH_TYPE,'CusName') = 'CusName' AND RM.RES_NAME LIKE '%' + @RES_NAME + '%' THEN 1
	                 WHEN ISNULL(@CUS_SEARCH_TYPE,'') = 'HPNo' AND RM.NOR_TEL3 = @RES_NAME THEN 1
	                 ELSE 0
	            END) = 1
	       AND (CASE 
	                 WHEN @BIT_CODE = '0' THEN 1
	                 WHEN RM.PRO_CODE LIKE(@MASTER_CODE + '-______' + @BIT_CODE) THEN 1
	                 ELSE 0
	            END) = 1
	ORDER BY
	       RM.RES_CODE
	       OFFSET((@PAGE_INDEX -1) * @PAGE_SIZE) ROWS
	
	FETCH NEXT @PAGE_SIZE ROWS ONLY
	
	
	
	;WITH CTE_LIST_TOTAL AS (
	    SELECT COUNT(1) AS 'TOTAL'
	    FROM   dbo.RES_MASTER_damo RM
	           INNER JOIN dbo.RES_DHS_DETAIL RDD
	                ON  RM.RES_CODE = RDD.RES_CODE
	           INNER JOIN dbo.EMP_MASTER_damo EM
	                ON  RM.NEW_CODE = EM.EMP_CODE
	    WHERE  RM.MASTER_CODE = @MASTER_CODE -- 항상 검색
	           AND (CASE 
	                     WHEN @RES_STATE = 10 THEN 1
	                     WHEN RM.RES_STATE = @RES_STATE THEN 1
	                     ELSE 0
	                END) = 1
	           AND (CASE 
	                     WHEN ISNULL(@SEARCH_CODE ,'') = '' THEN 1
	                     WHEN @CODE_TYPE = 1 AND RM.RES_CODE = @SEARCH_CODE THEN 1
	                     WHEN @CODE_TYPE = 2 AND RDD.DHS_RES_CODE = @SEARCH_CODE THEN 1
	                     WHEN @CODE_TYPE = 3 AND RDD.CFM_CODE = @SEARCH_CODE THEN 1
	                     ELSE 0
	                END) = 1
	           AND (CASE 
	                     WHEN @DATE_TYPE = 0 THEN 1
	                     WHEN @DATE_TYPE = 1 AND RM.NEW_DATE >= @START_DATE AND RM.NEW_DATE < @END_DATE THEN 1
	                     WHEN @DATE_TYPE = 2 AND RM.DEP_DATE >= @START_DATE AND RM.DEP_DATE < @END_DATE THEN 1
	                     ELSE 0
	                END) = 1
	           AND (CASE 
	                     WHEN ISNULL(@RES_NAME ,'') = '' THEN 1
						 WHEN ISNULL(@CUS_SEARCH_TYPE,'CusName') = 'CusName' AND RM.RES_NAME LIKE '%' + @RES_NAME + '%' THEN 1
						 WHEN ISNULL(@CUS_SEARCH_TYPE,'') = 'HPNo' AND RM.NOR_TEL3 = @RES_NAME THEN 1
	                     ELSE 0
	                END) = 1
	           AND (CASE 
	                     WHEN @BIT_CODE = '0' THEN 1
	                     WHEN RM.PRO_CODE LIKE(@MASTER_CODE + '-______' + @BIT_CODE) THEN 1
	                     ELSE 0
	                END) = 1
	)
	
	-- Total
	SELECT @TOTAL_COUNT = TOTAL
	FROM   CTE_LIST_TOTAL;
END
GO
