USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ Server					: 211.115.202.230
■ Database					: DIABLO
■ USP_Name					: XP_ASG_EVT_PKG_TC_LIST_SELECT
■ Description				: 
■ Input Parameter			:                  
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						:  
							
XP_ASG_EVT_PKG_TC_LIST_SELECT '','' ,'559','2016-08-01'

■ Author					:  
■ Date						: 
■ Memo						: 인솔자 행사배정 미배정인솔자 해당 상품 리스트
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
  2014-02-03		이동호 			최초생성
  2016-08-24		박형만 			임시로 유럽상품 전부 나오도록 (법인팀 담당 행사때문)
  2019-05-14		이명훈			DEP_DATE >= CONVERT(DATETIME, GETDATE()) => DEP_DATE >= CONVERT(DATE, GETDATE()) 수정
  2020-01-08		김영민			미주/태평양추가
-------------------------------------------------------------------------------------------------*/ 
CREATE PROCEDURE [dbo].[XP_ASG_EVT_PKG_TC_LIST_SELECT]
(      
	@SIGN_CODE VARCHAR(5) ='',  	
	@PRO_CODE VARCHAR(20),  	
	@TEAM_CODE	VARCHAR(7),
	@INDATE	VARCHAR(10)
)
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	DECLARE @SORTING VARCHAR(200), @WHERE VARCHAR(1000), @SQLSTRING NVARCHAR(4000)

	--SET @WHERE = 'AND A.NEW_CODE IN (SELECT EMP_CODE FROM EMP_MASTER WITH(NOLOCK) WHERE TEAM_CODE IN( ''' + @TEAM_CODE + ''',''542'',''''))' --해당팀 , 유럽 슈퍼클래스팀(542) 노출
	-- 유럽팁은 모두 노출
	--SET @WHERE = 'AND A.NEW_CODE IN (SELECT EMP_CODE FROM EMP_MASTER WITH(NOLOCK) WHERE TEAM_CODE IN( ''' + @TEAM_CODE + ''',''542'',''546'',''547'',''548'',''549'',''551'',''552''))' --해당팀 , 유럽 슈퍼클래스팀(542) 노출
	IF(@SIGN_CODE  ='')
	SET @WHERE = 'AND  (B.SIGN_CODE IN (''E'',''U'',''P'')  OR A.NEW_CODE IN (SELECT EMP_CODE FROM EMP_MASTER WITH(NOLOCK) WHERE TEAM_CODE IN( ''' + @TEAM_CODE + ''',''542'',''546'',''547'',''548'',''549'',''551'',''552'',''565'',''569'',''607'',''565'',''610'',''613'')) )' --해당팀 ,전체
	ELSE IF(@SIGN_CODE ='E')
	SET @WHERE = 'AND  (B.SIGN_CODE IN (''E'')  OR A.NEW_CODE IN (SELECT EMP_CODE FROM EMP_MASTER WITH(NOLOCK) WHERE TEAM_CODE IN( ''' + @TEAM_CODE + ''',''542'',''546'',''547'',''548'',''549'',''551'',''552'')) )' --해당팀 , 유럽 슈퍼클래스팀(542) 노출
	ELSE IF(@SIGN_CODE ='P')
	SET @WHERE = 'AND  (B.SIGN_CODE IN (''U'',''P'')  OR A.NEW_CODE IN (SELECT EMP_CODE FROM EMP_MASTER WITH(NOLOCK) WHERE TEAM_CODE IN( ''' + @TEAM_CODE + ''',''565'',''569'',''607'',''565'',''610'',''613'')) )' --해당팀 , 미주/태평양노출

	IF @PRO_CODE != ''
	BEGIN 
		SET @WHERE += ' AND A.PRO_CODE LIKE ''' + @PRO_CODE + '%'''
	END	
	
		SET @SQLSTRING = N'			
				SELECT A.PRO_CODE,A.PRO_NAME
					,(CASE WHEN A.SEAT_CODE = 0 THEN A.DEP_DATE ELSE S.DEP_DEP_DATE END) AS DEP_DATE
					,(CASE WHEN A.SEAT_CODE = 0 THEN A.ARR_DATE ELSE S.ARR_ARR_DATE END) AS ARR_DATE
					,DBO.XN_COM_GET_EMP_NAME(A.NEW_CODE) AS NEW_NAME					
				FROM PKG_DETAIL A WITH(NOLOCK)
					INNER JOIN PKG_MASTER B WITH(NOLOCK) 
						ON A.MASTER_CODE = B.MASTER_CODE 
				LEFT OUTER JOIN dbo.PRO_TRANS_SEAT S WITH(NOLOCK) ON A.SEAT_CODE = S.SEAT_CODE																											
				WHERE DEP_DATE >= CONVERT(DATE, GETDATE()) 
				AND DEP_DATE <= DATEADD(ms,-3,DATEADD(mm, DATEDIFF(m,0, CONVERT(DATETIME, '''+@INDATE+''') )+1, 0)) 
				AND A.TC_YN = ''Y''
				AND (A.TC_CODE IS NULL OR A.TC_CODE = '''')'
				+ @WHERE + ' 
				AND 0 < (SELECT COUNT(C.RES_CODE) FROM dbo.RES_MASTER_damo C WITH(NOLOCK) LEFT OUTER JOIN dbo.RES_CUSTOMER_damo D WITH(NOLOCK) ON C.RES_CODE = D.RES_CODE WHERE C.PRO_CODE = A.PRO_CODE AND C.RES_STATE < 5)
				ORDER BY DEP_DATE ASC'				
 --SELECT @SQLSTRING
 print @SQLSTRING
 EXEC SP_EXECUTESQL @SQLSTRING
END  
GO
