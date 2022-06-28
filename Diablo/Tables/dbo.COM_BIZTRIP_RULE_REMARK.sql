USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COM_BIZTRIP_RULE_REMARK](
	[RES_CODE] [varchar](20) NOT NULL,
	[AIR_SAME_YN] [char](1) NULL,
	[AIR_LIKE_YN] [char](1) NULL,
	[AIR_DISLIKE_YN] [char](1) NULL,
	[HOTEL_LIKE_YN] [char](1) NULL,
	[HOTEL_DISLIKE_YN] [char](1) NULL,
	[AIR_CLASS_LIMIT] [char](1) NULL,
	[HOTEL_PRICE_LIMIT] [int] NULL,
	[REASON_SEQ] [int] NULL,
	[REASON_REMARK] [varchar](50) NULL,
 CONSTRAINT [PK_COM_BIZTRIP_RULE_REMARK] PRIMARY KEY CLUSTERED 
(
	[RES_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_RULE_REMARK', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'동일항공사규정위반유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_RULE_REMARK', @level2type=N'COLUMN',@level2name=N'AIR_SAME_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'선호항공사규정위반유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_RULE_REMARK', @level2type=N'COLUMN',@level2name=N'AIR_LIKE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비선호항공사규정위반유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_RULE_REMARK', @level2type=N'COLUMN',@level2name=N'AIR_DISLIKE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'선호호텔규정위반유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_RULE_REMARK', @level2type=N'COLUMN',@level2name=N'HOTEL_LIKE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비선호호텔규정위반유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_RULE_REMARK', @level2type=N'COLUMN',@level2name=N'HOTEL_DISLIKE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'E : 이코노미, B : 비즈니스, F : 퍼스트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_RULE_REMARK', @level2type=N'COLUMN',@level2name=N'AIR_CLASS_LIMIT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호텔규정제한금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_RULE_REMARK', @level2type=N'COLUMN',@level2name=N'HOTEL_PRICE_LIMIT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'규정위반코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_RULE_REMARK', @level2type=N'COLUMN',@level2name=N'REASON_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'규정위반사유' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_RULE_REMARK', @level2type=N'COLUMN',@level2name=N'REASON_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'규정위반' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_RULE_REMARK'
GO
