USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: [XP_CUS_RECOMMEND_POINT_SELECT_LIST]
■ DESCRIPTION				: 추천인 제도 포인트 지급현황 내역 
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 

DECLARE @TOTAL_COUNT INT 
EXEC XP_CUS_RECOMMEND_POINT_SELECT_LIST -1 , '2018-11-01', '2018-11-20' , '' , '','','' , ''
, 0 , 3 , 2, @TOTAL_COUNT  OUTPUT 
SELECT  @TOTAL_COUNT 


DECLARE @TOTAL_COUNT INT 
EXEC XP_CUS_RECOMMEND_POINT_SELECT_LIST 0 , '2018-11-01', '2018-11-20' , '' , '','','' , ''
, 0 , 3 , 2, @TOTAL_COUNT  OUTPUT 
SELECT  @TOTAL_COUNT 





■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2018-11-07		박형만			최초생성
================================================================================================================*/ 
create  PROC [dbo].[XP_CUS_RECOMMEND_POINT_SELECT_LIST]
	@CUS_TYPE INT ,  --0:전체 , 1:가입자,2:추천인
	@START_DATE VARCHAR(10),
	@END_DATE VARCHAR(10),
	@CUS_NAME VARCHAR(20),  --고객명 
	@NOR_TEL1 VARCHAR(3),
	@NOR_TEL2 VARCHAR(4),
	@NOR_TEL3 VARCHAR(4),
	@RES_CODE RES_CODE,
	@CUS_NO INT  , 
	@PAGE_SIZE INT ,
	@PAGE_INDEX INT,
	@TOTAL_COUNT INT OUTPUT 
AS 
BEGIN 

--DECLARE @TOTAL_COUNT INT 
--DECLARE 
--	@CUS_TYPE INT , --0:전체 , 1:가입자,2:추천인
--	@START_DATE VARCHAR(10),
--	@END_DATE VARCHAR(10),
--	@CUS_NAME VARCHAR(20),  --고객명 
--	@NOR_TEL1 VARCHAR(3),
--	@NOR_TEL2 VARCHAR(4),
--	@NOR_TEL3 VARCHAR(4),
--	@CUS_NO INT  , 
--	@PAGE_SIZE INT ,
--	@PAGE_INDEX INT
	

--SELECT @CUS_TYPE = -1 ,
--	@START_DATE = '2018-11-01' ,
--	@END_DATE  = '2018-11-21',
--	@CUS_NAME = '',  --고객명 
--	@NOR_TEL1 ='',
--	@NOR_TEL2 ='',
--	@NOR_TEL3 ='',
--	@CUS_NO =0 , 
--	@PAGE_SIZE = 3 ,
--	@PAGE_INDEX = 2 

	 
DECLARE @SQLSTRING NVARCHAR(4000)
DECLARE @WHERE NVARCHAR(1000)
DECLARE @PARMDEFINITION NVARCHAR(1000)
SET @WHERE = 'WHERE 1=1 '


	-- 고유번호가 오게 되면 
	-- 해당 고유번호의 모든 내역 출력 
	IF( @CUS_NO > 0 ) 
	BEGIN
		SET @WHERE = @WHERE + ' AND A.CUS_NO = @CUS_NO  ' 
	END 
	ELSE  -- 그외 
	BEGIN

		IF( ISNULL(@START_DATE,'') <> '')
		BEGIN
			SET @WHERE = @WHERE + ' AND A.NEW_DATE >= CONVERT(DATETIME,@START_DATE) ' 	
		END 
		IF( ISNULL(@END_DATE,'') <> '')
		BEGIN
			SET @WHERE = @WHERE + ' AND A.NEW_DATE < DATEADD(DD,1,CONVERT(DATETIME,@END_DATE)) ' 
		END 

		IF( @CUS_TYPE > 0  )
		BEGIN
			SET @WHERE = @WHERE + ' AND A.CUS_TYPE =  '+ CONVERT(VARCHAR,@CUS_TYPE)+' ' 
		END 

		IF( ISNULL(@CUS_NAME,'') <> ''  )
		BEGIN
			SET @WHERE = @WHERE + ' AND B.CUS_NAME = @CUS_NAME  ' 
		END 

		IF( ISNULL(@NOR_TEL1,'') <> ''  )
		BEGIN
			SET @WHERE = @WHERE + ' AND B.NOR_TEL1 = @NOR_TEL1  ' 
		END 
		IF( ISNULL(@NOR_TEL2,'') <> ''  )
		BEGIN
			SET @WHERE = @WHERE + ' AND B.NOR_TEL2 = @NOR_TEL2  ' 
		END 
		IF( ISNULL(@NOR_TEL3,'') <> ''  )
		BEGIN
			SET @WHERE = @WHERE + ' AND B.NOR_TEL3 = @NOR_TEL3  ' 
		END 


		IF( ISNULL(@RES_CODE,'') <> ''  )
		BEGIN
			SET @WHERE = @WHERE + ' AND C.RES_CODE = @RES_CODE  ' 
		END 
	
		SET @SQLSTRING = N'
-- 전체 게시물 수
SELECT @TOTAL_COUNT = COUNT(*)
FROM CUS_RECOMMEND A WITH(NOLOCK) 
	LEFT JOIN VIEW_MEMBER B 
		ON A.CUS_NO = B.CUS_NO 
	LEFT JOIN CUS_POINT C 
		ON A.POINT_NO  = C.POINT_NO 
' + @WHERE + N';
WITH LIST AS
(
	SELECT 
		ROW_NUMBER() OVER (ORDER BY A.REC_SEQ) AS [ROWNUMBER],
		A.REC_SEQ,A.REC_GRP_SEQ,A.CUS_TYPE,A.REC_TYPE,
		A.CUS_NO,A.POINT_NO,A.NEW_CODE,A.NEW_DATE,A.REMARK , 
		B.CUS_ID , 
		B.CUS_NAME , B.BIRTH_DATE, B.NOR_TEL1, B.NOR_TEL2, B.NOR_TEL3, 
		C.POINT_PRICE 
	FROM CUS_RECOMMEND A WITH(NOLOCK) 
		LEFT JOIN VIEW_MEMBER B 
			ON A.CUS_NO = B.CUS_NO 
		LEFT JOIN CUS_POINT C 
			ON A.POINT_NO  = C.POINT_NO 
	' + @WHERE + N'
	ORDER BY A.REC_SEQ ASC
	OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
	ROWS ONLY
)
SELECT * 
FROM LIST Z 
ORDER BY REC_SEQ ;

SELECT SUM(POINT_PRICE) AS TOTAL_POINT
FROM CUS_RECOMMEND A WITH(NOLOCK) 
	LEFT JOIN VIEW_MEMBER B 
		ON A.CUS_NO = B.CUS_NO 
	LEFT JOIN CUS_POINT C 
		ON A.POINT_NO  = C.POINT_NO 
' + @WHERE + N';
'  
		SET @PARMDEFINITION = N'
		@PAGE_INDEX INT,
		@PAGE_SIZE INT,
		@TOTAL_COUNT INT OUTPUT,
		@START_DATE VARCHAR(10),
		@END_DATE VARCHAR(10),
		@CUS_NAME VARCHAR(20),
		@NOR_TEL1 VARCHAR(3),
		@NOR_TEL2 VARCHAR(4),
		@NOR_TEL3 VARCHAR(4),
		@RES_CODE VARCHAR(12),
		@CUS_NO INT '

		--PRINT @SQLSTRING
		
		EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
		@PAGE_INDEX,
		@PAGE_SIZE,
		@TOTAL_COUNT OUTPUT,
		@START_DATE,
		@END_DATE,
		@CUS_NAME,
		@NOR_TEL1,
		@NOR_TEL2,
		@NOR_TEL3,
		@RES_CODE,
		@CUS_NO 
	END 

END 
GO
