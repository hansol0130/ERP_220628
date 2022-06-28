USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAY_MATCHING_CLOSE](
	[PAY_SEQ] [int] NOT NULL,
	[MCH_SEQ] [int] NOT NULL,
	[CLOSE_REMARK] [nvarchar](1000) NULL,
	[CLOSE_RES_CODE] [dbo].[RES_CODE] NULL,
	[CLOSE_PRO_CODE] [dbo].[PRO_CODE] NULL,
	[LAST_CLOSE_DATE] [datetime] NULL,
 CONSTRAINT [PK_PAY_MATCHING_CLOSE] PRIMARY KEY CLUSTERED 
(
	[PAY_SEQ] ASC,
	[MCH_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PAY_MATCHING_CLOSE]  WITH CHECK ADD  CONSTRAINT [R_348] FOREIGN KEY([PAY_SEQ], [MCH_SEQ])
REFERENCES [dbo].[PAY_MATCHING] ([PAY_SEQ], [MCH_SEQ])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PAY_MATCHING_CLOSE] CHECK CONSTRAINT [R_348]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입금순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MATCHING_CLOSE', @level2type=N'COLUMN',@level2name=N'PAY_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'매칭순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MATCHING_CLOSE', @level2type=N'COLUMN',@level2name=N'MCH_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마감비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MATCHING_CLOSE', @level2type=N'COLUMN',@level2name=N'CLOSE_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MATCHING_CLOSE', @level2type=N'COLUMN',@level2name=N'CLOSE_RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MATCHING_CLOSE', @level2type=N'COLUMN',@level2name=N'CLOSE_PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마감일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MATCHING_CLOSE', @level2type=N'COLUMN',@level2name=N'LAST_CLOSE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입금마감정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MATCHING_CLOSE'
GO
