USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					:  XP_COM_EMPLOYEE_MATCHING_INSERT
■ DESCRIPTION				: 출장예약 출발자 - 직원 매핑 
■ INPUT PARAMETER			: 

	@CUS_NO  로 COM_EMPLOYEE 정보를 매핑 한다 

■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-03-03		박형만			최초생성    
   2016-05-23		박형만			버그수정 IF NOT EXISTS( SELECT * FROM COM_EMPLOYEE_MATCHING WITH(NOLOCK) WHERE CUS_NO = @CUS_NO ) => EXISTS 로 수정 
   2016-07-28		박형만			기존에 매핑CUS_NO가 있는데 새로운 CUS_NO 와 매핑되었을경우 추가 , 예약이동 추가 
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_EMPLOYEE_MATCHING_UPDATE]
(
	@AGT_CODE VARCHAR(10),
	@EMP_SEQ INT,
	@CUS_NO INT,
	@NEW_CODE VARCHAR(7) 
) 
AS 
BEGIN

	-- 매핑정보 없을경우만 
	IF NOT EXISTS (SELECT * FROM COM_EMPLOYEE_MATCHING WITH(NOLOCK) WHERE AGT_CODE = @AGT_CODE AND EMP_SEQ = @EMP_SEQ  ) 
	BEGIN
		-- 이미 매핑된 CUS_NO 가 있을경우 
		-- AGT_CODE , EMP_SEQ 정보를 갱신 
		IF EXISTS( SELECT * FROM COM_EMPLOYEE_MATCHING WITH(NOLOCK) WHERE CUS_NO = @CUS_NO )
		BEGIN
			UPDATE COM_EMPLOYEE_MATCHING
			SET AGT_CODE = @AGT_CODE 
			, EMP_SEQ = @EMP_SEQ 
			, NEW_CODE = @NEW_CODE 
			, NEW_DATE = (CASE WHEN ISNULL(@NEW_CODE,'') <> '' THEN GETDATE() ELSE NEW_DATE END )  
			WHERE CUS_NO = @CUS_NO 
		END 
		ELSE 
		BEGIN
			INSERT INTO COM_EMPLOYEE_MATCHING (AGT_CODE , EMP_SEQ , CUS_NO , NEW_CODE , NEW_DATE  ) 
			VALUES ( @AGT_CODE , @EMP_SEQ , @CUS_NO  , @NEW_CODE , (CASE WHEN ISNULL(@NEW_CODE,'') <> '' THEN GETDATE() ELSE NULL END ) )
		END 
	END 
	ELSE
	BEGIN

		--기존에 매핑정보 있는경우 
		DECLARE @OLD_CUS_NO INT 
		SET @OLD_CUS_NO = ISNULL( ( SELECT TOP 1 CUS_NO FROM COM_EMPLOYEE_MATCHING WITH(NOLOCK) WHERE AGT_CODE = @AGT_CODE AND EMP_SEQ = @EMP_SEQ ) ,0)

		--기존 매핑정보와 다를경우 (!기존매핑정보와 동일하면 갱신하지 않음)
		IF( @OLD_CUS_NO > 0 AND @OLD_CUS_NO <> @CUS_NO )
		BEGIN 
			--매핑정보 갱신 
			UPDATE COM_EMPLOYEE_MATCHING
			SET CUS_NO = @CUS_NO 
			, NEW_CODE = @NEW_CODE 
			, NEW_DATE = (CASE WHEN ISNULL(@NEW_CODE,'') <> '' THEN GETDATE() ELSE NEW_DATE END )  
			WHERE AGT_CODE = @AGT_CODE 
			AND EMP_SEQ = @EMP_SEQ 

			--기존 예약 CUS_NO 가 있을경우 
			--예약이동
			IF EXISTS ( SELECT * FROM RES_CUSTOMER_damo WHERE CUS_NO = @OLD_CUS_NO  )
			BEGIN
				UPDATE RES_CUSTOMER_damo 
				SET CUS_NO = @CUS_NO 
				WHERE CUS_NO = @OLD_CUS_NO 
			END 
			--예약이동
			IF EXISTS ( SELECT * FROM RES_MASTER_damo WHERE CUS_NO = @OLD_CUS_NO  )
			BEGIN
				UPDATE RES_MASTER_damo 
				SET CUS_NO = @CUS_NO 
				WHERE CUS_NO = @OLD_CUS_NO 
			END 
		END 

		
	

	END 
END 




GO
