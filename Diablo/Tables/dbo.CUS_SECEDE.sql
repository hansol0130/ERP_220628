USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CUS_SECEDE](
	[CUS_NO] [dbo].[CUS_NO] NOT NULL,
	[REMARK] [varchar](200) NULL,
	[NEW_DATE] [datetime] NULL,
	[AUTH_YN] [char](1) NULL,
	[AUTH_DATE] [datetime] NULL,
	[EMP_CODE] [dbo].[EMP_CODE] NULL,
 CONSTRAINT [PK_CUS_SECEDE] PRIMARY KEY CLUSTERED 
(
	[CUS_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객고유번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_SECEDE', @level2type=N'COLUMN',@level2name=N'CUS_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'탈퇴사유' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_SECEDE', @level2type=N'COLUMN',@level2name=N'REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'신청일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_SECEDE', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'처리여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_SECEDE', @level2type=N'COLUMN',@level2name=N'AUTH_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'처리일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_SECEDE', @level2type=N'COLUMN',@level2name=N'AUTH_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'처리자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_SECEDE', @level2type=N'COLUMN',@level2name=N'EMP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'탈퇴신청' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_SECEDE'
GO
