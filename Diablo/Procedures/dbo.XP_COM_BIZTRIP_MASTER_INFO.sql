USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_BIZTRIP_MASTER_INFO
■ DESCRIPTION				: 출장예약마스터 조회 - 상태 조회를 위해 간단한 마스터 테이블 조회 필요
■ INPUT PARAMETER			: 
	@BT_CODE				: 출장코드
	@AGT_CODE				: 로그인한사람 회사코드
	@EMP_SEQ				: 로그인한사람 직원코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	XP_COM_BIZTRIP_MASTER_INFO 'BT1606280466', '93881', 104
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-03-31		박형만			최초생성    
   2016-10-31		이유라			날짜와 규정에 따른 출장추가 조건 수정(XP_COM_BIZTRIP_MASTER_ARRANGE_LIST 조건 참고)
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_BIZTRIP_MASTER_INFO]
(
	@BT_CODE VARCHAR(20), 
	@AGT_CODE VARCHAR(10) = NULL,
	@EMP_SEQ INT = 0
)
AS 
BEGIN

	DECLARE @CONFIRM_YN CHAR(1)
	SET @CONFIRM_YN =  
		ISNULL((SELECT TOP 1 B.CONFIRM_YN  FROM DBO.FN_COM_BIZTRIP_GROUP_INFO(@AGT_CODE, @EMP_SEQ) A 
			INNER JOIN COM_BIZTRIP_GROUP B ON A.BT_SEQ = B.BT_SEQ AND A.AGT_CODE = B.AGT_CODE 
		ORDER BY A.ORDER_NUM),'N')  -- 사용되는 규정이 없으면 전부 승인 필요없음 

	SELECT @CONFIRM_YN AS CONFIRM_YN, T.BT_CODE ,APPROVAL_STATE
	FROM 
	(
		SELECT A.*, C.RES_STATE 
		FROM COM_BIZTRIP_MASTER A WITH(NOLOCK)  
		LEFT JOIN COM_BIZTRIP_DETAIL B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE AND A.BT_CODE = B.BT_CODE 
		LEFT JOIN RES_MASTER_damo C WITH(NOLOCK) ON B.RES_CODE = C.RES_CODE AND C.RES_STATE NOT IN (7,8,9) 
		WHERE 
			A.AGT_CODE = @AGT_CODE AND A.BT_START_DATE > GETDATE() -- 출발하지 않은
			AND (( @CONFIRM_YN = 'N' AND A.APPROVAL_STATE IN (0,1,2) ) -- 출장대기,요청,확정   출장대기 = 0, 출장요청 = 1, 출장확정 = 2, 출장반려 = 9
				OR ( @CONFIRM_YN = 'Y' AND A.APPROVAL_STATE IN (0) )) -- 출장대기만   출장대기 = 0, 출장요청 = 1, 출장확정 = 2, 출장반려 = 9
			AND A.BT_START_DATE >=  DATEADD(DD,1,CONVERT(VARCHAR(10),GETDATE(),121))  --현재일 +1일 뒤 출발건 부터
			AND A.NEW_SEQ = @EMP_SEQ  
			AND C.RES_STATE IS NOT NULL --전체 취소된 출장건은 제외 조건 추가
			AND A.BT_CODE = @BT_CODE 
	) T 
	GROUP BY T.BT_CODE , APPROVAL_STATE

	--2016-10-31 수정 이전 쿼리
	--SELECT * FROM COM_BIZTRIP_MASTER WITH(NOLOCK)
	--WHERE BT_CODE = @BT_CODE 
END 
GO
