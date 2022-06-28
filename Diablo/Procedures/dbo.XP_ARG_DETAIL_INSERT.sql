USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*================================================================================================================
■ USP_NAME					: XP_ARG_DETAIL_INSERT
■ DESCRIPTION				: 수배 디테일 입력
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
		
	exec XP_ARG_DETAIL_INSERT 0, 1, '수배요청【오키드홀리데이/4명출발】 위해+장보고유적지/탕박온천 3일_아시아나 연합', '수배요청 수배요청 <br> ㅁㅁㅁㅁㅁㅁㅁㅁㅁ', 0, 2, 1, 0, 0, NULL, NULL, NULL, 0, '9999999'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-05-22		이규식			최초생성
   2014-03-20		김성호			재생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_ARG_DETAIL_INSERT]
	@ARG_CODE VARCHAR(12) OUTPUT,
	@GRP_SEQ_NO INT OUTPUT,
	@AGT_CODE VARCHAR(10),
	@PRO_CODE VARCHAR(20),
	@PAR_GRP_SEQ_NO INT,
 	@TITLE VARCHAR(200),
	@CONTENT NVARCHAR(MAX),
	@ARG_TYPE INT,
	@ARG_STATUS INT,
	@DEP_DATE DATETIME,
	@ARR_DATE DATETIME,
	@NIGHTS INT,
	@DAY INT,
	@ADT_COUNT INT,
	@CHD_COUNT INT,
	@INF_COUNT INT,
	@FOC_COUNT INT,
	@NEW_CODE VARCHAR(7),
	@CXL_GRP_SEQ_NO INT
AS 
BEGIN

	-- ARG_MASTER 생성 체크
	IF @ARG_CODE IS NULL OR @ARG_CODE = ''
	BEGIN
		IF ISNULL(@PRO_CODE, '') = '' OR NOT EXISTS(SELECT 1 FROM ARG_MASTER A WITH(NOLOCK) WHERE A.AGT_CODE = @AGT_CODE AND A.PRO_CODE = @PRO_CODE)
		BEGIN
			EXEC SP_COD_GETSEQ 'ARG', @ARG_CODE OUTPUT
			SELECT @ARG_CODE = ('A' + SUBSTRING(CONVERT(VARCHAR(10), GETDATE(), 112), 3, 6) + '-' + RIGHT(('000' + @ARG_CODE), 4))

			INSERT INTO ARG_MASTER (ARG_CODE, AGT_CODE, PRO_CODE, NEW_CODE, NEW_DATE)
			VALUES (@ARG_CODE, @AGT_CODE, @PRO_CODE, @NEW_CODE, GETDATE())
		END
		ELSE
		BEGIN
			SELECT @ARG_CODE = A.ARG_CODE
			FROM ARG_MASTER A WITH(NOLOCK)
			WHERE A.AGT_CODE = @AGT_CODE AND A.PRO_CODE = @PRO_CODE
		END
	END

	-- 재발행 시 이전 문서 취소 처리
	IF @CXL_GRP_SEQ_NO > 0
	BEGIN
		UPDATE ARG_DETAIL SET ARG_STATUS = (CASE ARG_STATUS WHEN 1 THEN 3 WHEN 2 THEN 4 WHEN 5 THEN 7 WHEN 6 THEN 8 END), EDT_CODE = @NEW_CODE, EDT_DATE = GETDATE()
		WHERE ARG_CODE = @ARG_CODE AND GRP_SEQ_NO = @CXL_GRP_SEQ_NO

		UPDATE C SET C.ARG_STATUS = (CASE C.ARG_STATUS WHEN 1 THEN 3 WHEN 2 THEN 1 WHEN 5 THEN 2 WHEN 6 THEN 5 END), C.EDT_CODE = @NEW_CODE, C.EDT_DATE = GETDATE()
		FROM ARG_DETAIL A
		INNER JOIN ARG_CONNECT B ON A.ARG_CODE = B.ARG_CODE AND A.GRP_SEQ_NO = B.GRP_SEQ_NO
		INNER JOIN ARG_CUSTOMER C ON B.ARG_CODE = C.ARG_CODE AND B.CUS_SEQ_NO = C.CUS_SEQ_NO
		WHERE A.ARG_CODE = @ARG_CODE AND A.GRP_SEQ_NO = @CXL_GRP_SEQ_NO
	END

	SELECT @GRP_SEQ_NO = ISNULL(MAX(GRP_SEQ_NO), 0) + 1 FROM ARG_DETAIL WHERE ARG_CODE = @ARG_CODE

	INSERT INTO ARG_DETAIL
	(
		ARG_CODE
		, GRP_SEQ_NO
		, PAR_GRP_SEQ_NO
        , TITLE
        , CONTENT
        , ARG_TYPE
		, ARG_STATUS
		, DEP_DATE
		, ARR_DATE
		, NIGHTS
		, DAY
        , ADT_COUNT
        , CHD_COUNT
        , INF_COUNT
        , FOC_COUNT
        , NEW_CODE
		, NEW_DATE
	)
	VALUES
    (
		@ARG_CODE
		, @GRP_SEQ_NO
		, @PAR_GRP_SEQ_NO
        , @TITLE
        , @CONTENT
        , @ARG_TYPE
		, @ARG_STATUS
		, @DEP_DATE
		, @ARR_DATE
		, @NIGHTS
		, @DAY
        , @ADT_COUNT
        , @CHD_COUNT
        , @INF_COUNT
        , @FOC_COUNT
        , @NEW_CODE
		, GETDATE()
	)

	
END 


/*
ALTER PROC [dbo].[XP_ARG_DETAIL_INSERT]
	@GRP_SEQ_NO INT OUTPUT,
	@ARG_SEQ_NO INT,
 	@TITLE VARCHAR(200),
	@CONTENT NVARCHAR(MAX),
	@ARG_TYPE INT,
	@ADT_COUNT INT,
	@CHD_COUNT INT,
	@INF_COUNT INT,
	@FOC_COUNT INT,
	@FILENAME1 VARCHAR(200),
	@FILENAME2 VARCHAR(200),
	@FILENAME3 VARCHAR(200),
	@ARG_DETAIL_STATUS INT,
	@NEW_CODE VARCHAR(7),
	@RES_CODE VARCHAR(12),
	@ARG_DETAIL_GROUP INT
AS 
BEGIN

	IF ISNULL(@ARG_DETAIL_GROUP, 0) = 0
		BEGIN
			SELECT @ARG_DETAIL_GROUP = ISNULL(MAX(ARG_DETAIL_GROUP), 0) + 1 FROM ARG_DETAIL WHERE ARG_SEQ_NO = @ARG_SEQ_NO
		END

	SELECT @GRP_SEQ_NO = ISNULL(MAX(GRP_SEQ_NO), 0) + 1 FROM ARG_DETAIL 
	WHERE ARG_SEQ_NO = @ARG_SEQ_NO

	INSERT INTO ARG_DETAIL
           (ARG_SEQ_NO
		   ,GRP_SEQ_NO
           ,TITLE
           ,CONTENT
           ,ARG_TYPE
           ,ADT_COUNT
           ,CHD_COUNT
           ,INF_COUNT
           ,FOC_COUNT
           ,FILENAME1
           ,FILENAME2
           ,FILENAME3
           ,ARG_DETAIL_STATUS
           ,NEW_CODE
		   ,RES_CODE
		   ,ARG_DETAIL_GROUP)
	VALUES
           (@ARG_SEQ_NO
		   ,@GRP_SEQ_NO
           ,@TITLE
           ,@CONTENT
           ,@ARG_TYPE
           ,@ADT_COUNT
           ,@CHD_COUNT
           ,@INF_COUNT
           ,@FOC_COUNT
           ,@FILENAME1
           ,@FILENAME2
           ,@FILENAME3
           ,@ARG_DETAIL_STATUS
           ,@NEW_CODE
		   ,@RES_CODE
		   ,@ARG_DETAIL_GROUP)

	SELECT @GRP_SEQ_NO
END 
*/
GO
