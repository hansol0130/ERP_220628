USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ACR_MASTER](
	[ACR_SEQ_NO] [int] IDENTITY(1,1) NOT NULL,
	[AGT_CODE] [varchar](10) NULL,
	[PRO_CODE] [varchar](20) NULL,
	[DEP_DATE] [datetime] NULL,
	[ARR_DATE] [datetime] NULL,
	[REGION_CODE] [char](3) NULL,
	[ACR_START_DATE] [datetime] NULL,
	[ACR_END_DATE] [datetime] NULL,
	[GUIDE_CODE] [char](7) NULL,
	[TITLE] [varchar](200) NULL,
	[CONTENT] [ntext] NULL,
	[CFM_CODE] [char](7) NULL,
	[CFM_DATE] [datetime] NULL,
	[FILENAME1] [varchar](200) NULL,
	[FILENAME2] [varchar](200) NULL,
	[FILENAME3] [varchar](200) NULL,
	[NEW_CODE] [char](7) NOT NULL,
	[NEW_DATE] [datetime] NULL,
 CONSTRAINT [PK_ACR_MASTER] PRIMARY KEY CLUSTERED 
(
	[ACR_SEQ_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ACR_MASTER]  WITH CHECK ADD  CONSTRAINT [FK_ACR_MASTER_PRO_CODE] FOREIGN KEY([PRO_CODE])
REFERENCES [dbo].[PKG_DETAIL] ([PRO_CODE])
GO
ALTER TABLE [dbo].[ACR_MASTER] CHECK CONSTRAINT [FK_ACR_MASTER_PRO_CODE]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'경위서순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACR_MASTER', @level2type=N'COLUMN',@level2name=N'ACR_SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래처코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACR_MASTER', @level2type=N'COLUMN',@level2name=N'AGT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACR_MASTER', @level2type=N'COLUMN',@level2name=N'PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACR_MASTER', @level2type=N'COLUMN',@level2name=N'DEP_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACR_MASTER', @level2type=N'COLUMN',@level2name=N'ARR_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지역' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACR_MASTER', @level2type=N'COLUMN',@level2name=N'REGION_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발생시작일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACR_MASTER', @level2type=N'COLUMN',@level2name=N'ACR_START_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발생종료일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACR_MASTER', @level2type=N'COLUMN',@level2name=N'ACR_END_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'가이드코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACR_MASTER', @level2type=N'COLUMN',@level2name=N'GUIDE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACR_MASTER', @level2type=N'COLUMN',@level2name=N'TITLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'내용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACR_MASTER', @level2type=N'COLUMN',@level2name=N'CONTENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'확인자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACR_MASTER', @level2type=N'COLUMN',@level2name=N'CFM_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'확인일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACR_MASTER', @level2type=N'COLUMN',@level2name=N'CFM_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACR_MASTER', @level2type=N'COLUMN',@level2name=N'FILENAME1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACR_MASTER', @level2type=N'COLUMN',@level2name=N'FILENAME2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACR_MASTER', @level2type=N'COLUMN',@level2name=N'FILENAME3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACR_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACR_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'경위서' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACR_MASTER'
GO
