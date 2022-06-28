USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*================================================================================================================
■ USP_NAME					: XP_WEB_CUS_MEMBER_SELECT
■ DESCRIPTION				: 회원가입 정보 조회
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	exec  XP_WEB_CUS_MEMBER_SELECT 12048798 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-23		박형만			최초생성
   2013-10-02		박형만			포인트동의여부 추가
   2015-03-03		김성호			주민번호 삭제, 생년월일 사용
   2017-07-17		박형만			휴면회원의 경우 제대로 표시하기 
   2018-03-21		박형만			수정일,본인 인증여부 표시 
   2018-05-02		박형만			JOIN_TYPE 추가 
   2018-07-27		박형만			휴대폰 인증 PHONE_AUTH , SNS_MEM_YN
   2019-12-26		오준혁			법정대리인 동의 정보  
   2021-01-27		김영민			FORMEMBER_YN 평생회원컬럼추가 
================================================================================================================*/ 
CREATE PROC [dbo].[XP_WEB_CUS_MEMBER_SELECT]
	@CUS_NO INT 
AS 
BEGIN
	

--DECLARE @CUS_NO INT 
--SET @CUS_NO = 4228549 ;
	WITH  LIST AS (
		SELECT
			A.CUS_NO, A.CUS_ID, A.CUS_PASS, A.CUS_NAME, A.FIRST_NAME, A.LAST_NAME,
			A.NICKNAME, A.CUS_ICON, A.EMAIL, A.GENDER,
			--A.SOC_NUM1, damo.dbo.dec_varchar('DIABLO','dbo.CUS_CUSTOMER','SOC_NUM2', A.SEC_SOC_NUM2) AS SOC_NUM2,
			A.NOR_TEL1, A.NOR_TEL2, A.NOR_TEL3, A.HOM_TEL1, A.HOM_TEL2, A.HOM_TEL3,
			A.BIRTHDAY, A.LUNAR_YN,
			A.ADDRESS1, A.ADDRESS2, A.ZIP_CODE,
			A.VSOC_NUM, A.IPIN_DUP_INFO, A.IPIN_CONN_INFO, A.POINT_CONSENT ,
			A.SAFE_ID , A.BIRTH_DATE , A.OCB_AGREE_YN , A.OCB_AGREE_DATE , A.OCB_AGREE_EMP_CODE , A.OCB_CARD_NUM , 
			DAMO.dbo.dec_varchar('DIABLO','dbo.CUS_CUSTOMER','PASS_NUM', A.SEC_PASS_NUM) AS PASS_NUM , A.PASS_EXPIRE  , 
			A.EDT_DATE  , A.CERT_YN , A.POINT_CONSENT_DATE , JOIN_TYPE , 
			A.PHONE_AUTH_YN ,A.PHONE_AUTH_DATE, A.SNS_MEM_YN
			   -- 만14세 미만이고 법정대리인 동의없는 경우
			  ,CASE 
					WHEN ISNULL(A.BIRTH_DATE ,'') <> '' AND DATEDIFF(YEAR ,A.BIRTH_DATE ,GETDATE()) < 15 AND ISNULL(B.CUS_NO ,0) = 0 THEN 'Y'
					ELSE 'N'
			   END 'PARENT_AGREE_NEED_YN'
			  ,B.CUS_PARENT_NAME  AS 'PARENT_AGREE_NAME'
			  ,B.NOR_TEL1 AS 'PARENT_AGREE_TEL1'
			  ,B.NOR_TEL2 AS 'PARENT_AGREE_TEL2'
			  ,B.NOR_TEL3 AS 'PARENT_AGREE_TEL3'
			  ,B.NEW_DATE AS 'PARENT_AGREE_DATE'	
			  ,A.FORMEMBER_YN			
		FROM dbo.CUS_MEMBER A WITH (NOLOCK)
		   LEFT JOIN dbo.CUS_PARENT_AGREE B WITH(NOLOCK)
				ON  A.CUS_NO = B.CUS_NO
		WHERE A.CUS_NO = @CUS_NO 
		UNION ALL 
		SELECT
			A.CUS_NO, A.CUS_ID, A.CUS_PASS, A.CUS_NAME, A.FIRST_NAME, A.LAST_NAME,
			A.NICKNAME, A.CUS_ICON, A.EMAIL, A.GENDER,
			--A.SOC_NUM1, damo.dbo.dec_varchar('DIABLO','dbo.CUS_CUSTOMER','SOC_NUM2', A.SEC_SOC_NUM2) AS SOC_NUM2,
			A.NOR_TEL1, A.NOR_TEL2, A.NOR_TEL3, A.HOM_TEL1, A.HOM_TEL2, A.HOM_TEL3,
			A.BIRTHDAY, A.LUNAR_YN,
			A.ADDRESS1, A.ADDRESS2, A.ZIP_CODE,
			A.VSOC_NUM, A.IPIN_DUP_INFO, A.IPIN_CONN_INFO, A.POINT_CONSENT ,
			A.SAFE_ID , A.BIRTH_DATE , A.OCB_AGREE_YN , A.OCB_AGREE_DATE , A.OCB_AGREE_EMP_CODE , A.OCB_CARD_NUM , 
			DAMO.dbo.dec_varchar('DIABLO','dbo.CUS_CUSTOMER','PASS_NUM', (SELECT SEC_PASS_NUM FROM CUS_MEMBER WHERE CUS_NO = A.CUS_NO )) AS PASS_NUM , A.PASS_EXPIRE   , 
			A.EDT_DATE ,A.CERT_YN  , A.POINT_CONSENT_DATE  , JOIN_TYPE,
			A.PHONE_AUTH_YN ,A.PHONE_AUTH_DATE, A.SNS_MEM_YN
			   -- 만14세 미만이고 법정대리인 동의없는 경우
			  ,CASE 
					WHEN ISNULL(A.BIRTH_DATE ,'') <> '' AND DATEDIFF(YEAR ,A.BIRTH_DATE ,GETDATE()) < 15 AND ISNULL(B.CUS_NO ,0) = 0 THEN 'Y'
					ELSE 'N'
			   END 'PARENT_AGREE_NEED_YN'
			  ,B.CUS_PARENT_NAME  AS 'PARENT_AGREE_NAME'
			  ,B.NOR_TEL1 AS 'PARENT_AGREE_TEL1'
			  ,B.NOR_TEL2 AS 'PARENT_AGREE_TEL2'
			  ,B.NOR_TEL3 AS 'PARENT_AGREE_TEL3'
			  ,B.NEW_DATE AS 'PARENT_AGREE_DATE'	
			  ,A.FORMEMBER_YN			
		FROM CUS_MEMBER_SLEEP A
		   LEFT JOIN dbo.CUS_PARENT_AGREE B WITH(NOLOCK)
				ON  A.CUS_NO = B.CUS_NO
		WHERE A.CUS_NO = @CUS_NO 
	)  
	SELECT TOP 1 A.*
	      ,B.WEDDING_YN
	      ,B.WEDDING_DATE
	      ,B.MATE_BIRTHDAY
	      ,B.MATE_LUNAR_YN
	      ,B.HOPE_REGION
	      ,B.TRAVEL_TYPE
	      ,B.PASS_IMG_PATH
	      ,B.PASS_IMG_URL
	      ,B.INFLOW_ROUTE
	      ,C.RCV_EMAIL_YN
	      ,C.RCV_SMS_YN
	      ,C.EMAIL_AGREE_DATE
	      ,C.SMS_AGREE_DATE
	      ,C.EMAIL_INFLOW_TYPE
	      ,C.SMS_INFLOW_TYPE
	      ,(
	           SELECT PUB_VALUE
	           FROM   COD_PUBLIC
	           WHERE  PUB_TYPE = 'CUS.RCV.INFLOW.TYPE'
	                  AND PUB_CODE = C.EMAIL_INFLOW_TYPE
	       ) AS [EMAIL_INFLOW_STRING]
	      ,(
	           SELECT PUB_VALUE
	           FROM   COD_PUBLIC
	           WHERE  PUB_TYPE = 'CUS.RCV.INFLOW.TYPE'
	                  AND PUB_CODE = C.SMS_INFLOW_TYPE
	       ) AS [SMS_INFLOW_STRING]
	FROM   LIST A WITH(NOLOCK)
	       LEFT JOIN CUS_ADDITION B WITH(NOLOCK)
	            ON  A.CUS_NO = B.CUS_NO
	       LEFT JOIN CUS_CUSTOMER_damo C WITH(NOLOCK)
	            ON  A.CUS_NO = C.CUS_NO
	WHERE  A.CUS_NO = @CUS_NO
	       AND A.CUS_ID IS NOT NULL
	ORDER BY
	       CUS_NO ASC 


END 

GO
