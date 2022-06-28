USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FAX_ADDRESS](
	[EMP_CODE] [dbo].[EMP_CODE] NOT NULL,
	[SEQ] [dbo].[SEQ_NO] NOT NULL,
	[KOR_NAME] [dbo].[KOR_NAME] NULL,
	[FAX_NUMBER1] [varchar](4) NULL,
	[FAX_NUMBER2] [varchar](4) NULL,
	[FAX_NUMBER3] [varchar](4) NULL,
	[COM_NAME] [varchar](20) NULL,
	[DEL_YN] [char](1) NULL,
 CONSTRAINT [PK_FAX_ADDRESS] PRIMARY KEY CLUSTERED 
(
	[EMP_CODE] ASC,
	[SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사원번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_ADDRESS', @level2type=N'COLUMN',@level2name=N'EMP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'한글명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_ADDRESS', @level2type=N'COLUMN',@level2name=N'KOR_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팩스번호1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_ADDRESS', @level2type=N'COLUMN',@level2name=N'FAX_NUMBER1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팩스번호2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_ADDRESS', @level2type=N'COLUMN',@level2name=N'FAX_NUMBER2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팩스번호3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_ADDRESS', @level2type=N'COLUMN',@level2name=N'FAX_NUMBER3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'회사명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_ADDRESS', @level2type=N'COLUMN',@level2name=N'COM_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'삭제유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_ADDRESS', @level2type=N'COLUMN',@level2name=N'DEL_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팩스주소' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_ADDRESS'
GO
