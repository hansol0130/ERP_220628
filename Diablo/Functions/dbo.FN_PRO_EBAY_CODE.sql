USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- AUTHOR:		박형만
-- CREATE DATE: 2018-02-20
-- DESCRIPTION:	이베이(옥션,지마켓) 상품타입 검색
-- =============================================
CREATE FUNCTION [dbo].[FN_PRO_EBAY_CODE]
(
	@SIGN_CODE VARCHAR(1),
	@ATT_CODE VARCHAR(1),
	@BRANCH_CODE INT 
)
RETURNS VARCHAR(5)
AS
BEGIN

	DECLARE @GD_TYPE VARCHAR(5)

	SELECT @GD_TYPE = (
		CASE
			WHEN @SIGN_CODE = 'K' THEN 
				'PPT-5'
			ELSE 
				CASE 
					WHEN @BRANCH_CODE = 1 THEN 
						CASE WHEN @ATT_CODE = 'P' THEN 'PPT-1' 
							ELSE 'PAT-1'
						END
					WHEN @BRANCH_CODE = 2 THEN 
						CASE WHEN @ATT_CODE = 'P' THEN 'PPT-2' 
							ELSE 'PAT-2'
						END
					ELSE 
						CASE
							WHEN @ATT_CODE = 'W' THEN 'PT-03'
							WHEN @ATT_CODE = 'G' THEN 'PT-04'
							WHEN @ATT_CODE = 'C' THEN 'PT-05'
							WHEN @ATT_CODE = 'P' THEN 'PT-01'
							ELSE 'PT-02'  -- 기타는 에어텔로 
						END
				END
		END
	)

	RETURN (@GD_TYPE)
END


GO
