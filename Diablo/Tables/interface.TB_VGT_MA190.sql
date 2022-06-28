USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [interface].[TB_VGT_MA190](
	[ANCLY_SEQNO] [int] NOT NULL,
	[IF_SYS_RSV_NO] [varchar](50) NULL,
	[REG_USR_ID] [varchar](50) NOT NULL,
	[REG_DTM] [varchar](14) NOT NULL,
	[UPD_USR_ID] [varchar](50) NULL,
	[UPD_DTM] [varchar](14) NULL,
PRIMARY KEY CLUSTERED 
(
	[ANCLY_SEQNO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [interface].[TB_VGT_MA190] ADD  DEFAULT (CONVERT([varchar](10),getdate(),(112))+replace(CONVERT([varchar](8),getdate(),(108)),':','')) FOR [REG_DTM]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'부가서비스 일련번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_MA190', @level2type=N'COLUMN',@level2name=N'ANCLY_SEQNO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'인터페이스 시스템 예약 번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_MA190', @level2type=N'COLUMN',@level2name=N'IF_SYS_RSV_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록 사용자 ID' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_MA190', @level2type=N'COLUMN',@level2name=N'REG_USR_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록 일시' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_MA190', @level2type=N'COLUMN',@level2name=N'REG_DTM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정 사용자 ID' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_MA190', @level2type=N'COLUMN',@level2name=N'UPD_USR_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정 일시' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_MA190', @level2type=N'COLUMN',@level2name=N'UPD_DTM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'부가서비스예약번호매핑' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_MA190'
GO
