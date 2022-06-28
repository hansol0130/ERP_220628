USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RES_RECOMMEND_CODE](
	[IDX] [int] IDENTITY(1,1) NOT NULL,
	[RES_CODE] [dbo].[RES_CODE] NOT NULL,
	[CODE] [varchar](20) NOT NULL,
	[NEW_DATE] [datetime] NOT NULL,
	[EDT_DATE] [datetime] NULL,
 CONSTRAINT [PK_RES_RECOMMEND_CODE] PRIMARY KEY CLUSTERED 
(
	[IDX] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_RECOMMEND_CODE', @level2type=N'COLUMN',@level2name=N'IDX'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_RECOMMEND_CODE', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'추천인(추천코드)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_RECOMMEND_CODE', @level2type=N'COLUMN',@level2name=N'CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_RECOMMEND_CODE', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_RECOMMEND_CODE', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
