USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_NAVER_PKG_DETAIL_SCHDEULE_TRANPORT
■ DESCRIPTION				: 네이버 일정표 이동수단 변경
■ INPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 네이버 일정표 이동수단 변경 페이지
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2019-08-30		김남훈			        최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[XP_NAVER_PKG_DETAIL_SCHDEULE_TRANPORT]
	@PRO_CODE				VARCHAR(20),
	@SCH_SEQ				INT,
	@DAY_SEQ				INT,
	@TRANSPORT_TYPE			VARCHAR(20),
	@TRANSPORT_DESC			VARCHAR(20)
AS
BEGIN

	IF EXISTS(SELECT TOP 1 * FROM NAVER_PKG_DETAIL_SCH_DAY_TRANSPORT WHERE PRO_CODE = @PRO_CODE AND SCH_SEQ = @SCH_SEQ AND DAY_SEQ = @DAY_SEQ AND TRANSPORT_SEQ = 1)
	BEGIN

		--이미 있는 경우 Update
		UPDATE NAVER_PKG_DETAIL_SCH_DAY_TRANSPORT SET TRANSPORT_TYPE = @TRANSPORT_TYPE, TRANSPORT_DESC = @TRANSPORT_DESC
		WHERE PRO_CODE = @PRO_CODE AND SCH_SEQ = @SCH_SEQ AND DAY_SEQ = @DAY_SEQ AND TRANSPORT_SEQ = 1

	END
	ELSE
	BEGIN

		--없는 경우 Insert 멀티는 지원하지만 한개만 넣기로 일단 협의 20190830
		INSERT INTO NAVER_PKG_DETAIL_SCH_DAY_TRANSPORT(PRO_CODE, SCH_SEQ, DAY_SEQ, DAY_NUMBER, TRANSPORT_SEQ, TRANSPORT_TYPE, TRANSPORT_DESC)
		SELECT PRO_CODE,SCH_SEQ,DAY_SEQ,DAY_NUMBER,1,@TRANSPORT_TYPE,@TRANSPORT_DESC FROM PKG_DETAIL_SCH_DAY
		WHERE PRO_CODE = @PRO_CODE AND SCH_SEQ = @SCH_SEQ AND DAY_SEQ = @DAY_SEQ

	END

END           



GO
