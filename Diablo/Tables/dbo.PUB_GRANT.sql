USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PUB_GRANT](
	[MENU_GROUP_CODE] [varchar](5) NOT NULL,
	[MENU_CODE] [int] NOT NULL,
	[EMP_CODE] [dbo].[EMP_CODE] NOT NULL,
	[SELECT_YN] [char](1) NOT NULL,
	[INSERT_YN] [char](1) NOT NULL,
	[UPDATE_YN] [char](1) NOT NULL,
	[DELETE_YN] [char](1) NOT NULL,
	[MASTER_YN] [char](1) NOT NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
 CONSTRAINT [PK_PUB_GRANT] PRIMARY KEY CLUSTERED 
(
	[MENU_GROUP_CODE] ASC,
	[MENU_CODE] ASC,
	[EMP_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PUB_GRANT]  WITH CHECK ADD  CONSTRAINT [R_12] FOREIGN KEY([MENU_GROUP_CODE], [MENU_CODE])
REFERENCES [dbo].[PUB_MENU] ([MENU_GROUP_CODE], [MENU_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PUB_GRANT] CHECK CONSTRAINT [R_12]
GO
ALTER TABLE [dbo].[PUB_GRANT]  WITH NOCHECK ADD  CONSTRAINT [R_13] FOREIGN KEY([EMP_CODE])
REFERENCES [dbo].[EMP_MASTER_damo] ([EMP_CODE])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PUB_GRANT] CHECK CONSTRAINT [R_13]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'그룹코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_GRANT', @level2type=N'COLUMN',@level2name=N'MENU_GROUP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'메뉴코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_GRANT', @level2type=N'COLUMN',@level2name=N'MENU_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사원코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_GRANT', @level2type=N'COLUMN',@level2name=N'EMP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'조회유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_GRANT', @level2type=N'COLUMN',@level2name=N'SELECT_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_GRANT', @level2type=N'COLUMN',@level2name=N'INSERT_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_GRANT', @level2type=N'COLUMN',@level2name=N'UPDATE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'삭제유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_GRANT', @level2type=N'COLUMN',@level2name=N'DELETE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팀장유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_GRANT', @level2type=N'COLUMN',@level2name=N'MASTER_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_GRANT', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_GRANT', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_GRANT', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_GRANT', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'권한관리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_GRANT'
GO
