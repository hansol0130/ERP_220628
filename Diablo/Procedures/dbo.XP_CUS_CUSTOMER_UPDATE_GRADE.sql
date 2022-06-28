USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_CUS_CUSTOMER_UPDATE_GRADE
■ DESCRIPTION				: 고객등급 변경 (ERP)
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	exec  XP_CUS_CUSTOMER_UPDATE_GRADE 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2018-03-23		박형만			최초생성
   2020-09-14		김성호			VIP 지정테이블 변경 (CUS_CUSTOMER_DAMO -> CUS_VIP_HISTORY)
   2020-12-01		김성호			VIP 년도 지정 가능하게 수정
================================================================================================================*/ 
CREATE  PROC [dbo].[XP_CUS_CUSTOMER_UPDATE_GRADE]
(
	@CUS_NO INT,
	@VIP_YEAR INT,
	@CUS_GRADE INT,
	@CUS_GRADE_NAME VARCHAR(20),
	@EDT_CODE NEW_CODE,
	@REMARK VARCHAR(100)
)
AS 

BEGIN
	
	IF @CUS_NO > 1 AND @VIP_YEAR > 2000
	BEGIN
		IF EXISTS(SELECT 1 FROM CUS_VIP_HISTORY CVH WITH(NOLOCK) WHERE CVH.VIP_YEAR = @VIP_YEAR AND CVH.CUS_NO = @CUS_NO)
		BEGIN
			UPDATE CUS_VIP_HISTORY
			SET
				CUS_GRADE = @CUS_GRADE,
				CUS_GRADE_NAME = @CUS_GRADE_NAME,
				EDT_DATE = GETDATE(),
				EDT_CODE = @EDT_CODE,
				REMARK = @REMARK
			WHERE CUS_NO = @CUS_NO AND VIP_YEAR = @VIP_YEAR
		END
		ELSE
		BEGIN
			INSERT INTO CUS_VIP_HISTORY	(VIP_YEAR, CUS_NO, CUS_GRADE, CUS_GRADE_NAME, NEW_DATE, EDT_CODE, REMARK)
			VALUES (@VIP_YEAR, @CUS_NO, @CUS_GRADE, @CUS_GRADE_NAME, GETDATE(), @EDT_CODE, @REMARK)
		END
	END
	
END
GO
