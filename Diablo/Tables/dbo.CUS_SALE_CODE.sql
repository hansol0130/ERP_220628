USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CUS_SALE_CODE](
	[CODE_SEQ] [int] IDENTITY(1,1) NOT NULL,
	[SALE_CODE] [varchar](20) NOT NULL,
	[NEW_DATE] [datetime] NULL,
	[RES_CODE] [char](12) NULL,
	[CUS_NO] [int] NULL,
	[START_DATE] [datetime] NULL,
	[END_DATE] [datetime] NULL,
	[USE_NAME] [varchar](10) NULL,
	[USE_YN] [char](1) NOT NULL,
	[EDIT_DATE] [datetime] NULL,
 CONSTRAINT [PK_CUS_CODE] PRIMARY KEY CLUSTERED 
(
	[CODE_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'난수코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_SALE_CODE', @level2type=N'COLUMN',@level2name=N'SALE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성날짜' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_SALE_CODE', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_SALE_CODE', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'실제사용 고객번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_SALE_CODE', @level2type=N'COLUMN',@level2name=N'CUS_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'할인코드시작날짜' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_SALE_CODE', @level2type=N'COLUMN',@level2name=N'START_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'할인코드종료날짜' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_SALE_CODE', @level2type=N'COLUMN',@level2name=N'END_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'처음 등록된 사용자명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_SALE_CODE', @level2type=N'COLUMN',@level2name=N'USE_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_SALE_CODE', @level2type=N'COLUMN',@level2name=N'USE_YN'
GO
