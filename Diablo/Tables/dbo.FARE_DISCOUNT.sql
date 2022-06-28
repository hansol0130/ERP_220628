USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FARE_DISCOUNT](
	[SEQ_NO] [int] IDENTITY(1,1) NOT NULL,
	[START_DATE] [datetime] NULL,
	[END_DATE] [datetime] NULL,
	[AIRLINE_CODE] [char](2) NULL,
	[SUBJECT] [varchar](50) NULL,
	[TITLE1] [varchar](50) NULL,
	[TEXT1] [varchar](100) NULL,
	[TITLE2] [varchar](50) NULL,
	[TEXT2] [varchar](100) NULL,
	[TITLE3] [varchar](50) NULL,
	[TEXT3] [varchar](100) NULL,
	[DIS_PRICE] [int] NULL,
	[LINK] [varchar](500) NULL,
	[USE_YN] [char](1) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'할인순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_DISCOUNT', @level2type=N'COLUMN',@level2name=N'SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'할인시작일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_DISCOUNT', @level2type=N'COLUMN',@level2name=N'START_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'할인종료일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_DISCOUNT', @level2type=N'COLUMN',@level2name=N'END_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_DISCOUNT', @level2type=N'COLUMN',@level2name=N'AIRLINE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_DISCOUNT', @level2type=N'COLUMN',@level2name=N'SUBJECT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제목1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_DISCOUNT', @level2type=N'COLUMN',@level2name=N'TITLE1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'내용1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_DISCOUNT', @level2type=N'COLUMN',@level2name=N'TEXT1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제목2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_DISCOUNT', @level2type=N'COLUMN',@level2name=N'TITLE2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'내용2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_DISCOUNT', @level2type=N'COLUMN',@level2name=N'TEXT2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제목3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_DISCOUNT', @level2type=N'COLUMN',@level2name=N'TITLE3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'내용3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_DISCOUNT', @level2type=N'COLUMN',@level2name=N'TEXT3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'할인금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_DISCOUNT', @level2type=N'COLUMN',@level2name=N'DIS_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'URL' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_DISCOUNT', @level2type=N'COLUMN',@level2name=N'LINK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_DISCOUNT', @level2type=N'COLUMN',@level2name=N'USE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_DISCOUNT', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_DISCOUNT', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_DISCOUNT', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_DISCOUNT', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공요금할인' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_DISCOUNT'
GO
