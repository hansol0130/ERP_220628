USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NAVER_SHIP_CODE](
	[N_SHIP_CODE] [varchar](3) NULL,
	[NAME_KR] [varchar](500) NULL,
	[NAME_EN] [varchar](500) NULL,
	[SHIP_CODE] [varchar](2) NULL
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'네이버선박코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_SHIP_CODE'
GO
