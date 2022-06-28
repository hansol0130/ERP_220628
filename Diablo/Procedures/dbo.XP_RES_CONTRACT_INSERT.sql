USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_RES_CONTRACT_INSERT
■ DESCRIPTION				: 여행자 계약서 등록 및 갱신 
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

 


■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
2018-12-11			박형만			최초생성
2020-01-15			이유천			보험여부 추가(lyc)
================================================================================================================*/ 
CREATE PROC [dbo].[XP_RES_CONTRACT_INSERT] 
(
	@RES_CODE	RES_CODE	,
	@CONTRACT_NO	int	,
	@DEP_DATE	datetime	,
	@ARR_DATE	datetime	,
	@NIGHT	int	,
	@INS_YN CHAR(1)	, -- lyc
	@INS_TYPE	int	,
	@INS_PRICE	int	,
	@MIN_COUNT	int	,
	@MAX_COUNT	int	,
	@TRANS_TYPE	int	,
	@TRANS_GRADE	varchar(20)	,
	@STAY_TYPE	varchar(30)	,
	@STAY_COUNT	varchar(10)	,
	@TC_YN	char(1)	,
	@TRANSPORT_TYPE	int	,
	@TRANSPORT_COUNT	int	,
	@MANDATORY_1	char(1)	,
	@MANDATORY_2	char(1)	,
	@MANDATORY_4	char(1)	,
	@MANDATORY_5	char(1)	,
	@MANDATORY_6	char(1)	,
	@MANDATORY_7	char(1)	,
	@MANDATORY_3	char(1)	,
	@OPTION_1	char(1)	,
	@OPTION_2	char(1)	,
	@OPTION_3	char(1)	,
	@OPTION_4	char(1)	,
	@OPTION_5	char(1)	,
	@OPTION_6	char(1)	,
	@OPTION_7	char(1)	,
	@OPTION_8	char(1)	,
	@NEW_CODE	NEW_CODE	,
	@TOUR_TYPE	int	,
	@INSIDE_DAY	int	,
	@REMARK	varchar(MAX)	,
	@PRO_NAME	nvarchar(200)	,
	@ADT_PRICE	int	,
	@DEP_DEP_DATE	datetime	,
	@ARR_ARR_DATE	datetime	,
	@DEP_AIRPORT	varchar(40)	,
	@ARR_AIRPORT	varchar(40)	,
	@PAYMENT_YN	char(1)	,
	
	--201812추가된정보
	@RES_COUNT	int	,
	@TOTAL_PRICE	int	,
	@CONT_NAME	varchar(40)	,
		
	-- 승인정보 
	@CFM_YN	char(1) = null 	,
	@CFM_DATE	datetime = null 	,
	@CFM_TYPE	int = 0 	,
	@CFM_HEADER	varchar(max) = null	,
	@CFM_IP	varchar(20) = null 	,
	@RSV_DATE	datetime = null ,
	
	@CONT_DATE DATETIME = NULL ,
	@SPC_TERMS_INFO VARCHAR(MAX) = NULL 	
)
AS 
BEGIN

	-- 수정모드 추후 
	--IF( @CONTRACT_NO > 0 )
	--BEGIN
	--	UPDATE RES_CONTRACT 
		
	--	WHERE RES_CODE =@RES_CODE 
	--	AND CONTRACT_NO = @TMP_NO  
	--END 


	--등록모드 
	DECLARE @TMP_NO INT

	SELECT @TMP_NO = MAX(CONTRACT_NO) FROM RES_CONTRACT WITH(NOLOCK)
	WHERE RES_CODE = @RES_CODE

	SET @TMP_NO = ISNULL(@TMP_NO, 0) + 1

	INSERT INTO RES_CONTRACT
		(RES_CODE
		,CONTRACT_NO
		,DEP_DATE
		,ARR_DATE
		,NIGHT
		,INS_YN
		,INSIDE_DAY
		,INS_TYPE
		,INS_PRICE
		,MIN_COUNT
		,MAX_COUNT
		,TRANS_TYPE
		,TRANS_GRADE
		,STAY_TYPE
		,STAY_COUNT
		,TC_YN
		,TRANSPORT_TYPE
		,TRANSPORT_COUNT
,MANDATORY_1,MANDATORY_2,MANDATORY_4,MANDATORY_5,MANDATORY_6,MANDATORY_7,MANDATORY_3
,OPTION_1,OPTION_2,OPTION_3,OPTION_4,OPTION_5,OPTION_6,OPTION_7,OPTION_8
		,NEW_CODE
		,TOUR_TYPE
		,REMARK
		,PRO_NAME
		,ADT_PRICE
		,DEP_DEP_DATE
		,ARR_ARR_DATE
		,DEP_AIRPORT
		,ARR_AIRPORT
		,PAYMENT_YN

		,RES_COUNT
		,TOTAL_PRICE
		,CONT_NAME
		,CONT_DATE
		,SPC_TERMS_INFO
			   --@AddColumn
		)
	VALUES
		(@RES_CODE
		,@TMP_NO
		,@DEP_DATE
		,@ARR_DATE
		,@NIGHT
		,@INS_YN
		,@INSIDE_DAY
		,@INS_TYPE
		,@INS_PRICE
		,@MIN_COUNT
		,@MAX_COUNT
		,@TRANS_TYPE
		,@TRANS_GRADE
		,@STAY_TYPE
		,@STAY_COUNT
		,@TC_YN
		,@TRANSPORT_TYPE
		,@TRANSPORT_COUNT
,@MANDATORY_1,@MANDATORY_2,@MANDATORY_4,@MANDATORY_5,@MANDATORY_6,@MANDATORY_7,@MANDATORY_3
,@OPTION_1,@OPTION_2,@OPTION_3,@OPTION_4,@OPTION_5,@OPTION_6,@OPTION_7,@OPTION_8
		,@NEW_CODE
		,@TOUR_TYPE
		,@REMARK
		,@PRO_NAME
		,@ADT_PRICE
		,@DEP_DEP_DATE
		,@ARR_ARR_DATE
		,@DEP_AIRPORT
		,@ARR_AIRPORT
		,@PAYMENT_YN
		--@AddValues
		,@RES_COUNT
		,@TOTAL_PRICE
		,@CONT_NAME
		,@CONT_DATE
		,@SPC_TERMS_INFO
	)
	
	-- 수신동의 직접 수령 (OFFLINE) 일때 
	-- 동의일 바로 수정 
	IF(@RSV_DATE IS NOT NULL AND @CFM_TYPE = 2 )
	BEGIN
		UPDATE RES_CONTRACT 
		SET CFM_YN = @CFM_YN 
		,CFM_DATE  = @CFM_DATE
		,CFM_TYPE  = @CFM_TYPE
		,CFM_HEADER  = @CFM_HEADER
		,CFM_IP  = @CFM_IP 
		,RSV_DATE  = @RSV_DATE
		WHERE RES_CODE =@RES_CODE 
		AND CONTRACT_NO = @TMP_NO 
	END 

END 



GO
