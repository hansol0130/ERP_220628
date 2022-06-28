USE [VGLog]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AUTO_TEST_LOG](
	[SEQ] [int] IDENTITY(1,1) NOT NULL,
	[SITE_TYPE] [char](2) NULL,
	[TEST_TYPE] [varchar](20) NULL,
	[LINK] [varchar](100) NULL,
	[LOG] [varchar](1000) NULL,
	[ERROR_YN] [char](1) NULL,
	[NEW_DATE] [datetime] NULL,
 CONSTRAINT [PK_AUTO_TEST_LOG] PRIMARY KEY CLUSTERED 
(
	[SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AUTO_TEST_LOG', @level2type=N'COLUMN',@level2name=N'SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사이트종류 (PC, M)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AUTO_TEST_LOG', @level2type=N'COLUMN',@level2name=N'SITE_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'테스트 종류' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AUTO_TEST_LOG', @level2type=N'COLUMN',@level2name=N'TEST_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'화면주소' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AUTO_TEST_LOG', @level2type=N'COLUMN',@level2name=N'LINK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'로그내용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AUTO_TEST_LOG', @level2type=N'COLUMN',@level2name=N'LOG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'에러유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AUTO_TEST_LOG', @level2type=N'COLUMN',@level2name=N'ERROR_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AUTO_TEST_LOG', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
