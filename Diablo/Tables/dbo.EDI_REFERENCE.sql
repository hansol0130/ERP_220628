USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EDI_REFERENCE](
	[EDI_CODE] [dbo].[EDI_CODE] NOT NULL,
	[SEQ_NO] [dbo].[SEQ_NO] NOT NULL,
	[REF_CODE] [dbo].[EMP_CODE] NOT NULL,
	[REF_NAME] [dbo].[KOR_NAME] NOT NULL,
	[READ_YN] [char](1) NOT NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_NAME] [dbo].[KOR_NAME] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
 CONSTRAINT [PK_EDI_REFERENCE] PRIMARY KEY CLUSTERED 
(
	[EDI_CODE] ASC,
	[SEQ_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EDI_REFERENCE] ADD  CONSTRAINT [DF_EDI_REFERENCE_READ_YN]  DEFAULT ('N') FOR [READ_YN]
GO
ALTER TABLE [dbo].[EDI_REFERENCE]  WITH CHECK ADD  CONSTRAINT [R_14] FOREIGN KEY([EDI_CODE])
REFERENCES [dbo].[EDI_MASTER_damo] ([EDI_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[EDI_REFERENCE] CHECK CONSTRAINT [R_14]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'문서코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI_REFERENCE', @level2type=N'COLUMN',@level2name=N'EDI_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI_REFERENCE', @level2type=N'COLUMN',@level2name=N'SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'참조자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI_REFERENCE', @level2type=N'COLUMN',@level2name=N'REF_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'참조자명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI_REFERENCE', @level2type=N'COLUMN',@level2name=N'REF_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'읽음여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI_REFERENCE', @level2type=N'COLUMN',@level2name=N'READ_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI_REFERENCE', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI_REFERENCE', @level2type=N'COLUMN',@level2name=N'NEW_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI_REFERENCE', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'참조자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI_REFERENCE'
GO
