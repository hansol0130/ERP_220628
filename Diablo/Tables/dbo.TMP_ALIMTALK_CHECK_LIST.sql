USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TMP_ALIMTALK_CHECK_LIST](
	[SEQ] [int] IDENTITY(1,1) NOT NULL,
	[CHECK_CODE] [varchar](10) NOT NULL,
	[MASTER_CODE] [varchar](10) NULL,
	[PRO_CODE] [varchar](20) NULL,
	[NEW_DATE] [datetime] NOT NULL,
 CONSTRAINT [PK_TMP_ALIMTALK_CHECK_LIST] PRIMARY KEY CLUSTERED 
(
	[SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TMP_ALIMTALK_CHECK_LIST] ADD  DEFAULT (getdate()) FOR [NEW_DATE]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TMP_ALIMTALK_CHECK_LIST', @level2type=N'COLUMN',@level2name=N'SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'체크코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TMP_ALIMTALK_CHECK_LIST', @level2type=N'COLUMN',@level2name=N'CHECK_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TMP_ALIMTALK_CHECK_LIST', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TMP_ALIMTALK_CHECK_LIST', @level2type=N'COLUMN',@level2name=N'PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TMP_ALIMTALK_CHECK_LIST', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
