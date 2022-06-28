USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_CUS_CUSTOMER_HISTORY_INSERT
■ DESCRIPTION				: 회원(비회원)정보 수정이력 저장 
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC		
				

	회원정보가 CUS_CUSTOMER , CUS_MEMBER , CUS_MEMBER_SLEEP 
	3군데에 나누어져 저장되어 있으므로 
	회원정보 우선으로 하여 기준으로 하고 HISTORY 를 저장한다 
	

	XP_CUS_CUSTOMER_HISTORY_INSERT @CUS_NO = 4228549, @CUS_NAME = '박형만3' ,  @EMP_CODE = '9999999' , @EDT_REMARK = '임시수정' , @EDT_TYPE  = 1 

	EDT_TYPE 
0	정보수정(사이트,ERP)
1	본인인증실명정보갱신(사이트,ERP)
2	아이디수동변경(WEB,ERP)
3	등급변경(ERP)
4	아이디수동변경
5	고객병합(WEB,ERP)
6	회원탈퇴(WEB,ERP)	


99	기타변경


■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2018-03-22		박형만			최초생성
   2018-04-18		박형만			등급변경 버그수정
   2020-07-27		유민석			영문성/이름 CASE 구문 삭제
   2021-08-19		김성호			CUS_MEMBER 조회 시 CUS_ID IS NOT NULL 조건 추가
================================================================================================================*/ 
CREATE PROC [dbo].[XP_CUS_CUSTOMER_HISTORY_INSERT]
(
    @CUS_NO INT
   ,@CUS_ID VARCHAR(20) = NULL
   ,@CUS_NAME VARCHAR(20) = NULL
   ,@BIRTH_DATE DATETIME = NULL
   ,@GENDER CHAR(1) = NULL
   ,@NOR_TEL1 VARCHAR(6) = NULL
   ,@NOR_TEL2 VARCHAR(5) = NULL
   ,@NOR_TEL3 VARCHAR(4) = NULL
   ,@EMAIL VARCHAR(40) = NULL
   ,@CUS_GRADE INT = NULL
   ,@IPIN_DUP_INFO CHAR(64) = NULL
   ,@IPIN_CONN_INFO CHAR(88) = NULL
   ,@LAST_NAME VARCHAR(20) = NULL
   ,@FIRST_NAME VARCHAR(20) = NULL
   ,@NICKNAME VARCHAR(20) = NULL
   ,@RCV_EMAIL_YN CHAR(1) = NULL
   ,@RCV_SMS_YN CHAR(1) = NULL
   ,@CUS_PASS VARCHAR(100) = NULL
   ,@CUS_STATE CHAR(1) = NULL
   ,@COM_TEL1 VARCHAR(6) = NULL
   ,@COM_TEL2 VARCHAR(5) = NULL
   ,@COM_TEL3 VARCHAR(4) = NULL
   ,@HOM_TEL1 VARCHAR(6) = NULL
   ,@HOM_TEL2 VARCHAR(5) = NULL
   ,@HOM_TEL3 VARCHAR(4) = NULL
   ,@NATIONAL CHAR(2) = NULL
   ,@FOREIGNER_YN VARCHAR(20) = NULL
   ,@ADDRESS1 VARCHAR(100) = NULL
   ,@ADDRESS2 VARCHAR(100) = NULL
   ,@ZIP_CODE VARCHAR(7) = NULL
   ,@POINT_CONSENT CHAR(1) = NULL
   ,@POINT_CONSENT_DATE DATETIME = NULL
   ,@JOIN_TYPE INT = 1
   ,@CERT_YN CHAR(1) = NULL
   ,--@HIS_DATE	DATETIME , 
    @EMP_CODE NEW_CODE = NULL
   ,@EDT_REMARK VARCHAR(100) = NULL
   ,@SYSTEM_TYPE INT = NULL
   ,@EDT_TYPE INT
) AS 
BEGIN
	--DECLARE @CUS_NO INT
	--SET @CUS_NO = 4228549 ;
	
	SELECT *
	INTO   #TMP_LIST
	FROM   (
	           SELECT 1 AS ROW_NUM	-- 정회원 1순위
	                 ,CUS_NO
	                 ,CUS_ID
	                 ,CUS_NAME
	                 ,BIRTH_DATE
	                 ,GENDER
	                 ,NOR_TEL1
	                 ,NOR_TEL2
	                 ,NOR_TEL3
	                 ,EMAIL
	                 ,CUS_GRADE
	                 ,IPIN_DUP_INFO
	                 ,IPIN_CONN_INFO
	                 ,LAST_NAME
	                 ,FIRST_NAME
	                 ,NICKNAME
	                 ,RCV_EMAIL_YN
	                 ,RCV_SMS_YN
	                 ,CUS_PASS
	                 ,CUS_STATE
	                 ,COM_TEL1
	                 ,COM_TEL2
	                 ,COM_TEL3
	                 ,HOM_TEL1
	                 ,HOM_TEL2
	                 ,HOM_TEL3
	                 ,[NATIONAL]
	                 ,FOREIGNER_YN
	                 ,ADDRESS1
	                 ,ADDRESS2
	                 ,ZIP_CODE
	                 ,POINT_CONSENT
	                 ,POINT_CONSENT_DATE
	                 ,CERT_YN
	           FROM   CUS_MEMBER WITH(NOLOCK)
	           WHERE  CUS_NO = @CUS_NO AND CUS_ID IS NOT NULL
	           UNION ALL 
	           SELECT 2 AS ROW_NUM	-- 휴면정회원 2순위
	                 ,CUS_NO
	                 ,CUS_ID
	                 ,CUS_NAME
	                 ,BIRTH_DATE
	                 ,GENDER
	                 ,NOR_TEL1
	                 ,NOR_TEL2
	                 ,NOR_TEL3
	                 ,EMAIL
	                 ,CUS_GRADE
	                 ,IPIN_DUP_INFO
	                 ,IPIN_CONN_INFO
	                 ,LAST_NAME
	                 ,FIRST_NAME
	                 ,NICKNAME
	                 ,RCV_EMAIL_YN
	                 ,RCV_SMS_YN
	                 ,CUS_PASS
	                 ,CUS_STATE
	                 ,COM_TEL1
	                 ,COM_TEL2
	                 ,COM_TEL3
	                 ,HOM_TEL1
	                 ,HOM_TEL2
	                 ,HOM_TEL3
	                 ,[NATIONAL]
	                 ,FOREIGNER_YN
	                 ,ADDRESS1
	                 ,ADDRESS2
	                 ,ZIP_CODE
	                 ,POINT_CONSENT
	                 ,POINT_CONSENT_DATE
	                 ,CERT_YN
	           FROM   CUS_MEMBER_SLEEP WITH(NOLOCK)
	           WHERE  CUS_NO = @CUS_NO
	           UNION ALL  
	           SELECT 3 AS ROW_NUM	-- 비회원정보 3순위
	                 ,CUS_NO
	                 ,CUS_ID
	                 ,CUS_NAME
	                 ,BIRTH_DATE
	                 ,GENDER
	                 ,NOR_TEL1
	                 ,NOR_TEL2
	                 ,NOR_TEL3
	                 ,EMAIL
	                 ,CUS_GRADE
	                 ,IPIN_DUP_INFO
	                 ,IPIN_CONN_INFO
	                 ,LAST_NAME
	                 ,FIRST_NAME
	                 ,NICKNAME
	                 ,RCV_EMAIL_YN
	                 ,RCV_SMS_YN
	                 ,CUS_PASS
	                 ,CUS_STATE
	                 ,COM_TEL1
	                 ,COM_TEL2
	                 ,COM_TEL3
	                 ,HOM_TEL1
	                 ,HOM_TEL2
	                 ,HOM_TEL3
	                 ,[NATIONAL]
	                 ,FOREIGNER_YN
	                 ,ADDRESS1
	                 ,ADDRESS2
	                 ,ZIP_CODE
	                 ,POINT_CONSENT
	                 ,POINT_CONSENT_DATE
	                 ,'N' AS CERT_YN
	           FROM   CUS_CUSTOMER_DAMO WITH(NOLOCK)
	           WHERE  CUS_NO = @CUS_NO
	       ) T 
	--SELECT * FROM LIST
	--ORDER BY ROW_NUM
	--INTO  #TMP_ORG
	--FROM CUS_MEMBER
	--WHERE CUS_NO = @CUS_NO  
	
	-- 갱신된 변수가 있을경우 . 그외의 경우는 기존값 넣기 
	SELECT TOP 1 
	       @CUS_ID = CASE 
	                      WHEN ISNULL(@CUS_ID ,'') <> '' THEN @CUS_ID
	                      ELSE CUS_ID
	                 END
	      ,@CUS_NAME = CASE 
	                        WHEN ISNULL(@CUS_NAME ,'') <> '' THEN @CUS_NAME
	                        ELSE CUS_NAME
	                   END
	      ,@BIRTH_DATE = CASE 
	                          WHEN @BIRTH_DATE IS NOT NULL THEN @BIRTH_DATE
	                          ELSE BIRTH_DATE
	                     END
	      ,@GENDER = CASE 
	                      WHEN ISNULL(@GENDER ,'') <> '' THEN @GENDER
	                      ELSE GENDER
	                 END
	      ,@NOR_TEL1 = CASE 
	                        WHEN ISNULL(@NOR_TEL1 ,'') <> '' THEN @NOR_TEL1
	                        ELSE NOR_TEL1
	                   END
	      ,@NOR_TEL2 = CASE 
	                        WHEN ISNULL(@NOR_TEL2 ,'') <> '' THEN @NOR_TEL2
	                        ELSE NOR_TEL2
	                   END
	      ,@NOR_TEL3 = CASE 
	                        WHEN ISNULL(@NOR_TEL3 ,'') <> '' THEN @NOR_TEL3
	                        ELSE NOR_TEL3
	                   END
	      ,@EMAIL = CASE 
	                     WHEN ISNULL(@EMAIL ,'') <> '' THEN @EMAIL
	                     ELSE EMAIL
	                END
	      --,@CUS_GRADE = CASE 
	      --                   WHEN ISNULL(@CUS_GRADE ,-1) <> -1 THEN @CUS_GRADE
	      --                   ELSE (
	      --                            SELECT CUS_GRADE
	      --                            FROM   #TMP_LIST
	      --                            WHERE  ROW_NUM = 3
	      --                        )
	      --              END
	      --,@IPIN_DUP_INFO = CASE 
	      --                       WHEN ISNULL(@IPIN_DUP_INFO ,'') <> '' THEN @IPIN_DUP_INFO
	      --                       ELSE IPIN_DUP_INFO
	      --                  END
	      --,@IPIN_CONN_INFO = CASE 
	      --                        WHEN ISNULL(@IPIN_CONN_INFO ,'') <> '' THEN @IPIN_CONN_INFO
	      --                        ELSE IPIN_CONN_INFO
	      --                   END
	      ,@LAST_NAME = @LAST_NAME
	      ,@FIRST_NAME = @FIRST_NAME
	      ,@NICKNAME = CASE 
	                        WHEN ISNULL(@NICKNAME ,'') <> '' THEN @NICKNAME
	                        ELSE NICKNAME
	                   END
	      ,@RCV_EMAIL_YN = CASE 
	                            WHEN ISNULL(@RCV_EMAIL_YN ,'') <> '' THEN @RCV_EMAIL_YN
	                            ELSE (
	                                     SELECT RCV_EMAIL_YN
	                                     FROM   #TMP_LIST
	                                     WHERE  ROW_NUM = 3
	                                 )
	                       END
	      ,@RCV_SMS_YN = CASE 
	                          WHEN ISNULL(@RCV_SMS_YN ,'') <> '' THEN @RCV_SMS_YN
	                          ELSE (
	                                   SELECT RCV_SMS_YN
	                                   FROM   #TMP_LIST
	                                   WHERE  ROW_NUM = 3
	                               )
	                     END
	      ,@CUS_PASS = CASE 
	                        WHEN ISNULL(@CUS_PASS ,'') <> '' THEN @CUS_PASS
	                        ELSE CUS_PASS
	                   END
	      ,@CUS_STATE = CASE 
	                         WHEN ISNULL(@CUS_STATE ,'') <> '' THEN @CUS_STATE
	                         ELSE CUS_STATE
	                    END
	      ,@COM_TEL1 = CASE 
	                        WHEN ISNULL(@COM_TEL1 ,'') <> '' THEN @COM_TEL1
	                        ELSE COM_TEL1
	                   END
	      ,@COM_TEL2 = CASE 
	                        WHEN ISNULL(@COM_TEL2 ,'') <> '' THEN @COM_TEL2
	                        ELSE COM_TEL2
	                   END
	      ,@COM_TEL3 = CASE 
	                        WHEN ISNULL(@COM_TEL3 ,'') <> '' THEN @COM_TEL3
	                        ELSE COM_TEL3
	                   END
	      ,@HOM_TEL1 = CASE 
	                        WHEN ISNULL(@HOM_TEL1 ,'') <> '' THEN @HOM_TEL1
	                        ELSE HOM_TEL1
	                   END
	      ,@HOM_TEL2 = CASE 
	                        WHEN ISNULL(@HOM_TEL2 ,'') <> '' THEN @HOM_TEL2
	                        ELSE HOM_TEL2
	                   END
	      ,@HOM_TEL3 = CASE 
	                        WHEN ISNULL(@HOM_TEL3 ,'') <> '' THEN @HOM_TEL3
	                        ELSE HOM_TEL3
	                   END
	      ,@NATIONAL = CASE 
	                        WHEN ISNULL(@NATIONAL ,'') <> '' THEN @NATIONAL
	                        ELSE [NATIONAL]
	                   END
	      ,@FOREIGNER_YN = CASE 
	                            WHEN ISNULL(@FOREIGNER_YN ,'') <> '' THEN @FOREIGNER_YN
	                            ELSE FOREIGNER_YN
	                       END
	      ,@ADDRESS1 = CASE 
	                        WHEN ISNULL(@ADDRESS1 ,'') <> '' THEN @ADDRESS1
	                        ELSE ADDRESS1
	                   END
	      ,@ADDRESS2 = CASE 
	                        WHEN ISNULL(@ADDRESS2 ,'') <> '' THEN @ADDRESS2
	                        ELSE ADDRESS2
	                   END
	      ,@ZIP_CODE = CASE 
	                        WHEN ISNULL(@ZIP_CODE ,'') <> '' THEN @ZIP_CODE
	                        ELSE ZIP_CODE
	                   END
	      ,@POINT_CONSENT = CASE 
	                             WHEN ISNULL(@POINT_CONSENT ,'') <> '' THEN @POINT_CONSENT
	                             ELSE POINT_CONSENT
	                        END
	      ,@POINT_CONSENT_DATE = CASE 
	                                  WHEN @POINT_CONSENT_DATE IS NOT NULL THEN @POINT_CONSENT_DATE
	                                  ELSE POINT_CONSENT_DATE
	                             END
	      ,--@JOIN_TYPE =CASE WHEN ISNULL(@JOIN_TYPE,-1) <> -1 THEN @JOIN_TYPE ELSE JOIN_TYPE END,
	       @CERT_YN = CASE 
	                       WHEN ISNULL(@CERT_YN ,'') <> '' THEN @CERT_YN
	                       ELSE CERT_YN
	                  END
	FROM   #TMP_LIST
	ORDER BY
	       ROW_NUM ASC 
	
	---- 무조건 CUS_CUSTOMER 값인것들  수신여부 , 회원등급
	--SELECT @RCV_EMAIL_YN =  (SELECT RCV_EMAIL_YN FROM #TMP_LIST WHERE ROW_NUM = 3) ,
	--	@RCV_SMS_YN = (SELECT RCV_SMS_YN FROM #TMP_LIST WHERE ROW_NUM = 3) ,
	--	@CUS_GRADE = (SELECT CUS_GRADE FROM #TMP_LIST WHERE ROW_NUM = 3) 
	
	
	-- 정보가 없으면 최초 기존 정보 넣어줌 
	IF NOT EXISTS (
	       SELECT *
	       FROM   CUS_CUSTOMER_HISTORY
	       WHERE  CUS_NO = @CUS_NO
	   )
	BEGIN
	    INSERT INTO CUS_CUSTOMER_HISTORY
	      (
	        CUS_NO
	       ,HIS_NO
	       ,CUS_ID
	       ,CUS_NAME
	       ,BIRTH_DATE
	       ,GENDER
	       ,NOR_TEL1
	       ,NOR_TEL2
	       ,NOR_TEL3
	       ,EMAIL
	       ,CUS_GRADE
	       ,IPIN_DUP_INFO
	       ,IPIN_CONN_INFO
	       ,LAST_NAME
	       ,FIRST_NAME
	       ,NICKNAME
	       ,RCV_EMAIL_YN
	       ,RCV_SMS_YN
	       ,CUS_PASS
	       ,CUS_STATE
	       ,COM_TEL1
	       ,COM_TEL2
	       ,COM_TEL3
	       ,HOM_TEL1
	       ,HOM_TEL2
	       ,HOM_TEL3
	       ,[NATIONAL]
	       ,FOREIGNER_YN
	       ,ADDRESS1
	       ,ADDRESS2
	       ,ZIP_CODE
	       ,POINT_CONSENT
	       ,POINT_CONSENT_DATE
	       ,--JOIN_TYPE,
	        CERT_YN
	       ,NEW_DATE
	       ,EMP_CODE
	       ,EDT_REMARK
	       ,SYSTEM_TYPE
	       ,EDT_TYPE
	      )
	    SELECT TOP 1 CUS_NO
	          ,1
	          ,CUS_ID
	          ,CUS_NAME
	          ,BIRTH_DATE
	          ,GENDER
	          ,NOR_TEL1
	          ,NOR_TEL2
	          ,NOR_TEL3
	          ,EMAIL
	          ,@CUS_GRADE
	          ,IPIN_DUP_INFO
	          ,IPIN_CONN_INFO
	          ,LAST_NAME
	          ,FIRST_NAME
	          ,NICKNAME
	          ,@RCV_EMAIL_YN
	          ,@RCV_SMS_YN
	          ,CUS_PASS
	          ,CUS_STATE
	          ,COM_TEL1
	          ,COM_TEL2
	          ,COM_TEL3
	          ,HOM_TEL1
	          ,HOM_TEL2
	          ,HOM_TEL3
	          ,[NATIONAL]
	          ,FOREIGNER_YN
	          ,ADDRESS1
	          ,ADDRESS2
	          ,ZIP_CODE
	          ,POINT_CONSENT
	          ,POINT_CONSENT_DATE
	          ,--JOIN_TYPE,
	           CERT_YN
	          ,GETDATE()
	          ,'9999999'
	          ,'변경전(원본)'
	          ,NULL
	          ,0 -- 최초
	    FROM   #TMP_LIST
	    ORDER BY
	           ROW_NUM ASC
	END 
	
	DECLARE @HIS_NO INT 
	SET @HIS_NO = ISNULL(
	        (
	            SELECT MAX(HIS_NO)
	            FROM   CUS_CUSTOMER_HISTORY
	            WHERE  CUS_NO = @CUS_NO
	        )
	       ,0
	    ) + 1 
	
	INSERT INTO CUS_CUSTOMER_HISTORY
	  (
	    CUS_NO
	   ,HIS_NO
	   ,CUS_ID
	   ,CUS_NAME
	   ,BIRTH_DATE
	   ,GENDER
	   ,NOR_TEL1
	   ,NOR_TEL2
	   ,NOR_TEL3
	   ,EMAIL
	   ,CUS_GRADE
	   ,IPIN_DUP_INFO
	   ,IPIN_CONN_INFO
	   ,LAST_NAME
	   ,FIRST_NAME
	   ,NICKNAME
	   ,RCV_EMAIL_YN
	   ,RCV_SMS_YN
	   ,CUS_PASS
	   ,CUS_STATE
	   ,COM_TEL1
	   ,COM_TEL2
	   ,COM_TEL3
	   ,HOM_TEL1
	   ,HOM_TEL2
	   ,HOM_TEL3
	   ,[NATIONAL]
	   ,FOREIGNER_YN
	   ,ADDRESS1
	   ,ADDRESS2
	   ,ZIP_CODE
	   ,POINT_CONSENT
	   ,POINT_CONSENT_DATE
	   ,--JOIN_TYPE,
	    CERT_YN
	   ,NEW_DATE
	   ,EMP_CODE
	   ,EDT_REMARK
	   ,SYSTEM_TYPE
	   ,EDT_TYPE
	  )
	VALUES
	  (
	    @CUS_NO
	   ,@HIS_NO
	   ,@CUS_ID
	   ,@CUS_NAME
	   ,@BIRTH_DATE
	   ,@GENDER
	   ,@NOR_TEL1
	   ,@NOR_TEL2
	   ,@NOR_TEL3
	   ,@EMAIL
	   ,@CUS_GRADE
	   ,@IPIN_DUP_INFO
	   ,@IPIN_CONN_INFO
	   ,@LAST_NAME
	   ,@FIRST_NAME
	   ,@NICKNAME
	   ,@RCV_EMAIL_YN
	   ,@RCV_SMS_YN
	   ,@CUS_PASS
	   ,@CUS_STATE
	   ,@COM_TEL1
	   ,@COM_TEL2
	   ,@COM_TEL3
	   ,@HOM_TEL1
	   ,@HOM_TEL2
	   ,@HOM_TEL3
	   ,@NATIONAL
	   ,@FOREIGNER_YN
	   ,@ADDRESS1
	   ,@ADDRESS2
	   ,@ZIP_CODE
	   ,@POINT_CONSENT
	   ,@POINT_CONSENT_DATE
	   ,--@JOIN_TYPE,
	    @CERT_YN
	   ,GETDATE()
	   ,@EMP_CODE
	   ,@EDT_REMARK
	   ,@SYSTEM_TYPE
	   ,@EDT_TYPE
	  )
END 









GO
