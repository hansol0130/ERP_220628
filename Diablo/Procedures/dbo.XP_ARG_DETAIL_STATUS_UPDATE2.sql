USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_ARG_DETAIL_STATUS_UPDATE2
■ DESCRIPTION				: 수배현황상세 상태 업데이트2 - 전자결제 
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	DECLARE @EDI_CODE INT ,
	        @ARG_DETAIL_STATUS INT

	SET @EDI_CODE = '1311219818'
	SET @ARG_DETAIL_STATUS = 3

	EXEC DBO.XP_ARG_DETAIL_STATUS_UPDATE2 @ARG_SEQ_NO, @GRP_SEQ_NO, @ARG_DETAIL_STATUS
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-11-20		김완기			최초생성
   2014-01-10		박형만			전자결제상태업데이트에서는 인보이스3,정산진행4,정산완료5, 지급완료7, 지급불가8 만 정산완료 되도록
================================================================================================================*/ 
CREATE PROC [dbo].[XP_ARG_DETAIL_STATUS_UPDATE2]
	@EDI_CODE	VARCHAR(10),
	@ARG_DETAIL_STATUS	INT
AS 
BEGIN
	
	--UPDATE ARG_DETAIL SET ARG_DETAIL_STATUS = @ARG_DETAIL_STATUS
	--  FROM (SELECT B.*
	--		  FROM ARG_MASTER A 
	--		 INNER JOIN ARG_DETAIL B ON A.ARG_SEQ_NO = B.ARG_SEQ_NO
	--		 INNER JOIN SET_LAND_AGENT C ON A.PRO_CODE = C.PRO_CODE AND B.LAND_SEQ_NO = C.LAND_SEQ_NO
	--		 WHERE C.EDI_CODE = @EDI_CODE) A
	-- WHERE ARG_DETAIL.ARG_SEQ_NO = A.ARG_SEQ_NO AND ARG_DETAIL.GRP_SEQ_NO = A.GRP_SEQ_NO

	UPDATE ARG_DETAIL SET ARG_DETAIL_STATUS = @ARG_DETAIL_STATUS
	  FROM (SELECT B.*
			  FROM ARG_MASTER A 
			 INNER JOIN ARG_DETAIL B ON A.ARG_SEQ_NO = B.ARG_SEQ_NO
			 INNER JOIN SET_LAND_AGENT C ON A.PRO_CODE = C.PRO_CODE AND B.LAND_SEQ_NO = C.LAND_SEQ_NO
			 WHERE C.EDI_CODE = @EDI_CODE
			 AND B.ARG_DETAIL_STATUS IN ( 3,4,5,7,8)  --인보이스3,정산진행4,정산완료5, 지급완료7, 지급불가8
			 ) A
	 WHERE ARG_DETAIL.ARG_SEQ_NO = A.ARG_SEQ_NO AND ARG_DETAIL.GRP_SEQ_NO = A.GRP_SEQ_NO


END 

GO
