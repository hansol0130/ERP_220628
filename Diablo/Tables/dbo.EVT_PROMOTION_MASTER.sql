USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EVT_PROMOTION_MASTER](
	[SEC_SEQ] [int] NOT NULL,
	[SEC_NAME] [varchar](50) NULL,
	[AFF_TYPE] [int] NOT NULL,
	[EVT_DATE] [date] NULL,
	[NEW_CODE] [char](7) NULL,
	[NEW_DATE] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EVT_PROMOTION_MASTER] ADD  CONSTRAINT [DEF_EVT_PROMOTION_MASTER_NEW_DATE]  DEFAULT (getdate()) FOR [NEW_DATE]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'구분순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_PROMOTION_MASTER', @level2type=N'COLUMN',@level2name=N'SEC_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'구분명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_PROMOTION_MASTER', @level2type=N'COLUMN',@level2name=N'SEC_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1: 회원, 2: 복합, 3: 이메일, 4: 핸드폰 ( 0 : 전체, 1 : 회원, 2 : 복합,3 : 이메일 , 4 : 핸드폰)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_PROMOTION_MASTER', @level2type=N'COLUMN',@level2name=N'AFF_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이벤트일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_PROMOTION_MASTER', @level2type=N'COLUMN',@level2name=N'EVT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_PROMOTION_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_PROMOTION_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'프로모션관리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_PROMOTION_MASTER'
GO
