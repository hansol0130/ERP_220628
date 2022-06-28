USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PUB_JOINT_MENU](
	[JOINT_SEQ] [int] NOT NULL,
	[MENU_SEQ] [int] NOT NULL,
	[SORT_TYPE] [int] NULL,
	[CATEGORY_NAME] [nvarchar](100) NULL,
	[MENU_NAME] [nvarchar](100) NULL,
	[STYLE1] [varchar](200) NULL,
	[STYLE2] [varchar](200) NULL,
	[STYLE3] [varchar](200) NULL,
	[STYLE4] [varchar](200) NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
 CONSTRAINT [PK_PUB_JOINT_MENU] PRIMARY KEY CLUSTERED 
(
	[JOINT_SEQ] ASC,
	[MENU_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PUB_JOINT_MENU]  WITH CHECK ADD  CONSTRAINT [R_555] FOREIGN KEY([JOINT_SEQ])
REFERENCES [dbo].[PUB_JOINT_MASTER] ([JOINT_SEQ])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PUB_JOINT_MENU] CHECK CONSTRAINT [R_555]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'기획전번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_MENU', @level2type=N'COLUMN',@level2name=N'JOINT_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'메뉴번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_MENU', @level2type=N'COLUMN',@level2name=N'MENU_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'정렬' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_MENU', @level2type=N'COLUMN',@level2name=N'SORT_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카테고리제목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_MENU', @level2type=N'COLUMN',@level2name=N'CATEGORY_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'메뉴명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_MENU', @level2type=N'COLUMN',@level2name=N'MENU_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'스타일1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_MENU', @level2type=N'COLUMN',@level2name=N'STYLE1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'스타일2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_MENU', @level2type=N'COLUMN',@level2name=N'STYLE2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'스타일3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_MENU', @level2type=N'COLUMN',@level2name=N'STYLE3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'스타일4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_MENU', @level2type=N'COLUMN',@level2name=N'STYLE4'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_MENU', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_MENU', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_MENU', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_MENU', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'공동기획전 메뉴' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_MENU'
GO
