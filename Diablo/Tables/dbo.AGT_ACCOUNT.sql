USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AGT_ACCOUNT](
	[AGT_CODE] [varchar](10) NOT NULL,
	[ACC_SEQ] [int] NOT NULL,
	[ACC_TYPE] [int] NULL,
	[ACC_NAME] [varchar](50) NULL,
	[REG_NUMBER] [varchar](20) NULL,
	[REG_DATE] [datetime] NULL,
	[MEMBER_CODE] [varchar](20) NULL,
	[REG_RATE] [decimal](3, 1) NULL,
	[ADMIN_REMARK] [varchar](1000) NULL,
	[MGR_TEAM_CODE] [char](3) NULL,
	[SHOW_YN] [dbo].[USE_Y] NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[REG_NAME] [varchar](30) NULL,
 CONSTRAINT [PK_AGT_ACCOUNT] PRIMARY KEY CLUSTERED 
(
	[AGT_CODE] ASC,
	[ACC_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AGT_ACCOUNT]  WITH CHECK ADD  CONSTRAINT [R_270] FOREIGN KEY([AGT_CODE])
REFERENCES [dbo].[AGT_MASTER] ([AGT_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AGT_ACCOUNT] CHECK CONSTRAINT [R_270]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래처코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_ACCOUNT', @level2type=N'COLUMN',@level2name=N'AGT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'계좌순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_ACCOUNT', @level2type=N'COLUMN',@level2name=N'ACC_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : 가상계좌, 1 : 일반계좌,  2 : OFF-신용카드,  3 : PG-신용카드, 4 : 상품권, 5 : 현금, 6 : 미수대체, 7 : 기타, 8 : 포인트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_ACCOUNT', @level2type=N'COLUMN',@level2name=N'ACC_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'계좌명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_ACCOUNT', @level2type=N'COLUMN',@level2name=N'ACC_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'계좌번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_ACCOUNT', @level2type=N'COLUMN',@level2name=N'REG_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'통장개설일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_ACCOUNT', @level2type=N'COLUMN',@level2name=N'REG_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'가맹점번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_ACCOUNT', @level2type=N'COLUMN',@level2name=N'MEMBER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수수료율' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_ACCOUNT', @level2type=N'COLUMN',@level2name=N'REG_RATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'관리자비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_ACCOUNT', @level2type=N'COLUMN',@level2name=N'ADMIN_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'담당팀코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_ACCOUNT', @level2type=N'COLUMN',@level2name=N'MGR_TEAM_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_ACCOUNT', @level2type=N'COLUMN',@level2name=N'SHOW_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_ACCOUNT', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_ACCOUNT', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_ACCOUNT', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_ACCOUNT', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예금주' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_ACCOUNT', @level2type=N'COLUMN',@level2name=N'REG_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래처계좌정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_ACCOUNT'
GO
