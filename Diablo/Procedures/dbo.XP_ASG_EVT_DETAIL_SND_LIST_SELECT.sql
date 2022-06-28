USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: XP_ASG_EVT_DETAIL_SND_LIST_SELECT
■ DESCRIPTION				: 대외업무시스템 인솔자관리 배정행사 상세정보 발송내역 검색
■ INPUT PARAMETER			: 
	@PRO_CODE  VARCHAR(20)  : 행사코드
■ OUTPUT PARAMETER			: 
							: 
■ EXEC						: 
	DECLARE @PRO_CODE VARCHAR(20)
	        ,@FLAG int -- 0:SMS 1:EMAIL
			,@NEW_CODE	CHAR(7)
	SELECT @PRO_CODE='APP0504-130327TG5' , @FLAG= 1 ,@NEW_CODE	='T130001'

	exec XP_ASG_EVT_DETAIL_SND_LIST_SELECT @PRO_CODE ,@FLAG,@NEW_CODE
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-03-25		오인규			최초생성    
================================================================================================================*/ 


CREATE  PROCEDURE [dbo].[XP_ASG_EVT_DETAIL_SND_LIST_SELECT]
(
	 @PRO_CODE VARCHAR(20) 
	,@FLAG INT
	,@NEW_CODE CHAR(7)
)
AS  
BEGIN

	--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	IF @FLAG = 0  -- 0:SMS 1:EMAIL
	BEGIN
		SELECT
				A.SND_NO                         --  
				, A.SND_TYPE                       --  
				, A.SND_NUMBER                     --  
				, A.BODY                           --  
				, A.SND_RESULT                     --  
				, A.RCV_NUMBER1                    --  
				, A.RCV_NUMBER2                    --  
				, A.RCV_NUMBER3                    --  
				, A.RCV_NAME                       --  
				, A.NEW_CODE                       --  
				, A.NEW_DATE                       --  
				, A.SND_METHOD                     --  
				, A.SND_DATE                       --  
				, A.RES_CODE                       --  
				--A.SND_NO
				--,A.SND_TYPE --발송타입
				--,A.NEW_DATE -- 발송일
				--,A.NEW_CODE --발신자 
				--,DBO.XN_COM_GET_EMP_NAME(A.NEW_CODE) AS NEW_NAME--발신자명
				--,A.RCV_NAME --수신자명
				--,A.SND_RESULT --수신결과
				--,A.RCV_NUMBER1 -- 수신전화번호1
				--,A.RCV_NUMBER2 -- 수신전화번호2
				--,A.RCV_NUMBER3 -- 수신전화번호3
				--,A.SND_NUMBER -- 발송번호
				--,A.BODY
		FROM	dbo.RES_SND_SMS A WITH(NOLOCK)
		INNER JOIN dbo.RES_MASTER_damo B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE 
		WHERE	B.PRO_CODE = @PRO_CODE AND A.NEW_CODE = @NEW_CODE
		ORDER BY NEW_DATE DESC;
	END
	ElSE
	BEGIN
		SELECT
				A.SND_NO                         --  
				, A.SND_NAME                       --  
				, A.SND_EMAIL                      --  
				, A.RCV_NAME                       --  
				, A.RCV_EMAIL                      --  
				, A.CFM_YN                         --  
				, A.NEW_CODE                       --  
				, A.NEW_DATE                       --  
				, A.TITLE                          --  
				, A.BODY                           --  
				, A.CFM_DATE                       --  
				, A.SND_TYPE                       --  
				, A.REF_EMAIL                      --  
				, A.RES_CODE                       --  
				, A.CFM_HEADER                     --  
				, A.CFM_IP                         --  
				, A.DOC_NO                         --  
				--A.SND_NO
				--,A.SND_TYPE --발송타입
				--,A.NEW_DATE -- 발송일
				--,A.NEW_CODE --발신자 
				--,DBO.XN_COM_GET_EMP_NAME(A.NEW_CODE) AS NEW_NAME--발신자명
				--,A.RCV_EMAIL--수신메일
				--,A.RCV_NAME --수신자명
				--,A.CFM_DATE --수신일시 
				--,A.TITLE
				--,A.BODY
		FROM	dbo.RES_SND_EMAIL A WITH(NOLOCK)
		INNER JOIN dbo.RES_MASTER_damo B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE 
		WHERE	B.PRO_CODE = @PRO_CODE AND A.NEW_CODE = @NEW_CODE
		ORDER BY NEW_DATE DESC;
	END
END

GO
