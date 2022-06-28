USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: [XP_VOC_LIST_SELECT]
■ DESCRIPTION				: 고객의소리 메일 담당자 찾기
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

			EXEC [dbo].[XP_VOC_LIST_SELECT] 'RP2110209710'
								
			EXEC [dbo].[XP_VOC_LIST_SELECT] ''

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
	DATE			AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
	2019-05-31		김남훈			최초생성
	2021-01-18		오준혁			VIP고객센터팀 사내메일로 변경
	2022-03-30		김성호			담당자 중복 제거 및 정보 조회 위치 변경
	2022-04-27		이호철			팀코드 추가('540')
================================================================================================================*/ 
CREATE PROC [dbo].[XP_VOC_LIST_SELECT]

	@RES_CODE	VARCHAR(20)
	  
AS 
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	SELECT EL.NEW_CODE AS EMP_CODE
	      ,EMD.KOR_NAME
	      ,EMD.TEAM_CODE
	      ,ET.TEAM_NAME
	FROM   (
	           SELECT RMD.NEW_CODE
	           FROM   dbo.RES_MASTER_damo RMD
	           WHERE  RMD.RES_CODE = @RES_CODE
	           
	           UNION
	           SELECT RT.TEAM_EMP_CODE
	           FROM   dbo.RES_MASTER_damo RMD
	                  INNER JOIN EMP_TEAM RT
	                       ON  RMD.NEW_TEAM_CODE = RT.TEAM_CODE
	           WHERE  RMD.RES_CODE = @RES_CODE
	           
	           UNION
	           SELECT EMD.EMP_CODE
	           FROM   dbo.EMP_MASTER_damo EMD
	           WHERE  EMD.TEAM_CODE IN ('561', '540')	-- 팀코드 561: 회원관리팀
	                  AND EMD.WORK_TYPE = 1				-- 근무형태 1: 재직
	                  AND LEN(EMD.INNER_NUMBER3) > 0	-- 업무편의를 위해 생성된 직원 제외를 위해 내선번호 없는 직원 제외
	       ) EL
	       INNER JOIN dbo.EMP_MASTER_damo EMD
	            ON  EL.NEW_CODE = EMD.EMP_CODE
	       INNER JOIN dbo.EMP_TEAM ET
	            ON  EMD.TEAM_CODE = ET.TEAM_CODE;
END
GO
