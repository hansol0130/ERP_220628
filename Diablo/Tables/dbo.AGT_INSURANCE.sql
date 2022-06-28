USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AGT_INSURANCE](
	[AGT_CODE] [varchar](10) NOT NULL,
	[SEQ_NO] [int] NOT NULL,
	[INS_NAME] [varchar](100) NULL,
	[INS_DAY] [int] NULL,
	[INS_PRICE] [int] NULL,
	[REMARK] [varchar](200) NULL,
	[START_AGE] [int] NULL,
	[END_AGE] [int] NULL,
	[DC_COUNT] [int] NULL,
	[DC_RATE] [int] NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[GENDER] [char](1) NULL,
 CONSTRAINT [PK_AGT_INSURANCE] PRIMARY KEY CLUSTERED 
(
	[AGT_CODE] ASC,
	[SEQ_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AGT_INSURANCE]  WITH CHECK ADD  CONSTRAINT [R_332] FOREIGN KEY([AGT_CODE])
REFERENCES [dbo].[AGT_MASTER] ([AGT_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AGT_INSURANCE] CHECK CONSTRAINT [R_332]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래처코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_INSURANCE', @level2type=N'COLUMN',@level2name=N'AGT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_INSURANCE', @level2type=N'COLUMN',@level2name=N'SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'보험명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_INSURANCE', @level2type=N'COLUMN',@level2name=N'INS_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'보험 적용일수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_INSURANCE', @level2type=N'COLUMN',@level2name=N'INS_DAY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'보험료' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_INSURANCE', @level2type=N'COLUMN',@level2name=N'INS_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_INSURANCE', @level2type=N'COLUMN',@level2name=N'REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'적용시작나이' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_INSURANCE', @level2type=N'COLUMN',@level2name=N'START_AGE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'적용종료 나이' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_INSURANCE', @level2type=N'COLUMN',@level2name=N'END_AGE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DC 인원' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_INSURANCE', @level2type=N'COLUMN',@level2name=N'DC_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'할인율' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_INSURANCE', @level2type=N'COLUMN',@level2name=N'DC_RATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_INSURANCE', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_INSURANCE', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_INSURANCE', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_INSURANCE', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'M : 남성, F : 여성' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_INSURANCE', @level2type=N'COLUMN',@level2name=N'GENDER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'보험종류' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_INSURANCE'
GO
