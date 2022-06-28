USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ USP_Name					: XP_PRO_TRANS_SEAT_LIST_BY_PKG_MASTER_SUMMARY  
■ Description				: 마스터의 좌석 정보 조회(그룹)
■ Input Parameter			:                  


■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: EXEC XP_PRO_TRANS_SEAT_LIST_BY_PKG_MASTER_SUMMARY 'APPT334' , '2019-07-16' , '2019-12-31'
■ Author					: 박형만  
■ Date						: 2019-07-16
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
    2019-07-16		박형만			최초생성  
-------------------------------------------------------------------------------------------------*/ 
CREATE PROC [dbo].[XP_PRO_TRANS_SEAT_LIST_BY_PKG_MASTER_SUMMARY] 
	@MASTER_CODE VARCHAR(20),
	@START_DATE DATETIME,
	@END_DATE DATETIME,
	
	@DEP_TRANS_CODE VARCHAR(2) = NULL,
	@TOT_DAY INT = NULL
AS 
BEGIN

	SELECT 
	B.DEP_TRANS_CODE,
	B.TOT_DAY,
	B.SEAT,
	B.DEP_WK , 
	LEFT(DATENAME(DW, CONVERT(DATETIME, B.DEP_DEP_DATE)),1)  AS DEP_WEEK , 
	B.SEAT_GROUP  
	FROM PKG_DETAIL A WITH(NOLOCK)
		INNER JOIN VIEW_PRO_TRANS_SEAT B WITH(NOLOCK)
			ON A.SEAT_CODE = B.SEAT_CODE 
		INNER JOIN PRO_TRANS_SEAT C WITH(NOLOCK)
			ON A.SEAT_CODE = C.SEAT_CODE 
	WHERE MASTER_CODE=  @MASTER_CODE
	AND A.DEP_dATE >= @START_DATE
	AND A.DEP_dATE < DATEADD(D,1, @END_DATE)

	AND (B.DEP_TRANS_CODE = @DEP_TRANS_CODE OR ISNULL(@DEP_TRANS_CODE,'') = '' )
	AND (B.TOT_DAY = @TOT_DAY OR ISNULL(@TOT_DAY,0) = 0 )
	

	GROUP BY B.DEP_TRANS_CODE,
	B.TOT_DAY,
	B.SEAT,
	B.DEP_WK,
	LEFT(DATENAME(DW, CONVERT(DATETIME, B.DEP_DEP_DATE)),1),
	B.SEAT_GROUP  

	ORDER BY B.DEP_TRANS_CODE , B.SEAT_GROUP , B.DEP_WK


END 
GO
