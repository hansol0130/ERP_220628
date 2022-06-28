USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SET_GROUP](
	[PRO_CODE] [dbo].[PRO_CODE] NOT NULL,
	[GRP_SEQ_NO] [int] NOT NULL,
	[CUR_TYPE] [int] NULL,
	[EXC_RATE] [decimal](8, 2) NULL,
	[FOREIGN_PRICE] [int] NULL,
	[KOREAN_PRICE] [int] NULL,
	[PRICE] [int] NULL,
	[REMARK] [varchar](200) NULL,
	[PROFIT_YN] [char](1) NULL,
	[DOC_YN] [char](1) NULL,
	[EDI_CODE] [dbo].[EDI_CODE] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[RES_COUNT] [int] NULL,
 CONSTRAINT [PK_SET_GROUP] PRIMARY KEY CLUSTERED 
(
	[PRO_CODE] ASC,
	[GRP_SEQ_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SET_GROUP]  WITH CHECK ADD  CONSTRAINT [R_316] FOREIGN KEY([PRO_CODE])
REFERENCES [dbo].[SET_MASTER] ([PRO_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SET_GROUP] CHECK CONSTRAINT [R_316]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_GROUP', @level2type=N'COLUMN',@level2name=N'PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'공동경비 순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_GROUP', @level2type=N'COLUMN',@level2name=N'GRP_SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 : 원화, 2 : 달러화, 3 : 엔화, 4 : 유로화' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_GROUP', @level2type=N'COLUMN',@level2name=N'CUR_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'환율기준' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_GROUP', @level2type=N'COLUMN',@level2name=N'EXC_RATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'외화' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_GROUP', @level2type=N'COLUMN',@level2name=N'FOREIGN_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'원화' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_GROUP', @level2type=N'COLUMN',@level2name=N'KOREAN_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지출금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_GROUP', @level2type=N'COLUMN',@level2name=N'PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_GROUP', @level2type=N'COLUMN',@level2name=N'REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비용수익구분 여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_GROUP', @level2type=N'COLUMN',@level2name=N'PROFIT_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지결작성유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_GROUP', @level2type=N'COLUMN',@level2name=N'DOC_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'문서코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_GROUP', @level2type=N'COLUMN',@level2name=N'EDI_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_GROUP', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_GROUP', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_GROUP', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_GROUP', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약인원수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_GROUP', @level2type=N'COLUMN',@level2name=N'RES_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'공동경비' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_GROUP'
GO
