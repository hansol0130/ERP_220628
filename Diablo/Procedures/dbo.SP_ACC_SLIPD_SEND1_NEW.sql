USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ACC_SLIPD_SEND1_NEW]      
   @SLIP_MK_DAY CHAR(8),           
   @SLIP_MK_SEQ SMALLINT
AS        
        
DECLARE @PRO_NAME		VARCHAR(200),           
        @PRO_CODE		VARCHAR(20),              
        @DZ_PRO_CODE	VARCHAR(20),                  
        @CD_COMPANY		VARCHAR(4)
        
SELECT @CD_COMPANY = '3000'        
        
DECLARE CUR_1 SCROLL CURSOR FOR        
        
	SELECT DISTINCT TAB.PRO_CODE
	FROM
	(        
		SELECT	B.PRO_CODE   AS PRO_CODE
		FROM	ACC_SLIPM A, ACC_SLIPD B, ACC_ACCOUNT C      
		WHERE	A.SLIP_MK_DAY = @SLIP_MK_DAY        
				AND A.SLIP_MK_SEQ = @SLIP_MK_SEQ        
				AND A.SLIP_MK_DAY = B.SLIP_MK_DAY        
				AND A.SLIP_MK_SEQ = B.SLIP_MK_SEQ        
				AND B.USE_ACC_CD = C.USE_ACC_CD         
				AND C.PRO_CODE_CHK = 'Y'        
     ) TAB

OPEN CUR_1        
        
FETCH NEXT FROM CUR_1 INTO @PRO_CODE      
                                  
WHILE ( @@FETCH_STATUS <> -1 )
BEGIN
	SELECT	@DZ_PRO_CODE = DUZ_CODE    
	FROM	ACC_MATCHING    
	WHERE	PRO_CODE = @PRO_CODE                     

	IF @@ROWCOUNT = 1
	BEGIN
		IF NOT EXISTS ( SELECT *
                          FROM DZDB.NEOE.NEOE.SA_PROJECTH
                         WHERE CD_COMPANY = @CD_COMPANY
                           AND NO_PROJECT = @DZ_PRO_CODE )

        BEGIN
           --SELECT @PRO_NAME =  @PRO_CODE  + SUBSTRING(PRO_NAME, 1,8)        
           --  FROM PKG_DETAIL      
           -- WHERE PRO_CODE = @PRO_CODE      
            
          -- BEGIN TRANSACTION PJTCODE_INSERT
			-- 계약일에 출발일 세팅
			INSERT INTO DZDB.NEOE.NEOE.SA_PROJECTH
					(	NO_PROJECT, NO_SEQ, CD_COMPANY, NM_PROJECT,
						SD_PROJECT, ED_PROJECT, STA_PROJECT,
						DT_CHANGE )
			VALUES
					(	@DZ_PRO_CODE, '1', @CD_COMPANY, @PRO_CODE,
						'00000000', '00000000', '100',
						('20' + SUBSTRING(@PRO_CODE, (CHARINDEX('-', @PRO_CODE) + 1), 6)) )
						 
         --  COMMIT TRANSACTION PJTCODE_INSERT        
		END          
                
	END
	
	FETCH NEXT FROM CUR_1 INTO @PRO_CODE      
               
END        
        
CLOSE      CUR_1
DEALLOCATE CUR_1


--SELECT CHARINDEX('-', 'EPP300-100401')

--SELECT '20' + SUBSTRING(@PRO_CODE, (CHARINDEX('-', @PRO_CODE) + 1), 6)
GO
