USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PUB_JOINT_ITEM](
	[JOINT_SEQ] [int] NOT NULL,
	[MENU_SEQ] [int] NOT NULL,
	[ITEM_SEQ] [int] NOT NULL,
	[SORT_TYPE] [int] NULL,
	[PRO_CODE] [varchar](20) NULL,
	[PRO_NAME] [nvarchar](200) NULL,
	[PRO_REMARK] [nvarchar](200) NULL,
	[REGION_NAME] [nvarchar](20) NULL,
	[REGION_CSS_TYPE] [int] NULL,
	[REGION_LINE_CNT] [int] NULL,
	[CONTENT] [nvarchar](200) NULL,
	[SALE_PRICE] [int] NULL,
	[NORMAL_PRICE] [int] NULL,
	[LINK_URL] [varchar](300) NULL,
	[AIRLINE_CODE] [char](2) NULL,
	[IMAGE_URL] [varchar](300) NULL,
	[ETC1] [varchar](200) NULL,
	[ETC2] [varchar](200) NULL,
	[ETC3] [varchar](200) NULL,
	[ETC4] [varchar](200) NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
 CONSTRAINT [PK_PUB_JOINT_ITEM] PRIMARY KEY CLUSTERED 
(
	[JOINT_SEQ] ASC,
	[MENU_SEQ] ASC,
	[ITEM_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PUB_JOINT_ITEM]  WITH CHECK ADD  CONSTRAINT [R_556] FOREIGN KEY([JOINT_SEQ], [MENU_SEQ])
REFERENCES [dbo].[PUB_JOINT_MENU] ([JOINT_SEQ], [MENU_SEQ])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PUB_JOINT_ITEM] CHECK CONSTRAINT [R_556]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'기획전번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_ITEM', @level2type=N'COLUMN',@level2name=N'JOINT_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'메뉴번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_ITEM', @level2type=N'COLUMN',@level2name=N'MENU_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'아이템번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_ITEM', @level2type=N'COLUMN',@level2name=N'ITEM_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'정렬' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_ITEM', @level2type=N'COLUMN',@level2name=N'SORT_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_ITEM', @level2type=N'COLUMN',@level2name=N'PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_ITEM', @level2type=N'COLUMN',@level2name=N'PRO_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품설명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_ITEM', @level2type=N'COLUMN',@level2name=N'PRO_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지역' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_ITEM', @level2type=N'COLUMN',@level2name=N'REGION_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지역명CSS타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_ITEM', @level2type=N'COLUMN',@level2name=N'REGION_CSS_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지역명라인수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_ITEM', @level2type=N'COLUMN',@level2name=N'REGION_LINE_CNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'내용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_ITEM', @level2type=N'COLUMN',@level2name=N'CONTENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'할인가' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_ITEM', @level2type=N'COLUMN',@level2name=N'SALE_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'정상가' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_ITEM', @level2type=N'COLUMN',@level2name=N'NORMAL_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'링크' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_ITEM', @level2type=N'COLUMN',@level2name=N'LINK_URL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품이미지URL' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_ITEM', @level2type=N'COLUMN',@level2name=N'IMAGE_URL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비고1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_ITEM', @level2type=N'COLUMN',@level2name=N'ETC1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비고2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_ITEM', @level2type=N'COLUMN',@level2name=N'ETC2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비고3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_ITEM', @level2type=N'COLUMN',@level2name=N'ETC3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비고4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_ITEM', @level2type=N'COLUMN',@level2name=N'ETC4'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_ITEM', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_ITEM', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_ITEM', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_ITEM', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'공동기획전 아이템' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_ITEM'
GO
