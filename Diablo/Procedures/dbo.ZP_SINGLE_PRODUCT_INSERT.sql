USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME						: ZP_SINGLE_PRODUCT_INSERT
■ DESCRIPTION					: 단품상품 입력
■ INPUT PARAMETER				: 
	@NAME			VARCHAR(20)	: 주문자명
	@TEL			VARCHAR(13)	: 전화번호
	@EMAIL			VARCHAR(40)	: 이메일
	@DELV_NAME		VARCHAR(20)	: 배송자명
	@ZIP_CODE		VARCHAR(7)	: 우편번호
	@ADDR1			VARCHAR(100): 주소1
	@ADDR2			VARCHAR(100): 주소2
	@MAK_YN			VARCHAR(1)  : 마케팅 동의여부
	@CNT			INT			: 수량
	@PRICE			INT			: 단가
	@CUS_NO			INT			: 고객번호
■ OUTPUT PARAMETER			    :
■ EXEC						    :
■ MEMO						    :
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2020-10-27		홍종우			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_SINGLE_PRODUCT_INSERT]
	@NAME			VARCHAR(20),
	@TEL			VARCHAR(13),
	@EMAIL			VARCHAR(40),
	@DELV_NAME		VARCHAR(20),
	@ZIP_CODE		VARCHAR(7),
	@ADDR1			VARCHAR(100),
	@ADDR2			VARCHAR(100),
	@MAK_YN			VARCHAR(1),
	@CNT			INT,
	@PRICE			INT,
	@CUS_NO			INT,
	@CODE			VARCHAR(10)
AS 
BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @COD_TYPE VARCHAR(10)			-- COD_SEQ TABLE에서 게시판 키값 채번을 위한 E-커머스 코드값
	DECLARE @BBS_SEQ INT					-- 채번 된 키값
	DECLARE @STR_CUS VARCHAR(MAX)			-- 게시판 내용 중 회원유무 값
	DECLARE @STR_CUS2 VARCHAR(MAX)			-- 게시판 제목에 들어 갈 회원정보
    DECLARE @CONTENTS VARCHAR(MAX)			-- 게시판 내용
	DECLARE @CUS_GRADE VARCHAR(20)			-- 회원 등급
		
	-- 게시판 키값 채번
	SET @COD_TYPE = ('B' + CAST('178' AS VARCHAR))
	EXEC SP_COD_GETSEQ_UNLIMITED @COD_TYPE, @BBS_SEQ OUTPUT
	
	-- 회원 등급
    SET @CUS_GRADE = dbo.FN_CUS_GET_CUS_GRADE_NAME(@CUS_NO, FORMAT(GETDATE(),'yyyy'))
           
	-- 게시판 내용 중 회원 코드 링크 처리
	IF((SELECT @@SERVERNAME) = 'TADB')
	BEGIN
		SET @STR_CUS = CASE @CUS_NO WHEN 0 THEN '비회원' ELSE '회원(<A target="_blank" style="text-decoration:underline; color: Blue;" href="http://ta.paladin.verygoodtour.com/Consult/ConsultCustomerDetail.aspx?CusCode=' + CONVERT(VARCHAR,@CUS_NO) + '">' + CONVERT(VARCHAR,@CUS_NO) + '</a>)  / ' + CASE @CUS_GRADE WHEN '' THEN '일반' ELSE @CUS_GRADE END END
	END
	ELSE
	BEGIN
		SET @STR_CUS = CASE @CUS_NO WHEN 0 THEN '비회원' ELSE '회원(<A target="_blank" style="text-decoration:underline; color: Blue;" href="http://erp.verygoodtour.com/Consult/ConsultCustomerDetail.aspx?CusCode=' + CONVERT(VARCHAR,@CUS_NO) + '">' + CONVERT(VARCHAR,@CUS_NO) + '</a>)  / ' + CASE @CUS_GRADE WHEN '' THEN '일반' ELSE @CUS_GRADE END END
	END
	
	-- 게시판 제목에 들어 갈 회원정보
	SET @STR_CUS2 = CASE @CUS_NO WHEN 0 THEN '비회원' ELSE '회원(' + CONVERT(VARCHAR,@CUS_NO) + ')' END
    
	-- 게시판 내용
    SET @CONTENTS = '■ 주&nbsp;&nbsp;문&nbsp;&nbsp;일&nbsp;&nbsp;: ' + CONVERT(CHAR(19), GETDATE(), 20) + '<br />'
                  + '■ 고&nbsp;&nbsp;객&nbsp;&nbsp;명&nbsp;&nbsp;: ' + @DELV_NAME + '<br />'
                  + '■ 상&nbsp;&nbsp;품&nbsp;&nbsp;명&nbsp;&nbsp;: [2019년 10만명 유럽 고객님들의 선택] 레오나르디 콘디멘토 발사믹 식초 20년산<br />'
                  + '■ 수&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;량&nbsp;&nbsp;: ' + CONVERT(VARCHAR,@CNT) + '<br />'
                  + '■ 주문자정보&nbsp;&nbsp;: ' + @NAME +  ' / ' + @TEL +  ' / ' + @EMAIL + '<br />'
                  + '■ 배송&nbsp;&nbsp;정보&nbsp;&nbsp;: ' + @DELV_NAME +  ' / ' + @ADDR1 + ' ' + @ADDR2 + ' (우) ' + @ZIP_CODE + '<br />'
                  + '■ 회원&nbsp;&nbsp;유무&nbsp;&nbsp;: ' + @STR_CUS + '<br />'
                  + '■ 채&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;널&nbsp;&nbsp;: ' + @CODE
                  
     
	-- 게시판(E-커머스(MASTER_SEQ ; 178)) TABLE INSERT 
	INSERT INTO BBS_DETAIL
	  (
	    BBS_SEQ
	   ,MASTER_SEQ
	   ,SUBJECT
	   ,[PASSWORD]
	   ,CATEGORY_GROUP
	   ,CATEGORY_SEQ
	   ,CONTENTS
	   ,NOTICE_YN
	   ,FILE_COUNT
	   ,FILE_PATH
	   ,COMMENT_COUNT
	   ,ICON_SEQ
	   ,LEVEL
	   ,PARENT_SEQ
	   ,IPADDRESS
	   ,SCOPE_TYPE
	   ,TEAM_CODE
	   ,TEAM_NAME
	   ,NEW_NAME
	   ,NEW_CODE
	  )
	VALUES
	  (
	    @BBS_SEQ
	   ,178
	   ,@NAME + ' / ' + CONVERT(VARCHAR ,@CNT) + ' / ' + @STR_CUS2
	   ,''
	   ,NULL
	   ,0
	   ,@CONTENTS
	   ,'N'
	   ,0
	   ,''
	   ,0
	   ,0
	   ,0
	   ,0
	   ,''
	   ,'1'
	   ,''
	   ,''
	   ,'시스템'
	   ,''
	  )
	
	-- 단품상품 판매 TEMP TABLE INSERT
	INSERT INTO SINGLE_PRODUCT
	SELECT @NAME		
		  ,@TEL		
		  ,@EMAIL		
		  ,@DELV_NAME	
		  ,@ZIP_CODE	
		  ,@ADDR1		
		  ,@ADDR2		
		  ,@MAK_YN		
		  ,@CNT		
		  ,@PRICE		
		  ,@CUS_NO
		  ,GETDATE()
		  ,@BBS_SEQ
END
GO
