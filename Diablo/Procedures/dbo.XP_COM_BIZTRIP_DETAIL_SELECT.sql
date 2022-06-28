USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	
/*================================================================================================================
■ USP_NAME					: XP_COM_BIZTRIP_DETAIL_SELECT
■ DESCRIPTION				: 출장예약디테일 조회 
■ INPUT PARAMETER			: 
	
	XP_COM_BIZTRIP_DETAIL_SELECT 'BT1606210458' , ''
	XP_COM_BIZTRIP_DETAIL_SELECT '' , 'RP1605167982'

■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-03-16		박형만			최초생성    
   2016-04-07		박형만			후불결제 거래처 여부 가져오기
   2016-05-18		박형만			출장자 EMP_SEQ 가져오기 
   2016-06-01		박형만			취소된 내역도 EMP_SEQ 보이도록 수정 
   2016-06-22		박형만			RES_MASTER 의 매핑된 EMP_SEQ 가져오기 
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_BIZTRIP_DETAIL_SELECT]
(
	@BT_CODE	varchar(20),
	@RES_CODE	varchar(20)  --
)
AS 
BEGIN

	IF( ISNULL(@BT_CODE,'') <> '')
	BEGIN
		SELECT A.* ,  B.PAY_LATER_YN ,B.PAY_LATER_YN AS PAY_LATER_COM_YN  
			,STUFF((
				SELECT (',' + CONVERT(VARCHAR,ISNULL(BB.EMP_SEQ,'')) ) AS [text()]
				FROM RES_CUSTOMER_damo AA 
					INNER JOIN COM_EMPLOYEE_MATCHING BB 
						ON A.AGT_CODE = BB.AGT_CODE 
						AND AA.CUS_NO = BB.CUS_NO 
				WHERE A.RES_CODE = AA.RES_CODE 
				--AND RES_STATE = 0 -- 취소된 예약도 보이도록 수정 
				GROUP BY BB.EMP_SEQ  
				FOR XML PATH('')), 1, 1, '') AS CUS_EMP_SEQ  
			, D.EMP_SEQ AS RES_EMP_SEQ 
		FROM COM_BIZTRIP_DETAIL A WITH(NOLOCK)
			INNER JOIN AGT_MASTER B 
				ON A.AGT_CODE = B.AGT_CODE 

			LEFT JOIN  RES_MASTER_DAMO C 
				ON A.RES_CODE = C.RES_CODE 
			LEFT JOIN COM_EMPLOYEE_MATCHING D 
				ON A.AGT_CODE = D.AGT_CODE 
				AND C.CUS_NO = D.CUS_NO 
			
		WHERE BT_CODE = @BT_CODE 
		ORDER BY BT_RES_SEQ ASC 
	END 
	ELSE IF( ISNULL(@RES_CODE,'') <> '')
	BEGIN
		SELECT A.* , B.PAY_LATER_YN ,B.PAY_LATER_YN AS PAY_LATER_COM_YN 
			,STUFF((
			SELECT (',' + CONVERT(VARCHAR,ISNULL(BB.EMP_SEQ,'')) ) AS [text()]
			FROM RES_CUSTOMER_damo AA 
				INNER JOIN COM_EMPLOYEE_MATCHING BB 
					ON A.AGT_CODE = BB.AGT_CODE 
					AND AA.CUS_NO = BB.CUS_NO 
			WHERE A.RES_CODE = AA.RES_CODE 
			--AND RES_STATE = 0 -- 취소된 예약도 보이도록 수정 
			GROUP BY BB.EMP_SEQ  
			FOR XML PATH('')), 1, 1, '') AS CUS_EMP_SEQ  
			, D.EMP_SEQ AS RES_EMP_SEQ 
		FROM COM_BIZTRIP_DETAIL A WITH(NOLOCK)
			INNER JOIN AGT_MASTER B 
				ON A.AGT_CODE = B.AGT_CODE 

			LEFT JOIN  RES_MASTER_DAMO C 
				ON A.RES_CODE = C.RES_CODE 
			LEFT JOIN COM_EMPLOYEE_MATCHING D 
				ON A.AGT_CODE = D.AGT_CODE 
				AND C.CUS_NO = D.CUS_NO

		WHERE A.RES_CODE = @RES_CODE 	
		
	END 
END 

GO
