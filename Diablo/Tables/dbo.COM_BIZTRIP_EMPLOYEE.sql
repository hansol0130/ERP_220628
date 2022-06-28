USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COM_BIZTRIP_EMPLOYEE](
	[AGT_CODE] [varchar](10) NOT NULL,
	[BT_SEQ] [int] NOT NULL,
	[BTE_SEQ] [int] NOT NULL,
	[BT_EMP_TYPE] [char](1) NULL,
	[BT_EMP_SEQ] [int] NULL,
	[NEW_DATE] [datetime] NULL,
	[NEW_SEQ] [int] NULL,
 CONSTRAINT [PK_COM_BIZTRIP_EMPLOYEE] PRIMARY KEY CLUSTERED 
(
	[AGT_CODE] ASC,
	[BT_SEQ] ASC,
	[BTE_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래처코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_EMPLOYEE', @level2type=N'COLUMN',@level2name=N'AGT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출장그룹순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_EMPLOYEE', @level2type=N'COLUMN',@level2name=N'BT_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'그룹직원순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_EMPLOYEE', @level2type=N'COLUMN',@level2name=N'BTE_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'구분타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_EMPLOYEE', @level2type=N'COLUMN',@level2name=N'BT_EMP_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_EMPLOYEE', @level2type=N'COLUMN',@level2name=N'BT_EMP_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_EMPLOYEE', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_EMPLOYEE', @level2type=N'COLUMN',@level2name=N'NEW_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객사출장그룹직원관리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_EMPLOYEE'
GO
