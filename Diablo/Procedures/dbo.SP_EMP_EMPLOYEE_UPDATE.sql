USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_EMP_EMPLOYEE_UPDATE
■ DESCRIPTION				: 직원 정보 수정
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   									최초생성
   2011-02-07						담당자 인사말 지워지는 현상 수정
   2012-03-05						외부아이피 접속금지 @IS_ACC_OUT 추가 
   2014-10-06						담당지역 컬럼 추가
   2015-02-13		김성호			휴직, 퇴사인 경우 내선번호, 녹취채널, 녹취여부, CTI 사용 여부는 삭제
   2015-09-23		정지용			내선번호 필드 추가 / 대표번호 필드 추가 / 내선번호 사용유무 추가
   2015-10-26		박형만			PASSWORD VARCHAR(20) -> (100) ,  비번'' 일경우 업데이트 안함
   2015-10-26		박형만			BLOCK_YN  계정잠금 여부 해제 'N' 추가 
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_EMP_EMPLOYEE_UPDATE]
	@EMP_CODE VARCHAR(7),
	@PASSWORD VARCHAR(100) ,
	@KOR_NAME VARCHAR(20) ,
	@ENG_FIRST_NAME VARCHAR(20),
	@ENG_LAST_NAME VARCHAR(20),
	@JOIN_DATE SMALLDATETIME,
	@OUT_DATE SMALLDATETIME,
	@SOC_NUMBER1 VARCHAR(6),
	@SOC_NUMBER2 VARCHAR(7),
	@GENDER VARCHAR(1), 
	@JOIN_TYPE VARCHAR(1),
	@WORK_TYPE VARCHAR(1),
	@DUTY_TYPE VARCHAR(2),
	@POS_TYPE VARCHAR(2),
	@GROUP_TYPE VARCHAR(1),
	@EMAIL VARCHAR(30),
	@EMAIL_PASSWORD VARCHAR(30),
	@MESSENGER VARCHAR(30),
	@ZIP_CODE VARCHAR(7),
	@ADDRESS1 VARCHAR(50),
	@ADDRESS2 VARCHAR(80),
	@TEL_NUMBER1 VARCHAR(4),
	@TEL_NUMBER2 VARCHAR(4),
	@TEL_NUMBER3 VARCHAR(4),
	@HP_NUMBER1 VARCHAR(4),
	@HP_NUMBER2 VARCHAR(4),
	@HP_NUMBER3 VARCHAR(4),
	@INNER_NUMBER1 VARCHAR(4),
	@INNER_NUMBER2 VARCHAR(4),
	@INNER_NUMBER3 VARCHAR(4),
	@FAX_NUMBER1 VARCHAR(4),
	@FAX_NUMBER2 VARCHAR(4),
	@FAX_NUMBER3 VARCHAR(4),
	@GREETING VARCHAR(200),
	@SALARY_CLASS VARCHAR(4),
	--@TEAM_CODE VARCHAR(3),
	@PASSPORT VARCHAR(20),
	@PASS_EXPIRE_DATE SMALLDATETIME,
	@EDT_CODE VARCHAR(7),
	@BIRTH_DATE SMALLDATETIME,
	@MATE_NUMBER VARCHAR(4),
	@MATE_NUMBER2 VARCHAR(4),
	@MAIN_NUMBER1 VARCHAR(4),
	@MAIN_NUMBER2 VARCHAR(4),
	@MAIN_NUMBER3 VARCHAR(4),
	@ACC_OUT_YN CHAR(1),
	@MY_AREA VARCHAR(100),
	@SIGN_CODE VARCHAR(1),
	@IN_USE_YN VARCHAR(1),
	@BLOCK_YN VARCHAR(1) = ''  
	
AS
BEGIN
	SET NOCOUNT OFF;

	DECLARE @SEQ INT;
    --DECLARE @TEAM VARCHAR(100);

	BEGIN
			
			UPDATE EMP_MASTER
				SET
				KOR_NAME=@KOR_NAME,[PASSWORD]= CASE WHEN ISNULL(@PASSWORD,'') = '' THEN [PASSWORD] ELSE @PASSWORD END ,
				ENG_FIRST_NAME=@ENG_FIRST_NAME,ENG_LAST_NAME=@ENG_LAST_NAME,
				JOIN_DATE=@JOIN_DATE,OUT_DATE=@OUT_DATE,SOC_NUMBER1=@SOC_NUMBER1,SOC_NUMBER2=@SOC_NUMBER2,GENDER=@GENDER,
				JOIN_TYPE=@JOIN_TYPE,WORK_TYPE=@WORK_TYPE,DUTY_TYPE=@DUTY_TYPE,POS_TYPE=@POS_TYPE,
				EMAIL=@EMAIL,EMAIL_PASSWORD=@EMAIL_PASSWORD,MESSENGER=@MESSENGER,ZIP_CODE=@ZIP_CODE,ADDRESS1=@ADDRESS1,ADDRESS2=@ADDRESS2,
				TEL_NUMBER1=@TEL_NUMBER1,TEL_NUMBER2=@TEL_NUMBER2,TEL_NUMBER3=@TEL_NUMBER3,
				HP_NUMBER1=@HP_NUMBER1,HP_NUMBER2=@HP_NUMBER2,HP_NUMBER3=@HP_NUMBER3,
				INNER_NUMBER1=@INNER_NUMBER1,INNER_NUMBER2=@INNER_NUMBER2,INNER_NUMBER3=@INNER_NUMBER3,
				FAX_NUMBER1=@FAX_NUMBER1,FAX_NUMBER2=@FAX_NUMBER2,FAX_NUMBER3=@FAX_NUMBER3,SALARY_CLASS=@SALARY_CLASS,
				GREETING=ISNULL(@GREETING,GREETING),PASSPORT=@PASSPORT,PASS_EXPIRE_DATE=@PASS_EXPIRE_DATE,
				EDT_CODE=@EDT_CODE,EDT_DATE=GETDATE(), BIRTH_DATE = @BIRTH_DATE, MATE_NUMBER = @MATE_NUMBER, MATE_NUMBER2 = @MATE_NUMBER2,
				MAIN_NUMBER1 = @MAIN_NUMBER1, MAIN_NUMBER2 = @MAIN_NUMBER2, MAIN_NUMBER3 = @MAIN_NUMBER3,
				GROUP_TYPE = @GROUP_TYPE,
				ACC_OUT_YN = @ACC_OUT_YN,
				MY_AREA = @MY_AREA,
				SIGN_CODE = @SIGN_CODE,
				IN_USE_YN = @IN_USE_YN,
				BLOCK_YN  = ( CASE WHEN @BLOCK_YN ='N' THEN @BLOCK_YN ELSE BLOCK_YN END ) ,  --N 값(계정잠금해제)일때만 업데이트 
				FALE_COUNT = ( CASE WHEN @BLOCK_YN ='N' THEN 0 ELSE FALE_COUNT END )
			WHERE EMP_CODE=@EMP_CODE

			-- 휴직, 퇴사인 경우 내선번호, 녹취채널, 녹취여부, CTI 사용 여부는 삭제
			IF @WORK_TYPE IN (2, 5)
			BEGIN
				UPDATE EMP_MASTER_damo SET INNER_NUMBER1 = NULL, INNER_NUMBER2 = NULL, INNER_NUMBER3 = NULL, CH_NUM = 0, RECORD_YN = 'N', CTI_USE_YN = 'N' WHERE EMP_CODE = @EMP_CODE AND WORK_TYPE IN (2, 5)

				DELETE FROM IP_MASTER WHERE CONNECT_CODE = @EMP_CODE
			END

	END
END

GO