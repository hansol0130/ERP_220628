USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ Server					: 
■ Database					: DIABLO
■ USP_Name					: XP_AGT_LOGIN_SELECT
■ Description				: 로그인페이지에서 로그인아이디에 따른 기본정보 조회
■ Input Parameter			:                  
		@AGT_ID				: 로그인아이디
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: EXEC XP_AGT_LOGIN_SELECT 'A130001', '1111'
■ Author					: 이규식  
■ Date						: 2013-02-16
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2013-02-13		이규식			최초생성  
	2013-03-18		정지용			거래처가 정지일 때 로그인 안됨
-------------------------------------------------------------------------------------------------*/ 

 CREATE PROCEDURE [dbo].[XP_AGT_LOGIN_SELECT] 
 ( 
     @MEM_CODE	CHAR(7),
	 @PASSWORD  varchar(30)
) 
AS 
BEGIN 
	-- 거래처가 운영중일때만..
	IF NOT EXISTS(
		SELECT 1 FROM AGT_MEMBER A WITH(NOLOCK)
		INNER JOIN AGT_MASTER B WITH(NOLOCK) ON B.AGT_CODE = A.AGT_CODE
		WHERE A.MEM_CODE = @MEM_CODE AND A.PASSWORD = @PASSWORD
			--AND B.AGT_TYPE_CODE IN ('50')
			AND A.WORK_TYPE NOT IN ('2', '5')
			AND BLOCK_COUNT < 5
			AND B.SHOW_YN = 'Y'
	)
	BEGIN
		RETURN;
	END

 
	IF EXISTS(
		SELECT 1 FROM AGT_MEMBER A WITH(NOLOCK)
		INNER JOIN AGT_MASTER B WITH(NOLOCK) ON B.AGT_CODE = A.AGT_CODE
		WHERE A.MEM_CODE = @MEM_CODE AND A.PASSWORD = @PASSWORD
			--AND B.AGT_TYPE_CODE IN ('50')
			AND A.WORK_TYPE NOT IN ('2', '5')
			AND BLOCK_COUNT < 5
		)
	BEGIN
		-- 로그인 정보의 BLOCK 카운트를 초기화 시킨다.
		UPDATE AGT_MEMBER 
		SET BLOCK_COUNT = 0
		WHERE MEM_CODE = @MEM_CODE;

		-- 로그인이 성공했을 경우 로그인 정보를 넘겨준다.
		SELECT 
			A.AGT_CODE,
			B.KOR_NAME AS AGT_NAME,
			B.AGT_TYPE_CODE,
			A.MEM_CODE,
			A.KOR_NAME,
			A.MEM_TYPE,
			A.TEAM_NAME,
			A.POS_NAME,
			A.EMAIL,
			A.HP_NUMBER1,
			A.HP_NUMBER2,
			A.HP_NUMBER3,
			B.AREA_CODE
		FROM AGT_MEMBER A WITH(NOLOCK)
		INNER JOIN AGT_MASTER B WITH(NOLOCK) ON B.AGT_CODE = A.AGT_CODE
		WHERE A.MEM_CODE = @MEM_CODE AND A.PASSWORD = @PASSWORD
			--AND B.AGT_TYPE_CODE IN ('50')
			AND A.WORK_TYPE NOT IN ('2', '5')
			AND BLOCK_COUNT < 5


	END
	BEGIN
		-- 로그인 정보가 틀렸을 경우 해당 BLOCK 의 카운트를 증가시킨다.
		UPDATE AGT_MEMBER 
		SET BLOCK_COUNT = ISNULL(BLOCK_COUNT, 0) + 1
		WHERE MEM_CODE = @MEM_CODE
	END

END 
GO
