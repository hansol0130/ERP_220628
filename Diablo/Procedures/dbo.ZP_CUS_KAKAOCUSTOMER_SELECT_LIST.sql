USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME									: ZP_CUS_KAKAOCUSTOMER_SELECT_LIST
■ DESCRIPTION								: 카카오싱크 중복가입자 현황
■ INPUT PARAMETER							: 
	@CUS_NAME 								: 사용자이름
	@NOR_TEL1/@NOR_TEL2/@NOR_TEL3			: 전화번호
	@START_DATE/@END_DATE					: 가입일
■ OUTPUT PARAMETER							: 
■ EXEC										: 

EXEC ZP_CUS_KAKAOCUSTOMER_SELECT_LIST 1, 15, '','','','','',''
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2020-03-17		김영민		최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[ZP_CUS_KAKAOCUSTOMER_SELECT_LIST]
(
	@FLAG			CHAR(1),
	@PAGE_SIZE		INT,
	@PAGE_INDEX		INT,
	@CUS_NAME		VARCHAR(20) = '',
	@NOR_TEL1		VARCHAR(6) = '',
	@NOR_TEL2		VARCHAR(5) = '',
	@NOR_TEL3		VARCHAR(4) = '',
	@START_DATE		DATETIME = '',
	@END_DATE		DATETIME = ''
)
AS

BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	DECLARE  @FROM INT, @TO INT;

	SET @FROM = @PAGE_INDEX * @PAGE_SIZE + 1;
	SET @TO = @PAGE_INDEX * @PAGE_SIZE + @PAGE_SIZE;

	BEGIN
		IF @FLAG = 'C'	
			BEGIN
			SELECT 
			 COUNT(A.ROWNUMBER)
		 FROM (
			SELECT ROW_NUMBER() OVER (ORDER BY A.NEW_DATE DESC) AS [ROWNUMBER]
			FROM CUS_SNS_CLEAR A WITH(NOLOCK)  JOIN CUS_SNS_INFO B WITH(NOLOCK)   ON A.CUS_NO = B.CUS_NO
			JOIN CUS_MEMBER C WITH(NOLOCK) ON A.CUS_NO = C.CUS_NO
			WHERE CHECK_YN = 0 
		   AND (CASE 
				WHEN ISNULL(@CUS_NAME,'') = ''  THEN 1
				WHEN ISNULL(@CUS_NAME,'')<> '' AND C.CUS_NAME  = @CUS_NAME THEN 1
				ELSE 0
		   END) = 1
		   AND       
		  (CASE 
				WHEN ISNULL(@NOR_TEL1,'') = '' THEN 1
				WHEN ISNULL(@NOR_TEL1,'') <> '' AND C.NOR_TEL1 = @NOR_TEL1	THEN 1
				ELSE 0
			END) = 1        
		   AND       
		  (CASE 
				WHEN ISNULL(@NOR_TEL2,'') = '' THEN 1
				WHEN ISNULL(@NOR_TEL2,'') <> '' AND C.NOR_TEL2 = @NOR_TEL2	THEN 1
				ELSE 0
			END) = 1        
		   AND       
		  (CASE 
				WHEN ISNULL(@NOR_TEL3,'') = '' THEN 1
				WHEN ISNULL(@NOR_TEL3,'') <> '' AND C.NOR_TEL3 = @NOR_TEL3	THEN 1
				ELSE 0
			END) = 1        
		   AND       
		  (CASE 
				WHEN ISNULL(@START_DATE,'') = '' THEN 1
				WHEN ISNULL(@START_DATE,'') <> '' AND A.NEW_DATE >= @START_DATE 	THEN 1
				ELSE 0
			END) = 1        
		   AND       
		  (CASE 
				WHEN ISNULL(@END_DATE,'') = '' THEN 1
				WHEN ISNULL(@END_DATE,'') <> '' AND A.NEW_DATE < DATEADD(D,1,@END_DATE)	THEN 1
				ELSE 0
			END) = 1   
		)A 
			END
			
		ELSE IF @FLAG = 'L' 
		BEGIN
			SELECT 
			A.ROWNUMBER,
			A.CUS_SNS_SEQ,
			A.NEW_DATE,
			A.CUS_NO,
			A.CUS_ID,
			A.CUS_NAME,
			A.NOR_TEL1,
			A.NOR_TEL2,
			A.NOR_TEL3,
			A.BIRTH_DATE,
			A.SNS_EMAIL AS EMAIL FROM (
				SELECT ROW_NUMBER() OVER (ORDER BY A.NEW_DATE DESC, A.CUS_NO) AS [ROWNUMBER], A.CUS_NO ,B.SNS_NAME AS CUS_NAME, A.NEW_DATE, A.CUS_SNS_SEQ,
				B.SNS_ID, C.NOR_TEL1,  C.NOR_TEL2, C.NOR_TEL3, C.BIRTH_DATE, B.SNS_EMAIL , C.CUS_ID
				FROM CUS_SNS_CLEAR A WITH(NOLOCK)  JOIN CUS_SNS_INFO B WITH(NOLOCK)   ON A.CUS_NO = B.CUS_NO
				JOIN CUS_MEMBER C WITH(NOLOCK) ON A.CUS_NO = C.CUS_NO
				WHERE CHECK_YN = 0 
			   AND (CASE 
					WHEN ISNULL(@CUS_NAME,'') = ''  THEN 1
					WHEN ISNULL(@CUS_NAME,'')<> '' AND C.CUS_NAME  = @CUS_NAME THEN 1
					ELSE 0
			   END) = 1
			   AND       
			  (CASE 
					WHEN ISNULL(@NOR_TEL1,'') = '' THEN 1
					WHEN ISNULL(@NOR_TEL1,'') <> '' AND C.NOR_TEL1 = @NOR_TEL1	THEN 1
					ELSE 0
				END) = 1        
			   AND       
			  (CASE 
					WHEN ISNULL(@NOR_TEL2,'') = '' THEN 1
					WHEN ISNULL(@NOR_TEL2,'') <> '' AND C.NOR_TEL2 = @NOR_TEL2	THEN 1
					ELSE 0
				END) = 1        
			   AND       
			  (CASE 
					WHEN ISNULL(@NOR_TEL3,'') = '' THEN 1
					WHEN ISNULL(@NOR_TEL3,'') <> '' AND C.NOR_TEL3 = @NOR_TEL3	THEN 1
					ELSE 0
				END) = 1        
			   AND       
			  (CASE 
					WHEN ISNULL(@START_DATE,'') = '' THEN 1
					WHEN ISNULL(@START_DATE,'') <> '' AND A.NEW_DATE >= @START_DATE 	THEN 1
					ELSE 0
				END) = 1        
			   AND       
			  (CASE 
					WHEN ISNULL(@END_DATE,'') = '' THEN 1
					WHEN ISNULL(@END_DATE,'') <> '' AND A.NEW_DATE < DATEADD(D,1,@END_DATE)	THEN 1
					ELSE 0
				END) = 1   
			)A WHERE A.ROWNUMBER  BETWEEN  @FROM AND @TO
		END
		
	END

END


	

GO
