USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*=================================================================================================
■ USP_Name					: SP_COM_SCHEDULE_INSERT  
■ Description				: 회사 일정을 반복된 일수/주/달수로 삽입 및 수정한다
■ Input Parameter			: 
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 
■ MEMO						: 
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
   2008-04-19       문태중			최초생성
   2015-09-16       김성호			SCH_TYPE 형변환 CHAR(1) -> INT
=================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_COM_SCHEDULE_INSERT]
	@QTYPE			CHAR(1),
	@EMP_CODE		VARCHAR(10),
	@SCH_TYPE		INT,
	@SCH_DATE		DATETIME,
	@RPT_TYPE		INT,
	@SUBJECT		VARCHAR(50),
	@CONTENTS		VARCHAR(100),	
	@SCH_GRADE		CHAR(1),	
	@START_TIME		DATETIME,
	@END_TIME		DATETIME,	
	@USERID			VARCHAR(20),
	@USERNAME		VARCHAR(20),
	@SEQ			INT,
	@PARENT_SEQ		INT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @TMP_SEQ INT; --시퀀스 넘버
	DECLARE @REPEATCOUNT INT;  --반복 일수
	DECLARE @RPT_DAYCOUNT INT;   --반복 타입 1 : 1일 / 2:월~금 / 3:매주(+7) / 4:매월(+MONTH)
	
	IF @QTYPE = 'U'  --수정일 경우 기존 데이터 삭제
	BEGIN		
		SELECT @TMP_SEQ = PARENT_SEQ FROM COM_SCHEDULE WHERE SEQ_NO = @SEQ;
		DELETE FROM COM_SCHEDULE WHERE PARENT_SEQ = @TMP_SEQ;	
	END	
		
	SET @REPEATCOUNT = DATEDIFF(DAY,@START_TIME, @SCH_DATE);
	IF @REPEATCOUNT = 0
	BEGIN				
		INSERT INTO COM_SCHEDULE
		(
		EMP_CODE,		SCH_TYPE,		SCH_DATE,		SUBJECT,		CONTENTS,
		SCH_GRADE,		START_TIME,		END_TIME,		NEW_CODE,		NEW_NAME,		NEW_DATE
		)
		VALUES
		(
		@EMP_CODE,		@SCH_TYPE,		@SCH_DATE,		@SUBJECT,		@CONTENTS,
		@SCH_GRADE,		@START_TIME,	@END_TIME,		@EMP_CODE,		@USERNAME,		GETDATE()
		)
		
		
		SELECT @TMP_SEQ = @@IDENTITY;
		UPDATE COM_SCHEDULE SET PARENT_SEQ = @TMP_SEQ WHERE EMP_CODE = @EMP_CODE AND SEQ_NO = @TMP_SEQ;
	END
	ELSE
	BEGIN			
		
		SET @RPT_DAYCOUNT = (CASE @RPT_TYPE WHEN 1 THEN 1 WHEN 2 THEN 1 WHEN 3 THEN 7 ELSE 1 END);	--반복일수 계산		

		WHILE (@REPEATCOUNT > -1)
		BEGIN
			--print (@REPEATCOUNT)
			INSERT INTO COM_SCHEDULE   --@SCH_DATE는 일정을 가져오는데 척도가 되므로 반복 일정의 경우 시작시간으로 설정함
			(
			EMP_CODE,		SCH_TYPE,		SCH_DATE,		SUBJECT,		CONTENTS,
			SCH_GRADE,		START_TIME,		END_TIME,		NEW_CODE,		NEW_NAME,		NEW_DATE,		PARENT_SEQ
			)
			VALUES
			(
			@EMP_CODE,		@SCH_TYPE,		@START_TIME,	@SUBJECT,		@CONTENTS,
			@SCH_GRADE,		@START_TIME,	@END_TIME,		@EMP_CODE,		@USERNAME,		GETDATE(),		@PARENT_SEQ	
			)
			
			IF @PARENT_SEQ = 0   --처음 업데이트의 경우 PARENT SEQ 넘버를 저장함
			BEGIN
				SELECT @PARENT_SEQ = @@IDENTITY;
				UPDATE COM_SCHEDULE SET PARENT_SEQ = @PARENT_SEQ WHERE EMP_CODE = @EMP_CODE AND SEQ_NO = @PARENT_SEQ;
			END				
	
			IF @RPT_TYPE = 1 OR @RPT_TYPE = 2 OR @RPT_TYPE = 3  --반복 타입 1 : 1일 / 2:월~금 / 3:매주(+7)
			BEGIN
				--반복 카운트 줄여줌
				SET @REPEATCOUNT = @REPEATCOUNT - (CASE @RPT_TYPE WHEN 2 THEN 
																			(CASE DATEPART(DW, @START_TIME) WHEN '6' THEN 3 ELSE @RPT_DAYCOUNT END
																			)ELSE @RPT_DAYCOUNT END) ;	

				IF @SCH_TYPE <> '0'     --시작일 종료일 1/7일++ (만약 @RPT_TYPE이 2이고 금요일이면 토/일은 건너뜀)
				BEGIN
					SET @END_TIME = DATEADD(DD,(	CASE @RPT_TYPE WHEN 2 THEN 
																			(CASE DATEPART(DW, @START_TIME) WHEN '6' THEN 3 ELSE @RPT_DAYCOUNT END
																			)ELSE @RPT_DAYCOUNT END),@END_TIME);	

					SET @START_TIME = DATEADD(DD,(	CASE @RPT_TYPE WHEN 2 THEN 
																			(CASE DATEPART(DW, @START_TIME) WHEN '6' THEN 3 ELSE @RPT_DAYCOUNT END
																			) ELSE @RPT_DAYCOUNT END),@START_TIME);					
				END
				
				
			END
			ELSE IF @RPT_TYPE = 4   --반복 타입 월일 경우
			BEGIN
				IF @SCH_TYPE <> '0'     --시작일 종료일 월++
				BEGIN
					SET @START_TIME = DATEADD(m,@RPT_DAYCOUNT,@START_TIME);
					SET @END_TIME = DATEADD(m,@RPT_DAYCOUNT,@END_TIME);					
					SET @SCH_DATE = @START_TIME;
				END				
							
				SET @REPEATCOUNT = @REPEATCOUNT - 30;
			END		
		END
	END



END



GO
