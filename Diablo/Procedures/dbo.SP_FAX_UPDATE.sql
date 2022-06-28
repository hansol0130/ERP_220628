USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		<문태중>
-- Create date: <2008-05-19>
-- Description:	<팩스 카테고리 이동>
-- =============================================
CREATE PROCEDURE [dbo].[SP_FAX_UPDATE]
	@GROUP_CODE VARCHAR(20),
	@FAX_SEQ VARCHAR(2000),
	@FAX_CAT_SEQ INT,
	@EXETYPE CHAR(1)
AS
BEGIN	
	SET NOCOUNT ON;
    
	DECLARE @SEQ INT;
	DECLARE @TEMP_SEQ VARCHAR(20);
	DECLARE @TEMP_SEQ_LIST VARCHAR(2000);
	DECLARE @INDEX INT;

	SET @INDEX = CHARINDEX(',', @FAX_SEQ);
	IF @INDEX = 0   --FAX 한개 이동 / 삭제
		BEGIN
			IF @EXETYPE = 'D'
				BEGIN
					UPDATE FAX_MASTER SET
					DEL_YN = 'Y'
					WHERE FAX_SEQ = @FAX_SEQ
				END
			ELSE
				BEGIN
					UPDATE FAX_MASTER SET
					FAX_CAT_SEQ = @FAX_CAT_SEQ
					WHERE FAX_SEQ = @FAX_SEQ
				END		
		END
	ELSE
		BEGIN  --멀티 이동 / 삭제
			SET @FAX_SEQ = @FAX_SEQ + ',';
			WHILE NOT(@INDEX=0)
			BEGIN
				SET @TEMP_SEQ = LEFT(@FAX_SEQ, @INDEX - 1); 
				SET @TEMP_SEQ_LIST = RIGHT(@FAX_SEQ, LEN(@FAX_SEQ) - @INDEX);

				IF @EXETYPE = 'D'
					BEGIN
						UPDATE FAX_MASTER SET DEL_YN = 'Y'
						WHERE FAX_SEQ = @TEMP_SEQ;	
					END
				ELSE
					BEGIN
						UPDATE FAX_MASTER SET FAX_CAT_SEQ = @FAX_CAT_SEQ
						WHERE FAX_SEQ = @TEMP_SEQ;	
					END				
				
				
				SET @INDEX = CHARINDEX(',',@TEMP_SEQ_LIST);
				SET @FAX_SEQ = @TEMP_SEQ_LIST;
				
			END
		END

END




GO
