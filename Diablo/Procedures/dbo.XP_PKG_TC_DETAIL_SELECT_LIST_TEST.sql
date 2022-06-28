USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Server					: 211.115.202.230
■ Database					: DIABLO
■ USP_Name					: XP_PKG_TC_DETAIL_SELECT_LIST
■ Description				: 
■ Input Parameter			:                  
	@TC_YN	CHAR(1),
	@NOW_MONTH	VARCHAR(10),
	@TEAM_CODE VARCHAR(4),
	@SORT		VARCHAR(1)
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						:  
							
XP_PKG_TC_DETAIL_SELECT_LIST 'Y' ,'2014-01-01', '5239', '', '', '','1'

CPP225-140114#2014-01-14|2014-01-18,
MPP980-140131#2014-01-31|2014-02-07

exec XP_PKG_TC_DETAIL_SELECT_LIST_TEST @TC_YN=N'Y',@NOW_MONTH=N'2014-07-01',@TEAM_CODE=N'546',@EMP_CODE=N'2004032',@SORT=NULL,@ASSIGN_YN=N'',@TYPE=N'2'

■ Author					:  
■ Date						: 
■ Memo						: 배정/미배정 행사 조회
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
  2013-04-24			이상일 			  최초생성  
  2014-01-28			이동호 			  인졸자기준 추가   
-------------------------------------------------------------------------------------------------*/ 
CREATE PROCEDURE [dbo].[XP_PKG_TC_DETAIL_SELECT_LIST_TEST]
(        
	@TC_YN		CHAR(1),
	@NOW_MONTH	VARCHAR(10),
	@TEAM_CODE	VARCHAR(4),
	@EMP_CODE	VARCHAR(7),
	@SORT		VARCHAR(1), -- 정렬 (배정 : NULL, 미배정: 1, 이름:2, 아이디:3)
	@ASSIGN_YN  VARCHAR(1),
	@TYPE  CHAR(1) --인솔자기준: 1, 출발일 기준: 2
)
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	DECLARE @SORTING VARCHAR(200), @WHERE VARCHAR(1000), @SQLSTRING NVARCHAR(4000)

	IF @TYPE = '2' 
	BEGIN 

			IF @SORT = '1'
				BEGIN 			
					 SET @SORTING = ' ISNULL(A.TC_ASSIGN_YN, ''N'') ASC'
			END
			ELSE IF @SORT = '2' 
				BEGIN
					SET @SORTING = ' ISNULL(A.TC_ASSIGN_YN, ''N'') DESC, A.TC_NAME ASC '
			END
			ELSE IF @SORT = '3' 
				BEGIN
					SET @SORTING = ' ISNULL(A.TC_ASSIGN_YN, ''N'') DESC, MEM_CODE DESC'
			END
			ELSE
				BEGIN
					SET @SORTING = ' ISNULL(A.TC_ASSIGN_YN, ''N'') DESC'
			END

			IF @EMP_CODE = ''
				BEGIN
					SET @WHERE = ' AND AA.NEW_CODE IN (SELECT EMP_CODE FROM EMP_MASTER WITH(NOLOCK) WHERE TEAM_CODE = ''' + @TEAM_CODE + ''') '
				END
			ELSE
				BEGIN
					SET @WHERE = ' AND A.NEW_CODE = ''' + @EMP_CODE + ''' '
				END

	END
	ELSE
	BEGIN

			IF @SORT = '1'
				BEGIN 			
					 SET @SORTING = ' PKG_DATE ASC '
			END
			ELSE IF @SORT = '2' 
				BEGIN
					SET @SORTING = ' KOR_NAME ASC'
			END
			ELSE IF @SORT = '3' 
				BEGIN
					SET @SORTING = ' MEM_CODE DESC'
			END
			ELSE
				BEGIN
					SET @SORTING = ' PKG_DATE DESC '
			END

			IF @EMP_CODE = ''
				BEGIN
					SET @WHERE = ' AND A.NEW_CODE IN (SELECT EMP_CODE FROM EMP_MASTER WITH(NOLOCK) WHERE TEAM_CODE = ''' + @TEAM_CODE + ''') '
				END
			ELSE
				BEGIN
					SET @WHERE = ' AND A.NEW_CODE = ''' + @EMP_CODE + ''' '
				END
	END 


	IF @ASSIGN_YN != ''
		BEGIN
			IF @ASSIGN_YN = 'Y'
				BEGIN
					SET @WHERE += ' AND A.TC_ASSIGN_YN = ''Y'' '
				END
			ELSE
				BEGIN
					SET @WHERE += ' AND A.TC_ASSIGN_YN != ''Y'' '
				END
		END
	
	IF @TYPE = '2' 
	BEGIN 
		SET @SQLSTRING = N'				
				WITH LIST AS
				(
					SELECT B.MEM_CODE, B.AGT_CODE, B.MEM_TYPE, B.WORK_TYPE,B.KOR_NAME, B.GENDER, B.BIRTH_DATE, B.NEW_CODE, B.AGT_GRADE
					, B.HP_NUMBER1 , B.HP_NUMBER2 , B.HP_NUMBER3
					FROM AGT_MASTER A WITH(NOLOCK)
					INNER JOIN AGT_MEMBER B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE
					WHERE AGT_TYPE_CODE = 30 AND B.WORK_TYPE = ''1'' 
				)		
				SELECT * FROM (		
					SELECT 
							B.PRO_CODE
							, CONVERT(VARCHAR(10),(SELECT COUNT(C.RES_CODE) FROM dbo.RES_MASTER_damo C LEFT OUTER JOIN dbo.RES_CUSTOMER_damo D ON C.RES_CODE = D.RES_CODE WHERE C.PRO_CODE = B.PRO_CODE AND C.RES_STATE < 5)) AS CUSTOMER_COUNT
							, B.PRO_NAME
							, ISNULL(A.KOR_NAME, '''') AS TC_NAME
							, B.TC_ASSIGN_YN
							, (CASE WHEN B.SEAT_CODE = 0 THEN B.DEP_DATE ELSE B.DEP_DEP_DATE END) AS ''DEP_DATE''
							, (CASE WHEN B.SEAT_CODE = 0 THEN B.ARR_DATE ELSE B.ARR_ARR_DATE END) AS ''ARR_DATE''	
							, DATEDIFF(DAY, (CASE WHEN B.SEAT_CODE = 0 THEN B.DEP_DATE ELSE B.DEP_DEP_DATE END), (CASE WHEN B.SEAT_CODE = 0 THEN B.ARR_DATE ELSE B.ARR_ARR_DATE END)) + 1 AS DATES
							, DBO.XN_COM_GET_TEAM_NAME(A.NEW_CODE) AS TEAM_NAME
							, DBO.XN_COM_GET_EMP_NAME(A.NEW_CODE) AS NEW_NAME
							, ISNULL(A.AGT_GRADE, '''') AS AGT_GRADE, A.MEM_CODE AS TC_CODE, A.GENDER, A.BIRTH_DATE, A.NEW_CODE		
					FROM LIST A
					LEFT OUTER JOIN (
						SELECT 
							A.PRO_CODE, A.PRO_NAME, A.TC_ASSIGN_YN, A.SEAT_CODE, A.DEP_DATE, B.DEP_DEP_DATE, A.ARR_DATE, B.ARR_ARR_DATE, A.TC_CODE
						FROM PKG_DETAIL A WITH(NOLOCK)
						LEFT OUTER JOIN PRO_TRANS_SEAT B WITH(NOLOCK) ON A.SEAT_CODE = B.SEAT_CODE
						WHERE A.TC_YN = ''Y''
								AND CONVERT(CHAR(10), (CASE WHEN A.SEAT_CODE = 0 THEN A.DEP_DATE ELSE B.DEP_DEP_DATE END), 126) >= ''' + @NOW_MONTH + '''
								AND CONVERT(CHAR(10), (CASE WHEN A.SEAT_CODE = 0 THEN A.DEP_DATE ELSE B.DEP_DEP_DATE END), 126) <= DATEADD(ms,-3,DATEADD(mm, DATEDIFF(m,0, CONVERT(DATETIME, ''' + @NOW_MONTH + ''') )+1, 0)) 
								AND TC_CODE IS NOT NULL
					) B ON A.MEM_CODE = B.TC_CODE
				) A WHERE 1 = 1 '+ @WHERE +' ORDER BY DEP_DATE ASC'
	END
	ELSE
	BEGIN
			SET @SQLSTRING = N'
					WITH LIST AS
					(
						SELECT B.MEM_CODE, B.AGT_CODE, B.MEM_TYPE, B.WORK_TYPE,B.KOR_NAME, B.GENDER, B.BIRTH_DATE, B.NEW_CODE, B.AGT_GRADE
						, B.HP_NUMBER1 , B.HP_NUMBER2 , B.HP_NUMBER3
						FROM AGT_MASTER A WITH(NOLOCK)
						INNER JOIN AGT_MEMBER B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE
						WHERE AGT_TYPE_CODE = 30 AND B.WORK_TYPE = ''1'' 
					)
						SELECT 
						A.MEM_CODE AS ''TC_CODE'', A.AGT_CODE, A.MEM_TYPE, A.WORK_TYPE, A.KOR_NAME AS ''TC_NAME'', A.GENDER, A.BIRTH_DATE, A.NEW_CODE, A.AGT_GRADE
						, A.HP_NUMBER1, A.HP_NUMBER2, A.HP_NUMBER3
						,STUFF((
								SELECT ('','' 
									+  CONVERT(VARCHAR(10),(SELECT COUNT(C.RES_CODE) FROM dbo.RES_MASTER_damo C LEFT OUTER JOIN dbo.RES_CUSTOMER_damo D ON C.RES_CODE = D.RES_CODE WHERE C.PRO_CODE = P.PRO_CODE AND C.RES_STATE < 5)) 
									+ ''여행기간:'' + CONVERT(VARCHAR(10),DATEDIFF(day, (CASE WHEN P.SEAT_CODE = 0 THEN P.DEP_DATE ELSE S.DEP_DEP_DATE END), (CASE WHEN P.SEAT_CODE = 0 THEN P.ARR_DATE ELSE S.ARR_ARR_DATE END)) + 1)
									+ ''행사코드:'' + PRO_CODE 
									+ ''출발일:'' + CONVERT(CHAR(10), (CASE WHEN P.SEAT_CODE = 0 THEN P.DEP_DATE ELSE S.DEP_DEP_DATE END), 126) 
									+ ''도착일:'' + CONVERT(CHAR(10), (CASE WHEN P.SEAT_CODE = 0 THEN P.ARR_DATE ELSE S.ARR_ARR_DATE END),126)									
									)  AS [text()]								
								FROM PKG_DETAIL P WITH(NOLOCK) 
								LEFT OUTER JOIN dbo.PRO_TRANS_SEAT S WITH(NOLOCK) ON P.SEAT_CODE = S.SEAT_CODE
								WHERE P.TC_CODE = A.MEM_CODE 
											AND  P.TC_YN = ''Y'' 
											AND CONVERT(CHAR(10), (CASE WHEN P.SEAT_CODE = 0 THEN P.DEP_DATE ELSE S.DEP_DEP_DATE END), 126) >= ''' + @NOW_MONTH + '''
											AND CONVERT(CHAR(10), (CASE WHEN P.SEAT_CODE = 0 THEN P.DEP_DATE ELSE S.DEP_DEP_DATE END), 126) <= DATEADD(ms,-3,DATEADD(mm, DATEDIFF(m,0, CONVERT(DATETIME, ''' + @NOW_MONTH + ''') )+1, 0)) 
								 ORDER BY (CASE WHEN P.SEAT_CODE = 0 THEN P.DEP_DATE ELSE S.DEP_DEP_DATE END) ASC
								 FOR XML PATH('''') ), 1, 1, '''') AS PKG_DATE		 									
						FROM LIST A WHERE 1=1 ' + @WHERE						
						+ 'ORDER BY '
						+ @SORTING	
	END 

 --SELECT 	@SQLSTRING;
 print @SQLSTRING
 EXEC SP_EXECUTESQL @SQLSTRING
END  



GO
