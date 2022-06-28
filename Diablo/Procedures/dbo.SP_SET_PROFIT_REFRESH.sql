USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: SP_SET_PROFIT_REFRESH
■ Description				: 정산수익 조정과 관련하여 현재 예약데이타를 가지고 관련 부서를 가져온다.
■ Input Parameter			:                  
	@PRO_CODE				: 행사코드
	@NEW_CODE				: 직원코드
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 

	EXEC SP_SET_PROFIT_REFRESH 'JPP162-190106', '2008011'
	
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2010-01-28		이규식			최초생성
	2015-01-13		김성호			호텔 수동 예약 이동을 위해 예약 코드 중복 시 행사코드를 업데이트 한다.
	2017-05-22		김성호			70% 수익 대리점 조정 (부산, 대구만 남기고 삭제)
	2018-07-25		박형만			대전지점추가
	2019-01-07		김성호			지점 수익분배 방식 변경으로 인한 코드 등록
--	2019-05-29		김성호			정산마감시에는 갱신하지 않는다
-------------------------------------------------------------------------------------------------*/ 
CREATE PROCEDURE [dbo].[SP_SET_PROFIT_REFRESH]
	@PRO_CODE VARCHAR(20),
	@NEW_CODE CHAR(7)
AS
BEGIN

	--IF EXISTS(SELECT 1 FROM SET_MASTER A WITH(NOLOCK) WHERE A.PRO_CODE = @PRO_CODE AND A.SET_STATE <> 2)
	--BEGIN
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		-- SET_PROFIT에 예약코드가 존재하는 경우 (이동으로 인해 행사코드가 달라진 경우 업데이트 EX) 호텔 수동 이동 시 발생)
		UPDATE A SET A.PRO_CODE = B.PRO_CODE, A.PROFIT_RATE = (CASE WHEN B.PROFIT_TEAM_CODE IN ('514', '568','624','627') THEN 70 ELSE 100 END)
			, A.EDT_CODE = @NEW_CODE, A.EDT_DATE = GETDATE()
		FROM SET_PROFIT A
		INNER JOIN RES_MASTER_damo B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
		WHERE A.RES_CODE IN (SELECT RES_CODE FROM RES_MASTER_damo AA WHERE AA.PRO_CODE = @PRO_CODE AND AA.RES_STATE <= 7)

		-- 신규 등록
		INSERT SET_PROFIT(PRO_CODE, RES_CODE, PROFIT_RATE, NEW_CODE)
		SELECT @PRO_CODE, RES_CODE, (CASE WHEN A.PROFIT_TEAM_CODE IN ('514','568','624','627') THEN 70 ELSE 100 END), @NEW_CODE 
		FROM RES_MASTER_damo A WITH(NOLOCK)
		WHERE A.PRO_CODE = @PRO_CODE AND A.RES_STATE <= 7
			AND RES_CODE NOT IN (
				SELECT RES_CODE FROM SET_PROFIT WHERE RES_CODE IN (
					SELECT RES_CODE FROM RES_MASTER_damo WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE
				)
			)

		-------------------------------------------------------
		---- 지점수수료 업데이트
		UPDATE A SET A.BRANCH_RATE = ISNULL(B.BRANCH_RATE, 0)
		FROM SET_PROFIT A
		INNER JOIN RES_PKG_DETAIL B ON A.RES_CODE = B.RES_CODE 
		WHERE A.PRO_CODE = @PRO_CODE AND A.BRANCH_RATE <> B.BRANCH_RATE
		-------------------------------------------------------
	
		--INSERT SET_PROFIT(PRO_CODE, RES_CODE, PROFIT_RATE, NEW_CODE)
		--SELECT @PRO_CODE, RES_CODE, (CASE WHEN A.PROFIT_TEAM_CODE IN ('514', '515', '516') THEN 70 ELSE 100 END), @NEW_CODE 
		--FROM RES_MASTER_damo A WITH(NOLOCK)
		--WHERE A.PRO_CODE = @PRO_CODE AND A.RES_STATE <= 7 AND NOT EXISTS (
		--	SELECT * FROM SET_PROFIT Z WHERE Z.RES_CODE IN (SELECT RES_CODE FROM SET_PROFIT WHERE PRO_CODE = @PRO_CODE AND RES_STATE <= 7)
		--)

		-- SET_PROFIT에는 존재하지만 RES_MASTER_damo에서 변경된 경우 SET_PROFIT의 해당 팀을 삭제한다.
		-- 취소된 정산수익 정보는 삭제
		DELETE FROM SET_PROFIT WHERE PRO_CODE = @PRO_CODE AND EXISTS (SELECT * FROM RES_MASTER_damo Z WHERE Z.RES_CODE= SET_PROFIT.RES_CODE AND Z.RES_STATE > 7)
	--END

END
GO
