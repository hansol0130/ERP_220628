USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[INF_OPTION](
	[CNT_CODE] [dbo].[CNT_CODE] NOT NULL,
	[TEL_NUMBER] [varchar](30) NULL,
	[FAX_NUMBER] [varchar](30) NULL,
	[ADDRESS] [nvarchar](50) NULL,
	[ADD_REMARK] [nvarchar](1000) NULL,
	[ETC_REMARK] [nvarchar](1000) NULL,
 CONSTRAINT [PK_INF_OPTION] PRIMARY KEY CLUSTERED 
(
	[CNT_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[INF_OPTION]  WITH CHECK ADD  CONSTRAINT [FK__INF_OPTIO__CNT_C__0C46B282] FOREIGN KEY([CNT_CODE])
REFERENCES [dbo].[INF_MASTER] ([CNT_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[INF_OPTION] CHECK CONSTRAINT [FK__INF_OPTIO__CNT_C__0C46B282]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'컨텐츠코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_OPTION', @level2type=N'COLUMN',@level2name=N'CNT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전화번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_OPTION', @level2type=N'COLUMN',@level2name=N'TEL_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팩스번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_OPTION', @level2type=N'COLUMN',@level2name=N'FAX_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주소' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_OPTION', @level2type=N'COLUMN',@level2name=N'ADDRESS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'부가정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_OPTION', @level2type=N'COLUMN',@level2name=N'ADD_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_OPTION', @level2type=N'COLUMN',@level2name=N'ETC_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'옵션컨텐츠' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_OPTION'
GO
