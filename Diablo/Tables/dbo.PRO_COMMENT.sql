USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRO_COMMENT](
	[MASTER_CODE] [dbo].[MASTER_CODE] NOT NULL,
	[COM_SEQ] [int] NOT NULL,
	[PRO_CODE] [dbo].[PRO_CODE] NULL,
	[TITLE] [nvarchar](50) NULL,
	[CONTENTS] [nvarchar](1000) NULL,
	[GRADE] [int] NULL,
	[POINT1] [int] NULL,
	[POINT2] [int] NULL,
	[POINT3] [int] NULL,
	[POINT4] [int] NULL,
	[POINT5] [int] NULL,
	[NICKNAME] [varchar](20) NULL,
	[CUS_NO] [dbo].[CUS_NO] NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
 CONSTRAINT [PK_PRO_COMMENT_1] PRIMARY KEY CLUSTERED 
(
	[COM_SEQ] ASC,
	[MASTER_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_COMMENT', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_COMMENT', @level2type=N'COLUMN',@level2name=N'COM_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_COMMENT', @level2type=N'COLUMN',@level2name=N'PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_COMMENT', @level2type=N'COLUMN',@level2name=N'TITLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'내용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_COMMENT', @level2type=N'COLUMN',@level2name=N'CONTENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'별점' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_COMMENT', @level2type=N'COLUMN',@level2name=N'GRADE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상세점수1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_COMMENT', @level2type=N'COLUMN',@level2name=N'POINT1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상세점수2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_COMMENT', @level2type=N'COLUMN',@level2name=N'POINT2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상세점수3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_COMMENT', @level2type=N'COLUMN',@level2name=N'POINT3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상세점수4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_COMMENT', @level2type=N'COLUMN',@level2name=N'POINT4'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상세점수5' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_COMMENT', @level2type=N'COLUMN',@level2name=N'POINT5'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'닉네임' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_COMMENT', @level2type=N'COLUMN',@level2name=N'NICKNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성고객' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_COMMENT', @level2type=N'COLUMN',@level2name=N'CUS_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_COMMENT', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품평' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_COMMENT'
GO
