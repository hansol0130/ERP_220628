USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: XP_ASG_EVT_REPORT_LIST_SELECT_3
■ DESCRIPTION				: 대외업무시스템 인솔자관리 출장보고서 리스트 검색(내부 인솔자별 리스트)
■ INPUT PARAMETER			: 
	@EMP_CODE	CHAR(7)     : 인솔자 코드
	@ORDER_BY	INT			: 정렬 순서
■ OUTPUT PARAMETER			: 
	       
■ EXEC						: 
	DECLARE  
	@EMP_CODE	CHAR(7),
	@ORDER_BY	INT

	SELECT @EMP_CODE='T130114',@ORDER_BY=2

	exec XP_ASG_EVT_REPORT_LIST_SELECT_3 @EMP_CODE, @order_by
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-20		이상일			최초생성
   2019-04-30		이명훈			OTR_MASTER => TRAVEL_REPORT_MASTER   
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_ASG_EVT_REPORT_LIST_SELECT_3]
(
	@EMP_CODE	CHAR(7),
	@ORDER_BY	INT
)

AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @SQLSTRING NVARCHAR(MAX), @PARMDEFINITION NVARCHAR(1000);
	DECLARE @WHERE NVARCHAR(4000),@ORDER NVARCHAR(4000);


	SELECT
		@WHERE = '',
		@ORDER = ' A.DEP_DATE DESC'

   
	-- WHERE 조건 만들기	
	IF ISNULL(@EMP_CODE, '') <> '' -- 인솔자 코드
		SET @WHERE =@WHERE + ' AND A.TC_CODE = ''' + @EMP_CODE + ''' '   


	--ORDER BY 조건 만들기

	IF @ORDER_BY = 1 -- 작성여부
		SET @ORDER = ' V.OTR_STATE  '
	IF  @ORDER_BY = 2 -- 출발일
		SET @ORDER = ' A.DEP_DATE DESC '
	IF  @ORDER_BY = 3 -- 담당자명
		SET @ORDER = ' DBO.XN_COM_GET_EMP_NAME(A.NEW_CODE)   '
	IF  @ORDER_BY = 4 -- 지역
		SET @ORDER = ' X.KOR_NAME  '



	--상태 -- 0 예정:해당인솔자에게 배정되고 출발일이 지나지 않은 행사 --1 완료: 해당인솔자에게 배정되고 출발이 지난행사

	SET @SQLSTRING = N'
				SELECT   X.KOR_NAME AS SIGN_KOR_NAME 
				        ,Y.SIGN_CODE -- 지역
						,A.DEP_DATE --출발일
						,A.PRO_CODE --행사코드
						,A.PRO_NAME --행사명
						,A.TOUR_NIGHT --박
						,A.TOUR_DAY -- 일
						,(SELECT COUNT(B.RES_CODE) FROM dbo.Res_master_damo B
						LEFT OUTER JOIN dbo.RES_CUSTOMER_damo C ON B.RES_CODE = C.RES_CODE
						WHERE B.PRO_CODE = A.PRO_CODE AND C.RES_STATE = 0) AS RESCUSTOMERCOUNT--예약자수
						,DBO.XN_COM_GET_EMP_NAME(A.NEW_CODE) AS NEW_NAME--담당자
						,ISNULL(V.OTR_STATE , ''0'') AS REPORT_STATE -- 보고서 상태 
						,CASE WHEN DATEDIFF(DAY,GETDATE(),A.DEP_DATE) <0 THEN 1 
						WHEN GETDATE() BETWEEN A.DEP_DATE AND A.ARR_DATE THEN 3
						ELSE 2 END AS RES_STATE --상태
						,V.EDI_CODE 
						,DBO.XN_COM_GET_EMP_NAME(A.TC_CODE) AS ASSIGN_NAME -- 인솔자
						,V.OTR_SEQ
				FROM dbo.PKG_DETAIL A 
				INNER JOIN dbo.PKG_MASTER Y ON A.MASTER_CODE = Y.MASTER_CODE
				LEFT OUTER JOIN dbo.PUB_REGION X ON Y.SIGN_CODE = X.SIGN
				LEFT OUTER JOIN dbo.TRAVEL_REPORT_MASTER V ON A.PRO_CODE = V.PRO_CODE
				WHERE A.TC_ASSIGN_YN =''Y'' '+ @WHERE + '
				ORDER BY ' + @ORDER


	SET @PARMDEFINITION = N'@EMP_CODE CHAR(7)';

	--PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @EMP_CODE;

END



GO
