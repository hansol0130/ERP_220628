USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EMP_GROUP_DETAIL](
	[GROUP_CODE] [varchar](4) NOT NULL,
	[TEAM_CODE] [dbo].[TEAM_CODE] NOT NULL,
	[TEAM_NAME] [varchar](50) NULL,
 CONSTRAINT [PK_GROUP_DETAIL] PRIMARY KEY CLUSTERED 
(
	[GROUP_CODE] ASC,
	[TEAM_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EMP_GROUP_DETAIL]  WITH CHECK ADD  CONSTRAINT [R_35] FOREIGN KEY([GROUP_CODE])
REFERENCES [dbo].[EMP_GROUP_MASTER] ([GROUP_CODE])
GO
ALTER TABLE [dbo].[EMP_GROUP_DETAIL] CHECK CONSTRAINT [R_35]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'그룹코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_GROUP_DETAIL', @level2type=N'COLUMN',@level2name=N'GROUP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팀코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_GROUP_DETAIL', @level2type=N'COLUMN',@level2name=N'TEAM_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팀명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_GROUP_DETAIL', @level2type=N'COLUMN',@level2name=N'TEAM_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'그룹세부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_GROUP_DETAIL'
GO
