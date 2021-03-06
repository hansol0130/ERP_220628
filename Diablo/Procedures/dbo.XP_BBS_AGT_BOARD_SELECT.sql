USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_BBS_AGT_BOARD_SELECT
■ DESCRIPTION				: 대외업무시스템 게시판 게시물 검색
■ INPUT PARAMETER			: 
	@NOTE_SEQ_NO	INT		: 사내메일 순번
	@RCV_SEQ_NO		INT		: 수신자 순번
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
	exec XP_BBS_AGT_BOARD_SELECT 10000, 33, 'A130001','Y'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-02-26		김성호			최초생성
   2013-06-10		김성호			WITH(NOLOCK) 추가
   2014-01-07		이동호			TOP 공지글은 비노출 수정 
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_BBS_AGT_BOARD_SELECT]
(
	@MASTER_SEQ		INT,
	@BBS_SEQ		INT,
	@EMP_CODE		CHAR(7),
	@COUNT_YN		CHAR(1)
)
AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @COM_TYPE INT
	DECLARE @AREA_CODE VARCHAR(25)
	SELECT @COM_TYPE = DBO.XN_COM_GET_COM_TYPE(@EMP_CODE)

	SET @AREA_CODE = (SELECT A.AREA_CODE FROM AGT_MASTER A INNER JOIN AGT_MEMBER B ON A.AGT_CODE = B.AGT_CODE WHERE B.MEM_CODE = @EMP_CODE)
			
	-- 조회수 증가
	IF @COUNT_YN = 'Y' AND EXISTS(SELECT 1 FROM BBS_DETAIL WITH(NOLOCK) WHERE MASTER_SEQ = @MASTER_SEQ AND BBS_SEQ = @BBS_SEQ AND NEW_CODE <> @EMP_CODE)
	BEGIN
		UPDATE BBS_DETAIL SET READ_NUM = (READ_NUM + 1) WHERE MASTER_SEQ = @MASTER_SEQ AND BBS_SEQ = @BBS_SEQ
	END

	-- 본문내용
	SELECT A.*
		, (
			SELECT STUFF((
				SELECT ('/' + DBO.XN_COM_GET_COM_TYPE_NAME(AA.COM_TYPE)) AS [text()]
				FROM BBS_DETAIL_VIEW AA WITH(NOLOCK)
				WHERE AA.MASTER_SEQ = A.MASTER_SEQ AND AA.BBS_SEQ = A.BBS_SEQ
				FOR XML PATH('')
			), 1, 1, '')
		) AS [VIEW_AGENT]
		, DBO.XN_COM_GET_TEAM_NAME(A.NEW_CODE) AS [AGT_NAME]
		, DBO.XN_COM_GET_COM_TYPE(A.NEW_CODE) AS [COM_TYPE]
		, R.TEAM_NAME AS CATEGORY_GROUP_NAME
	FROM BBS_DETAIL A WITH(NOLOCK)
	LEFT OUTER JOIN dbo.EMP_TEAM R WITH(NOLOCK) ON A.CATEGORY_GROUP = R.TEAM_CODE
	WHERE A.MASTER_SEQ = @MASTER_SEQ AND A.BBS_SEQ = @BBS_SEQ AND DEL_YN = 'N'
		AND (
			DBO.XN_COM_GET_VGL_YN(@EMP_CODE) = 'Y' OR
			EXISTS(SELECT 1 FROM BBS_DETAIL_VIEW AA WITH(NOLOCK) WHERE AA.MASTER_SEQ = A.MASTER_SEQ AND AA.BBS_SEQ = A.BBS_SEQ AND AA.COM_TYPE = @COM_TYPE)
		)

	-- 덧글리스트
	SELECT A.*
		, DBO.XN_COM_GET_COM_TYPE(A.NEW_CODE) AS [COM_TYPE]
		, DBO.XN_COM_GET_TEAM_NAME(A.NEW_CODE) AS [AGT_NAME]
	FROM BBS_COMMENT A WITH(NOLOCK)
	WHERE A.MASTER_SEQ = @MASTER_SEQ AND A.BBS_SEQ = @BBS_SEQ-- AND DEL_YN = 'N'
	ORDER BY COMMENT_SEQ DESC

	-- 관련파일
	SELECT * FROM BBS_FILE A WITH(NOLOCK)
	WHERE A.MASTER_SEQ = @MASTER_SEQ AND A.BBS_SEQ = @BBS_SEQ
	
	/*
	지점 권한이 추가 
	*/
	IF @COM_TYPE != '99'
	BEGIN			
			IF SUBSTRING(@EMP_CODE,1,1) = 'L'  
			BEGIN
				-- 이전글
				SELECT TOP 1 * FROM BBS_DETAIL A WITH(NOLOCK) WHERE A.MASTER_SEQ = @MASTER_SEQ AND A.BBS_SEQ > @BBS_SEQ AND A.DEL_YN = 'N' AND A.NOTICE_YN = 'N' 
					AND EXISTS(SELECT 1 FROM BBS_DETAIL_VIEW AA WITH(NOLOCK) WHERE AA.MASTER_SEQ = A.MASTER_SEQ AND AA.BBS_SEQ = A.BBS_SEQ AND AA.COM_TYPE IN (121, @AREA_CODE))
					AND EXISTS(SELECT 1 FROM BBS_DETAIL_VIEW AA WITH(NOLOCK) WHERE AA.MASTER_SEQ = A.MASTER_SEQ AND AA.BBS_SEQ = A.BBS_SEQ AND AA.COM_TYPE =12)
				ORDER BY A.BBS_SEQ ASC

				-- 다음글
				SELECT TOP 1 * FROM BBS_DETAIL A WITH(NOLOCK) WHERE A.MASTER_SEQ = @MASTER_SEQ AND A.BBS_SEQ < @BBS_SEQ AND A.DEL_YN = 'N' AND A.NOTICE_YN = 'N'
				   AND EXISTS(SELECT 1 FROM BBS_DETAIL_VIEW AA WITH(NOLOCK) WHERE AA.MASTER_SEQ = A.MASTER_SEQ AND AA.BBS_SEQ = A.BBS_SEQ AND AA.COM_TYPE IN (121, @AREA_CODE))
				   AND EXISTS(SELECT 1 FROM BBS_DETAIL_VIEW AA WITH(NOLOCK) WHERE AA.MASTER_SEQ = A.MASTER_SEQ AND AA.BBS_SEQ = A.BBS_SEQ AND AA.COM_TYPE = 12)
				ORDER BY A.BBS_SEQ DESC
			END 
			ELSE
			BEGIN
				-- 이전글
				SELECT TOP 1 * FROM BBS_DETAIL A WITH(NOLOCK) WHERE A.MASTER_SEQ = @MASTER_SEQ AND A.BBS_SEQ > @BBS_SEQ AND DEL_YN = 'N' AND A.NOTICE_YN = 'N' 
					AND EXISTS(SELECT 1 FROM BBS_DETAIL_VIEW AA WITH(NOLOCK) WHERE AA.MASTER_SEQ = A.MASTER_SEQ AND AA.BBS_SEQ = A.BBS_SEQ AND AA.COM_TYPE = @COM_TYPE) -- 2013.05.09 정연주 추가	
				ORDER BY A.BBS_SEQ ASC

				-- 다음글
				SELECT TOP 1 * FROM BBS_DETAIL A WITH(NOLOCK) WHERE A.MASTER_SEQ = @MASTER_SEQ AND A.BBS_SEQ < @BBS_SEQ AND DEL_YN = 'N' AND A.NOTICE_YN = 'N'
				   AND EXISTS(SELECT 1 FROM BBS_DETAIL_VIEW AA WITH(NOLOCK) WHERE AA.MASTER_SEQ = A.MASTER_SEQ AND AA.BBS_SEQ = A.BBS_SEQ AND AA.COM_TYPE = @COM_TYPE) -- 2013.05.09 정연주 추가
				ORDER BY A.BBS_SEQ DESC
			END 
	END 	
	ELSE
	BEGIN
			-- 이전글
			SELECT TOP 1 * FROM BBS_DETAIL A WITH(NOLOCK) WHERE A.MASTER_SEQ = @MASTER_SEQ AND A.BBS_SEQ > @BBS_SEQ AND DEL_YN = 'N' AND A.NOTICE_YN = 'N' 				
			ORDER BY A.BBS_SEQ ASC

			-- 다음글
			SELECT TOP 1 * FROM BBS_DETAIL A WITH(NOLOCK) WHERE A.MASTER_SEQ = @MASTER_SEQ AND A.BBS_SEQ < @BBS_SEQ AND DEL_YN = 'N' AND A.NOTICE_YN = 'N'			  
			ORDER BY A.BBS_SEQ DESC
	END 

END


GO
