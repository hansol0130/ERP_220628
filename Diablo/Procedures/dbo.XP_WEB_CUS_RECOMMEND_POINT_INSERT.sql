USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*================================================================================================================
■ USP_NAME					: XP_WEB_CUS_RECOMMEND_POINT_INSERT
■ DESCRIPTION				: 회원가입시 추천인 등록 /수정 및 포인트지급  
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
EXEC XP_WEB_CUS_RECOMMEND_POINT_INSERT 10630104 , 10630091 , '박형만->이슬아 추천 테스트'


EXEC XP_WEB_CUS_RECOMMEND_POINT_INSERT 10630082 , 10630091 , '박형만->이슬아 추천 테스트'

	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2018-11-06		박형만			최초생성
================================================================================================================*/ 
CREATE  PROC [dbo].[XP_WEB_CUS_RECOMMEND_POINT_INSERT]
	@CUS_NO	INT ,  -- 가입자 회원번호 
	@REC_CUS_NO INT , -- 피추천인 회원번호
	
	@REMARK VARCHAR(500) --  
AS 
BEGIN 


	DECLARE @POINT_PRICE INT 
	SET @POINT_PRICE = 2000   -- 추천인 포인트 고정 

	-- 가입포인트를 받은 사람만 
	-- 가입포인트를 받지 않았다면 이미 받은적이 있는 사람이다 (가입포인트는 휴대폰번호1개당 1회 적립) 
	IF EXISTS ( SELECT * FROM CUS_POINT WHERE CUS_NO = @CUS_NO
		AND POINT_TYPE = 1 -- 적립 
		AND ACC_USE_TYPE = 3 )  -- 회원가입 

	BEGIN
		DECLARE @REC_GRP_SEQ INT 
		DECLARE @REC_TYPE INT 

		SET @REC_GRP_SEQ = ISNULL((SELECT MAX(REC_GRP_SEQ) FROM CUS_RECOMMEND ),0) + 1 
		SET @REC_TYPE = 0 -- 추천타입- 회원가입 
		

		DECLARE @CUS_NAME VARCHAR(20)
		SET @CUS_NAME = ( SELECT TOP 1 CUS_NAME FROM CUS_MEMBER WITH(NOLOCK) WHERE CUS_NO = @CUS_NO )
		SET @CUS_NAME = SUBSTRING(ISNULL(@CUS_NAME,@CUS_NO),1,LEN(ISNULL(@CUS_NAME,@CUS_NO))-1) + '*'
		
		DECLARE @REC_CUS_NAME VARCHAR(20)
		SET @REC_CUS_NAME = ( SELECT TOP 1 CUS_NAME FROM CUS_MEMBER WITH(NOLOCK) WHERE CUS_NO = @REC_CUS_NO )
		SET @REC_CUS_NAME = SUBSTRING(ISNULL(@REC_CUS_NAME,@REC_CUS_NO),1,LEN(ISNULL(@REC_CUS_NAME,@REC_CUS_NO))-1) + '*' 

		DECLARE @TITLE VARCHAR(400)
		DECLARE @REC_TITLE VARCHAR(400)
		SET @TITLE = '추천인 포인트 적립(' +@REC_CUS_NAME+'님 추천)'
		SET @REC_TITLE = '추천인 포인트 적립(' +@CUS_NAME+'님의 추천)'
		

		-- 가입자 포인트 등록 
		DECLARE @INS_POINT_NO TABLE (POINT_NO INT)
		INSERT INTO @INS_POINT_NO  -- POINT_NO 테이블 넣기 
		EXEC SP_CUS_POINT_INSERT @CUS_NO = @CUS_NO,
			@ACC_TYPE = 7 ,
			@POINT_PRICE = @POINT_PRICE ,
			@RES_CODE = NULL , 
			@TITLE =  @TITLE,
			@REMARK = NULL ,
			@NEW_CODE  = '9999999'
		
		DECLARE @POINT_NO INT 
		SET @POINT_NO = (SELECT POINT_NO FROM @INS_POINT_NO)
		IF( @POINT_NO > 0 )
		BEGIN
			INSERT INTO CUS_RECOMMEND 
			( REC_GRP_SEQ ,CUS_TYPE,REC_TYPE ,CUS_NO, POINT_NO, NEW_CODE, NEW_DATE, REMARK ) 
			VALUES 
			( @REC_GRP_SEQ ,1	,@REC_TYPE	,@CUS_NO, @POINT_NO,'9999999',GETDATE(), @REMARK )	
		END 
		-- 테이블 초기화 
		DELETE @INS_POINT_NO 

		-- 피추천인 포인트 등록 
		INSERT INTO @INS_POINT_NO 
		EXEC SP_CUS_POINT_INSERT @CUS_NO = @REC_CUS_NO,
			@ACC_TYPE = 8 ,
			@POINT_PRICE = @POINT_PRICE ,
			@RES_CODE = NULL , 
			@TITLE =  @REC_TITLE,
			@REMARK = NULL ,
			@NEW_CODE  = '9999999'
		
		SET @POINT_NO = (SELECT POINT_NO FROM @INS_POINT_NO)

		IF( @POINT_NO > 0 )
		BEGIN
			INSERT INTO CUS_RECOMMEND 
			( REC_GRP_SEQ ,CUS_TYPE,REC_TYPE ,CUS_NO, POINT_NO, NEW_CODE, NEW_DATE, REMARK ) 
			VALUES 
			( @REC_GRP_SEQ ,2	,@REC_TYPE	,@REC_CUS_NO, @POINT_NO,'9999999',GETDATE(), @REMARK )	
		END 

		SELECT @POINT_NO AS NEW_POINT_NO 
	END 
	ELSE 
	BEGIN
		SELECT -1 AS NEW_POINT_NO 
	END 
END 
GO
