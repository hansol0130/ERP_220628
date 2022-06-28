USE [SEND]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_ALT_CATEGORY_LIST_SELECT
■ DESCRIPTION				: 알림톡 메세지 템플릿 검색
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	EXEC XP_ALT_CATEGORY_LIST_SELECT '', 'PAY_MA_0005'
	EXEC XP_ALT_CATEGORY_LIST_SELECT 'PAY', ''
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2018-05-14		김성호			최초생성
   2018-06-14		정지용			카테고리 코드 배열로 받게 수정
   2018-06-14		정지용			템플릿 검색 추가
   2018-08-06		정지용			조건 수정
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[XP_ALT_CATEGORY_LIST_SELECT]
	--@CATEGORY_CD	VARCHAR(12),
	@CATEGORY_CD	VARCHAR(50),
	@KAKAO_TMPL_CD	VARCHAR(500),
	@TMPL_NM VARCHAR(50) = ''
AS
BEGIN

	DECLARE @SQLSTRING NVARCHAR(4000), @WHERE NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000);

	IF LEN(@KAKAO_TMPL_CD) > 0
	BEGIN
		SET @WHERE = ' AND A.KAKAO_TMPL_CD IN (SELECT DATA FROM Diablo.dbo.FN_SPLIT(@KAKAO_TMPL_CD, '',''))';
	END
	ELSE IF LEN(@CATEGORY_CD) > 0
	BEGIN
		--SET @WHERE = 'WHERE A.CATEGORY_CD = @CATEGORY_CD';
		SET @WHERE = ' AND A.CATEGORY_CD IN (SELECT DATA FROM Diablo.dbo.FN_SPLIT(@CATEGORY_CD, '',''))';
	END

	IF @TMPL_NM != ''
	BEGIN
		IF CHARINDEX('DEV_', UPPER(@TMPL_NM)) = 1
		BEGIN
			SET @WHERE = ' AND A.KAKAO_TMPL_CD = REPLACE(@TMPL_NM, ''DEV_'', '''')';
		END
		ELSE
		BEGIN
			SET @WHERE = @WHERE + ' AND CONTS_NM LIKE ''%'' + @TMPL_NM + ''%'' ';
		END
		--SET @WHERE = @WHERE + ' AND CONTS_NM LIKE ''%'' + @TMPL_NM + ''%'' ';
	END

	SELECT @WHERE = @WHERE + ' AND A.KAKAO_INSP_STATUS = ''APR'' AND A.KAKAO_TMPL_STATUS IN (''A'', ''R'')'

	SET @SQLSTRING = N'

	SELECT /* 알림톡 템플릿 조회 */
		CONTS_NM,			-- 템플릿명
		KAKAO_TMPL_CD,		-- 카카오 템플릿 코드
		KAKAO_TMPL_STATUS,	-- 카카오 템플릿 상태 [S:중단, A:정상, R:대기(발송전)]
		KAKAO_INSP_STATUS,	-- 알림톡 템플릿 카카오 검수상태 [REG:등록, REQ:검수요청, REJ:반려, APR:승인]
		CONTS_TXT,			-- 템플릿 내용
		CATEGORY_CD			-- 카테고리 코드
	FROM SEND.dbo.NVMOBILECONTENTS A WITH(NOLOCK) WHERE USE_YN = ''Y''
	' + @WHERE + N';'


	--PRINT @SQLSTRING

	SET @PARMDEFINITION = N'
		@CATEGORY_CD	VARCHAR(50),
		@KAKAO_TMPL_CD	VARCHAR(500),
		@TMPL_NM		VARCHAR(50)';

	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, 
		@CATEGORY_CD,
		@KAKAO_TMPL_CD,
		@TMPL_NM;
 
END
GO
