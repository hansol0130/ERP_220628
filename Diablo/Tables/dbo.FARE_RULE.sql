USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FARE_RULE](
	[FARE_CODE] [int] NOT NULL,
	[RULE_CODE] [int] NOT NULL,
	[RULE_NAME] [varchar](100) NULL,
	[RULE_REMARK] [nvarchar](2000) NULL,
	[RULE_GRADE] [int] NULL,
	[NEW_CODE] [char](7) NULL,
	[NEW_DATE] [datetime] NULL,
	[EDT_CODE] [char](7) NULL,
	[EDT_DATE] [datetime] NULL,
 CONSTRAINT [PK_FARE_RULE] PRIMARY KEY CLUSTERED 
(
	[FARE_CODE] ASC,
	[RULE_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FARE_RULE]  WITH CHECK ADD  CONSTRAINT [FK__FARE_RULE__FARE___2E46C4CB] FOREIGN KEY([FARE_CODE])
REFERENCES [dbo].[FARE_MASTER] ([FARE_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FARE_RULE] CHECK CONSTRAINT [FK__FARE_RULE__FARE___2E46C4CB]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공요금코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_RULE', @level2type=N'COLUMN',@level2name=N'FARE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'적용규정코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_RULE', @level2type=N'COLUMN',@level2name=N'RULE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'적용규정제목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_RULE', @level2type=N'COLUMN',@level2name=N'RULE_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'적용규정내용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_RULE', @level2type=N'COLUMN',@level2name=N'RULE_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'적용규정등급' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_RULE', @level2type=N'COLUMN',@level2name=N'RULE_GRADE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_RULE', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_RULE', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_RULE', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_RULE', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공규정' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_RULE'
GO
