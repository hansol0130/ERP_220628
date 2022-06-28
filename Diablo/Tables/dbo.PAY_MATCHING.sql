USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAY_MATCHING](
	[PAY_SEQ] [int] NOT NULL,
	[MCH_SEQ] [int] NOT NULL,
	[MCH_TYPE] [int] NULL,
	[RES_CODE] [dbo].[RES_CODE] NULL,
	[PRO_CODE] [dbo].[PRO_CODE] NULL,
	[PART_PRICE] [int] NULL,
	[REMARK] [nvarchar](1000) NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[CXL_YN] [dbo].[USE_N] NULL,
	[CXL_CODE] [dbo].[CANCEL_CODE] NULL,
	[CXL_DATE] [dbo].[CANCEL_DATE] NULL,
 CONSTRAINT [PK_PAY_MATCHING] PRIMARY KEY CLUSTERED 
(
	[PAY_SEQ] ASC,
	[MCH_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PAY_MATCHING]  WITH CHECK ADD  CONSTRAINT [R_267] FOREIGN KEY([PAY_SEQ])
REFERENCES [dbo].[PAY_MASTER_damo] ([PAY_SEQ])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PAY_MATCHING] CHECK CONSTRAINT [R_267]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입금순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MATCHING', @level2type=N'COLUMN',@level2name=N'PAY_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'매칭순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MATCHING', @level2type=N'COLUMN',@level2name=N'MCH_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : 결제, 1 : 기타' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MATCHING', @level2type=N'COLUMN',@level2name=N'MCH_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MATCHING', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MATCHING', @level2type=N'COLUMN',@level2name=N'PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'확인금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MATCHING', @level2type=N'COLUMN',@level2name=N'PART_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MATCHING', @level2type=N'COLUMN',@level2name=N'REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'확인일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MATCHING', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'확인자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MATCHING', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MATCHING', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MATCHING', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취소여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MATCHING', @level2type=N'COLUMN',@level2name=N'CXL_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취소자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MATCHING', @level2type=N'COLUMN',@level2name=N'CXL_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취소일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MATCHING', @level2type=N'COLUMN',@level2name=N'CXL_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입금매칭' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MATCHING'
GO
