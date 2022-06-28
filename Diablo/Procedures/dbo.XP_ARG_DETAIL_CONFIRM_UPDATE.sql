USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_ARG_DETAIL_CONFIRM_UPDATE
■ DESCRIPTION				: 수배현황상세 확인자 업데이트
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	XP_ARG_DETAIL_CONFIRM_UPDATE 2004, 4, '9999999'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-05-22		이규식			최초생성
   2014-01-14		김성호			쿼리수정
   2014-03-28		박형만			쿼리수정
   2014-04-01		이동호			
================================================================================================================*/ 
CREATE PROC [dbo].[XP_ARG_DETAIL_CONFIRM_UPDATE]
	@ARG_CODE VARCHAR(12),
	@GRP_SEQ_NO INT,
	@CFM_CODE EMP_CODE 
AS 
BEGIN

	DECLARE @CUR_ARG_TYPE INT 
	DECLARE @CUR_ARG_STATUS INT 
	DECLARE @CUR_CFM_CODE VARCHAR(12)
	SELECT @CUR_ARG_TYPE = ARG_TYPE ,@CUR_ARG_STATUS = ARG_STATUS, @CUR_CFM_CODE = CFM_CODE FROM ARG_DETAIL WITH(NOLOCK) 
	WHERE ARG_CODE = @ARG_CODE AND GRP_SEQ_NO = @GRP_SEQ_NO 
	--1수배요청, 2수배확정, 3수배취소, 4수배확정취소, 5인보이스발행, 6인보이스확정, 7인보이스취소, 8인보이스확정취소, 9정산결제, 10정산지급
	--
	IF ISNULL(@CUR_CFM_CODE,'') = '' 
	BEGIN

		--1수배요청서 , 4확정인보이스 -> 랜드사가 수신하는 입장이므로 
		IF  @CUR_ARG_TYPE IN (1 , 4) 
		BEGIN
			-- 랜드사만 확인 가능 
			IF  @CUR_ARG_STATUS IN (1,3,6,8) -- 1수배요청, 3수배취소, 6인보이스발행, 8인보이스확정취소
			BEGIN
				--랜드사일경우 
				IF EXISTS ( SELECT * FROM AGT_MEMBER WITH(NOLOCK)  WHERE MEM_CODE = @CFM_CODE  )
				BEGIN
					--확인자 업데이트 
					UPDATE ARG_DETAIL SET CFM_DATE = GETDATE(), CFM_CODE = @CFM_CODE
					WHERE ARG_CODE = @ARG_CODE AND GRP_SEQ_NO = @GRP_SEQ_NO
				END 
			END  
		END 
		--2수배확정서 , 3인보이스 -> 본사에서 수신하는 입장이므로 
		ELSE IF @CUR_ARG_TYPE IN (2 ,3 )  
		BEGIN
			-- 본사만 확인가능
			IF  @CUR_ARG_STATUS IN (2, 5, 4, 7) --2수배확정,5인보이스발행,4수배확정취소, 7인보이스취소
			BEGIN
				--본사직원일경우  
				IF EXISTS ( SELECT * FROM EMP_MASTER WITH(NOLOCK) WHERE EMP_CODE = @CFM_CODE  )
				BEGIN
					UPDATE ARG_DETAIL SET CFM_DATE = GETDATE(), CFM_CODE = @CFM_CODE
					WHERE ARG_CODE = @ARG_CODE AND GRP_SEQ_NO = @GRP_SEQ_NO
				END 
			END  
		END 
	END 	

	--수배요청서가 아닐때만(?), 확인자 없을때만 일때만 업데이트 
	--IF ISNULL(@CUR_ARG_TYPE = 1  AND ISNULL(@CUR_CFM_CODE,'') = ''
	--BEGIN
	--	UPDATE ARG_DETAIL SET CFM_DATE = GETDATE(), CFM_CODE = @CFM_CODE
	--	WHERE ARG_CODE = @ARG_CODE AND GRP_SEQ_NO = @GRP_SEQ_NO
	--END

	--DECLARE @CHECK_CFM_CODE VARCHAR(10);

	--SELECT  @CHECK_CFM_CODE = CFM_CODE
	--  FROM  ARG_DETAIL WITH(NOLOCK)
	-- WHERE  ARG_SEQ_NO =  @ARG_SEQ_NO AND GRP_SEQ_NO = @GRP_SEQ_NO

	--IF ISNULL(@CHECK_CFM_CODE, '') = ''
	--	BEGIN
	--		UPDATE ARG_DETAIL
	--		SET CFM_DATE = GETDATE(), CFM_CODE = @CFM_CODE
	--		WHERE ARG_SEQ_NO =  @ARG_SEQ_NO AND GRP_SEQ_NO = @GRP_SEQ_NO
	--	END


END 
GO
