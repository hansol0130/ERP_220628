USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PKG_SENDING](
	[SEQ_NO] [int] IDENTITY(1,1) NOT NULL,
	[PRO_CODE] [varchar](20) NOT NULL,
	[PRO_NAME] [varchar](200) NOT NULL,
	[DEP_DATE] [datetime] NOT NULL,
	[DEP_TIME] [char](5) NOT NULL,
	[TRANS_NAME] [varchar](15) NOT NULL,
	[MANAGER_CODE] [char](7) NULL,
	[INNER_NUMBER] [varchar](4) NULL,
	[EMR_TEL_NUMBER] [varchar](11) NULL,
	[MEET_CNT] [int] NULL,
	[CONTRACT_CNT] [int] NULL,
	[RECEIPT_CNT] [int] NULL,
	[MEET_COUNTER] [int] NULL,
	[TC_YN] [char](1) NULL,
	[MEET_DATE] [datetime] NULL,
	[MEET_TIME] [char](5) NULL,
	[REMARK] [varchar](2000) NULL,
	[NEW_CODE] [char](7) NOT NULL,
	[NEW_DATE] [datetime] NOT NULL,
	[EDT_CODE] [char](7) NULL,
	[EDT_DATE] [datetime] NULL,
	[SEND_KEY] [varchar](6) NULL,
PRIMARY KEY CLUSTERED 
(
	[SEQ_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PKG_SENDING] ADD  DEFAULT ((0)) FOR [MEET_CNT]
GO
ALTER TABLE [dbo].[PKG_SENDING] ADD  DEFAULT ((0)) FOR [CONTRACT_CNT]
GO
ALTER TABLE [dbo].[PKG_SENDING] ADD  DEFAULT ((0)) FOR [RECEIPT_CNT]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'센딩순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_SENDING', @level2type=N'COLUMN',@level2name=N'SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_SENDING', @level2type=N'COLUMN',@level2name=N'PRO_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_SENDING', @level2type=N'COLUMN',@level2name=N'DEP_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_SENDING', @level2type=N'COLUMN',@level2name=N'DEP_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발편' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_SENDING', @level2type=N'COLUMN',@level2name=N'TRANS_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'담당직원코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_SENDING', @level2type=N'COLUMN',@level2name=N'MANAGER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'내선번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_SENDING', @level2type=N'COLUMN',@level2name=N'INNER_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'직원핸드폰번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_SENDING', @level2type=N'COLUMN',@level2name=N'EMR_TEL_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'미팅인원' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_SENDING', @level2type=N'COLUMN',@level2name=N'MEET_CNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'계약서' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_SENDING', @level2type=N'COLUMN',@level2name=N'CONTRACT_CNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'영수증' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_SENDING', @level2type=N'COLUMN',@level2name=N'RECEIPT_CNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'미팅장소 ( 0 : 표시안함, 1 : A카운터, 2 : M카운터, 3 : AM카운터, 4 : H카운터 )' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_SENDING', @level2type=N'COLUMN',@level2name=N'MEET_COUNTER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'인솔자여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_SENDING', @level2type=N'COLUMN',@level2name=N'TC_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'미팅일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_SENDING', @level2type=N'COLUMN',@level2name=N'MEET_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'미팅시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_SENDING', @level2type=N'COLUMN',@level2name=N'MEET_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_SENDING', @level2type=N'COLUMN',@level2name=N'REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_SENDING', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_SENDING', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_SENDING', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_SENDING', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'센딩ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_SENDING', @level2type=N'COLUMN',@level2name=N'SEND_KEY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사센딩' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_SENDING'
GO
