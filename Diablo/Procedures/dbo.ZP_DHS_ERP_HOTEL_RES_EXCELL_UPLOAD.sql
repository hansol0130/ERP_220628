USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME						: ZP_DHS_ERP_HOTEL_RES_EXCELL_UPLOAD
■ DESCRIPTION					: 입력_홈쇼핑호텔_엑셀업로드
■ INPUT PARAMETER				: 
■ OUTPUT PARAMETER			    :
■ EXEC						    :
■ MEMO						    : 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2022-01-28		오준혁			최초생성
   2022-02-04		김성호			예약 수량 만큼 반복 되도록 수정
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_DHS_ERP_HOTEL_RES_EXCELL_UPLOAD]
	 @DHS_RES_CODE      VARCHAR(20)
	,@RES_NAME          VARCHAR(40)
	,@RES_PHONE         VARCHAR(20)
	,@DHS_ROOM_CODE     VARCHAR(20)
	,@PRICE             INT
	,@MASTER_CODE       VARCHAR(20)
	,@RES_QTY_COUNT     INT	= 1
AS 
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	DECLARE @PRO_CODE          VARCHAR(20)
	       ,@PRO_NAME          NVARCHAR(100)
	       ,@RES_CODE          RES_CODE
	       ,@NOR_TEL1          VARCHAR(4)
	       ,@NOR_TEL2          VARCHAR(4)
	       ,@NOR_TEL3          VARCHAR(4)
	       ,@SALE_COM_CODE     VARCHAR(10)
	       ,@COMM_RATE         DECIMAL(4 ,2)
	       ,@COMM_PRICE        INT
	
	-- 전화번호 정리
	SELECT @RES_PHONE = (CASE WHEN LEFT(@RES_PHONE ,1) = '0' THEN '' ELSE '0' END) + REPLACE(@RES_PHONE ,'-' ,'');
	
	-- 담당자 사번
	DECLARE @NEW_CODE CHAR(7)
	
	SELECT @NEW_CODE = NEW_CODE
	FROM   dbo.PKG_MASTER
	WHERE  MASTER_CODE = @MASTER_CODE

	

	
	-- 중복 체크
	IF EXISTS(
	       SELECT 1
	       FROM   dbo.RES_DHS_DETAIL RDD
	       WHERE  RDD.MASTER_CODE = @MASTER_CODE
	              AND RDD.DHS_RES_CODE = @DHS_RES_CODE
	   )
	BEGIN
	    -- 국내호텔홈쇼핑 마스터
	    UPDATE dbo.RES_DHS_DETAIL
	    SET    RES_NAME = @RES_NAME
	          ,RES_PHONE = @RES_PHONE
	          ,EDT_DATE = GETDATE()
	    WHERE  MASTER_CODE = @MASTER_CODE
	           AND DHS_RES_CODE = @DHS_RES_CODE 
	    
	    -- 리턴 성공 카운트 : 1
	    SELECT 1
	END
	ELSE
	BEGIN
	    SELECT TOP 1 
	           @NOR_TEL1 = CASE 
	                            WHEN LEN(@RES_PHONE) > 10 AND LEFT(@RES_PHONE ,2) = '01' THEN SUBSTRING(@RES_PHONE ,1 ,3)
	                            ELSE NULL
	                       END
	          ,@NOR_TEL2 = CASE 
	                            WHEN LEN(@RES_PHONE) > 10 AND LEFT(@RES_PHONE ,2) = '01' THEN SUBSTRING(@RES_PHONE ,4 ,(LEN(@RES_PHONE) - 7))
	                            ELSE NULL
	                       END
	          ,@NOR_TEL3 = CASE 
	                            WHEN LEN(@RES_PHONE) > 10 AND LEFT(@RES_PHONE ,2) = '01' THEN RIGHT(@RES_PHONE ,4)
	                            ELSE NULL
	                       END
	          ,@PRO_CODE = (@MASTER_CODE + '-000000')
	          ,@PRO_NAME = PMP.PRICE_NAME
	          ,@SALE_COM_CODE = DM.SALE_COM_CODE
	          ,@COMM_RATE = DM.COMM_RATE
	          ,@COMM_PRICE = (@PRICE * @COMM_RATE * 0.01)
	    FROM   PKG_MASTER_PRICE PMP
	           INNER JOIN PKG_MASTER_PRICE_DHS_MASTER DM
	                ON  PMP.MASTER_CODE = DM.MASTER_CODE AND PMP.PRICE_SEQ = DM.PRICE_SEQ
	    WHERE  PMP.MASTER_CODE = @MASTER_CODE
	           AND DM.DHS_ROOM_CODE = @DHS_ROOM_CODE;
	    
	    -- RES_MASTER
	    DECLARE @TMP_RES_CODE TABLE (RES_CODE VARCHAR(20));
	    
	    -- 구매 수량 만큼 반복
	    WHILE @RES_QTY_COUNT > 0
	    BEGIN
	        INSERT @TMP_RES_CODE
	        EXEC DIABLO.DBO.XP_WEB_RES_MASTER_INSERT 
	             @RES_AGT_TYPE = 0
	            ,@PRO_TYPE = 1
	            ,@RES_TYPE = 0
	            ,@RES_PRO_TYPE = 1
	            ,@PROVIDER = 4
	            ,@RES_STATE = 0
	            ,@RES_CODE = NULL
	            ,@MASTER_CODE = @MASTER_CODE
	            ,@PRO_CODE = @PRO_CODE
	            ,@PRICE_SEQ = 1
	            ,@PRO_NAME = '' -- @PRO_NAME (예약 확정전에 룸타입을 알수없음)
	            ,@DEP_DATE = NULL
	            ,@ARR_DATE = NULL
	            ,@LAST_PAY_DATE = NULL
	            ,@CUS_NO = 1
	            ,@RES_NAME = @RES_NAME
	            ,@BIRTH_DATE = NULL
	            ,@GENDER = NULL
	            ,@IPIN_DUP_INFO = NULL
	            ,@RES_EMAIL = NULL
	            ,@NOR_TEL1 = @NOR_TEL1
	            ,@NOR_TEL2 = @NOR_TEL2
	            ,@NOR_TEL3 = @NOR_TEL3
	            ,@ETC_TEL1 = NULL
	            ,@ETC_TEL2 = NULL
	            ,@ETC_TEL3 = NULL
	            ,@RES_ADDRESS1 = NULL
	            ,@RES_ADDRESS2 = NULL
	            ,@ZIP_CODE = NULL
	            ,@MEMBER_YN = NULL
	            ,@CUS_REQUEST = NULL
	            ,@CUS_RESPONSE = NULL
	            ,@COMM_RATE = @COMM_RATE
	            ,@COMM_AMT = @COMM_PRICE
	            ,@NEW_CODE = @NEW_CODE
	            ,@ETC = NULL
	            ,@SYSTEM_TYPE = 2
	            ,@SALE_COM_CODE = @SALE_COM_CODE
	            ,@TAX_YN = 'N';
	        
	        SELECT TOP 1 @RES_CODE = RES_CODE
	        FROM   @TMP_RES_CODE;
	        
	        -- RES_DHS_DETAIL
	        INSERT INTO dbo.RES_DHS_DETAIL
	          (
	            RES_CODE
	           ,MASTER_CODE
	           ,DHS_RES_CODE
	           ,RES_NAME
	           ,RES_PHONE
	           ,DHS_ROOM_CODE
	           ,NEW_DATE
	          )
	        VALUES
	          (
	            @RES_CODE
	           ,@MASTER_CODE
	           ,@DHS_RES_CODE
	           ,@RES_NAME
	           ,@RES_PHONE
	           ,@DHS_ROOM_CODE
	           ,GETDATE()
	          );
	        
	        -- RES_CUSTOMER
	        INSERT INTO dbo.RES_CUSTOMER_damo
	          (
	            RES_CODE
	           ,SEQ_NO
	           ,CUS_NO
	           ,CUS_NAME
	           ,AGE_TYPE
	           ,SALE_PRICE
	           ,TAX_PRICE
	           ,CHG_PRICE
	           ,DC_PRICE
	           ,NEW_CODE
	           ,NEW_DATE
	          )
	        VALUES
	          (
	            @RES_CODE
	           ,1
	           ,1
	           ,@RES_NAME
	           ,0
	           ,@PRICE
	           ,0
	           ,0
	           ,0
	           ,@NEW_CODE
	           ,GETDATE()
	          );
	        
	        
	        -- dbo.RES_PKG_DETAIL
	        INSERT INTO dbo.RES_PKG_DETAIL
	        (
	        	RES_CODE,
	        	AIR_GDS,
	        	HOTEL_GDS,
	        	AIR_PNR,
	        	HOTEL_VOUCHER,
	        	AIR_ONLINE_YN,
	        	HOTEL_ONLINE_YN,
	        	BRANCH_RATE
	        )
	        VALUES
	        (
	        	@RES_CODE,
	        	NULL,
	        	NULL,
	        	NULL,
	        	NULL,
	        	NULL,
	        	NULL,
	        	NULL
	        )
	        
	        -- 예약 수량에서 차감
	        SELECT @RES_QTY_COUNT = @RES_QTY_COUNT - 1
	        
	        -- 결과 테이블 삭제
	        DELETE 
	        FROM   @TMP_RES_CODE
	    END
	    
	    -- 리턴 성공 카운트 : 1
	    SELECT 1
	END
END
GO
