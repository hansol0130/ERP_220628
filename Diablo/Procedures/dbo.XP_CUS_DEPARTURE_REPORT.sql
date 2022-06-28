USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_CUS_DEPARTURE_REPORT
■ DESCRIPTION				: 예약출발자 조회 프로시저 (고객서비스, 마케팅용)
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
XP_CUS_DEPARTURE_REPORT '2019-12-01', '2019-12-10', 'M' ,'A','T1'	

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
 2019-07-19         김남훈          최초생성
 2019-07-22         김남훈          2터미널 출발자 이용항공으로 제거
 2019-09-02         김남훈          14세미만 어린이 제거
 2020-01-03         박형만          수신거부여부 추가 
 2020-01-30         오준혁          적립액 추가
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[XP_CUS_DEPARTURE_REPORT]
(
	@START_DATE VARCHAR(10),
	@END_DATE VARCHAR(10),
	@MEMBER VARCHAR(2),
	@PRO_TYPE VARCHAR(2),
	@TERMINAL VARCHAR(2),
	@CHILD VARCHAR(2) = 'A'
)
AS  
BEGIN
	
	--DECLARE @START_DATE VARCHAR(10),
	--@END_DATE VARCHAR(10),
	--@MEMBER VARCHAR(2),
	--@PRO_TYPE VARCHAR(2),
	--@TERMINAL VARCHAR(2),
	--@CHILD VARCHAR(2)  
	
	--SELECT @START_DATE =  '2019-11-10', @END_DATE =  '2019-11-30', @MEMBER = 'M' ,@PRO_TYPE = 'P',@TERMINAL = 'AA' , @CHILD = 'A'	
	
	
	IF(@TERMINAL = 'AA')
	BEGIN
		SELECT 
			RC.CUS_NO, 
			RC.CUS_NAME,
			CONVERT(VARCHAR(10),RC.BIRTH_DATE,121) AS BIRTH_DATE,
			RC.NOR_TEL1, 
			RC.NOR_TEL2, 
			RC.NOR_TEL3, 
			RC.NOR_TEL1 + RC.NOR_TEL2 + RC.NOR_TEL3 AS NOR_TEL, 
			RC.RES_CODE, 
			VM.CUS_ID,
			CONVERT(VARCHAR(10),RM.DEP_DATE,121) AS DEP_DATE, 
			CONVERT(VARCHAR(10),RM.ARR_DATE,121) AS ARR_DATE,
			RM.PRO_CODE,
			RM.PROFIT_TEAM_NAME,
			(SELECT EM.KOR_NAME FROM PKG_DETAIL PD WITH(NOLOCK) INNER JOIN EMP_MASTER_damo EM WITH(NOLOCK) ON PD.NEW_CODE = EM.EMP_CODE WHERE PD.PRO_CODE = RM.PRO_CODE) AS NEW_NAME,
			CASE WHEN (SELECT COUNT(*)  FROM  CUS_REJECT WITH(NOLOCK) WHERE 거부신청번호 = RC.NOR_TEL1 + '-' + RC.NOR_TEL2 + '-' + RC.NOR_TEL3) > 0 THEN 'Y' ELSE 'N' END   REJECT_YN,-- 문자 수신 거부 여부  
			CASE WHEN CC.CUS_ID IS NULL THEN  '-'  WHEN ISNULL(CC.RCV_SMS_YN,'N') <> 'Y' THEN 'Y' ELSE 'N' END AS RCV_REJECT_YN,   -- 마케팅 SMS 수신 거부 여부 
			IIF(ISNULL(RC.POINT_YN, 'N') = 'N', 0, RC.POINT_PRICE) AS 'POINT_PRICE' -- 포인트 적립액
		FROM RES_CUSTOMER_DAMO RC WITH(NOLOCK)
			INNER JOIN RES_MASTER_DAMO RM WITH(NOLOCK)
				ON RC.RES_CODE = RM.RES_CODE
			LEFT JOIN VIEW_MEMBER VM WITH(NOLOCK)
				ON VM.CUS_NO = RC.CUS_NO
			LEFT JOIN CUS_CUSTOMER_DAMO CC WITH(NOLOCK)
				ON CC.CUS_NO = RC.CUS_NO
			LEFT JOIN CUS_REJECT CR WITH(NOLOCK)
				ON RC.NOR_TEL1 + '-' + RC.NOR_TEL2 + '-' + RC.NOR_TEL3   = CR.거부신청번호  
				
		WHERE RM.DEP_DATE BETWEEN @START_DATE AND @END_DATE
			AND RM. RES_STATE < 7 AND RC.RES_STATE = 0
			AND RC.SALE_PRICE <> 0		
			AND LEN(RC.NOR_TEL1 + RC.NOR_TEL2 + RC.NOR_TEL3) > 9
			AND RC.NOR_TEL1 + RC.NOR_TEL2 + RC.NOR_TEL3 not like '0100%'
			AND RC.NOR_TEL1 + RC.NOR_TEL2 + RC.NOR_TEL3 not like '0101%'
			AND ((@MEMBER = 'M' AND VM.CUS_NO IS NOT NULL) OR 	
				(@MEMBER = 'N' AND VM.CUS_NO IS NULL))			
			AND ((@PRO_TYPE = 'P' AND RM.RES_CODE LIKE 'RP%')  OR (@PRO_TYPE = 'A'))
			AND ((@CHILD = 'I' AND RC.BIRTH_DATE < CONCAT(DATEPART(YY,DATEADD(YY,-14,GETDATE())), '-01-01'))  OR (@CHILD = 'A'))
		ORDER BY CONVERT(VARCHAR(10),RM.DEP_DATE,121)

	END
	ELSE IF(@TERMINAL = 'T1')
	BEGIN
		SELECT * FROM 
		(
			SELECT 
					RC.CUS_NO,
					RC.CUS_NAME,
					CONVERT(VARCHAR(10),RC.BIRTH_DATE,121) AS BIRTH_DATE,
					RC.NOR_TEL1,
					RC.NOR_TEL2,
					RC.NOR_TEL3, 
					RC.NOR_TEL1 + RC.NOR_TEL2 + RC.NOR_TEL3 AS NOR_TEL,
					RC.RES_CODE, 
					CC.CUS_ID,
					CONVERT(VARCHAR(10),RM.DEP_DATE,121) AS DEP_DATE,
					CONVERT(VARCHAR(10),RM.ARR_DATE,121) AS ARR_DATE,
					PTS.DEP_TRANS_CODE,
					CASE WHEN (SELECT COUNT(*)  FROM  CUS_REJECT WITH(NOLOCK) WHERE 거부신청번호 = RC.NOR_TEL1 + '-' + RC.NOR_TEL2 + '-' + RC.NOR_TEL3) > 0 THEN 'Y' ELSE 'N' END   REJECT_YN,
					CASE WHEN CC.CUS_ID IS NULL THEN  '-'  WHEN ISNULL(CC.RCV_SMS_YN,'N') <> 'Y' THEN 'Y' ELSE 'N' END AS RCV_REJECT_YN,
					IIF(ISNULL(RC.POINT_YN, 'N') = 'N', 0, RC.POINT_PRICE) AS 'POINT_PRICE'
				FROM RES_MASTER_damo RM WITH(NOLOCK)
					INNER JOIN RES_CUSTOMER_damo RC	WITH(NOLOCK)
						ON RM.RES_CODE = RC.RES_CODE
					INNER JOIN PKG_DETAIL PD WITH(NOLOCK) 
						ON RM.PRO_CODE = PD.PRO_CODE
					INNER JOIN PRO_TRANS_SEAT PTS WITH(NOLOCK)
						ON PD.SEAT_CODE = PTS.SEAT_CODE
					LEFT JOIN CUS_CUSTOMER_damo CC WITH(NOLOCK)
						ON CC.CUS_NO = RC.CUS_NO
					LEFT JOIN CUS_REJECT CR WITH(NOLOCK)
						ON RC.NOR_TEL1 + '-' + RC.NOR_TEL2 + '-' + RC.NOR_TEL3   = CR.거부신청번호
					
				WHERE RM.DEP_DATE BETWEEN @START_DATE AND @END_DATE
					AND RC.RES_STATE = 0 
					AND RM.RES_STATE < 7
					AND PD.TRANSFER_TYPE = 1
					AND PTS.DEP_DEP_AIRPORT_CODE = 'ICN'
					AND RC.SALE_PRICE > 0
					AND PD.MEET_COUNTER < 4		
					AND LEN(RC.NOR_TEL1 + RC.NOR_TEL2 + RC.NOR_TEL3) > 9
					AND RC.NOR_TEL1 + RC.NOR_TEL2 + RC.NOR_TEL3 NOT LIKE '0100%'
					AND RC.NOR_TEL1 + RC.NOR_TEL2 + RC.NOR_TEL3 NOT LIKE '0101%'
					AND ((@PRO_TYPE = 'P' AND RM.RES_CODE LIKE 'RP%')  OR (@PRO_TYPE = 'A'))
		) A
		WHERE 
		-- 대한항공,델타항공,에어프랑스,네덜란드항공,에어로멕시코항공,이태리항공,중화항공,체코항공,하문항공,러시아항공,가루다항공
		A.DEP_TRANS_CODE NOT IN ('KE','DL','AF','KL','AM','AZ','CI','OK','MF','SU','GA')
		ORDER BY A.DEP_DATE

	END
END
GO
