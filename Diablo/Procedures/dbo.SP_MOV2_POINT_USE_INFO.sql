USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: [SP_MOV2_POINT_USE_INFO]
■ DESCRIPTION				: 검색_SNS 가입정보가 있는 회원
■ INPUT PARAMETER			: @SNS_COMPANY, @SNS_ID
■ EXEC						: 
    -- [SP_MOV2_POINT_USE_INFO] '1','8505125' --SNS 업체 번호 , SNS 발행 아이디

■ MEMO						: 사용자 포인트 사용정합계 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-05-26	  아이비솔루션				최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_POINT_USE_INFO]
	-- Add the parameters for the stored procedure here
	@CUS_NO				VARCHAR(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	;with [dd] AS(
		SELECT		
			P.CUS_NO, 
			P.POINT_NO, 
			P.POINT_TYPE,
			P.ACC_USE_TYPE,
			P.POINT_PRICE,
			CASE WHEN P.POINT_TYPE = 1 
				THEN P.POINT_PRICE - ISNULL(( SELECT SUM(B.POINT_PRICE) FROM CUS_POINT_HISTORY B  WITH(NOLOCK)  WHERE P.POINT_NO = B.ACC_POINT_NO ),0) 
				ELSE 0 END  AS REMAIN_PRICE ,
			P.TOTAL_PRICE,			
			P.RES_CODE, 
			P.MASTER_SEQ, 
			P.BOARD_SEQ,
			P.TITLE,
			P.START_DATE,
			P.END_DATE,
			P.NEW_DATE
		FROM CUS_POINT P WITH(NOLOCK)
		WHERE p.CUS_NO=@CUS_NO

		)

		SELECT	
		p.POINT_TYPE
		,P.ACC_USE_TYPE
		,SUM(P.POINT_PRICE) AS SUM_PRICE
		FROM [dd] P WITH(NOLOCK)	
		
		GROUP BY P.POINT_TYPE, P.ACC_USE_TYPE
END

GO
