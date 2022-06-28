USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EVT_PROMOTION_DETAIL](
	[SEC_SEQ] [int] NOT NULL,
	[SEQ_NO] [int] NOT NULL,
	[CUS_NO] [int] NULL,
	[CUS_NAME] [varchar](20) NULL,
	[EMAIL] [varchar](300) NULL,
	[NOR_TEL1] [varchar](4) NULL,
	[NOR_TEL2] [varchar](4) NULL,
	[NOR_TEL3] [varchar](4) NULL,
	[CONTENTS] [varchar](200) NULL,
	[NEW_DATE] [datetime] NULL,
	[PROVIDER_TYPE] [int] NULL,
	[IPADDRESS] [varchar](50) NULL,
	[DEL_YN] [char](1) NULL,
	[MOBILE_YN] [char](1) NULL,
	[PRO_CODE] [varchar](20) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EVT_PROMOTION_DETAIL] ADD  CONSTRAINT [DEF_EVT_PROMOTION_DETAIL_CUS_NO]  DEFAULT ((0)) FOR [CUS_NO]
GO
ALTER TABLE [dbo].[EVT_PROMOTION_DETAIL] ADD  CONSTRAINT [DEF_EVT_PROMOTION_DETAIL_NEW_DATE]  DEFAULT (getdate()) FOR [NEW_DATE]
GO
ALTER TABLE [dbo].[EVT_PROMOTION_DETAIL] ADD  DEFAULT ('N') FOR [DEL_YN]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'섹션코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_PROMOTION_DETAIL', @level2type=N'COLUMN',@level2name=N'SEC_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_PROMOTION_DETAIL', @level2type=N'COLUMN',@level2name=N'SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_PROMOTION_DETAIL', @level2type=N'COLUMN',@level2name=N'CUS_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_PROMOTION_DETAIL', @level2type=N'COLUMN',@level2name=N'CUS_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이메일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_PROMOTION_DETAIL', @level2type=N'COLUMN',@level2name=N'EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전화번호1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_PROMOTION_DETAIL', @level2type=N'COLUMN',@level2name=N'NOR_TEL1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전화번호2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_PROMOTION_DETAIL', @level2type=N'COLUMN',@level2name=N'NOR_TEL2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전화번호3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_PROMOTION_DETAIL', @level2type=N'COLUMN',@level2name=N'NOR_TEL3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'내용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_PROMOTION_DETAIL', @level2type=N'COLUMN',@level2name=N'CONTENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_PROMOTION_DETAIL', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'유입처' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_PROMOTION_DETAIL', @level2type=N'COLUMN',@level2name=N'PROVIDER_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'아이피' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_PROMOTION_DETAIL', @level2type=N'COLUMN',@level2name=N'IPADDRESS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'삭제여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_PROMOTION_DETAIL', @level2type=N'COLUMN',@level2name=N'DEL_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'모바일여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_PROMOTION_DETAIL', @level2type=N'COLUMN',@level2name=N'MOBILE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_PROMOTION_DETAIL', @level2type=N'COLUMN',@level2name=N'PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'프로모션항목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_PROMOTION_DETAIL'
GO
