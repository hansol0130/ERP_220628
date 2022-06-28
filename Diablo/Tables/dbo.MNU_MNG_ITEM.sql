USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MNU_MNG_ITEM](
	[SITE_CODE] [varchar](3) NOT NULL,
	[MENU_CODE] [varchar](20) NOT NULL,
	[SEC_CODE] [varchar](4) NOT NULL,
	[GRP_SEQ] [int] NOT NULL,
	[ITEM_SEQ] [int] NOT NULL,
	[IMG_URL] [varchar](500) NULL,
	[LINK_URL] [varchar](500) NULL,
	[MASTER_CODE] [dbo].[MASTER_CODE] NULL,
	[PRO_CODE] [dbo].[PRO_CODE] NULL,
	[PRICE_SEQ] [int] NULL,
	[PRICE] [int] NULL,
	[MASTER_SEQ] [int] NULL,
	[BOARD_SEQ] [int] NULL,
	[EVT_SEQ] [int] NULL,
	[PRO_NAME] [nvarchar](200) NULL,
	[PKG_COMMENT] [nvarchar](200) NULL,
	[DTI_ITEM1] [nvarchar](200) NULL,
	[DTI_ITEM2] [nvarchar](200) NULL,
	[DTI_ITEM3] [nvarchar](200) NULL,
	[DTI_ITEM4] [nvarchar](200) NULL,
	[ORDER_NO] [int] NULL,
	[SCH_YN] [char](1) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
 CONSTRAINT [PK_MNU_MNG_ITEM] PRIMARY KEY CLUSTERED 
(
	[SITE_CODE] ASC,
	[MENU_CODE] ASC,
	[SEC_CODE] ASC,
	[GRP_SEQ] ASC,
	[ITEM_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MNU_MNG_ITEM] ADD  CONSTRAINT [DEF_MNU_MNG_ITEM_SCH_YN]  DEFAULT ('N') FOR [SCH_YN]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'패키지 = 101, 라르고, 자유여행, 프리미엄, 국내_제주, 지방출발, 테마여행, 법인상용, 여행정보, 고객센터, 마이페이지, 회원, 기획전, 이벤트, 주말할인, 금주출발, 검색, 큐비, 마이트래블가이드, 메인, 패키지메인이벤트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MNU_MNG_ITEM', @level2type=N'COLUMN',@level2name=N'MENU_CODE'
GO
