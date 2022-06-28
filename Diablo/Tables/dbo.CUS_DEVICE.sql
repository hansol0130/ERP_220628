USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CUS_DEVICE](
	[NEW_CODE] [char](7) NOT NULL,
	[NEW_DATE] [datetime] NULL,
	[CUS_DEVICE_ID] [varchar](4000) NULL,
	[CUS_NO] [int] NOT NULL,
	[REMARK] [varchar](2000) NULL,
	[APP_CODE] [int] NULL,
 CONSTRAINT [PK_CUS_DEVICE] PRIMARY KEY CLUSTERED 
(
	[CUS_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CUS_DEVICE]  WITH CHECK ADD FOREIGN KEY([CUS_NO])
REFERENCES [dbo].[CUS_CUSTOMER_damo] ([CUS_NO])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CUS_DEVICE]  WITH CHECK ADD  CONSTRAINT [R_APP_MASTER_TO_CUS_DEVICE] FOREIGN KEY([APP_CODE])
REFERENCES [dbo].[APP_MASTER] ([APP_CODE])
GO
ALTER TABLE [dbo].[CUS_DEVICE] CHECK CONSTRAINT [R_APP_MASTER_TO_CUS_DEVICE]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_DEVICE', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_DEVICE', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객장비아이디' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_DEVICE', @level2type=N'COLUMN',@level2name=N'CUS_DEVICE_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객고유번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_DEVICE', @level2type=N'COLUMN',@level2name=N'CUS_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_DEVICE', @level2type=N'COLUMN',@level2name=N'REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'앱코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_DEVICE', @level2type=N'COLUMN',@level2name=N'APP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객 디바이스 정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_DEVICE'
GO
