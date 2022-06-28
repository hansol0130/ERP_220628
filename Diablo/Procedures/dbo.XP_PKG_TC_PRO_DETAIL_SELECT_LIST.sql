USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*-------------------------------------------------------------------------------------------------
■ Server					: 211.115.202.230
■ Database					: DIABLO
■ USP_Name					: XP_PKG_TC_PRO_DETAIL_SELECT_LIST
■ Description				: 
■ Input Parameter			:                  
	@TC_YN	CHAR(1),
	@NOW_MONTH	VARCHAR(10),
	@TEAM_CODE VARCHAR(4),
	@SORT		VARCHAR(1)
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						:  
							
XP_PKG_TC_PRO_DETAIL_SELECT_LIST '2014-01-01', '501', ''

■ Author					:  
■ Date						: 
■ Memo						: 인솔자 미배정 행사 리스트 조회
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
  2014-01-29			이동호 		신규   
-------------------------------------------------------------------------------------------------*/ 
CREATE PROCEDURE [dbo].[XP_PKG_TC_PRO_DETAIL_SELECT_LIST]
(        
	@NOW_MONTH	VARCHAR(10),
	@TEAM_CODE	VARCHAR(4),
	@PRO_CODE	VARCHAR(12)
)
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	DECLARE @SORTING VARCHAR(200), @WHERE VARCHAR(1000), @SQLSTRING NVARCHAR(4000)

	

	IF @TEAM_CODE != ''
		BEGIN
			SET @WHERE = ' AND A.NEW_CODE IN (SELECT EMP_CODE FROM EMP_MASTER WITH(NOLOCK) WHERE TEAM_CODE = ''' + @TEAM_CODE + ''') '
		END

	IF @PRO_CODE != ''
		BEGIN
			SET @WHERE = ' AND A.PRO_CODE LIKE ''' + @PRO_CODE + '%'''
		END	
		
				SET @SQLSTRING = N'
					SELECT * FROM ( 
						SELECT A.PRO_CODE, A.PRO_NAME
							, (CASE WHEN A.SEAT_CODE = 0 THEN A.DEP_DATE ELSE S.DEP_DEP_DATE END) AS DEP_DATE
							, (CASE WHEN A.SEAT_CODE = 0 THEN A.ARR_DATE ELSE S.ARR_ARR_DATE END) AS ARR_DATE	
							,DBO.XN_COM_GET_TEAM_NAME(A.NEW_CODE) AS TEAM_NAME
							,DBO.XN_COM_GET_EMP_NAME(A.NEW_CODE) AS NEW_NAME							
						,(SELECT COUNT(C.RES_CODE) FROM dbo.RES_MASTER_damo C LEFT OUTER JOIN dbo.RES_CUSTOMER_damo D ON C.RES_CODE = D.RES_CODE WHERE C.PRO_CODE = A.PRO_CODE AND C.RES_STATE < 5) AS CUSTOMER_COUNT
						FROM PKG_DETAIL A
						LEFT OUTER JOIN dbo.PRO_TRANS_SEAT S WITH(NOLOCK) ON A.SEAT_CODE = S.SEAT_CODE								
						WHERE A.TC_YN = ''Y'' 
						AND DEP_DATE > GETDATE() 
						AND DEP_DATE <= DATEADD(ms,-3,DATEADD(mm, DATEDIFF(m,0, GETDATE() )+1, 0)) 
						AND A.TC_CODE IS NULL'
						+ @WHERE + ' ) A 										
					WHERE CUSTOMER_COUNT > 0'
	


 print @SQLSTRING
 EXEC SP_EXECUTESQL @SQLSTRING
END  


 
GO
