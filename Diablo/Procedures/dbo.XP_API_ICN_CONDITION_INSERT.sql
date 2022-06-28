USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: [XP_API_ICN_CONDITION_INSERT]
■ DESCRIPTION				: 인천공항 혼잡도 등록 
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	SELECT TOP 100 * FROM API_ICN_CONDITION_V2

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
	DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
	2022-02-28			김성호			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_API_ICN_CONDITION_INSERT]
	@DEP_DATE VARCHAR(8),
	@DEP_TIME VARCHAR(5) ,
	@T1_ENTRY_EAST_AB INT,
	@T1_ENTRY_WEST_EF INT,
	@T1_ENTRY_IMM_C INT,
	@T1_ENTRY_IMM_D INT,
	@T1_ENTRY_TOTAL INT,
	@T1_DEP_12 INT,
	@T1_DEP_3 INT,
	@T1_DEP_4 INT,
	@T1_DEP_56 INT,
	@T1_DEP_TOTAL INT,
	@T2_ENTRY_1 INT,
	@T2_ENTRY_2 INT,
	@T2_ENTRY_TOTAL INT,
	@T2_DEP_1 INT,
	@T2_DEP_2 INT,
	@T2_DEP_TOTAL INT
AS 
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	
	
	IF EXISTS(
	       SELECT 1
	       FROM   API_ICN_CONDITION_V2 V2 WITH(NOLOCK)
	       WHERE  V2.DEP_DATE = @DEP_DATE
	              AND V2.DEP_TIME = @DEP_TIME
	   )
	BEGIN
	    UPDATE API_ICN_CONDITION_V2
	    SET    T1_ENTRY_EAST_AB = @T1_ENTRY_EAST_AB
	          ,T1_ENTRY_WEST_EF = @T1_ENTRY_WEST_EF
	          ,T1_ENTRY_IMM_C = @T1_ENTRY_IMM_C
	          ,T1_ENTRY_IMM_D = @T1_ENTRY_IMM_D
	          ,T1_ENTRY_TOTAL = @T1_ENTRY_TOTAL
	          ,T1_DEP_12 = @T1_DEP_12
	          ,T1_DEP_3 = @T1_DEP_3
	          ,T1_DEP_4 = @T1_DEP_4
	          ,T1_DEP_56 = @T1_DEP_56
	          ,T1_DEP_TOTAL = @T1_DEP_TOTAL
	          ,T2_ENTRY_1 = @T2_ENTRY_1
	          ,T2_ENTRY_2 = @T2_ENTRY_2
	          ,T2_ENTRY_TOTAL = @T2_ENTRY_TOTAL
	          ,T2_DEP_1 = @T2_DEP_1
	          ,T2_DEP_2 = @T2_DEP_2
	          ,T2_DEP_TOTAL = @T2_DEP_TOTAL
	          ,EDT_DATE = GETDATE()
	    WHERE  DEP_DATE = @DEP_DATE
	           AND DEP_TIME = @DEP_TIME
	END
	ELSE
	BEGIN
	    INSERT INTO API_ICN_CONDITION_V2
	      (
	        DEP_DATE
	       ,DEP_TIME
	       ,T1_ENTRY_EAST_AB
	       ,T1_ENTRY_WEST_EF
	       ,T1_ENTRY_IMM_C
	       ,T1_ENTRY_IMM_D
	       ,T1_ENTRY_TOTAL
	       ,T1_DEP_12
	       ,T1_DEP_3
	       ,T1_DEP_4
	       ,T1_DEP_56
	       ,T1_DEP_TOTAL
	       ,T2_ENTRY_1
	       ,T2_ENTRY_2
	       ,T2_ENTRY_TOTAL
	       ,T2_DEP_1
	       ,T2_DEP_2
	       ,T2_DEP_TOTAL
	       ,NEW_DATE
	      )
	    VALUES
	      (
	        @DEP_DATE
	       ,@DEP_TIME
	       ,@T1_ENTRY_EAST_AB
	       ,@T1_ENTRY_WEST_EF
	       ,@T1_ENTRY_IMM_C
	       ,@T1_ENTRY_IMM_D
	       ,@T1_ENTRY_TOTAL
	       ,@T1_DEP_12
	       ,@T1_DEP_3
	       ,@T1_DEP_4
	       ,@T1_DEP_56
	       ,@T1_DEP_TOTAL
	       ,@T2_ENTRY_1
	       ,@T2_ENTRY_2
	       ,@T2_ENTRY_TOTAL
	       ,@T2_DEP_1
	       ,@T2_DEP_2
	       ,@T2_DEP_TOTAL
	       ,GETDATE()
	      )
	END
END
GO
